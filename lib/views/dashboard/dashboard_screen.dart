import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_service_app/views/jobmanagement/job_details_screen.dart';
import 'package:field_service_app/views/notifications/notification_screen.dart';
import 'package:field_service_app/views/reports/service_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Stream<QuerySnapshot> getJobs() {
    return FirebaseFirestore.instance
        .collection('serviceRequests')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [

          IconButton(
            onPressed: () {
              Get.to(
                    () => const NotificationScreen(),
              );
            },
            icon: const Icon(
              Icons.notifications,
            ),
          ),

          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff6A11CB),
                        Color(0xff2575FC),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Back 👷",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get(),
                        builder: (context, snapshot) {

                          if (!snapshot.hasData) {
                            return const Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }

                          final data =
                          snapshot.data!.data() as Map<String, dynamic>?;

                          return Text(
                            data?['name'] ?? 'Technician',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Manage your assigned jobs efficiently",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

          const SizedBox(height: 10,),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: const Size(
                          double.infinity,
                          55,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                    onPressed: () {
                      Get.to(
                            () => const ServiceHistoryScreen(),
                      );
                    },
                    child: const Text(
                      "View Service History", style:
                        TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

        const SizedBox(height: 20),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: getJobs(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final docs = snapshot.data!.docs;

              int assigned = 0;
              int pending = 0;
              int completed = 0;

              for (var doc in docs) {
                String status = doc['status'];

                if (status == 'assigned') {
                  assigned++;
                } else if (status == 'pending') {
                  pending++;
                } else if (status == 'completed') {
                  completed++;
                }
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _StatCard(
                        title: "Assigned",
                        count: assigned.toString(),
                        color: Colors.blue,
                      ),
                      _StatCard(
                        title: "Pending",
                        count: pending.toString(),
                        color: Colors.orange,
                      ),
                      _StatCard(
                        title: "Completed",
                        count: completed.toString(),
                        color: Colors.green,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Daily Activity Overview",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  docs.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const Text("Today's Jobs"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  pending.toString(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const Text("Pending"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  completed.toString(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const Text("Completed"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: docs.isEmpty
                        ? const Center(
                      child: Text(
                        "No Jobs Assigned",
                      ),
                    )
                        : ListView.builder(
                      itemCount: docs.length,
                      itemBuilder:
                          (context, index) {
                        //var data = docs[index];
                            var data = docs[index].data() as Map<String, dynamic>;

                        return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            onTap: () {
                              Get.to(
                                    () => JobDetailsScreen(
                                  jobId: docs[index].id,
                                ),
                              );
                            },
                            leading: CircleAvatar(
                          backgroundColor:
                          data['status'] == 'completed'
                          ? Colors.green
                              : Colors.orange,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                            title: Text(data['customerName']?.toString() ?? 'No Name'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['serviceType']?.toString() ?? 'No Service',
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data['serviceLocation']?.toString() ?? '',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: data['status'] == 'completed'
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                data['status']?.toString() ?? 'No Status',
                                style: TextStyle(
                                  color: data['status'] == 'completed'
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        ],
              ),
            ),
    ),
    );

  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }
}
