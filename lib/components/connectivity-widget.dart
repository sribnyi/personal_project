import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityStatus extends StatefulWidget {
  final Widget child;

  const ConnectivityStatus({super.key, required this.child});

  @override
  _ConnectivityStatusState createState() => _ConnectivityStatusState();
}

class _ConnectivityStatusState extends State<ConnectivityStatus> {
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() {
          _connectivityStatus = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectivityStatus == ConnectivityResult.none) {
      return const Scaffold(
        body: Center(
          child: Text('FuelApp needs a working internet connection!'),
        ),
      );
    } else {
      return widget.child;
    }
  }
}
