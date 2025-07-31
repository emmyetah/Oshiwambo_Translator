import 'package:flutter/material.dart';
import 'viewmodels/phrases_vm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PhraseViewModel viewModel = PhraseViewModel();
  final TextEditingController controller = TextEditingController();
  String translation = "";

  @override
  void initState() {
    super.initState();
    viewModel.loadPhrases();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Oshiwambo Translator")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: "Enter English phrase"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final result = viewModel.search(controller.text);
                  setState(() {
                    translation = result?.oshikwanyama ?? "Not found";
                  });
                  //delete when finished
                  print ("Input: ${controller.text}");
                  print("Result: ${result?.english} -> ${result?.oshikwanyama}");
                },
                child: Text("Translate"),
              ),
              SizedBox(height: 20),
              Text("Translation: $translation"),
            ],
          ),
        ),
      ),
    );
  }
}
