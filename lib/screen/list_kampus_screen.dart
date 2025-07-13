import 'package:flutter/material.dart';
import '../model/kampus.dart';
import '../service/api_service.dart';
import 'tambah_kampus_screen.dart';
import 'edit_kampus_screen.dart';
import 'detail_kampus_screen.dart';

class ListKampusScreen extends StatefulWidget {
  @override
  State<ListKampusScreen> createState() => _ListKampusScreenState();
}

class _ListKampusScreenState extends State<ListKampusScreen> {
  late Future<List<Kampus>> kampusList;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      kampusList = ApiService.fetchKampus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Daftar Kampus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.pink[800],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD0), Color(0xFFFFF0F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Kampus>>(
          future: kampusList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.pink));
            } else if (snapshot.hasError) {
              return const Center(child: Text("Gagal memuat data", style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Data kampus kosong", style: TextStyle(color: Colors.pink)));
            } else {
              final list = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async => _refresh(),
                color: Colors.pink,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 80),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final kampus = list[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFC2185B),
                          child: Icon(Icons.school, color: Colors.white),
                        ),
                        title: Text(kampus.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(kampus.alamat),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_note, color: Colors.deepOrange),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditKampusScreen(kampus: kampus),
                                  ),
                                );
                                if (result == true) _refresh();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Konfirmasi"),
                                    content: const Text("Yakin ingin menghapus kampus ini?"),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
                                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  final res = await ApiService.deleteKampus(kampus.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(res['message']),
                                      backgroundColor: res['success'] ? Colors.pink : Colors.red,
                                    ),
                                  );
                                  if (res['success']) _refresh();
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailKampusScreen(kampus: kampus),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahKampusScreen()),
          );
          if (result == true) _refresh();
        },
        label: const Text("Tambah Kampus"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink[700],
      ),
    );
  }
}
