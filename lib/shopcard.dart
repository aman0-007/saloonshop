import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saloonshop/shopinfo.dart';

class ShopCard extends StatefulWidget {
  final Map<String, dynamic> shop;
  final double deviceWidth;
  final double deviceHeight;

  const ShopCard({
    super.key,
    required this.shop,
    required this.deviceWidth,
    required this.deviceHeight,
  });

  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  late Timer _timer;
  bool _isDotVisible = true;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _isDotVisible = !_isDotVisible;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getShopStatus(Map<String, dynamic> timings) {
    final DateTime now = DateTime.now();
    final String currentDay = DateFormat('EEEE').format(now);

    if (timings.containsKey(currentDay)) {
      final Map<String, dynamic> dayTiming = timings[currentDay];
      if (dayTiming.containsKey('status')) {
        return dayTiming['status'];
      }

      final String? openTimeStr = dayTiming['openTime'];
      final String? closeTimeStr = dayTiming['closeTime'];

      if (openTimeStr != null && closeTimeStr != null) {
        final DateFormat timeFormat = DateFormat('hh:mm a');
        final DateTime openTime = timeFormat.parse(openTimeStr).copyWith(year: now.year, month: now.month, day: now.day);
        final DateTime closeTime = timeFormat.parse(closeTimeStr).copyWith(year: now.year, month: now.month, day: now.day);

        final DateTime adjustedCloseTime = closeTime.isBefore(openTime) ? closeTime.add(const Duration(days: 1)) : closeTime;

        if (now.isAfter(openTime) && now.isBefore(adjustedCloseTime)) {
          return 'open';
        }
      }
    }
    return 'closed'; // Default if status is unknown or no timings are available
  }

  @override
  Widget build(BuildContext context) {
    final String status = _getShopStatus(widget.shop['shopTimings'] ?? {});

    Color statusColor;
    String statusText;
    Widget statusDot;

    if (status == 'open') {
      statusColor = Colors.green;
      statusText = 'Open Now';
      statusDot = AnimatedOpacity(
        opacity: _isDotVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
      );
    } else {
      statusColor = Colors.red;
      statusText = 'Closed';
      statusDot = Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: statusColor,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: widget.deviceWidth * 0.47,
      height: widget.deviceHeight * 0.35,
      margin: EdgeInsets.only(right: widget.deviceWidth * 0.07),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(128, 128, 128, 0.5),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.grey[900],
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    widget.shop['profileImage'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.shop['shopName'] ?? 'Shop Name',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    statusDot,
                    const SizedBox(width: 5),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.yellow,
                      size: 12,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.shop['distance']?.toStringAsFixed(2) ?? 'N/A'} km',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: widget.deviceWidth * 0.073,
                      height: widget.deviceHeight * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopInfo(
                                name: widget.shop['shopName'] ?? 'Shop Name',
                                docId: widget.shop['docId'] ?? '',  // Pass the docId here
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: widget.deviceHeight * 0.04,
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'BOOK NOW',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

