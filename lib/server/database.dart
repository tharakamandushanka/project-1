import 'package:flutter_application_1/models/expence.dart';
import 'package:hive/hive.dart';

class Database {
  //create a database reference

  final _myBox = Hive.box("expenceDatabase");

  List<ExpenceModel> expenceList = [];

  //creatr the init expence list function

  void creatrInitialDatabase() {
    expenceList = [
      ExpenceModel(
          amount: 12.5,
          date: DateTime.now(),
          title: "Football",
          category: Category.leasure),
      ExpenceModel(
          amount: 100,
          date: DateTime.now(),
          title: "Carrot",
          category: Category.food)
    ];
  }

//load the data

  void loadData() {
    final dynamic data = _myBox.get("EXP_DATA");

    //validate the data
    if (data != null && data is List<dynamic>) {
      expenceList = data.cast<ExpenceModel>().toList();
    }
  }

  // update the data
  Future<void> updateData() async {
    await _myBox.put("EXP_DATA", expenceList);
    print("data save");
  }
}
