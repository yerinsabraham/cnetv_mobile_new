import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  String exampleData = 'Hello CNETV!';

  void updateData(String newData) {
    exampleData = newData;
    notifyListeners();
  }
}
