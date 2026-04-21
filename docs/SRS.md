# Software Requirement Specification (SRS)

## 1. Identitas Proyek
- Nama aplikasi: E-Ticketing Helpdesk
- Platform: Flutter (Android, iOS, Web, Desktop)
- Tujuan: Memfasilitasi pelaporan masalah IT dan penanganannya secara terstruktur.

## 2. Ruang Lingkup
Aplikasi menyediakan fitur autentikasi sederhana, pembuatan tiket, pemantauan status tiket, komentar pada tiket, dan pengelolaan status tiket berdasarkan role pengguna.

## 3. Definisi Role
- User: Pelapor masalah, dapat membuat tiket dan melihat tiket miliknya.
- Helpdesk: Petugas penanganan tiket, dapat melihat seluruh tiket, mengubah status, dan memberi komentar.
- Admin: Pengelola sistem, memiliki semua hak User + Helpdesk.

## 4. Kebutuhan Fungsional
- FR-001: Pengguna login dengan username dan password.
- FR-002: Sistem menentukan role berdasarkan username login.
- FR-003: Pengguna dapat melakukan registrasi akun (UI).
- FR-004: Pengguna dapat mengakses reset password (UI).
- FR-005: User/Admin dapat membuat tiket dengan judul, deskripsi, dan lampiran opsional.
- FR-006: User melihat daftar tiket miliknya; Helpdesk/Admin melihat seluruh tiket.
- FR-007: Pengguna dapat melihat detail tiket.
- FR-008: Helpdesk/Admin dapat mengubah status tiket (Open, In Progress, Resolved).
- FR-009: Semua role dapat menambahkan komentar pada tiket.
- FR-010: Dashboard menampilkan statistik tiket sesuai visibilitas role.
- FR-011: Pengguna dapat mengubah tema aplikasi (light/dark).
- FR-012: Pengguna dapat logout.

## 5. Aturan Bisnis
- RB-001: Username "admin" memperoleh role Admin.
- RB-002: Username "helpdesk" atau "staff" memperoleh role Helpdesk.
- RB-003: Username selain RB-001 dan RB-002 memperoleh role User.
- RB-004: Tiket baru selalu berstatus Open.
- RB-005: Hanya Helpdesk/Admin yang dapat mengubah status tiket.
- RB-006: User hanya dapat melihat tiket yang dibuat oleh dirinya.

## 6. Kebutuhan Non-Fungsional
- NFR-001: Antarmuka responsif untuk mobile dan desktop.
- NFR-002: Perubahan state bersifat reaktif dengan Provider.
- NFR-003: Navigasi sederhana dan konsisten antar halaman.
- NFR-004: Data tiket disimpan in-memory untuk simulasi praktikum.

## 7. Data Utama
Entitas tiket:
- id: String
- title: String
- description: String
- status: String
- createdAt: DateTime
- reporter: String
- comments: List<{author, text}>
- imagePath: String?

## 8. Kriteria Penerimaan
- AC-001: Login dengan username "admin" menampilkan role Admin di dashboard/profil.
- AC-002: Login dengan username umum (contoh: "budi") hanya menampilkan tiket milik budi.
- AC-003: Helpdesk/Admin dapat mengubah status tiket dari halaman detail.
- AC-004: User tidak dapat menekan tombol submit tiket jika role tidak diizinkan.
- AC-005: Statistik dashboard berubah saat tiket ditambah atau status diperbarui.
