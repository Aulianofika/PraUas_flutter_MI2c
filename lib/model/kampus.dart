class Kampus {
  final int? id;
  final String nama;
  final String alamat;
  final String noTelpon;
  final String kategori;
  final double latitude;
  final double longitude;
  final String jurusan;

  Kampus({
    this.id,
    required this.nama,
    required this.alamat,
    required this.noTelpon,
    required this.kategori,
    required this.latitude,
    required this.longitude,
    required this.jurusan,
  });

  factory Kampus.fromJson(Map<String, dynamic> json) {
    return Kampus(
      id: json['id'],
      nama: json['nama_kampus'],
      alamat: json['alamat'],
      noTelpon: json['no_telepon'],
      kategori: json['kategori'],
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      jurusan: json['jurusan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_kampus': nama,
      'alamat': alamat,
      'no_telepon': noTelpon,
      'kategori': kategori,
      'latitude': latitude,
      'longitude': longitude,
      'jurusan': jurusan,
    };
  }


}
