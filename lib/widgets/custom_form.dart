import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quit_mate/widgets/custom_text_box.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({super.key});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _field1Controller = TextEditingController();
  final _field2Controller = TextEditingController();
  final _field3Controller = TextEditingController();

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  Future<void> _createAndWriteFile() async {
    final field1 = _field1Controller.text;
    final field2 = _field2Controller.text;
    final field3 = _field3Controller.text;
    String directoryPath = '/storage/emulated/0/Download/QuitMate';
    String filePath = '$directoryPath/form_data.txt';

    final file = File(filePath);

    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        print('Directory created at: $directoryPath');
      }

      if (!await file.exists()) {
        await file.create();
        print('File created at: $filePath');
      }

      await file.writeAsString('$field1\n$field2\n$field3');
      print('Data written to the file: $filePath');

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File created and data saved!')));
    } catch (e) {
      print('Error creating or writing to the file: $e');
    }
  }

  Future<void> _loadDataFromFile() async {
    String directoryPath = '/storage/emulated/0/Download/QuitMate';
    String filePath = '$directoryPath/form_data.txt';

    final file = File(filePath);

    try {
      if (await file.exists()) {
        String fileContents = await file.readAsString();
        List<String> fields = fileContents.split('\n');

        // Populate the text fields with data from the file
        if (fields.length == 3) {
          _field1Controller.text = fields[0];
          _field2Controller.text = fields[1];
          _field3Controller.text = fields[2];
        }
        print('Data loaded from the file: $filePath');
      } else {
        print('File does not exist at: $filePath');
      }
    } catch (e) {
      print('Error reading the file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDataFromFile();
  }

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    _field3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quit Smoking Bro!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextBox(
                label: 'How many cigarettes do you smoke per day?',
                hintText: '300',
                icon: Icons.smoke_free,
                controller: _field1Controller,
                validator: _validateNumber,
              ),
              const SizedBox(height: 16),
              CustomTextBox(
                label: 'How much does a pack of cigarettes cost?',
                hintText: 'My soul',
                icon: Icons.smoke_free,
                controller: _field2Controller,
                validator: _validateNumber,
              ),
              const SizedBox(height: 16),
              CustomTextBox(
                label: 'How many pieces are in a box?',
                hintText: 'Not enough',
                icon: Icons.smoke_free,
                controller: _field3Controller,
                validator: _validateNumber,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createAndWriteFile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
