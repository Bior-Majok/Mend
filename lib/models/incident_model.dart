enum IncidentStatus {
  submitted,
  inProgress,
  resolved;

  String get displayName {
    switch (this) {
      case IncidentStatus.submitted:
        return 'Submitted';
      case IncidentStatus.inProgress:
        return 'In Progress';
      case IncidentStatus.resolved:
        return 'Resolved';
    }
  }

  static IncidentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'inprogress':
      case 'in_progress':
      case 'in progress':
        return IncidentStatus.inProgress;
      case 'resolved':
        return IncidentStatus.resolved;
      case 'submitted':
      default:
        return IncidentStatus.submitted;
    }
  }
}

class TimelineEvent {
  final IncidentStatus status;
  final DateTime timestamp;
  final String note;
  final String updatedBy;

  TimelineEvent({
    required this.status,
    required this.timestamp,
    required this.note,
    required this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
      'updatedBy': updatedBy,
    };
  }

  factory TimelineEvent.fromMap(Map<String, dynamic> map) {
    return TimelineEvent(
      status: IncidentStatus.fromString(map['status'] as String? ?? 'submitted'),
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      note: map['note'] as String? ?? '',
      updatedBy: map['updatedBy'] as String? ?? 'Campus Administration',
    );
  }
}

class IncidentModel {
  final String id;
  final String title;
  final String category;
  final String location;
  final String description;
  final IncidentStatus status;
  final String reporterId;
  final String reporterName;
  final String reporterEmail;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TimelineEvent> timeline;
  final String? staffNotes;

  IncidentModel({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.description,
    required this.status,
    required this.reporterId,
    required this.reporterName,
    required this.reporterEmail,
    this.imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TimelineEvent>? timeline,
    this.staffNotes,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        timeline = timeline ??
            [
              TimelineEvent(
                status: IncidentStatus.submitted,
                timestamp: createdAt ?? DateTime.now(),
                note: 'Report submitted by student',
                updatedBy: reporterName,
              )
            ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'location': location,
      'description': description,
      'status': status.name,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'reporterEmail': reporterEmail,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'timeline': timeline.map((e) => e.toMap()).toList(),
      'staffNotes': staffNotes,
    };
  }

  factory IncidentModel.fromMap(Map<String, dynamic> map, String id) {
    final rawTimeline = map['timeline'] as List<dynamic>? ?? [];
    return IncidentModel(
      id: id,
      title: map['title'] as String? ?? 'Untitled Incident',
      category: map['category'] as String? ?? 'Facilities',
      location: map['location'] as String? ?? 'Campus Ground',
      description: map['description'] as String? ?? '',
      status: IncidentStatus.fromString(map['status'] as String? ?? 'submitted'),
      reporterId: map['reporterId'] as String? ?? '',
      reporterName: map['reporterName'] as String? ?? 'Campus Student',
      reporterEmail: map['reporterEmail'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      timeline: rawTimeline
          .map((item) => TimelineEvent.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList(),
      staffNotes: map['staffNotes'] as String?,
    );
  }

  IncidentModel copyWith({
    String? id,
    String? title,
    String? category,
    String? location,
    String? description,
    IncidentStatus? status,
    String? reporterId,
    String? reporterName,
    String? reporterEmail,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TimelineEvent>? timeline,
    String? staffNotes,
  }) {
    return IncidentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      description: description ?? this.description,
      status: status ?? this.status,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      reporterEmail: reporterEmail ?? this.reporterEmail,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      timeline: timeline ?? this.timeline,
      staffNotes: staffNotes ?? this.staffNotes,
    );
  }
}
