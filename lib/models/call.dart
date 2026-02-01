enum CallType { incoming, outgoing, missed }

class Call {
  const Call({
    required this.id,
    required this.phoneNumber,
    required this.timestamp,
    required this.type,
    this.contactName,
    this.duration,
    this.messageSent = false,
    this.simSlot,
    this.simDisplayName,
  });

  final String id;
  final String phoneNumber;
  final DateTime timestamp;
  final CallType type;
  final String? contactName;
  final Duration? duration;
  final bool messageSent;
  final int? simSlot;
  final String? simDisplayName;

  String get displayName => contactName ?? phoneNumber;

  String get formattedDuration {
    if (duration == null) return '';
    final minutes = duration!.inMinutes;
    final seconds = duration!.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'همین الان';
    if (diff.inMinutes < 60) return '${diff.inMinutes} دقیقه پیش';
    if (diff.inHours < 24) return '${diff.inHours} ساعت پیش';
    if (diff.inDays < 7) return '${diff.inDays} روز پیش';
    return '${timestamp.year}/${timestamp.month}/${timestamp.day}';
  }

  String get simLabel {
    // Prioritize showing SIM slot number (سیم ۱ or سیم ۲)
    if (simSlot != null) {
      return 'سیم ${simSlot! + 1}';
    }
    // Fallback to carrier name if slot unknown
    if (simDisplayName != null && simDisplayName!.isNotEmpty) {
      return simDisplayName!;
    }
    return '';
  }

  Call copyWith({
    String? id,
    String? phoneNumber,
    DateTime? timestamp,
    CallType? type,
    String? contactName,
    Duration? duration,
    bool? messageSent,
    int? simSlot,
    String? simDisplayName,
  }) {
    return Call(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      contactName: contactName ?? this.contactName,
      duration: duration ?? this.duration,
      messageSent: messageSent ?? this.messageSent,
      simSlot: simSlot ?? this.simSlot,
      simDisplayName: simDisplayName ?? this.simDisplayName,
    );
  }
}
