import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'main.dart';
import 'cakeWidget.dart';

class wholeCakeElapsed extends StatefulWidget {
  const wholeCakeElapsed({super.key});

  @override
  State<wholeCakeElapsed> createState() => _wholeCakeElapsingState();
}

class _wholeCakeElapsingState extends State<wholeCakeElapsed> {

  @override
  Widget build(BuildContext context) {
  return Consumer<CakeDataBase>(
  builder: (context, cakeDatabase, child) {
    return ReorderableGridView.builder(
      itemCount: cakeDatabase.cakes.length,
      onReorder: (oldIndex, newIndex) {
        cakeDatabase.reorderCakes(oldIndex, newIndex);
      },
      //gridDelegate: 각 셀의 크기를 결정
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.7,
      ),
      //itemCount 속성에 의해 itemBuilder가 몇 번 호출될지 결정된다.
      itemBuilder: (context, index) {
        final cake = cakeDatabase.cakes[index];
        return Card(
          key: ValueKey(cake.value),
          child: cake,
        );
       },
     );
   },
  );
}
}
