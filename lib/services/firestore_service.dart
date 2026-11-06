import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/incident_model.dart';
import 'firebase_service.dart';

class FirestoreService {
  final FirebaseFirestore? _firestore =
      FirebaseService.isInitialized ? FirebaseFirestore.instance : null;

  // Initial mock data for testing
  final List<IncidentModel> _mockIncidents = [
    IncidentModel(
      id: 'inc_water_001',
      title: 'Water shortage',
      category: 'Water',
      location: 'Student Residence',
      description:
          'There has been no water supply in the student residence since this morning. This is affecting many students on the 2nd floor. Kindly check and fix the issue.',
      status: IncidentStatus.submitted,
      reporterId: 'user_amina_123',
      reporterName: 'Amina Hassan',
      reporterEmail: 'amina.hassan@alustudent.com',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      timeline: [
        TimelineEvent(
          status: IncidentStatus.submitted,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          note: 'Incident report submitted by Amina Hassan',
          updatedBy: 'Amina Hassan',
        ),
      ],
    ),
    IncidentModel(
      id: 'inc_proj_002',
      title: 'Broken classroom projector',
      category: 'Facilities',
      location: 'Block B - Room 104',
      description:
          'The projector HDMI port is unresponsive and bulb flickers intermittently during lectures.',
      status: IncidentStatus.inProgress,
      reporterId: 'user_james_456',
      reporterName: 'James Okafor',
      reporterEmail: 'james.okafor@alustudent.com',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      timeline: [
        TimelineEvent(
          status: IncidentStatus.submitted,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          note: 'Report received by system',
          updatedBy: 'James Okafor',
        ),
        TimelineEvent(
          status: IncidentStatus.inProgress,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          note: 'IT technician dispatched with replacement projector cable',
          updatedBy: 'Campus IT Operations',
        ),
      ],
    ),
    IncidentModel(
      id: 'inc_bin_003',
      title: 'Overflowing bin',
      category: 'Sanitation',
      location: 'Cafeteria Courtyard',
      description:
          'Sanitation bins near the main cafeteria door are overflowing after lunch hours.',
      status: IncidentStatus.resolved,
      reporterId: 'user_nia_789',
      reporterName: 'Nia Smith',
      reporterEmail: 'nia.smith@alustudent.com',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      staffNotes: 'Cleaned and sanitized by campus ground crew.',
      timeline: [
        TimelineEvent(
          status: IncidentStatus.submitted,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          note: 'Report submitted by student',
          updatedBy: 'Nia Smith',
        ),
        TimelineEvent(
          status: IncidentStatus.inProgress,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          note: 'Work order assigned to Sanitation team',
          updatedBy: 'Estate Supervisor',
        ),
        TimelineEvent(
          status: IncidentStatus.resolved,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          note: 'Bins cleared and larger waste receptacles deployed.',
          updatedBy: 'Sanitation Lead',
        ),
      ],
    ),
    IncidentModel(
      id: 'inc_light_004',
      title: 'Flickering corridor lighting',
      category: 'Electricity',
      location: 'Block A - 2nd Floor',
      description:
          'Three fluorescent fixtures in the east wing corridor are buzzing and failing to illuminate properly.',
      status: IncidentStatus.inProgress,
      reporterId: 'user_amina_123',
      reporterName: 'Amina Hassan',
      reporterEmail: 'amina.hassan@alustudent.com',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      timeline: [
        TimelineEvent(
          status: IncidentStatus.submitted,
          timestamp: DateTime.now().subtract(const Duration(days: 4)),
          note: 'Report submitted',
          updatedBy: 'Amina Hassan',
        ),
        TimelineEvent(
          status: IncidentStatus.inProgress,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          note: 'Electrician scheduled for ballast and tube replacement',
          updatedBy: 'Estate Supervisor',
        ),
      ],
    ),
    IncidentModel(
      id: 'inc_safe_005',
      title: 'Loose railing on outdoor staircase',
      category: 'Safety',
      location: 'Sports Field Grandstand',
      description:
          'Handrail wobbles significantly when pushed. Hazard during campus sporting events.',
      status: IncidentStatus.submitted,
      reporterId: 'user_amina_123',
      reporterName: 'Amina Hassan',
      reporterEmail: 'amina.hassan@alustudent.com',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      timeline: [
        TimelineEvent(
          status: IncidentStatus.submitted,
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
          note: 'Safety hazard flagged by student',
          updatedBy: 'Amina Hassan',
        ),
      ],
    ),
  ];

  late final StreamController<List<IncidentModel>> _incidentsStreamController;

  FirestoreService() {
    _incidentsStreamController =
        StreamController<List<IncidentModel>>.broadcast(onListen: () {
      _emitMockList();
    });
  }

  void _emitMockList() {
    _mockIncidents.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _incidentsStreamController.add(List.unmodifiable(_mockIncidents));
  }

  Stream<List<IncidentModel>> streamIncidents() {
    final firestore = _firestore;
    if (FirebaseService.isInitialized && firestore != null) {
      return firestore
          .collection('incidents')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return IncidentModel.fromMap(doc.data(), doc.id);
        }).toList();
      });
    } else {
      return _incidentsStreamController.stream;
    }
  }

  Future<void> createIncident(IncidentModel incident) async {
    final firestore = _firestore;
    if (FirebaseService.isInitialized && firestore != null) {
      try {
        final docRef = firestore.collection('incidents').doc(incident.id);
        await docRef.set(incident.toMap());
      } catch (e) {
        debugPrint('Firestore write error: $e');
        _mockIncidents.insert(0, incident);
        _emitMockList();
      }
    } else {
      _mockIncidents.insert(0, incident);
      _emitMockList();
    }
  }

  Future<void> updateIncidentStatus({
    required String incidentId,
    required IncidentStatus newStatus,
    required String updatedBy,
    String? staffNotes,
  }) async {
    final now = DateTime.now();
    final newEvent = TimelineEvent(
      status: newStatus,
      timestamp: now,
      note: staffNotes ?? 'Status updated to ${newStatus.displayName} by $updatedBy',
      updatedBy: updatedBy,
    );

    final firestore = _firestore;
    if (FirebaseService.isInitialized && firestore != null) {
      try {
        final docRef = firestore.collection('incidents').doc(incidentId);
        await docRef.update({
          'status': newStatus.name,
          'updatedAt': now.toIso8601String(),
          'staffNotes': staffNotes,
          'timeline': FieldValue.arrayUnion([newEvent.toMap()]),
        });
      } catch (e) {
        debugPrint('Firestore update error: $e');
        _updateMockStatus(incidentId, newStatus, newEvent, staffNotes);
      }
    } else {
      _updateMockStatus(incidentId, newStatus, newEvent, staffNotes);
    }
  }

  void _updateMockStatus(
    String incidentId,
    IncidentStatus newStatus,
    TimelineEvent newEvent,
    String? staffNotes,
  ) {
    final index = _mockIncidents.indexWhere((item) => item.id == incidentId);
    if (index != -1) {
      final current = _mockIncidents[index];
      final updatedTimeline = List<TimelineEvent>.from(current.timeline)..add(newEvent);
      _mockIncidents[index] = current.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        timeline: updatedTimeline,
        staffNotes: staffNotes ?? current.staffNotes,
      );
      _emitMockList();
    }
  }

  Future<void> deleteIncident(String incidentId) async {
    final firestore = _firestore;
    if (FirebaseService.isInitialized && firestore != null) {
      try {
        await firestore.collection('incidents').doc(incidentId).delete();
      } catch (e) {
        _mockIncidents.removeWhere((item) => item.id == incidentId);
        _emitMockList();
      }
    } else {
      _mockIncidents.removeWhere((item) => item.id == incidentId);
      _emitMockList();
    }
  }

  String generateId() {
    return const Uuid().v4();
  }
}
