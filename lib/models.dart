class TodoMod{
  final int? id;
  final String? title;

  TodoMod({
    this.id,
    this.title,
});

  TodoMod.fromMap(Map<String,dynamic> res):
      id = res ['id'],
      title = res ['title'];

  Map<String, Object?> toMap(){
    return {
      'id' : id,
      'title' : title,
    };
  }
  }
