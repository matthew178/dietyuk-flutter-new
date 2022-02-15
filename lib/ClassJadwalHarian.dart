class ClassJadwalHarian {
  String id, idbeli, tanggal, hari, waktu, keterangan, takaran, status;

  ClassJadwalHarian(this.id, this.idbeli, this.tanggal, this.hari, this.waktu,
      this.keterangan, this.takaran, this.status);

  bool getStatus() {
    if (this.status == "1") {
      return true;
    } else {
      return false;
    }
  }
}
