import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/app_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _showEditProfileDialog(BuildContext context) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final nameController = TextEditingController(text: appProvider.fullName);
    final usernameController = TextEditingController(text: appProvider.username);
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profil'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username wajib diisi';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                final messenger = ScaffoldMessenger.of(this.context);
                final nav = Navigator.of(context);
                final success = appProvider.updateProfile(
                  name: nameController.text,
                  username: usernameController.text,
                );
                if (success) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Profil berhasil diperbarui.'), backgroundColor: Colors.green),
                  );
                  nav.pop();
                } else {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Gagal update profil. Username mungkin sudah dipakai.'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password Saat Ini'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Masukkan password saat ini';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: newController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password Baru'),
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Password baru minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Konfirmasi Password Baru'),
                  validator: (value) {
                    if (value != newController.text) {
                      return 'Konfirmasi password tidak sama';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                final messenger = ScaffoldMessenger.of(this.context);
                final nav = Navigator.of(context);
                final success = appProvider.changePassword(
                  currentPassword: currentController.text,
                  newPassword: newController.text,
                );
                if (success) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Password berhasil diubah.'), backgroundColor: Colors.green),
                  );
                  nav.pop();
                } else {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Password saat ini salah.'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Ubah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Pengguna"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              appProvider.fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('@${appProvider.username}'),
            Text("Role: ${appProvider.role}"),
            const Divider(height: 40),

            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Nama & Username'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showEditProfileDialog(context),
            ),

            ListTile(
              leading: const Icon(Icons.password_outlined),
              title: const Text('Reset Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showChangePasswordDialog(context),
            ),

            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Mode Gelap"),
              trailing: Switch(
                value: appProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  appProvider.toggleTheme(value);
                },
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Provider.of<AppProvider>(context, listen: false).logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text("LOGOUT"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}