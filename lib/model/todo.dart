class ToDo {
  String id;
  String todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  // Optional: Initial demo data (you can remove this if you don't need it)
  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Meeting with manager', isDone: true),
      ToDo(id: '02', todoText: 'Buy Groceries', isDone: true),
      ToDo(id: '03', todoText: 'Do the dishes'),
      ToDo(id: '04', todoText: 'Family time'),
    ];
  }
}
