import 'package:engracia_dbassignment/home.dart';
import 'package:engracia_dbassignment/models.dart';
import 'package:flutter/material.dart';
import 'databasehand.dart';

class AddTask extends StatefulWidget {

  int? todoId;
  String? todoTitle;
  String? todoDesc;
  bool? update;

  AddTask({
    this.todoId,
    this.todoTitle,
    this.todoDesc,
    this.update,
});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DBhandler? dbhandler;
  late Future<List<TodoMod>> datalist;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    dbhandler = DBhandler();
    loadData();
  }

  loadData()async{
    datalist = dbhandler!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    String appTitle;
    if(widget.update == true){
      appTitle = "Update Task";
    }else{
      appTitle = "Add Task";
    }

    return Scaffold(
      appBar:AppBar(
        title: Text(appTitle,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal : 20),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Add Task Here"
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Add Task";
                      }
                      return null;
                    }
                  ),)
                ],),
              ),
              SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Material(
                    color: Colors.blue,
                    child: InkWell(
                      onTap: (){
                        if(_formKey.currentState!.validate()){
                          if(widget.update == true){
                            dbhandler!.update(TodoMod(
                                id:widget.todoId,
                                title:titleController.text));
                          }else{
                            dbhandler!.insert(TodoMod(
                            id:widget.todoId,
                            title:titleController.text));
                          }
                        }
                          Navigator.push(context, MaterialPageRoute(builder:
                          (context)=>Home()));
                          titleController.clear();
                        },
                     child: Container(
                       alignment: Alignment.center,
                       margin:EdgeInsets.symmetric(horizontal:20),
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       height: 55,
                       width: 115,
                       child: Text('Submit',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 22,
                         ),),
                     ),
                    ),
                  )

                  ],
                ),
              )
            ],
          )
        )
      ),
    );
  }
}
