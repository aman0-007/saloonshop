import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  late Future<List<Map<String, dynamic>>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = _fetchAppointments();
  }

  Future<List<Map<String, dynamic>>> _fetchAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print(userId);

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    List<Map<String, dynamic>> appointments = [];

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .get();

      for (var doc in querySnapshot.docs) {
        appointments.add(doc.data());
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }

    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }

          final appointments = snapshot.data!;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];

              // Determine the background color and text color based on the status
              Color backgroundColor;
              Color textColor;
              if (appointment['status'] == 'no') {
                backgroundColor = const Color(0xFF171717);
                textColor = Colors.grey;
              } else if (appointment['status'] == 'booked') {
                backgroundColor = Colors.yellow;
                textColor = Colors.black;
              } else {
                backgroundColor = Colors.white; // default background
                textColor = Colors.black; // default text color
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: textColor.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer: ${appointment['customerName']}',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Employee ID: ${appointment['employeeId']}',
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      'Selected Date: ${appointment['selectedDate']}',
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      'Selected Time Slot: ${appointment['selectedTimeSlot']}',
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      'Shop ID: ${appointment['shopId']}',
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      'Status: ${appointment['status']}',
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
