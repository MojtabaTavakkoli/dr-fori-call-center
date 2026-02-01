import 'package:call_log/call_log.dart' as call_log;
import 'package:permission_handler/permission_handler.dart';
import 'package:dr_fori_call_center/models/call.dart';

class CallService {
  // Cache for mapping SIM identifiers to slot numbers
  final Map<String, int> _simSlotCache = {};

  Future<bool> requestPermission() async {
    try {
      // Request both phone and contacts permissions for full call log access
      final results = await [
        Permission.phone,
        Permission.contacts,
      ].request();
      
      return results[Permission.phone]?.isGranted == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasPermission() async {
    try {
      return await Permission.phone.isGranted;
    } catch (e) {
      return false;
    }
  }

  Future<PermissionStatus> getPermissionStatus() async {
    try {
      return await Permission.phone.status;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  Future<List<Call>> getRecentCalls({int? limit}) async {
    final hasAccess = await hasPermission();
    if (!hasAccess) {
      return [];
    }

    try {
      // Get all calls first, then filter by date
      final now = DateTime.now();
      final oneMonthAgo = now.subtract(const Duration(days: 30));
      
      // Query all calls without filters to ensure we get both SIMs
      final entries = await call_log.CallLog.get();
      final entriesList = entries.toList();
      
      // Build SIM slot cache from all entries
      _buildSimSlotCache(entriesList);
      
      // Filter by date and map to Call objects
      final callsList = entriesList
          .where((entry) {
            if (entry.timestamp == null) return false;
            final callTime = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
            return callTime.isAfter(oneMonthAgo) && callTime.isBefore(now);
          })
          .map(_mapCallEntry)
          .toList();
      
      if (limit != null) {
        return callsList.take(limit).toList();
      }
      return callsList;
    } catch (e) {
      return [];
    }
  }

  void _buildSimSlotCache(List<call_log.CallLogEntry> entries) {
    _simSlotCache.clear();
    
    for (final entry in entries) {
      final simId = _getSimIdentifier(entry);
      if (simId != null && !_simSlotCache.containsKey(simId)) {
        // Assign slot based on order of discovery (first unique SIM = 0, second = 1)
        _simSlotCache[simId] = _simSlotCache.length;
      }
    }
  }

  String? _getSimIdentifier(call_log.CallLogEntry entry) {
    // Prefer phoneAccountId as it's more unique
    if (entry.phoneAccountId != null && entry.phoneAccountId!.isNotEmpty) {
      return entry.phoneAccountId;
    }
    // Fallback to simDisplayName (carrier name)
    if (entry.simDisplayName != null && entry.simDisplayName!.isNotEmpty) {
      return entry.simDisplayName;
    }
    return null;
  }

  Call _mapCallEntry(call_log.CallLogEntry entry) {
    final simSlot = _detectSimSlot(entry);
    
    return Call(
      id: entry.timestamp?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      phoneNumber: entry.number ?? '',
      contactName: entry.name,
      timestamp: DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0),
      type: _mapCallType(entry.callType),
      duration: Duration(seconds: entry.duration ?? 0),
      simSlot: simSlot,
      simDisplayName: _getSimDisplayName(entry),
    );
  }

  int? _detectSimSlot(call_log.CallLogEntry entry) {
    // Use cached SIM slot based on unique identifier
    final simId = _getSimIdentifier(entry);
    if (simId != null && _simSlotCache.containsKey(simId)) {
      return _simSlotCache[simId];
    }
    
    return null;
  }

  String? _getSimDisplayName(call_log.CallLogEntry entry) {
    return entry.simDisplayName;
  }

  CallType _mapCallType(call_log.CallType? type) {
    return switch (type) {
      call_log.CallType.incoming || call_log.CallType.answeredExternally => CallType.incoming,
      call_log.CallType.outgoing => CallType.outgoing,
      call_log.CallType.missed || call_log.CallType.rejected || call_log.CallType.blocked || call_log.CallType.voiceMail => CallType.missed,
      _ => CallType.incoming,
    };
  }
}
