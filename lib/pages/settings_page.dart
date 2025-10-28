import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void _mostrarCreditos(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Center(
              child: Icon(Icons.group, size: 60, color: isDark ? Colors.greenAccent : Colors.green),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                "Créditos da Equipe",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),


_creditItem(Icons.phone_android, "Raul", "Desenvolvedor Mobile"),
_creditItem(Icons.palette, "Matheus", "Designer UI/UX"),
_creditItem(Icons.palette, "Brian", "Designer UI/UX"),
_creditItem(Icons.code, "Michael", "Programador Web"),
_creditItem(Icons.code, "Cauê", "Programador Web"),
_creditItem(Icons.code, "Saliou", "Programador Web"),

          ],
        ),
      ),
    );
  }


  void _mostrarSobre(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Center(
              child: Icon(Icons.info, size: 60, color: isDark ? Colors.blueAccent : Colors.blue),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                "Sobre o Aplicativo",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Este aplicativo permite consultar veículos via OCR (Reconhecimento Óptico de Caracteres) e também por entrada manual. "
              "Foi desenvolvido com foco em praticidade e acessibilidade para usuários que precisam ler informações de placas de forma rápida e intuitiva.",
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              "Versão: 2.1.1",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 25),

            Text(
              "Tecnologias Utilizadas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _techItem(Icons.flutter_dash, "Flutter", "Framework multiplataforma para desenvolvimento mobile."),
            _techItem(Icons.code, "Dart", "Linguagem de programação utilizada no Flutter."),
            _techItem(Icons.camera_alt, "Google ML Kit", "Biblioteca de Machine Learning para OCR (Reconhecimento de Texto)."),
            _techItem(Icons.design_services, "Material Design", "Sistema de design do Google para UI/UX consistente."),
          ],
        ),
      ),
    );
  }


  Widget _creditItem(IconData icon, String name, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$name — $role",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _techItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Configurações",
          style: TextStyle(
            color: isDark ? Colors.white : const Color.fromARGB(255, 4, 0, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 4, 0, 255),
        ),
      ),
      body: ListView(
        children: [

          SwitchListTile(
            title: Text(
              "Modo Escuro",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
            activeColor: isDark ? Colors.white : const Color.fromARGB(255, 4, 0, 255),
          ),

          Divider(color: isDark ? Colors.white24 : Colors.black26),


          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: Text(
              "Limpar cache",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Cache limpo com sucesso!"),
                  backgroundColor: isDark
                      ? Colors.grey[900]
                      : const Color.fromARGB(255, 4, 0, 255),
                ),
              );
            },
          ),

          Divider(color: isDark ? Colors.white24 : Colors.black26),


          ListTile(
            leading: const Icon(Icons.group, color: Colors.green),
            title: Text(
              "Créditos",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            onTap: () => _mostrarCreditos(context, isDark),
          ),

          Divider(color: isDark ? Colors.white24 : Colors.black26),


          ListTile(
            leading: const Icon(Icons.info, color: Colors.blueAccent),
            title: Text(
              "Sobre o aplicativo",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            onTap: () => _mostrarSobre(context, isDark),
          ),
        ],
      ),
    );
  }
}
