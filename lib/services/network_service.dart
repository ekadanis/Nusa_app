import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = 
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    // Check initial connectivity
    await _checkConnectivity();
    
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
  }  Future<void> _checkConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      final hasConnection = await _hasInternetConnection(connectivityResults);
      _updateConnectionStatus(hasConnection);
    } catch (e) {
      // Error saat memeriksa konektivitas
      _updateConnectionStatus(false);
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) async {
    final hasConnection = await _hasInternetConnection(results);
    _updateConnectionStatus(hasConnection);
  }

  Future<bool> _hasInternetConnection(List<ConnectivityResult> connectivityResults) async {
    if (connectivityResults.contains(ConnectivityResult.none) && connectivityResults.length == 1) {
      return false;
    }    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      // Error saat memeriksa koneksi internet
      return false;
    }
  }
  void _updateConnectionStatus(bool isConnected) {
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _connectionStatusController.add(isConnected);
      // Status jaringan berubah
    }
  }

  Future<bool> checkConnection() async {
    await _checkConnectivity();
    return _isConnected;
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
