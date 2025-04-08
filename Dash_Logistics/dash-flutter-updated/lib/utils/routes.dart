import 'package:flutter/material.dart';
import 'package:logistics/login/login_screen.dart';
import 'package:logistics/packagedetailpage/package_detail_screen.dart';
import 'package:logistics/signature/signature_screen.dart';

import '../scan.dart';

final routes = {
  '/detail':         (BuildContext context) => new PackageDetailScreen(),
  '/scan':         (BuildContext context) => new QRViewExample(),
 // '/sign':         (BuildContext context) => new Sign(),
  '/':         (BuildContext context) => new PackageDetailScreen(),

};