import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Message {
  final int id;
  final String text;
  final String? prediction;
  final double? confidence;

  Message({
    required this.id,
    required this.text,
    this.prediction,
    this.confidence,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      text: map['text'],
      prediction: map['prediction'],
      confidence: (map['confidence'] as num?)?.toDouble(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Message> messages = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    setState(() => loading = true);

    try {
      final data = await Supabase.instance.client
          .from('messages')
          .select()
          .order('created_at', ascending: false);

      // data is List<dynamic>
      final List<Message> fetched =
          (data as List).map((msg) => Message.fromMap(msg)).toList();

      if (!mounted) return;
      setState(() {
        messages = fetched;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading messages: $e')));
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> onSwipe(int index, bool isSpam) async {
    final updated = Message(
      id: messages[index].id,
      text: messages[index].text,
      prediction: isSpam ? "Spam" : "Not Spam",
      confidence: isSpam ? 0.9 : 0.99,
    );

    setState(() {
      messages[index] = updated;
    });

    try {
      await Supabase.instance.client
          .from('messages')
          .update({
            'prediction': updated.prediction,
            'confidence': updated.confidence,
          })
          .eq('id', updated.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update message: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spam Scanner 🔍'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/new-message',
          ).then((_) => fetchMessages());
        },
        icon: const Icon(Icons.add),
        label: const Text('New Message'),
        backgroundColor: Colors.redAccent,
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Dismissible(
                    key: Key(message.id.toString()),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.block,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      final isSpam = direction == DismissDirection.endToStart;
                      await onSwipe(index, isSpam);
                      return false; // keep the item, no dismiss animation
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          message.text,
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle:
                            message.prediction == null
                                ? null
                                : Text(
                                  '${message.prediction} (${message.confidence!.toStringAsFixed(1)}%)',
                                  style: TextStyle(
                                    color:
                                        message.prediction == "Spam"
                                            ? Colors.red
                                            : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        leading: const Icon(Icons.message),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
