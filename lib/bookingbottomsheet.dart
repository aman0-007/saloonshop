import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingBottomSheet extends StatefulWidget {
  final String? selectedEmployeeId;
  final Set<String> selectedMenuIds;

  const BookingBottomSheet({
    super.key,
    this.selectedEmployeeId,
    required this.selectedMenuIds,
  });

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  DateTime _selectedDate = DateTime.now();
  Map<String, String> _timeSlots = {};
  String? _selectedTimeSlot;

  final List<DateTime> _dateOptions = List.generate(
    7,
        (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateOptions.first; // Set first date as selected by default
    _fetchTimeSlotsForDate(_selectedDate); // Fetch initial time slots for the first date
  }

  void _fetchTimeSlotsForDate(DateTime date) async {
    if (widget.selectedEmployeeId == null) return;

    // Format the date for Firestore path
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final formattedMonth = DateFormat('MMMM yyyy').format(date);

    // Print for debugging
    print('Fetching time slots for employee: ${widget.selectedEmployeeId}');
    print('Date selected: $formattedDate');
    print('Formatted month: $formattedMonth');

    try {
      // Fetch document from the nested collection
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.selectedEmployeeId)
          .collection('appointments')
          .doc(formattedMonth)
          .collection('days')
          .doc(formattedDate)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        print('Document data retrieved: $data');

        // Extract time slots from the retrieved data
        final timeSlotsData = data['timeSlots'] as Map<String, dynamic>;
        print('Time slots data: $timeSlotsData');

        setState(() {
          _timeSlots = timeSlotsData.map((time, slotData) {
            // Assuming each slotData has a 'status' field
            final status = slotData['status'] as String;
            return MapEntry(time, status);
          });
          // Reset selected time slot when new data is fetched
          _selectedTimeSlot = null;
        });
      } else {
        print('Document does not exist for date: $formattedDate');
        setState(() {
          _timeSlots = {};
          _selectedTimeSlot = null; // Reset selected time slot
        });
      }
    } catch (e) {
      print('Error fetching time slots: $e');
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _fetchTimeSlotsForDate(date); // Fetch and show time slots for the selected date
    });
  }

  void _onSlotTap(String time) async {
    setState(() {
      if (_selectedTimeSlot == time) {
        // Deselect if already selected
        _timeSlots[time] = "available";
        _selectedTimeSlot = null;
      } else {
        // Deselect previous slot
        if (_selectedTimeSlot != null) {
          _timeSlots[_selectedTimeSlot!] = "available";
        }
        // Select new slot
        _timeSlots[time] = "selected";
        _selectedTimeSlot = time;
      }
    });

    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(widget.selectedEmployeeId)
        .collection('slots')
        .doc(formattedDate)
        .update({
      'timeSlots.$time': _selectedTimeSlot == time ? 'available' : 'selected',
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DATE & TIME',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildDatePicker(),
            const SizedBox(height: 20),
            const Text(
              'DATE',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildDateSelector(),
            const SizedBox(height: 20),
            const Text(
              'TIME',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildTimeSlots(), // Display time slots
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left, color: Colors.yellow),
            onPressed: () {
              setState(() {
                if (_selectedDate.month > DateTime.now().month) {
                  _selectedDate =
                      DateTime(_selectedDate.year, _selectedDate.month - 1);
                  _fetchTimeSlotsForDate(_selectedDate); // Fetch slots for the new month
                }
              });
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right, color: Colors.yellow),
            onPressed: () {
              setState(() {
                if (_selectedDate.month <
                    DateTime.now().add(const Duration(days: 30)).month) {
                  _selectedDate =
                      DateTime(_selectedDate.year, _selectedDate.month + 1);
                  _fetchTimeSlotsForDate(_selectedDate); // Fetch slots for the new month
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _dateOptions.map((date) {
          final bool isSelected = date == _selectedDate;
          return GestureDetector(
            onTap: () => _onDateSelected(date),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.yellow : Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeSlots() {
    if (_timeSlots.isEmpty) {
      return Center(
        child: Text(
          'Shop Closed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _timeSlots.keys.map((time) {
          final String status = _timeSlots[time]!;
          final bool isSelected = time == _selectedTimeSlot;
          final bool isDisabled = status == "yes" || status == "booked";
          final Color backgroundColor = isSelected
              ? Colors.yellow
              : isDisabled
              ? Colors.grey[700]!
              : Colors.grey[800]!;
          final Color textColor = isSelected
              ? Colors.black
              : isDisabled
              ? Colors.grey[500]!
              : Colors.white;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: GestureDetector(
              onTap: isDisabled
                  ? null
                  : () => _onSlotTap(time),
              child: Center(
                child: Text(
                  time,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
