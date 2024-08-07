import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingBottomSheet extends StatefulWidget {
  final String? selectedEmployeeId;
  final Set<String> selectedMenuIds;

  const BookingBottomSheet({
    Key? key,
    this.selectedEmployeeId,
    required this.selectedMenuIds,
  }) : super(key: key);

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  DateTime _selectedDate = DateTime.now();
  DateTime? _savedDate; // Variable to save the selected date

  final List<DateTime> _dateOptions = List.generate(
    7,
        (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // Increased height
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DATE & TIME',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildDatePicker(),
            SizedBox(height: 20),
            Text(
              'DATE',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 10),
            _buildDateSelector(),
            SizedBox(height: 20),
            Text(
              'TIME',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                  // Optionally, use _savedDate for further processing
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Button color
                  foregroundColor: Colors.black, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Book Now'),
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
            icon: Icon(Icons.arrow_left, color: Colors.yellow),
            onPressed: () {
              setState(() {
                if (_selectedDate.month > DateTime.now().month) {
                  _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
                }
              });
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right, color: Colors.yellow),
            onPressed: () {
              setState(() {
                if (_selectedDate.month < DateTime.now().add(Duration(days: 30)).month) {
                  _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
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
            onTap: () {
              setState(() {
                _selectedDate = date;
                _savedDate = date; // Save the selected date
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.all(10),
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
}
