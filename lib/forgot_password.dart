import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement forgot password logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('หากมีบัญชีนี้ ระบบจะส่งวิธีรีเซ็ตรหัสผ่านไปให้'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ลืมรหัสผ่าน')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Gmail',
                    hintText: 'yourname@gmail.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอก Gmail';
                    }
                    final emailRegex = RegExp(r'^[\w-\.]+@gmail\.com');
                    if (!emailRegex.hasMatch(value)) {
                      return 'กรุณากรอก Gmail ให้ถูกต้อง';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('รีเซ็ตรหัสผ่าน'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
