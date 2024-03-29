// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:utibu_health_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  _StatementScreenState createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  String _statement = '';

  @override
  void initState() {
    super.initState();
    fetchStatement();
  }

  Future<void> fetchStatement() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.getCurrentUser();
    final token = await user!.getIdToken();
    final response = await http.get(
      Uri.parse('YOUR_BACKEND_URL/statement'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        _statement = response.body;
      });
    } else {
      // Failed to fetch statement
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch statement'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(_statement),
        ),
      ),
    );
  }
}
