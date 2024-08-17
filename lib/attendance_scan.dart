import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AttendanceScan extends StatefulWidget {
  final String selectedSportId;
  final String acId;

  const AttendanceScan({super.key, required this.selectedSportId, required this.acId});

  @override
  State<AttendanceScan> createState() => _AttendanceScanState();
}

class _AttendanceScanState extends State<AttendanceScan> {
  late CameraController _cameraController;
  late BarcodeScanner _barcodeScanner;
  Set<String> attendanceRecords = {};
  bool _isCameraInitialized = false;
  Map<String, String> enrolledStudents = {};
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _fetchEnrolledStudents();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
      await _cameraController.initialize().then((_) {
        setState(() {
          _isCameraInitialized = true;
        });
      });
      _barcodeScanner = BarcodeScanner();
      _startBarcodeScanning();
    } else {
      log('No cameras found');
    }
  }

  void _startBarcodeScanning() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) async {
      if (_cameraController.value.isInitialized) {
        final image = await _cameraController.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);
        final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          setState(() {
            for (final barcode in barcodes) {
              final studentId = barcode.rawValue;
              if (studentId != null && enrolledStudents.containsKey(studentId)) {
                if (attendanceRecords.add(studentId)) {
                  // Add sound here if needed
                }
              }
            }
          });
        } else {
          log('No barcode found in the image.');
        }
      }
    });
  }

  Future<void> _fetchEnrolledStudents() async {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:3002/students/api/stud'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'gyjh',
      },
      body: jsonEncode({'sports_id': widget.selectedSportId, 'ac_id': widget.acId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        enrolledStudents = {for (var student in data) student['stud_id']: student['name']};
      });
    } else {
      log('Failed to fetch enrolled students, status code: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _cameraController.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents = enrolledStudents.length;
    final presentStudents = attendanceRecords.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Attendance')),
      body: SafeArea(
        child: Column(
          children: [
            if (_isCameraInitialized)
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                ),
              )
            else
              const Expanded(
                flex: 2,
                child: Center(child: Text('Loading Camera')),
              ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sport ID: ${widget.selectedSportId}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                Text('AC ID: ${widget.acId}', style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Total: $totalStudents', style: const TextStyle(fontSize: 15)),
                                Text('Present: $presentStudents', style: const TextStyle(fontSize: 15, color: Colors.green)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        attendanceRecords.isNotEmpty
                            ? Expanded(
                          child: ListView.builder(
                            itemCount: attendanceRecords.length,
                            itemBuilder: (context, index) {
                              final studentId = attendanceRecords.elementAt(index);
                              final studentName = enrolledStudents[studentId] ?? 'Unknown';
                              return ListTile(
                                title: Text('Student ID: $studentId', style: const TextStyle(fontSize: 15)),
                                subtitle: Text('Name: $studentName', style: const TextStyle(fontSize: 15)),
                              );
                            },
                          ),
                        )
                            : const Center(child: Text('No barcodes found')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: FloatingActionButton.extended(
                  onPressed: (){},
                  // onPressed: () async {
                  //   _timer.cancel();
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       // builder: (context) => ReviewAttendancePage(
                  //       //   enrolledStudentIds: enrolledStudents.keys.toList(),
                  //       //   attendanceRecords: attendanceRecords.toList(),
                  //       //   selectedSportId: widget.selectedSportId,
                  //       //   acId: widget.acId,
                  //       // ),
                  //     ),
                  //   ).then((_) {
                  //     _startBarcodeScanning();
                  //   });
                  // },
                  label: const Text('Review Attendance'),
                  icon: const Icon(Icons.rate_review_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
