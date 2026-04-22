import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  AppProvider();

  ThemeMode _themeMode = ThemeMode.light;
  String _fullName = 'Guest User';
  String _username = 'Guest';
  String _role = 'User';
  static const Set<String> _internalUsernames = {'admin', 'helpdesk', 'staff'};

  final Map<String, Map<String, String>> _accounts = {
    'admin': {'name': 'Admin System', 'password': 'admin123', 'role': 'Admin'},
    'helpdesk': {'name': 'Helpdesk Team', 'password': 'helpdesk123', 'role': 'Helpdesk'},
    'staff': {'name': 'Staff IT', 'password': 'staff123', 'role': 'Helpdesk'},
  };

  List<Map<String, dynamic>> _tickets = [
    {
      'id': 'TKT-001',
      'title': 'Internet Mati',
      'status': 'Open',
      'createdAt': DateTime(2026, 4, 18, 9, 30),
      'description': 'Wifi lantai 2 tidak terdeteksi.',
      'reporter': 'budi',
      'comments': <Map<String, dynamic>>[
        {'author': 'Admin', 'text': 'Tiket diteruskan ke helpdesk.'},
      ],
      'imagePath': null,
    },
    {
      'id': 'TKT-002',
      'title': 'Laptop Blue Screen',
      'status': 'In Progress',
      'createdAt': DateTime(2026, 4, 17, 13, 10),
      'description': 'Muncul error saat booting.',
      'reporter': 'ani',
      'comments': <Map<String, dynamic>>[
        {'author': 'Helpdesk', 'text': 'Sedang proses pengecekan RAM.'},
      ],
      'imagePath': null,
    },
  ];

  ThemeMode get themeMode => _themeMode;
  String get fullName => _fullName;
  String get username => _username;
  String get role => _role;
  List<Map<String, dynamic>> get tickets {
    _normalizeTicketStore();
    return List.unmodifiable(_tickets);
  }
  bool get canCreateTicket =>
      _role == 'User' || _role == 'Admin' || _role == 'Helpdesk';
  bool get canManageTicket => _role == 'Helpdesk' || _role == 'Admin';
  bool get canCreateInternalAccount => _role == 'Admin';

  List<Map<String, dynamic>> get visibleTickets {
    _normalizeTicketStore();
    if (_role == 'User') {
      return _tickets.where((t) => t['reporter'] == _username.toLowerCase()).toList();
    }
    return List.unmodifiable(_tickets);
  }

  void _normalizeTicketStore() {
    _tickets = _tickets.map((rawTicket) {
      final ticket = Map<String, dynamic>.from(rawTicket);

      final rawComments = ticket['comments'];
      if (rawComments is List) {
        ticket['comments'] = rawComments
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      } else {
        ticket['comments'] = <Map<String, dynamic>>[];
      }

      final rawCreatedAt = ticket['createdAt'];
      if (rawCreatedAt is DateTime) {
        ticket['createdAt'] = rawCreatedAt;
      } else if (rawCreatedAt is String) {
        ticket['createdAt'] = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
      } else {
        ticket['createdAt'] = DateTime.now();
      }

      ticket['id'] = (ticket['id'] ?? '').toString();
      ticket['title'] = (ticket['title'] ?? '').toString();
      ticket['description'] = (ticket['description'] ?? '').toString();
      ticket['status'] = (ticket['status'] ?? 'Open').toString();
      ticket['reporter'] = (ticket['reporter'] ?? 'guest').toString();

      return ticket;
    }).toList();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setUsername(String name) {
    _username = name.trim().isEmpty ? 'Guest' : name.trim();
    notifyListeners();
  }

  bool login(String username, String password) {
    final cleanedUsername = username.trim();
    final cleanedPassword = password.trim();

    if (cleanedUsername.isEmpty || cleanedPassword.isEmpty) {
      return false;
    }

    final lookup = cleanedUsername.toLowerCase();
    final account = _accounts[lookup];

    if (account == null) {
      return false;
    }

    final expectedPassword = account['password'];
    if (cleanedPassword != expectedPassword) {
      return false;
    }

    _username = cleanedUsername;
    _fullName = account['name'] ?? cleanedUsername;
    _role = _normalizeRole(account['role']);
    notifyListeners();
    return true;
  }

  bool registerAccount({
    required String name,
    required String username,
    required String password,
  }) {
    final cleanedName = name.trim();
    final cleanedUsername = username.trim();
    final cleanedPassword = password.trim();

    if (cleanedName.isEmpty || cleanedUsername.isEmpty || cleanedPassword.isEmpty) {
      return false;
    }

    final key = cleanedUsername.toLowerCase();
    if (_accounts.containsKey(key) || _internalUsernames.contains(key)) {
      return false;
    }

    _accounts[key] = {
      'name': cleanedName,
      'password': cleanedPassword,
      'role': 'User',
    };

    notifyListeners();
    return true;
  }

  bool createInternalAccount({
    required String name,
    required String username,
    required String password,
    required String role,
  }) {
    if (!canCreateInternalAccount) {
      return false;
    }

    final cleanedName = name.trim();
    final cleanedUsername = username.trim();
    final cleanedPassword = password.trim();
    final normalizedRole = _normalizeRole(role);

    if (cleanedName.isEmpty || cleanedUsername.isEmpty || cleanedPassword.length < 6) {
      return false;
    }

    if (normalizedRole != 'Admin' && normalizedRole != 'Helpdesk') {
      return false;
    }

    final key = cleanedUsername.toLowerCase();
    if (_accounts.containsKey(key)) {
      return false;
    }

    _accounts[key] = {
      'name': cleanedName,
      'password': cleanedPassword,
      'role': normalizedRole,
    };

    notifyListeners();
    return true;
  }

  void logout() {
    _fullName = 'Guest User';
    _username = 'Guest';
    _role = 'User';
    notifyListeners();
  }

  bool updateProfile({
    required String name,
    required String username,
  }) {
    final cleanedName = name.trim();
    final cleanedUsername = username.trim();
    if (cleanedName.isEmpty || cleanedUsername.isEmpty) {
      return false;
    }

    final oldKey = _username.toLowerCase();
    final newKey = cleanedUsername.toLowerCase();
    final account = _accounts[oldKey];
    if (account == null) {
      return false;
    }

    if (newKey != oldKey && _accounts.containsKey(newKey)) {
      return false;
    }

    final updated = {
      'name': cleanedName,
      'password': account['password'] ?? '',
      'role': _normalizeRole(account['role'] ?? _role),
    };

    if (newKey != oldKey) {
      _accounts.remove(oldKey);
      _accounts[newKey] = updated;
      if (_role == 'User') {
        for (final ticket in _tickets) {
          if (ticket['reporter'] == oldKey) {
            ticket['reporter'] = newKey;
          }
        }
      }
    } else {
      _accounts[oldKey] = updated;
    }

    _fullName = cleanedName;
    _username = cleanedUsername;
    _role = _normalizeRole(updated['role'] ?? _role);

    notifyListeners();
    return true;
  }

  bool changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    final oldPwd = currentPassword.trim();
    final newPwd = newPassword.trim();
    if (oldPwd.isEmpty || newPwd.length < 6) {
      return false;
    }

    final key = _username.toLowerCase();
    final account = _accounts[key];
    if (account == null) {
      return false;
    }

    if (account['password'] != oldPwd) {
      return false;
    }

    account['password'] = newPwd;
    notifyListeners();
    return true;
  }

  String _generateTicketId() {
    _normalizeTicketStore();
    final next = _tickets.length + 1;
    return 'TKT-${next.toString().padLeft(3, '0')}';
  }

  void addTicket(String title, String description, {String? imagePath}) {
    _normalizeTicketStore();
    final newId = _generateTicketId();
    final now = DateTime.now();

    _tickets.insert(0, {
      'id': newId,
      'title': title,
      'status': 'Open',
      'createdAt': now,
      'description': description,
      'reporter': _username.toLowerCase(),
      'comments': <Map<String, dynamic>>[
        {'author': _role, 'text': 'Tiket dibuat oleh $_username.'},
      ],
      'imagePath': imagePath,
    });

    notifyListeners();
  }

  void updateTicketStatus(String ticketId, String status) {
    _normalizeTicketStore();
    if (!canManageTicket) {
      return;
    }

    final idx = _tickets.indexWhere((t) => t['id'] == ticketId);
    if (idx == -1) {
      return;
    }

    _tickets[idx]['status'] = status;
    final comments = _tickets[idx]['comments'] as List<dynamic>;
    comments.add({'author': _role, 'text': 'Status diubah menjadi $status.'});
    notifyListeners();
  }

  void addComment(String ticketId, String message) {
    _normalizeTicketStore();
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final idx = _tickets.indexWhere((t) => t['id'] == ticketId);
    if (idx == -1) {
      return;
    }

    final comments = _tickets[idx]['comments'] as List<dynamic>;
    comments.add({'author': _role, 'text': trimmed});
    notifyListeners();
  }

  Map<String, int> get ticketStats {
    final source = visibleTickets;
    final open = source.where((t) => t['status'] == 'Open').length;
    final inProgress = source.where((t) => t['status'] == 'In Progress').length;
    final resolved = source.where((t) => t['status'] == 'Resolved').length;
    return {
      'total': source.length,
      'open': open,
      'inProgress': inProgress,
      'resolved': resolved,
    };
  }

  String _normalizeRole(String? value) {
    if (value == 'Admin' || value == 'Helpdesk' || value == 'User') {
      return value!;
    }
    return 'User';
  }
}