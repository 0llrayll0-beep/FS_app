import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final Function(int) onNavigate;

  const WelcomePage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final buttonColor = isDark ? Colors.grey[800]! : const Color.fromARGB(255, 4, 0, 255);
    final buttonTextColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_car,
                  size: 100,
                  color: isDark ? const Color.fromARGB(255, 4, 0, 255) : const Color.fromARGB(255, 4, 0, 255),
                ),
                const SizedBox(height: 20),

                Text(
                  "Bem-vindo ao FS – Fortec Scanner!\n"
"Criado pelos alunos do Tin 2, este aplicativo permite que você consulte veículos de forma rápida e prática:\n"
"basta tirar uma foto da placa ou inserir os dados manualmente.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 40),


                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => onNavigate(1),
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text("Ir para OCR de Imagem"),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => onNavigate(2),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text("Ir para Entrada Manual"),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => onNavigate(3),
                  icon: const Icon(Icons.list, color: Colors.white),
                  label: const Text("Ir para Detalhes dos Veículos"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
