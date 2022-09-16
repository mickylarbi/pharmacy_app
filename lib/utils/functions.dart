import 'package:flutter/material.dart';

Future<T?> navigate<T extends Object?>(
        BuildContext context, Widget destination) =>
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => destination));

List<String> hiredServices = [];
int pagesToPop = 0;
