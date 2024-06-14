import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

const spinner = NutsActivityIndicator(
  activeColor: Colors.red,
  inactiveColor: Colors.blueGrey,
  tickCount: 20,
  relativeWidth: 0.4,
  radius: 15,
  startRatio: 0.7,
  animationDuration: Duration(milliseconds: 800),
);
