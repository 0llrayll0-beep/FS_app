import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class ManualEntryPage extends StatefulWidget {
  final String? initialPlate;
  const ManualEntryPage({super.key, this.initialPlate});

  @override
  State<ManualEntryPage> createState() => _ManualEntryPageState();
}

class _ManualEntryPageState extends State<ManualEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  String _status = 'Ativo';

  final CollectionReference _platesCollection =
      FirebaseFirestore.instance.collection('plates');

  bool _firebaseAvailable = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialPlate != null) {
      _plateController.text = widget.initialPlate!;
      _checkPlateExists(widget.initialPlate!);
    }
  }

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/bancolocal.json');
  }

  Future<List<Map<String, dynamic>>> _readLocalData() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) {
        await file.writeAsString(jsonEncode([]));
        return [];
      }
      final content = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(content));
    } catch (_) {
      return [];
    }
  }

  Future<void> _writeLocalData(List<Map<String, dynamic>> data) async {
    final file = await _getLocalFile();
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> _checkPlateExists(String plate) async {
    try {
      final snapshot = await _platesCollection
          .where('plate', isEqualTo: plate.toUpperCase())
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _brandController.text = data['brand'] ?? '';
          _modelController.text = data['model'] ?? '';
          _yearController.text = data['year'] ?? '';
          _status = data['status'] ?? 'Ativo';
        });
      }
    } catch (e) {
      // Firebase falhou = usar local
      _firebaseAvailable = false;
      final localData = await _readLocalData();
      final match = localData.firstWhere(
        (item) => item['plate'] == plate.toUpperCase(),
        orElse: () => {},
      );
      if (match.isNotEmpty) {
        setState(() {
          _brandController.text = match['brand'] ?? '';
          _modelController.text = match['model'] ?? '';
          _yearController.text = match['year'] ?? '';
          _status = match['status'] ?? 'Ativo';
        });
      }
    }
  }

  Future<void> _savePlate() async {
    if (!_formKey.currentState!.validate()) return;

    final plate = _plateController.text.trim().toUpperCase();
    final newData = {
      'plate': plate,
      'brand': _brandController.text.trim(),
      'model': _modelController.text.trim(),
      'year': _yearController.text.trim(),
      'status': _status,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    try {
      if (_firebaseAvailable) {
        final snapshot =
            await _platesCollection.where('plate', isEqualTo: plate).get();

        if (snapshot.docs.isEmpty) {
          await _platesCollection.add({
            ...newData,
            'createdAt': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Placa cadastrada com sucesso no Firebase!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          final docId = snapshot.docs.first.id;
          await _platesCollection.doc(docId).update(newData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Placa atualizada no Firebase!'),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (_) {
      _firebaseAvailable = false;
    }

    
    if (!_firebaseAvailable) {
      final localData = await _readLocalData();
      final index = localData.indexWhere((item) => item['plate'] == plate);

      if (index == -1) {
        localData.add(newData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Placa salva localmente (Modo offline).'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        localData[index] = newData;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Placa atualizada localmente (Modo offline).'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      await _writeLocalData(localData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final fieldColor = isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
    final buttonColor = isDark ? Colors.grey[800]! :Color.fromARGB(255, 4, 0, 255);
    final scaffoldColor = isDark ? const Color(0xFF121212) : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: const Text('Entrada Manual'),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1F1F1F) : Color.fromARGB(255, 4, 0, 255),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Placa', _plateController, textColor, fieldColor, true),
              const SizedBox(height: 16),
              _buildTextField('Marca', _brandController, textColor, fieldColor, false),
              const SizedBox(height: 16),
              _buildTextField('Modelo', _modelController, textColor, fieldColor, false),
              const SizedBox(height: 16),
              _buildTextField(
                'Ano',
                _yearController,
                textColor,
                fieldColor,
                false,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  filled: true,
                  fillColor: fieldColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                  DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
                ],
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                style: TextStyle(color: textColor),
                dropdownColor: fieldColor,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: _savePlate,
                child: const Text('Salvar / Buscar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Color textColor,
    Color fillColor,
    bool capitalize, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      cursorColor: textColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textCapitalization: capitalize ? TextCapitalization.characters : TextCapitalization.none,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Digite $label';
        return null;
      },
    );
  }
}
