import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleDetailsPage extends StatelessWidget {
  const VehicleDetailsPage({super.key});


  Future<List<Map<String, dynamic>>> getPlates() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('plates').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      final file = File('lib/pages/bancolocal.json');
      final jsonData = jsonDecode(await file.readAsString());
      final List<dynamic> list = jsonData['plates'] ?? [];
      return list.cast<Map<String, dynamic>>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.grey[200];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes das Placas'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getPlates(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: Text('Erro ao carregar dados'));
          }

          final plates = snapshot.data!;
          if (plates.isEmpty) {
            return const Center(child: Text('Nenhuma placa encontrada'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plates.length,
            itemBuilder: (context, index) {
              final plate = plates[index];

              final plateNumber = plate['plate'] ?? 'Desconhecido';
              final brand = plate['brand'] ?? 'N/A';
              final model = plate['model'] ?? 'N/A';
              final year = plate['year'] ?? 'N/A';
              final status = plate['status'] ?? 'Desconhecido';

              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Placa: $plateNumber",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Marca: $brand", style: TextStyle(color: textColor)),
                      Text("Modelo: $model", style: TextStyle(color: textColor)),
                      Text("Ano: $year", style: TextStyle(color: textColor)),
                      Text(
                        "Status: $status",
                        style: TextStyle(
                          color: status == "Ativo"
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
