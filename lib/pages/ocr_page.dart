import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:FS/firebase_options.dart';

class OcrPage extends StatefulWidget {
  const OcrPage({super.key});

  @override
  State<OcrPage> createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> {
  File? _selectedImage;
  bool _isLoading = false;
  String? _recognizedText;
  Map<String, dynamic>? _vehicleData;

  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);


  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  String _status = 'Ativo';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _localDbPath = 'bancolocal.json';



  Future<Map<String, dynamic>> _loadLocalDb() async {
    final file = File(_localDbPath);
    if (!await file.exists()) {
      await file.writeAsString(jsonEncode({'plates': []}));
    }
    return jsonDecode(await file.readAsString());
  }

  Future<void> _saveLocalDb(Map<String, dynamic> data) async {
    final file = File(_localDbPath);
    await file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>?> _getFromLocal(String plate) async {
    final db = await _loadLocalDb();
    final list = db['plates'] as List<dynamic>;
    try {
      return list.firstWhere(
        (item) => item['plate'] == plate,
        orElse: () => {},
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToLocal(Map<String, dynamic> vehicle) async {
    final db = await _loadLocalDb();
    final List<dynamic> list = db['plates'];

    final index = list.indexWhere((e) => e['plate'] == vehicle['plate']);
    if (index >= 0) {
      list[index] = vehicle;
    } else {
      list.add(vehicle);
    }

    await _saveLocalDb({'plates': list});
  }


  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();
  }

  Future<void> _pickImage(ImageSource source) async {
    await _requestPermissions();
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _recognizedText = null;
        _vehicleData = null;
      });
    }
  }

  Future<void> _processPlate() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    final inputImage = InputImage.fromFile(_selectedImage!);
    final recognizedTextResult = await textRecognizer.processImage(inputImage);
    final rawText =
        recognizedTextResult.text.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final plateRegex = RegExp(r'[A-Z]{3}[0-9][A-Z0-9][0-9]{2}');
    final match = plateRegex.firstMatch(rawText);

    if (match == null) {
      setState(() {
        _isLoading = false;
        _recognizedText = "Placa não reconhecida";
        _vehicleData = null;
        _plateController.clear();
      });
      return;
    }

    final plate = match.group(0)!;
    _plateController.text = plate;

    Map<String, dynamic>? vehicle;
    try {
      final querySnapshot = await _firestore
          .collection('plates')
          .where('plate', isEqualTo: plate)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        vehicle = querySnapshot.docs.first.data();
      }
    } catch (e) {
      debugPrint('⚠️ Firebase offline, usando banco local: $e');
      vehicle = await _getFromLocal(plate);
    }

    setState(() => _isLoading = false);

    if (vehicle != null && vehicle.isNotEmpty) {
setState(() {
  _recognizedText = "Placa encontrada: $plate";
  _vehicleData = vehicle;
  _brandController.text = vehicle?['brand'] ?? '';
  _modelController.text = vehicle?['model'] ?? '';
  _yearController.text = vehicle?['year'] ?? '';
  _status = vehicle?['status'] ?? 'Ativo';
});
    } else {
      setState(() {
        _recognizedText =
            "Placa não encontrada. Preencha os dados para salvar.";
        _vehicleData = null;
        _brandController.clear();
        _modelController.clear();
        _yearController.clear();
        _status = 'Ativo';
      });
    }
  }

  Future<void> _saveVehicle() async {
    final plate = _plateController.text.trim().toUpperCase();
    final brand = _brandController.text.trim();
    final model = _modelController.text.trim();
    final year = _yearController.text.trim();

    if (plate.isEmpty || brand.isEmpty || model.isEmpty || year.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    final vehicle = {
      'plate': plate,
      'brand': brand,
      'model': model,
      'year': year,
      'status': _status,
    };

    try {
      await _firestore.collection('plates').doc(plate).set(vehicle);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veículo salvo no Firebase!")),
      );
    } catch (e) {
      debugPrint('⚠️ Firebase offline, salvando localmente: $e');
      await _saveToLocal(vehicle);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veículo salvo no banco local!")),
      );
    }

    setState(() {
      _vehicleData = vehicle;
    });
  }

  @override
  void dispose() {
    textRecognizer.close();
    _plateController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final containerColor =
        isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
    const buttonColor = Color.fromARGB(255, 4, 0, 255);

    return Scaffold(
      appBar: AppBar(title: const Text("OCR de Placas")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isDark ? Colors.white24 : Colors.grey, width: 2),
              ),
              child: _selectedImage == null
                  ? Center(
                      child: Icon(Icons.camera_alt,
                          size: 80, color: textColor.withOpacity(0.6)))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text("Câmera",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () => _pickImage(ImageSource.camera),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: buttonColor),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo, color: Colors.white),
                  label: const Text("Galeria",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: buttonColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedImage != null ? _processPlate : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, foregroundColor: Colors.white),
              child: const Text("Processar Placa"),
            ),
            const SizedBox(height: 20),
            if (_recognizedText != null) ...[
              Text(
                _recognizedText!,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 20),
              _buildFormOrData(containerColor, textColor, buttonColor),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildFormOrData(Color containerColor, Color textColor, Color buttonColor) {
    if (_vehicleData != null) {
      return Card(
        color: containerColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField("Placa", _plateController, textColor, false),
              const SizedBox(height: 12),
              _buildTextField("Marca", _brandController, textColor, false),
              const SizedBox(height: 12),
              _buildTextField("Modelo", _modelController, textColor, false),
              const SizedBox(height: 12),
              _buildTextField("Ano", _yearController, textColor, false),
              const SizedBox(height: 12),
              Text("Status: $_status",
                  style: TextStyle(color: textColor, fontSize: 16)),
            ],
          ),
        ),
      );
    } else {
      return Card(
        color: containerColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField("Placa", _plateController, textColor, true),
              const SizedBox(height: 12),
              _buildTextField("Marca", _brandController, textColor, true),
              const SizedBox(height: 12),
              _buildTextField("Modelo", _modelController, textColor, true),
              const SizedBox(height: 12),
              _buildTextField("Ano", _yearController, textColor, true,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                  DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
                ],
                onChanged: (value) => setState(() => _status = value!),
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: TextStyle(color: textColor),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveVehicle,
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                child: const Text("Salvar Veículo"),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      Color textColor, bool enabled,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
