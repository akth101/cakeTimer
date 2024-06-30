import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'main.dart';

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
      itemCount: cakeDatabase.elapsingCakes.length,
      onReorder: (oldIndex, newIndex) {
        cakeDatabase.reorderElapsingCakes(oldIndex, newIndex);
      },
      //gridDelegate: 각 셀의 크기를 결정
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.7,
      ),
      //itemCount 속성에 의해 itemBuilder가 몇 번 호출될지 결정된다.
      itemBuilder: (context, index) {
        final cake = cakeDatabase.elapsingCakes[index];
        return Card(
          key: ValueKey(cake.cakeKey),
          child: cake,
        );
       },
     );
   },
  );
}
}