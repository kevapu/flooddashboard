import 'package:flutter/material.dart';

class RegionRisk {
  final String regionId;
  final List<String> nodes;
  final String riskLevel;
  final DateTime lastUpdated;

  RegionRisk({
    required this.regionId,
    required this.nodes,
    required this.riskLevel,
    required this.lastUpdated,
  });

  factory RegionRisk.fromJson(String regionId, Map<String, dynamic> json) {
    return RegionRisk(
      regionId: regionId,
      nodes: List<String>.from(json['nodes'] ?? []),
      riskLevel: json['risk_level'] ?? 'Unknown',
      lastUpdated: DateTime.now(),
    );
  }

  // Color mapping for risk levels
  Color getRiskColor() {
    switch (riskLevel) {
      case 'High Flood Risk':
        return Colors.red.withOpacity(0.7);
      case 'Potential Blockage Risk':
        return Colors.orange.withOpacity(0.7);
      case 'Low Risk':
        return Colors.green.withOpacity(0.7);
      default:
        return Colors.grey.withOpacity(0.7);
    }
  }
}

class RegionAnalysis {
  final List<RegionRisk> regions;
  final Map<String, String> individualDrains;
  final DateTime lastUpdated;

  RegionAnalysis({
    required this.regions,
    required this.individualDrains,
    required this.lastUpdated,
  });

  factory RegionAnalysis.fromJson(Map<String, dynamic> json) {
    List<RegionRisk> regions = [];
    
    if (json['regions'] != null) {
      json['regions'].forEach((key, value) {
        regions.add(RegionRisk.fromJson(key, value));
      });
    }

    return RegionAnalysis(
      regions: regions,
      individualDrains: Map<String, String>.from(json['individual_drains'] ?? {}),
      lastUpdated: DateTime.parse(json['last_updated'] ?? DateTime.now().toIso8601String()),
    );
  }
}