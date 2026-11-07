import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/incident_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class IncidentProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  List<IncidentModel> _incidents = [];
  StreamSubscription<List<IncidentModel>>? _subscription;

  String _selectedStatusFilter = 'All';
  String _selectedCategoryFilter = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSubmitting = false;

  IncidentProvider() {
    _initIncidentsStream();
  }

  void _initIncidentsStream() {
    _isLoading = true;
    _subscription = _firestoreService.streamIncidents().listen((data) {
      _incidents = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _incidents = _firestoreService.getInitialIncidents();
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // Getters
  List<IncidentModel> get allIncidents => _incidents;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get selectedCategoryFilter => _selectedCategoryFilter;
  String get searchQuery => _searchQuery;

  // Summary counts
  int get totalCount => _incidents.length;
  int get submittedCount =>
      _incidents.where((i) => i.status == IncidentStatus.submitted).length;
  int get inProgressCount =>
      _incidents.where((i) => i.status == IncidentStatus.inProgress).length;
  int get resolvedCount =>
      _incidents.where((i) => i.status == IncidentStatus.resolved).length;

  int myReportsCount(String? userId) {
    if (userId == null) return 0;
    return _incidents.where((i) => i.reporterId == userId).length;
  }

  List<IncidentModel> myReports(String? userId) {
    if (userId == null) return [];
    return _incidents.where((i) => i.reporterId == userId).toList();
  }

  // Filtered incidents
  List<IncidentModel> get filteredIncidents {
    return _incidents.where((incident) {
      // 1. Status Filter
      if (_selectedStatusFilter != 'All') {
        if (_selectedStatusFilter == 'My Reports') {
          // Handled elsewhere or checks reporter
        } else {
          final matchesStatus = incident.status.displayName.toLowerCase() ==
              _selectedStatusFilter.toLowerCase();
          if (!matchesStatus) return false;
        }
      }

      // 2. Category Filter
      if (_selectedCategoryFilter != 'All') {
        if (incident.category.toLowerCase() !=
            _selectedCategoryFilter.toLowerCase()) {
          return false;
        }
      }

      // 3. Search Query
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = incident.title.toLowerCase().contains(query);
        final matchesDesc = incident.description.toLowerCase().contains(query);
        final matchesLoc = incident.location.toLowerCase().contains(query);
        final matchesCategory = incident.category.toLowerCase().contains(query);
        if (!matchesTitle && !matchesDesc && !matchesLoc && !matchesCategory) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void setStatusFilter(String filter) {
    _selectedStatusFilter = filter;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<bool> createIncident({
    required String title,
    required String category,
    required String location,
    required String description,
    required UserModel reporter,
    String priority = 'Medium',
    bool isAnonymous = false,
    XFile? imageFile,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      String? uploadedImageUrl;
      if (imageFile != null) {
        uploadedImageUrl = await _storageService.uploadIncidentImage(imageFile);
      }

      final newIncident = IncidentModel(
        id: _firestoreService.generateId(),
        title: title,
        category: category,
        location: location,
        description: description,
        status: IncidentStatus.submitted,
        reporterId: reporter.uid,
        reporterName: reporter.fullName,
        reporterEmail: reporter.email,
        imageUrl: uploadedImageUrl,
        priority: priority,
        isAnonymous: isAnonymous,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        timeline: [
          TimelineEvent(
            status: IncidentStatus.submitted,
            timestamp: DateTime.now(),
            note: isAnonymous
                ? 'Incident reported anonymously by student'
                : 'Incident reported by ${reporter.fullName}',
            updatedBy: isAnonymous ? 'Anonymous' : reporter.fullName,
          )
        ],
      );

      await _firestoreService.createIncident(newIncident);
      if (!_incidents.any((i) => i.id == newIncident.id)) {
        _incidents.insert(0, newIncident);
      }
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Failed to submit incident: $e');
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStatus({
    required String incidentId,
    required IncidentStatus newStatus,
    required UserModel staffUser,
    String? staffNotes,
  }) async {
    // Only staff can update status
    if (!staffUser.isStaff) {
      throw Exception('Unauthorized: Only campus staff can update incident statuses.');
    }

    try {
      await _firestoreService.updateIncidentStatus(
        incidentId: incidentId,
        newStatus: newStatus,
        updatedBy: staffUser.fullName,
        staffNotes: staffNotes,
      );
      return true;
    } catch (e) {
      debugPrint('Error updating incident status: $e');
      return false;
    }
  }

  Future<bool> deleteIncident(String incidentId, UserModel user) async {
    // Only author or staff can delete
    final incident = _incidents.firstWhere((i) => i.id == incidentId);
    if (!user.isStaff && incident.reporterId != user.uid) {
      throw Exception('Unauthorized: You can only delete your own submitted reports.');
    }

    try {
      await _firestoreService.deleteIncident(incidentId);
      return true;
    } catch (e) {
      debugPrint('Error deleting incident: $e');
      return false;
    }
  }
}
