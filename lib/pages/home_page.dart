import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_first_flutter/data/database.dart';
import 'package:my_first_flutter/util/dialog_box.dart';
import 'package:my_first_flutter/util/todo_title.dart';

class HomePage extends StatefulWidget {
  final Function(MaterialColor) updateColorCallback;

  //const HomePage({super.key});
  const HomePage({Key? key, required this.updateColorCallback}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}

class _HomePageState extends State<HomePage>{
  MaterialColor _appBarColor = Colors.indigo;
  int buttonClickCount = 0;

  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever opening the app, then create default data
    if (_myBox.get("TODOLIST")==null){
      db.createIntiaData();
    }else{
      // there already exists data
      db.loadData();
    }
    super.initState();
  }
  // text controller
final _controller = TextEditingController();

  //list of todo tasks
  /*List toDoList = [
    ["Make Tutorial", false],
    ["Do Exercise", false],
  ];
*/
  //checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
void saveNewTask(){
    setState(() {
      db.toDoList.add([ _controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }
//delte task
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }
  // creaet a new task
  void createNewTask(){
    showDialog(
        context: context,
        builder: (context){
      return DialogBox(
        controller: _controller,

        onSave: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),);
    });
  }
  void updateAppBarColor() {
    buttonClickCount++;
    if (buttonClickCount == 1) {
      _appBarColor = createMaterialColor(Color(0xFFf5a6a6));
    } else if (buttonClickCount == 2) {
      _appBarColor = createMaterialColor(Color(0xFFf5e5a6));
    } else if (buttonClickCount == 3) {
      _appBarColor = createMaterialColor(Color(0xFFa7dbac));
    } else if (buttonClickCount == 4) {
      _appBarColor = createMaterialColor(Color(0xFF9aaae6));
    } else {
      buttonClickCount = 0;
      _appBarColor = createMaterialColor(Color(0xFF191b42));
    }
    setState(() {});

    widget.updateColorCallback(_appBarColor); // 새로운 색상을 MyApp에 전달
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    appBar: AppBar(
      centerTitle: true,
      title: Text('TO DO'),
      backgroundColor: _appBarColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite),
          tooltip: 'Open shopping cart',
          onPressed: () =>
            updateAppBarColor(),
          ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: createNewTask,
      child: Icon(Icons.add)
    ),
    body:Column(
      children: [
          Expanded(

          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal:16, vertical: 16),
              proxyDecorator: (Widget child, int index, Animation<double> animation){
//          (BuildContext context, int index) {
                return ToDoTitle(
                  itemIndex: index,
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex = newIndex - 1;
                  }
                  final element = db.toDoList.removeAt(oldIndex);
                  db.toDoList.insert(newIndex, element);
                });
              }, children: <Widget>[
                for(int index = 0; index < db.toDoList.length; index += 1)
                  Padding(
                    key: Key('$index'),
                    padding: const EdgeInsets.all(8.0),
                    child:
                    ToDoTitle(
                      itemIndex: index,
                      taskName: db.toDoList[index][0],
                      taskCompleted: db.toDoList[index][1],
                      onChanged: (value) => checkBoxChanged(value, index),
                      deleteFunction: (context) => deleteTask(index),
                    ),
                  )
            ],),
          ),
    )
      ],
    ),
  );
  }
}
