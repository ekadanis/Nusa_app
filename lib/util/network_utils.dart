import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../widgets/offline_screen.dart';

/// Extension to easily check network status and show offline screen
extension NetworkChecker on Widget {
  /// Wraps the widget with network checking capability
  Widget withNetworkCheck({bool showOfflineScreen = true}) {
    return NetworkStatusWidget(
      child: this,
      showOfflineScreen: showOfflineScreen,
    );
  }
}

class NetworkStatusWidget extends StatefulWidget {
  final Widget child;
  final bool showOfflineScreen;

  const NetworkStatusWidget({
    Key? key,
    required this.child,
    this.showOfflineScreen = true,
  }) : super(key: key);

  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  final NetworkService _networkService = NetworkService();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _listenToConnectionChanges();
  }

  Future<void> _checkInitialConnection() async {
    final isConnected = await _networkService.checkConnection();
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }
  }

  void _listenToConnectionChanges() {
    _networkService.connectionStatus.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  Future<void> _retryConnection() async {
    final isConnected = await _networkService.checkConnection();
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showOfflineScreen || _isConnected) {
      return widget.child;
    }

    return OfflineScreen(
      onRetry: _retryConnection,
    );
  }
}

/// Utility class for network operations
class NetworkUtils {
  static final NetworkService _networkService = NetworkService();

  /// Check if device is connected to internet
  static Future<bool> isConnected() async {
    return await _networkService.checkConnection();
  }

  /// Get network status stream
  static Stream<bool> get connectionStatus => _networkService.connectionStatus;

  /// Show snackbar when offline
  static void showOfflineSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 8),
            Text('Tidak ada koneksi internet'),
          ],
        ),
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Coba Lagi',
          textColor: Colors.white,
          onPressed: () async {
            await _networkService.checkConnection();
          },
        ),
      ),
    );
  }

  /// Execute function only if connected, otherwise show offline message
  static Future<T?> executeIfConnected<T>(
    BuildContext context,
    Future<T> Function() function, {
    bool showSnackBar = true,
  }) async {
    final isConnected = await _networkService.checkConnection();
    
    if (!isConnected) {
      if (showSnackBar && context.mounted) {
        showOfflineSnackBar(context);
      }
      return null;
    }
    
    return await function();
  }
}
