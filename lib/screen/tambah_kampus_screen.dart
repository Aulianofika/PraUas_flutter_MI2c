import 'package:flutter/material.dart';
import '../model/kampus.dart';
import '../service/api_service.dart';

class TambahKampusScreen extends StatefulWidget {
  @override
  State<TambahKampusScreen> createState() => _TambahKampusScreenState();
}

class _TambahKampusScreenState extends State<TambahKampusScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _telponController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  final _jurusanController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    double? lat = double.tryParse(_latController.text);
    double? long = double.tryParse(_longController.text);

    if (lat == null || long == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Latitude dan Longitude harus berupa angka'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final kampus = Kampus(
      nama: _namaController.text,
      alamat: _alamatController.text,
      noTelpon: _telponController.text,
      kategori: _kategoriController.text,
      latitude: lat,
      longitude: long,
      jurusan: _jurusanController.text,
    );

    setState(() => _isLoading = true);

    final result = await ApiService.tambahKampus(kampus);


    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan'), backgroundColor: Colors.pink),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result['message']}'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Tambah Kampus",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.pink[800],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD0), Color(0xFFFFF0F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.pink))
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput("Nama Kampus", Icons.school, _namaController),
                  _buildInput("Alamat", Icons.location_on, _alamatController, maxLines: 3),
                  _buildInput("No Telepon", Icons.phone, _telponController, keyboardType: TextInputType.phone),
                  _buildInput("Kategori", Icons.category, _kategoriController),
                  _buildInput("Latitude", Icons.explore_outlined, _latController, keyboardType: TextInputType.number),
                  _buildInput("Longitude", Icons.explore_rounded, _longController, keyboardType: TextInputType.number),
                  _buildInput("Jurusan", Icons.book, _jurusanController),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC2185B),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
      String label,
      IconData icon,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.pink[600]),
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.95),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (val) => val == null || val.isEmpty ? "$label tidak boleh kosong" : null,
      ),
    );
  }
}