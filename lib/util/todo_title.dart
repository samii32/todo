import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
 
class ToDoTitle extends StatelessWidget {
  final int itemIndex;
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  ToDoTitle({
    super.key,
    required this.itemIndex,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // 세로 방향으로 최대한 높게

      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: Slidable(
            closeOnScroll: false,
            endActionPane: ActionPane(
              motion: StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: deleteFunction,
                icon: Icons.delete,
                backgroundColor: Colors.red.shade200,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
          ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                ),
                child: Row(
                  children: [
                    //checkbox
                    Container(
                        margin: EdgeInsets.only(right:10),
                        child: Checkbox(
                            value: taskCompleted,
                            onChanged: onChanged,
                            activeColor: Colors.black,)
                    ),
                    //task name
                    Expanded(
                      child: Text(taskName,
                      style: TextStyle(
                        color: Colors.black,
                          decorationColor: Colors.black,
                          decorationThickness: 2,
                        decoration: taskCompleted?
                        TextDecoration.lineThrough:
                        TextDecoration.none
                      ),
                      ),
                    )
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }
}
