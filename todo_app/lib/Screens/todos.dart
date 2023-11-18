import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/Screens/add_todos.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Services/todos_service.dart';

class todos extends StatefulWidget {
  const todos({super.key});

  @override
  State<todos> createState() => _todosState();
}

class _todosState extends State<todos> {

  List<dynamic> allTodos = [];

  void navigateToAddTodos()async{
    final route = MaterialPageRoute(builder: (context) => const add_todos());
    await Navigator.push(context, route);
    setState(() {

    });
    fetchTodo();
  }

  void navigateToEdit(data)async{
    final route = MaterialPageRoute(builder: (context) => add_todos(editTodo: data,));
    await Navigator.push(context, route);
    setState(() {

    });
    fetchTodo();
  }

  void showErrorMessage(String message){
    final snackBar = SnackBar(
      content: Center(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),)), backgroundColor: Colors.redAccent[200],);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Center(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),)), backgroundColor: Colors.deepPurple[300],);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> fetchTodo()async{
    final response = await TodoService.fetchTodo();

    if(response is List){
      setState(() {
        allTodos = response;
      });
    }
    else{
      showErrorMessage('Something went Wrong!');
    }
    setState(() {
    });
  }

  Future<void> deleteTodo(String id)async{
    final isTrue = await TodoService.deleteById(id);
    if(isTrue){
      print("Deleted Succesfully!");
      final allData = allTodos.where((element) => element['_id']!=id).toList();
      setState(() {
        allTodos = allData;
        showSuccessMessage('Todo has been deleted successfully!');
      });
    }
    else{
      showErrorMessage('Deletion Failed!');
    }
  }

  @override
  void initState(){
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo App"), centerTitle: true,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddTodos,
          label: const Icon(Icons.add_rounded, color: Colors.white,)),
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: allTodos.isNotEmpty?ListView.builder(
          padding: const EdgeInsets.all(12),
            itemCount: allTodos.length,
            itemBuilder: (context, index){
              final data = allTodos[index];
              final id = data['_id'];
              print('******$data*******');
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  color: Colors.blueGrey[900],
                  child: ListTile(
                      leading: CircleAvatar(child: Text("${index + 1}", style: const TextStyle(color: Colors.white),)),
                      title: Text(data['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                      subtitle: Text(data['description'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: (){
                            navigateToEdit(data);
                          }, icon: const Icon(FontAwesomeIcons.penToSquare, size: 19,),),

                          IconButton(onPressed: (){
                            showDialog(context: context, builder: (context)=>AlertDialog(
                              title: const Text("Delete Confirmation", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                              content: const Text("Are you sure want to delete?", style: TextStyle(fontSize: 17),),
                              actions: [
                                TextButton(onPressed: (){
                                       deleteTodo(id);
                                       Navigator.of(context).pop(true);
                                }, child: const Text("Yes", style: TextStyle(fontSize: 19,),)),

                                TextButton(onPressed: (){
                                  Navigator.of(context).pop(false);
                                }, child: const Text("No", style: TextStyle(fontSize: 19,)))
                              ],
                            ),);
                          }, icon: const Icon(FontAwesomeIcons.trashCan, size: 19,),),
                        ],
                      ),
                  ),
                ),
              );
            }):const Center(child: Text("Data Not Found!", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),),
      ),
    );
  }
}
