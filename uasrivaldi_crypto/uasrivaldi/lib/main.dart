import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Harga Crypto 2024 (Rivaldi Hidayatullah)'),
        ),
        body: const CryptoList(),
      ),
    );
  }
}

class CryptoList extends StatefulWidget {
  const CryptoList({super.key});

  @override
  _CryptoListState createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList> {
  List<dynamic> _cryptoData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCryptoData();
  }

  Future<void> _fetchCryptoData() async {
    final response =
        await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));

    if (response.statusCode == 200) {
      setState(() {
        _cryptoData = json.decode(response.body)['data'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load crypto data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _cryptoData.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _cryptoData[index]['name'],
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Harga: \$${_cryptoData[index]['price_usd']} USD',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
