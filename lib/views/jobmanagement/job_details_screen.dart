import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_service_app/views/customer/customer_service_history_screen.dart';
import 'package:field_service_app/views/reports/service_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobId;

  const JobDetailsScreen({
    super.key,
    required this.jobId,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {

  final noteController = TextEditingController();


  Widget detailCard(
      IconData icon,
      String title,
      String value,
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('serviceRequests')
            .doc(widget.jobId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
          snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  detailCard(
                    Icons.person,
                    "Customer",
                    data['customerName'] ?? 'N/A',
                  ),

                  detailCard(
                    Icons.phone,
                    "Phone",
                    data['customerPhone'] ?? 'N/A',
                  ),

                  detailCard(
                    Icons.location_on,
                    "Location",
                    data['serviceLocation'] ?? 'N/A',
                  ),

                  detailCard(
                    Icons.warning,
                    "Issue",
                    data['issueDescription'] ?? 'N/A',
                  ),

                  detailCard(
                    Icons.calendar_month,
                    "Service Date",
                    data['serviceDate']?.toString() ?? 'N/A',
                  ),

                  detailCard(
                    Icons.build,
                    "Service Type",
                    data['serviceType'] ?? 'N/A',
                  ),

                  detailCard(
                    Icons.check_circle,
                    "Status",
                    data['status'] ?? 'N/A',
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: noteController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Service Notes",
                      hintText: "Enter service notes...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(
                          double.infinity,
                          55,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('serviceRequests')
                            .doc(widget.jobId)
                            .update({
                          'status': 'pending',
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Job Accepted",
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Accept Job",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),


                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {

                        await FirebaseFirestore.instance
                            .collection('serviceRequests')
                            .doc(widget.jobId)
                            .update({
                          'status': 'rejected',
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Job Rejected",
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Reject Job",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(
                          double.infinity,
                          55,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        if (noteController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter service notes",
                              ),
                            ),
                          );
                          return;
                        }

                        await FirebaseFirestore.instance
                            .collection('serviceRequests')
                            .doc(widget.jobId)
                            .update({
                          'serviceNote': noteController.text.trim(),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Service Note Saved"),
                          ),
                        );
                      },
                      child: const Text("Save Note",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

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
                              () => ServiceReportScreen(
                            jobId: widget.jobId,
                          ),
                        );
                      },
                      child: const Text(
                        "Create Service Report",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
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
                              () => CustomerServiceHistoryScreen(
                            customerName: data['customerName'],
                          ),
                        );
                      },
                      child: const Text(
                        "View Customer History",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(
                          double.infinity,
                          55,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('serviceRequests')
                            .doc(widget.jobId)
                            .update({
                          'status': 'completed',
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Job Completed",
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Complete Job",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}