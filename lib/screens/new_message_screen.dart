import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  String? prediction;
  double? confidence;
  bool scanning = false;

  Future<void> scanMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      scanning = true;
      prediction = null;
      confidence = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
          'https://spam-snap-api.onrender.com/predict',
        ), // <-- Render API URL here
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          prediction = data['prediction'];
          confidence = (data['confidence'] as num).toDouble();
        });

        // Save result to Supabase
        await Supabase.instance.client.from('messages').insert({
          'text': text,
          'prediction': prediction,
          'confidence': confidence,
        });

        cardKey.currentState?.toggleCard();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get prediction')),
        );
      }
    } catch (e) {
      print('🔴 ERROR connecting to server: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to the server')),
      );
    }

    setState(() {
      scanning = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildFrontCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: 200,
        child: SingleChildScrollView(
          child: Text(
            _controller.text.isEmpty
                ? "Your message preview"
                : _controller.text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget buildBackCard() {
    final color = prediction == "Spam" ? Colors.red : Colors.green;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: color,
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              prediction ?? '',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              confidence != null
                  ? '${confidence!.toStringAsFixed(1)}% confidence'
                  : '',
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Message 📝')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Paste or type your message...',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (prediction != null) {
                  setState(() {
                    prediction = null;
                    confidence = null;
                  });
                  cardKey.currentState?.toggleCard();
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: scanning ? null : scanMessage,
              icon:
                  scanning
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Icon(Icons.search),
              label: Text(scanning ? 'Scanning...' : 'Scan Now'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 40),
            FlipCard(
              key: cardKey,
              flipOnTouch: false,
              front: buildFrontCard(),
              back: buildBackCard(),
            ),
          ],
        ),
      ),
    );
  }
}
