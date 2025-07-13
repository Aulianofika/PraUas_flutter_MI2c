import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/kampus.dart';

class DetailKampusScreen extends StatelessWidget {
  final Kampus kampus;

  const DetailKampusScreen({super.key, required this.kampus});

  Future<void> _openGoogleMaps(double lat, double lng, BuildContext context) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat membuka Google Maps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        backgroundColor: Colors.pink[800],
        title: const Text(
          "Detail Kampus",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          color: const Color(0xFFFDE0EC),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.school, size: 80, color: Color(0xFFEF7188)),
                      const SizedBox(height: 8),
                      Text(
                        kampus.nama,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF880E4F),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.pinkAccent),
                const SizedBox(height: 12),
                _buildInfoTile(Icons.location_on, "Alamat", kampus.alamat),
                _buildInfoTile(Icons.phone, "Telepon", kampus.noTelpon),
                _buildInfoTile(Icons.category, "Kategori", kampus.kategori),
                _buildInfoTile(Icons.book, "Jurusan", kampus.jurusan),
                const Spacer(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _openGoogleMaps(kampus.latitude, kampus.longitude, context),
                    icon: const Icon(Icons.explore_rounded),
                    label: const Text("Buka di Google Maps"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF7188),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.pink.shade300),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
