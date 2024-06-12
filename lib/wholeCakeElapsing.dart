import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'main.dart';
import 'cakeWidget.dart';

class wholeCakeElapsing extends StatefulWidget {
  const wholeCakeElapsing({super.key});

  @override
  State<wholeCakeElapsing> createState() => _wholeCakeElapsingState();
}

class _wholeCakeElapsingState extends State<wholeCakeElapsing> {

  @override
  Widget build(BuildContext context) {
  return Consumer<CakeDataBase>(
  builder: (context, cakeDatabase, child) {
    return ReorderableGridView.builder(
      itemCount: cakeDatabase.cakes.length,
      onReorder: (oldIndex, newIndex) {
        cakeDatabase.reorderCakes(oldIndex, newIndex);
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final cake = cakeDatabase.cakes[index];
        return Card(
          key: ValueKey(cake.value),
          color: Colors.blueAccent,
          child: Center(
            child: Text(
              'Cake ${cake.value}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
             ),
           ),
         );
       },
     );
   },
  );
}
}