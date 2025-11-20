import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // PURE FRONTEND LISTS
  List<ToDo> _todosList = []; // Local in-memory list
  List<ToDo> _foundToDo = []; // Filtered list for search

  final _todoController = TextEditingController();
  bool isLoading = false;
  int _counter = 1; // Used to generate unique IDs

  @override
  void initState() {
    super.initState();
    fetchTodos(); // Just sets initial UI state
  }

  // PURE FRONTEND "FETCH"
  Future<void> fetchTodos() async {
    setState(() {
      isLoading = false;
      _foundToDo = _todosList;
    });
  }

  // ADD TODO (LOCAL ONLY)
  void _addToDoItem(String toDoText) {
    if (toDoText.isEmpty) return;

    final newTodo = ToDo(
      id: _counter.toString(),
      todoText: toDoText,
      isDone: false,
    );

    setState(() {
      _todosList.add(newTodo);
      _foundToDo = _todosList;
      _counter++;
    });

    _todoController.clear();
  }

  // DELETE TODO (LOCAL ONLY)
  void _deleteToDoItem(String id) {
    setState(() {
      _todosList.removeWhere((item) => item.id == id);
      _foundToDo = _todosList;
    });
  }

  // TOGGLE CHECKBOX (LOCAL ONLY)
  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      _foundToDo = _todosList;
    });
  }

  // SEARCH FILTER
  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];

    if (enteredKeyword.isEmpty) {
      results = _todosList;
    } else {
      results = _todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      searchBox(),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                top: 50,
                                bottom: 20,
                              ),
                              child: const Text(
                                'All ToDos',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            // DISPLAY TODO ITEMS
                            for (ToDo todoo in _foundToDo.reversed)
                              ToDoItem(
                                todo: todoo,
                                onToDoChanged: (todo) =>
                                    _handleToDoChange(todo),
                                onDeleteItem: (id) => _deleteToDoItem(id),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // ADD NEW TODO INPUT + BUTTON
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          right: 20,
                          left: 20,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: _todoController,
                          decoration: const InputDecoration(
                            hintText: 'Add a new todo item',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _addToDoItem(_todoController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(60, 60),
                          elevation: 10,
                        ),
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
    );
  }

  // SEARCH BOX WIDGET
  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }
}
