import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/kampus.dart';

class ApiService {
  static const String baseUrl = "http://192.168.157.1:8000/api/kampus";


  // Ambil semua data kampus
  static Future<List<Kampus>> fetchKampus() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final jsonRes = json.decode(res.body);
        List jsonData = jsonRes['data'];
        return jsonData.map((e) => Kampus.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat data. Status: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  // Tambah data kampus
  static Future<Map<String, dynamic>> tambahKampus(Kampus kampus) async {
    try {
      // Debug: Tampilkan data JSON sebelum dikirim
      print("Data yang dikirim ke API:");
      print(jsonEncode(kampus.toJson()));

      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(kampus.toJson()),
      );

      if (res.statusCode == 201) {
        return {'success': true, 'message': 'Data berhasil ditambahkan'};
      } else {
        return {
          'success': false,
          'message': 'Gagal menambahkan. Status: ${res.statusCode}\nBody: ${res.body}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }


  // Update data kampus
  static Future<Map<String, dynamic>> updateKampus(int id, Kampus kampus) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(kampus.toJson()),
      );

      if (res.statusCode == 200) {
        return {'success': true, 'message': 'Data berhasil diupdate'};
      } else {
        return {
          'success': false,
          'message': 'Gagal update. Status: ${res.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Hapus data kampus
  static Future<Map<String, dynamic>> deleteKampus(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));

      if (res.statusCode == 200) {
        return {'success': true, 'message': 'Data berhasil dihapus'};
      } else {
        return {
          'success': false,
          'message': 'Gagal hapus. Status: ${res.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
