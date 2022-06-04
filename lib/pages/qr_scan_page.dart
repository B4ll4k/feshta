import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget buildQriew(BuildContext context) {
    return QRView(key: qrKey, onQRViewCreated: onQRViewCreated);
  }

  void onQRViewCreated(QRViewController p1) {
    setState(() {
      this.qrViewController = p1;
    });
  }
}
