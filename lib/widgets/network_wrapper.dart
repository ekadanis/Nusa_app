import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../widgets/offline_screen.dart';


enum NetworkUIType { fullScreen, banner, none }

class NetworkWrapper extends StatefulWidget {
  final Widget child;
  final NetworkUIType networkUIType;

  const NetworkWrapper({
    Key? key,
    required this.child,
    this.networkUIType = NetworkUIType.fullScreen,
  }) : super(key: key);

  @override
  State<NetworkWrapper> createState() => _NetworkWrapperState();
}

class _NetworkWrapperState extends State<NetworkWrapper> {
  final NetworkService _networkService = NetworkService();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _initializeNetwork();
  }

  Future<void> _initializeNetwork() async {
    // Check initial connection
    final isConnected = await _networkService.checkConnection();
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }

    // Listen for connection changes
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
    switch (widget.networkUIType) {
      case NetworkUIType.none:
        return widget.child;
      
      case NetworkUIType.banner:
        return Stack(
          children: [
            widget.child,
            if (!_isConnected)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'No internet connection',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _retryConnection,
                          child: const Text(
                            'Try Again',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      
      case NetworkUIType.fullScreen:
      default:
        if (_isConnected) {
          return widget.child;
        }
        return OfflineScreen(
          onRetry: _retryConnection,
        );
    }
  }
}
