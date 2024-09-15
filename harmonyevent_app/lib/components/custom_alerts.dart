import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';

void showSuccessAlert(BuildContext context) {     
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 2), 
    title: 'Success',
    subtitle: 'Login completed successfully!', 
    configuration: IconConfiguration(
      icon: Icons.check,
      color: const Color.fromARGB(255, 162, 235, 14),
              size: 180.0,
      ), 
    backgroundColor: Colors.transparent,
    // borderRadius: BorderRadius.circular(10),
  ); 
} 
void showErrorAlert(BuildContext context) { 
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 2), 
    title: 'Invalid username or password!', 
    subtitle: 'Please try again.', 
    configuration: IconConfiguration(
      icon: Icons.block_rounded,
      color: const Color.fromARGB(255, 162, 235, 14),
      size: 180.0,
      ), 
    backgroundColor: const Color.fromARGB(255, 36, 51, 6),
  ); 
} 

void showSuccessAlertCreateEvent(BuildContext context) {     
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 2), 
    title: 'Success',
    subtitle: 'Event created successfully!', 
    configuration: IconConfiguration(
      icon: Icons.check,
      color: const Color.fromARGB(255, 162, 235, 14),
              size: 180.0,
      ), 
    backgroundColor: Colors.transparent,
    // borderRadius: BorderRadius.circular(10),
  ); 
} 
void showErrorAlertCreateEvent(BuildContext context) { 
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 2), 
    title: 'Something went wrong', 
    subtitle: 'Please try again!', 
    configuration: IconConfiguration(
      icon: Icons.block_rounded,
      color: const Color.fromARGB(255, 162, 235, 14),
      size: 180.0,
      ), 
    backgroundColor: const Color.fromARGB(255, 36, 51, 6),
  ); 
} 

void showSuccessAlertCreateUser(BuildContext context) {     
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 2), 
    title: 'Success',
    subtitle: 'User created successfully!', 
    configuration: IconConfiguration(
      icon: Icons.check,
      color: const Color.fromARGB(255, 162, 235, 14),
              size: 180.0,
      ), 
    backgroundColor: Colors.transparent,
    // borderRadius: BorderRadius.circular(10),
  ); 
} 
void showErrorAlertCreateUser(BuildContext context) { 
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 2), 
    title: 'Something went wrong', 
    subtitle: 'Please try again!', 
    configuration: IconConfiguration(
      icon: Icons.block_rounded,
      color: const Color.fromARGB(255, 162, 235, 14),
      size: 180.0,
      ), 
    backgroundColor: const Color.fromARGB(255, 36, 51, 6),
  ); 
} 