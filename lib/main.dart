
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const Color bgColor = Color(0xFF0B1020);
const Color cardColor = Color(0xFF151D32);
const Color accentColor = Color(0xFF00E5A8);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController controller = TextEditingController();

  String result = "";
  String frequent = "";
  int key = 0;

  void decrypt() {
    final String message = controller.text.toUpperCase();
    const String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    int max = 0;
    String mostFrequent = "";

    // Step 1: Frequency Analysis
    for (int i = 0; i < 26; i++) {
      int count = 0;

      for (int j = 0; j < message.length; j++) {
        if (alphabet[i] == message[j]) {
          count++;
        }
      }

      if (count > max) {
        max = count;
        mostFrequent = alphabet[i];
      }
    }

    // Check empty message
    if (mostFrequent.isEmpty) {
      setState(() {
        result = "Please enter an encrypted message.";
        frequent = "";
        key = 0;
      });
      return;
    }

    // Step 2: Estimate key assuming E is most frequent
    final int estimatedKey =
        (alphabet.indexOf(mostFrequent) - 4 + 26) % 26;

    // Step 3: Decryption
    String decrypted = "";

    for (int i = 0; i < message.length; i++) {
      final int position = alphabet.indexOf(message[i]);

      if (position == -1) {
        decrypted += message[i];
      } else {
        final int newPosition =
            (position - estimatedKey + 26) % 26;
        decrypted += alphabet[newPosition];
      }
    }

    setState(() {
      frequent = mostFrequent;
      key = estimatedKey;
      result = decrypted;
    });
  }

  void clearAll() {
    controller.clear();

    setState(() {
      result = "";
      frequent = "";
      key = 0;
    });
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accentColor, size: 25),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value.isEmpty ? "--" : value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgColor,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // App Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.security,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CRYPTEX",
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 12,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Caesar Cipher Attack",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: clearAll,
                      tooltip: "Clear all",
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Encrypted Text Input
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.terminal,
                            color: accentColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "ENCRYPTED TEXT",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller,
                        maxLines: 5,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter your encrypted message...",
                          hintStyle: const TextStyle(
                            color: Colors.white38,
                          ),
                          filled: true,
                          fillColor: bgColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: decrypt,
                          icon: const Icon(Icons.lock_open),
                          label: const Text(
                            "DECRYPT MESSAGE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: bgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Analysis Results
                const Text(
                  "ANALYSIS RESULTS",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    buildInfoCard(
                      icon: Icons.analytics_outlined,
                      title: "Frequent Letter",
                      value: frequent,
                    ),
                    const SizedBox(width: 14),
                    buildInfoCard(
                      icon: Icons.vpn_key_outlined,
                      title: "Estimated Key",
                      value: frequent.isEmpty ? "" : "$key",
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Decrypted Message
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: accentColor.withAlpha(70),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: accentColor,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "DECRYPTED MESSAGE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SelectableText(
                        result.isEmpty
                            ? "Your result will appear here..."
                            : result,
                        style: TextStyle(
                          color: result.isEmpty
                              ? Colors.white38
                              : accentColor,
                          fontSize: 17,
                          height: 1.6,
                        ),
                      ),
                    ],
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
