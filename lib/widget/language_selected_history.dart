
import 'package:flutter/material.dart';

class CountryHistoryWidget extends StatelessWidget {
  final List<String> countryHistory;
  final Function(String) onDelete;

  const CountryHistoryWidget({Key? key, required this.countryHistory, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: countryHistory.map((country) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Chip(
              label: Text(country),
              onDeleted: () => onDelete(country), 
            ),
          );
        }).toList(),
      ),
    );
  }
}