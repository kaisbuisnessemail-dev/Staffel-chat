import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class XmppService {
  static final XmppService _instance = XmppService._internal();
  factory XmppService() => _instance;
  XmppService._internal();

  io.Socket? _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect(String jid, String password) {
    final serverUrl = 'ws://chat.staffel.cyou:5280/xmpp-websocket';
    _socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': {
        'jid': jid,
        'password': password,
      },
    });

    _socket!.onConnect((_) {
      _isConnected = true;
      debugPrint('✅ XMPP Connected');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      debugPrint('❌ XMPP Disconnected');
    });

    _socket!.on('message', (data) {
      debugPrint('📩 New message: $data');
    });

    _socket!.on('presence', (data) {
      debugPrint('👤 Presence update: $data');
    });

    _socket!.connect();
  }

  void sendMessage(String to, String message) {
    if (!_isConnected) {
      debugPrint('❌ Not connected to XMPP');
      return;
    }
    final data = {
      'to': to,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _socket!.emit('message', data);
  }

  void sendPresence(String status, String statusMessage) {
    if (!_isConnected) return;
    _socket!.emit('presence', {
      'status': status,
      'status_message': statusMessage,
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _isConnected = false;
  }
}
