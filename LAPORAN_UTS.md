# Laporan UTS - Proyek Praktikum

## A. Identitas
- Nama Proyek: E-Ticketing Helpdesk
- Mata Kuliah: UTS Praktikum
- Format nama repository yang disarankan: nim_nama_kelas_uts
- Link repository: (isi link git Anda di sini)

## B. Ringkasan Pengerjaan SRS
Dokumen SRS telah disusun pada file docs/SRS.md dan diimplementasikan dalam aplikasi Flutter.

Role sesuai SRS:
- User: membuat tiket, melihat tiket milik sendiri, memberi komentar.
- Helpdesk: melihat semua tiket, mengubah status tiket, memberi komentar.
- Admin: seluruh hak akses User dan Helpdesk.

## C. Mapping SRS ke Implementasi
- FR-001 sampai FR-004: halaman auth (login, register, reset password).
- FR-005: pembuatan tiket baru pada halaman Create Ticket.
- FR-006: daftar tiket berdasarkan role (user hanya tiket miliknya).
- FR-007: detail tiket menampilkan informasi lengkap tiket.
- FR-008: update status pada detail tiket (khusus Helpdesk/Admin).
- FR-009: komentar tiket pada detail tiket.
- FR-010: statistik dashboard dinamis sesuai data tiket terlihat.
- FR-011: toggle tema pada halaman profil.
- FR-012: logout pada halaman profil.

## D. Pengkategorian Warna
Sistem warna yang digunakan:
- Primary: Biru (identitas aplikasi helpdesk)
- Accent status Open: Oranye
- Accent status In Progress: Kuning/Amber
- Accent status Resolved: Hijau
- Danger (logout): Merah

Alasan:
- Biru memberi kesan profesional dan informatif.
- Warna status memudahkan pembacaan progres tiket secara cepat.

## E. Font dan Tipografi
- Font bawaan Material (Flutter default)
- Hierarki tipografi:
- Headline: judul halaman/dashboard
- Title: judul kartu dan section penting
- Body: informasi detail tiket dan deskripsi
- Button text: huruf kapital untuk aksi utama

Catatan pengembangan lanjut:
- Dapat ditingkatkan dengan font khusus agar identitas visual lebih kuat.

## F. Wireframe (Deskripsi)
### 1. Splash
- Logo aplikasi di tengah
- Nama aplikasi di bawah logo

### 2. Login
- Input username
- Input password
- Link lupa password
- Tombol masuk
- Link daftar

### 3. Dashboard
- Header berisi role aktif
- Ringkasan statistik tiket (Total, Open, In Progress, Resolved)
- Tombol lihat/kelola tiket
- Tombol buat tiket (hanya role tertentu)

### 4. Daftar Tiket
- List card tiket
- Informasi id, judul, tanggal, pelapor, status
- Navigasi ke detail tiket

### 5. Detail Tiket
- Badge status
- Deskripsi tiket
- Lampiran
- Komentar/balasan
- Aksi update status (Helpdesk/Admin)

### 6. Profil
- Informasi username dan role
- Toggle mode gelap
- Tombol logout

## G. Prototipe Desain (Implementasi)
Prototipe yang telah berjalan pada aplikasi:
- Alur autentikasi ke dashboard
- Alur pembuatan tiket
- Alur list dan detail tiket
- Role-based access control pada aksi tiket
- Statistik dashboard dinamis
- Dukungan light/dark mode

## H. Uji Coba Singkat
Skenario uji:
1. Login sebagai admin -> verifikasi role Admin tampil.
2. Login sebagai helpdesk -> cek bisa ubah status tiket.
3. Login sebagai user umum -> cek hanya melihat tiket miliknya.
4. Tambah tiket baru -> tiket muncul di daftar dan statistik bertambah.
5. Tambah komentar -> komentar tampil pada detail tiket.
6. Toggle mode gelap -> tema berubah.

Hasil:
- Semua skenario utama berjalan sesuai kebutuhan SRS.

## I. Lampiran Pengumpulan
- Dokumen SRS: docs/SRS.md
- Kode sumber: repository Git
- Link repository untuk dilampirkan ke laporan: (isi link git Anda)
- Upload laporan pada HEBAT sesuai ketentuan.

## J. Kesimpulan
Proyek telah disesuaikan dengan SRS dasar sistem helpdesk ticketing, termasuk pemisahan hak akses role User, Helpdesk, dan Admin. Fitur inti pelaporan, pemantauan, pembaruan status, dan komentar tiket sudah terimplementasi dan siap dijadikan bahan responsi.
