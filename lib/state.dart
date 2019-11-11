import 'package:flutter/cupertino.dart';

class WeathifyState with ChangeNotifier {
  WeathifyState();
  bool _isFetchingData = false;

  void settFetchingDataStatus(bool b) {
    _isFetchingData = b;
    notifyListeners();
  }

  bool getIsFetchingDat() {
    return _isFetchingData;
  }
}
