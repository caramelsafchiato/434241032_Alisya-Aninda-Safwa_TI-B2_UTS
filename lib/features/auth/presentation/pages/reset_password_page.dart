import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Masukkan email terdaftar untuk menerima link reset.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Hapus kata 'const' di depan TextFormField ini
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(), // Pastikan tertulis lengkap sampai kurung tutup
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("KIRIM LINK"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}