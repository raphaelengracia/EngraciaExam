import 'addTask.dart';
import 'package:engracia_dbassignment/databasehand.dart';
import 'package:engracia_dbassignment/models.dart';
import 'package:flutter/material.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DBhandler? dbhandler;
  late Future<List<TodoMod>> dataList;

  @override
  void initState(){
    super.initState();
    dbhandler = DBhandler();
    loadData();
  }

  loadData() async{
    dataList = dbhandler!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar:AppBar(
        title: Text('To DO',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500
        ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(
            future: dataList,
            builder: (context, AsyncSnapshot<List<TodoMod>>snapshot){
              if(!snapshot.hasData || snapshot.data == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(snapshot.data!.length == 0){
                return Center(
                  child: Text('No task '),
                );
              }else{
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context,index){
                    int todoId = snapshot.data![index].id!.toInt();
                    String todoTitle = snapshot.data![index].title.toString();

                    return Dismissible(
                      key: ValueKey<int>(todoId),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete,color:Colors.white,),
                      ),
                      onDismissed: (DismissDirection direction){
                        setState(() {
                          dbhandler!.delete(todoId);
                          dataList = dbhandler!.getDataList();
                          snapshot.data!.remove(snapshot.data![index]);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          boxShadow: [
                           BoxShadow(
                             color: Colors.black,
                             blurRadius: 4,
                             spreadRadius: 1,
                           )
                          ]
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(10),
                              title: Padding(
                                padding: EdgeInsets.only(bottom:10),
                                child: Text(todoTitle,
                                style: TextStyle(fontSize: 20),
                                ),
                              )
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 0.8,
                            ),
                            Padding(
                                padding:EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                            child : Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) => AddTask(
                                            todoId: todoId,
                                            todoTitle:todoTitle,
                                            update: true,
                                          ),
                                        ));
                                  },
                                  child:Icon(Icons.edit,
                                    size: 28,
                                    color: Colors.black,),
                                ),
                              ],
                            )
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) =>AddTask(),
          ));
        },
        label: Text('Add Task')
      ),
    );
  }
}
