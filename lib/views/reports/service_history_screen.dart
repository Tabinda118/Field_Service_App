import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceHistoryScreen extends StatelessWidget {
  const ServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service History",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('serviceReports')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final reports = snapshot.data!.docs;

          if (reports.isEmpty) {
            return const Center(
              child: Text("No Reports Found"),
            );
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {

              final data =
              reports[index].data() as Map<String, dynamic>;

               return Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor:
                            Colors.deepPurple,
                            child: Icon(
                              Icons.description,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Report ID: ${data['reportId']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "🔍 Findings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        data['findings'],
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "🔧 Actions Taken",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        data['actionsTaken'],
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "✔ Completion Notes",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        data['completionNotes'],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "🕒 ${data['timestamp']}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}