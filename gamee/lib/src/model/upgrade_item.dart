import 'package:flutter/material.dart';

class UpgradeItem {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final int price;

  const UpgradeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.price,
  });
}
