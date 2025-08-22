class ImageObject {
  final String namaBudaya;
  final String deskripsiSingkat;
  final String sejarah;
  final String fungsiBudaya;
  final String asalDaerah;
  final String filosofiSimbolik;
  final String materialUtama;
  final String perkembanganKini;

  ImageObject({
    required this.namaBudaya,
    required this.deskripsiSingkat,
    required this.sejarah,
    required this.fungsiBudaya,
    required this.asalDaerah,
    required this.filosofiSimbolik,
    required this.materialUtama,
    required this.perkembanganKini,
  });

  factory ImageObject.fromJson(Map<String, dynamic> json) {
    return ImageObject(
      namaBudaya: json['nama_budaya'],
      deskripsiSingkat: json['deskripsi_singkat'],
      sejarah: json['sejarah'],
      fungsiBudaya: json['fungsi_budaya'],
      asalDaerah: json['asal_daerah'],
      filosofiSimbolik: json['filosofi_simbolik'],
      materialUtama: json['material_utama'],
      perkembanganKini: json['perkembangan_kini'],
    );
  }
}
