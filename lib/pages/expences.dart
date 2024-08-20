import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expence.dart';
import 'package:flutter_application_1/server/database.dart';
import 'package:flutter_application_1/widgets/add_new_expence.dart';
import 'package:flutter_application_1/widgets/expence_listr.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';

class Expences extends StatefulWidget {
  const Expences({super.key});

  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {
  final _myBox = Hive.box("expenceDatabase");
  Database db = Database();
  //expencecList
  // final List<ExpenceModel> _expenceList = [
  //   ExpenceModel(
  //       amount: 12.5,
  //       date: DateTime.now(),
  //       title: "Football",
  //       category: Category.leasure),
  //   ExpenceModel(
  //       amount: 100,
  //       date: DateTime.now(),
  //       title: "Carrot",
  //       category: Category.food)
  // ];
  // PIE CHART
  Map<String, double> dataMap = {
    "Food": 0,
    "Travel": 0,
    "Leasure": 0,
    "Work": 0,
  };
  //add new expence
  void onAddNewExpence(ExpenceModel expence) {
    setState(() {
      db.expenceList.add(expence);
      db.updateData();
      calCategoryValue();
    });
  }

  //function to open a model overlay
  void _openAssExpencesOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddNEewExpences(
          onAddExpence: onAddNewExpence,
        );
      },
    );
  }

  //add new expences
  // void addNewExpences(ExpenceModel expence) {
  //   setState(() {
  //     db.expenceList.add(expence);
  //     db.updateData();
  //   });
  // }

  //remov a expence
  void onDeleteexpence(ExpenceModel expence) {
    //store the deleting expence
    ExpenceModel deletingExpence = expence;
    // get the index of the removing expence
    final int removingIndex = db.expenceList.indexOf(expence);

    setState(() {
      db.expenceList.remove(expence);
      db.updateData();
      calCategoryValue();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Delete Sucessfull"),
        action: SnackBarAction(
          label: "undo",
          onPressed: () {
            setState(
              () {
                db.expenceList.insert(removingIndex, deletingExpence);
                db.updateData();
                calCategoryValue();
              },
            );
          },
        ),
      ),
    );
  }

  double foodVal = 0;
  double lesureVal = 0;
  double travelVal = 0;
  double workVal = 0;

  void calCategoryValue() {
    double foodValTotal = 0;
    double lesureValTotal = 0;
    double travelValTotal = 0;
    double workValTotal = 0;

    for (final expence in db.expenceList) {
      if (expence.category == Category.food) {
        foodValTotal += expence.amount;
      }
      if (expence.category == Category.leasure) {
        lesureValTotal += expence.amount;
      }
      if (expence.category == Category.travel) {
        travelValTotal += expence.amount;
      }
      if (expence.category == Category.work) {
        workValTotal += expence.amount;
      }
    }
    setState(() {
      foodVal = foodValTotal;
      travelVal = travelValTotal;
      lesureVal = lesureValTotal;
      workVal = workValTotal;
    });
    //update the dateMap
    dataMap = {
      "Food": foodVal,
      "Travel": travelVal,
      "Leasure": lesureVal,
      "Work": workVal,
    };
  }

  @override
  void initState() {
    super.initState();

    // if this is the first time create the initial data
    if (_myBox.get("EXP_DATA") == null) {
      db.creatrInitialDatabase();
      calCategoryValue();
    } else {
      print("app to load data");
      db.loadData();
      calCategoryValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expence Master"),
        backgroundColor: const Color.fromARGB(255, 77, 4, 195),
        elevation: 0,
        actions: [
          Container(
            color: Colors.yellow,
            child: IconButton(
              onPressed: _openAssExpencesOverlay,
              icon: const Icon(Icons.add),
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          PieChart(dataMap: dataMap),
          ExpenceList(
            expenceList: db.expenceList,
            onDeleteExpence: onDeleteexpence,
          )
        ],
      ),
    );
  }
}
