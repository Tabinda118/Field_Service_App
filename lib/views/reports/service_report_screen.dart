import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceReportScreen extends StatelessWidget {
  final String jobId;

  ServiceReportScreen({
    super.key,
    required this.jobId,
  });

  final findingsController = TextEditingController();
  final actionsController = TextEditingController();
  final completionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Service Report",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Job ID: $jobId",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: findingsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Findings",
                    prefixIcon: Icon(
                      Icons.search, color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: actionsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Actions Taken",
                    prefixIcon: Icon(
                      Icons.build,color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: findingsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Completion Notes",
                    prefixIcon: Icon(
                      Icons.check_circle,color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.deepPurple,
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

                  //Service report ki validation kay fill hai all ya nai

                  if (findingsController.text.isEmpty ||
                      actionsController.text.isEmpty ||
                      completionController.text.isEmpty) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please fill all report fields",
                        ),
                      ),
                    );

                    return;
                  }

                  final reportRef = FirebaseFirestore.instance
                      .collection('serviceReports')
                      .doc();

                  await reportRef.set({
                    'reportId': reportRef.id,
                    'jobId': jobId,
                    'findings': findingsController.text.trim(),
                    'actionsTaken': actionsController.text.trim(),
                    'completionNotes': completionController.text.trim(),
                    'timestamp': Timestamp.now(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Report Saved"),
                    ),
                  );

                  Get.back();
                },
                child: const Text("Save Report", style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}