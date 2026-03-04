import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remindersEnabledProvider = StateProvider<bool>((ref) => true);
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
