import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerServiceHistoryScreen extends StatelessWidget {
  final String customerName;

  const CustomerServiceHistoryScreen({
    super.key,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "$customerName History",
          style: const TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('serviceRequests')
            .where(
          'customerName',
          isEqualTo: customerName,
        )
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {

              final data =
              docs[index].data() as Map<String, dynamic>;

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
                          CircleAvatar(
                            backgroundColor:
                            Colors.indigo,
                            child: const Icon(
                              Icons.build,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              data['serviceType']
                                  ?.toString() ??
                                  'No Service',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Issue: "
                            "${data['issueDescription'] ?? 'N/A'}",
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Location: "
                            "${data['serviceLocation'] ?? 'N/A'}",
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: data['status'] ==
                              'completed'
                              ? Colors.green
                              .withOpacity(0.2)
                              : Colors.orange
                              .withOpacity(0.2),
                          borderRadius:
                          BorderRadius.circular(
                              20),
                        ),
                        child: Text(
                          data['status']
                              ?.toString() ??
                              'Unknown',
                          style: TextStyle(
                            color: data['status'] ==
                                'completed'
                                ? Colors.green
                                : Colors.orange,
                            fontWeight:
                            FontWeight.bold,
                          ),
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