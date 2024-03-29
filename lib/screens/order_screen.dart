// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:utibu_health_app/services/auth_service.dart';

class OrderScreen extends StatelessWidget {
  final TextEditingController _medicationController = TextEditingController();

  OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Medication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _medicationController,
              decoration: const InputDecoration(labelText: 'Medication Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                final user = await authService.getCurrentUser();
                final token = await user!.getIdToken();
                final response = await http.post(
                  Uri.parse('YOUR_BACKEND_URL/order'),
                  headers: {'Authorization': 'Bearer $token'},
                  body: {'medication': _medicationController.text},
                );
                if (response.statusCode == 200) {
                  // Order successful
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Medication ordered successfully'),
                    ),
                  );
                } else {
                  // Order failed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to order medication'),
                    ),
                  );
                }
              },
              child: const Text('Order'),
            ),
          ],
        ),
      ),
    );
  }
}
