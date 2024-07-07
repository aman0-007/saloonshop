import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:saloonshop/location.dart';
import 'package:saloonshop/savedata.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Ownerside extends StatefulWidget {
  const Ownerside({super.key});

  @override
  State<Ownerside> createState() => _OwnersideState();
}

class _OwnersideState extends State<Ownerside> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopDescriptionController = TextEditingController();
  final TextEditingController _shopOpeningTimeController = TextEditingController();
  final TextEditingController _shopClosingTimeController = TextEditingController();
  final TextEditingController _shopOpenDaysController = TextEditingController();

  DateTime? _shopOpeningTime;
  DateTime? _shopClosingTime;

  bool _isTextFieldFocused = false;
  Position? _currentPosition;

  final ULocation _locationService = ULocation();
  final Savedata _dataService = Savedata();

  final List<Map<String, dynamic>> _services = [];

  // File? _profileImage;
  // File? _shopImage;
  PlatformFile? _profileImage;
  PlatformFile? _shopImage;
  final ImagePicker _picker = ImagePicker();
  String _profileImageName = '';
  String _shopImageName = '';

  // Future<void> _pickProfileImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImage = File(pickedFile.path);
  //       _profileImageName = _profileImage!.path.split('/').last;
  //     });
  //   }
  // }
  //
  // Future<void> _pickShopImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _shopImage = File(pickedFile.path);
  //       _shopImageName = _shopImage!.path.split('/').last;
  //     });
  //   }
  // }

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb, // Set to true for web to get file bytes
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _profileImage = result.files.first;
        _profileImageName = _profileImage!.name;
      });
    }
  }

  Future<void> _pickShopImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb, // Set to true for web to get file bytes
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _shopImage = result.files.first;
        _shopImageName = _shopImage!.name;
      });
    }
  }

  Widget _buildImagePicker({
    required String imageName,
    required VoidCallback onPickImage,
    required String label,
  }) {
    return Column(
      children: [
        Text(imageName),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPickImage,
          child: Text('Upload $label Image'),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context, {required bool isOpeningTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final DateTime now = DateTime.now();
      final DateTime selectedDateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        if (isOpeningTime) {
          _shopOpeningTime = selectedDateTime;
          _shopOpeningTimeController.text = DateFormat.jm().format(selectedDateTime);
        } else {
          _shopClosingTime = selectedDateTime;
          _shopClosingTimeController.text = DateFormat.jm().format(selectedDateTime);
        }
      });
    }
  }

  Future<void> _selectDays(BuildContext context, TextEditingController controller) async {
    final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final List<bool> selectedDays = List.generate(weekdays.length, (index) => false);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Days'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(weekdays.length, (index) {
                  return CheckboxListTile(
                    title: Text(weekdays[index]),
                    value: selectedDays[index],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedDays[index] = value!;
                      });
                    },
                  );
                }),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                final selectedWeekdays = <String>[];
                for (int i = 0; i < weekdays.length; i++) {
                  if (selectedDays[i]) {
                    selectedWeekdays.add(weekdays[i]);
                  }
                }
                controller.text = selectedWeekdays.join(', ');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addService() {
    setState(() {
      _services.add({
        'serviceName': TextEditingController(),
        'servicePrice': TextEditingController(),
        'serviceTime': '30 mins',
      });
    });
  }

  Widget _buildServiceForm(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _services[index]['serviceName'],
              decoration: InputDecoration(
                labelText: 'Service Name',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _services[index]['servicePrice'],
              decoration: InputDecoration(
                labelText: 'Service Price',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _services[index]['serviceTime'],
              decoration: InputDecoration(
                labelText: 'Service Time Required',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              items: [
                '30 mins', '45 mins', '1 hr', '1 hr 30 mins', '2 hrs'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _services[index]['serviceTime'] = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _services.removeAt(index);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Remove Service'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Center(
                child: Flexible(
                  child: Container(
                    width: deviceWidth * 0.76,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Add Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: deviceHeight * 0.03),
                        TextField(
                          controller: _shopNameController,
                          decoration: InputDecoration(
                            hintText: 'Shop Name',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _isTextFieldFocused = true;
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _isTextFieldFocused = false;
                            });
                          },
                          onChanged: (value) {
                            // Handle text changes
                          },
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        TextField(
                          controller: _shopDescriptionController,
                          decoration: InputDecoration(
                            hintText: 'Shop Description',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _isTextFieldFocused = true;
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _isTextFieldFocused = false;
                            });
                          },
                          onChanged: (value) {
                            // Handle text changes
                          },
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Opening Time',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onTap: () {
                            _selectTime(context, isOpeningTime: true);
                          },
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Closing Time',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onTap: () {
                            _selectTime(context, isOpeningTime: false);
                          },
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        TextField(
                          controller: _shopOpenDaysController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Open Days',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onTap: () {
                            _selectDays(context, _shopOpenDaysController);
                          },
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),

                        const Text(
                          'Add Services',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _services.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildServiceForm(index);
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _addService,
                          child: const Text('Add Service'),
                        ),
                        SizedBox(height: deviceHeight * 0.03),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        const Text(
                          'Upload Images',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        _buildImagePicker(
                          imageName: _profileImageName,
                          onPickImage: _pickProfileImage,
                          label: 'Profile',
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        _buildImagePicker(
                          imageName: _shopImageName,
                          onPickImage: _pickShopImage,
                          label: 'Shop',
                        ),

                        SizedBox(height: deviceHeight * 0.01),
                        ElevatedButton(
                          onPressed: () async {
                            await _locationService.getCurrentLocation((position) {
                              setState(() {
                                _currentPosition = position;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Button color
                            foregroundColor: Colors.black, // Text color
                            padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.013, horizontal: deviceWidth * 0.21),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            'Get Location',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.03),
                        ElevatedButton(
                          onPressed: () async {
                            await _dataService.saveShopOwnerDetails(
                              context: context,
                              shopNameController: _shopNameController,
                              shopDescriptionController: _shopDescriptionController,
                              shopOpeningTime: _shopOpeningTime,
                              shopClosingTime: _shopClosingTime,
                              shopOpenDaysController: _shopOpenDaysController,
                              currentPosition: _currentPosition,
                              services: _services,
                              profileImage: _profileImage,
                              shopImage: _shopImage,
                            );
                          },
                          child: const Text("Save Data and Location"),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
