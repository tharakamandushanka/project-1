import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expence.dart';
import 'package:flutter_application_1/widgets/expence_tile.dart';

class ExpenceList extends StatelessWidget {
  final List<ExpenceModel> expenceList;
  final void Function(ExpenceModel expence) onDeleteExpence;

  const ExpenceList(
      {super.key, required this.expenceList, required this.onDeleteExpence});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: expenceList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Dismissible(
              key: ValueKey(expenceList[index]),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {
                onDeleteExpence(expenceList[index]);
              },
              child: ExpenceTile(
                expence: expenceList[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
