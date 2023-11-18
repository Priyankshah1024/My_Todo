import 'package:flutter/material.dart';
import 'package:todo_app/Services/todos_service.dart';

class add_todos extends StatefulWidget {
  final Map? editTodo;
  const add_todos({super.key, this.editTodo});

  @override
  State<add_todos> createState() => _add_todosState();
}

class _add_todosState extends State<add_todos> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit=false;

  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Center(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),)), backgroundColor: Colors.deepPurple[300],);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message){
    final snackBar = SnackBar(
      content: Center(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),)), backgroundColor: Colors.redAccent[200],);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> addData()async {
    final title = titleController.text;
    final desc = descController.text;
    final body = {
      "title": title,
      "description": desc,
      "is_completed": false
    };

    final response = await TodoService.addData(body);

    if(response){
      titleController.text = '';
      descController.text = '';
      print("Data uploaded successfully!");
      showSuccessMessage('Data uploaded successfully!');
    }
    else{
      print("Uploading data failed!");
      showErrorMessage('Uploading data is failed!');
    }
  }

  Future<void> updateData()async{
    final title = titleController.text;
    final desc = descController.text;
    final id = widget.editTodo!['_id'];
    final isCompleted = widget.editTodo!['isCompleted'];
    final body = {
      "title": title,
      "description": desc,
      "is_completed": isCompleted,
    };

    final response = await TodoService.updateData(id, body);

    if(response){
      print("Data updated successfully!");
    }
    else{
      print("Update failed!");
      showErrorMessage('Update failed!');
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.editTodo!=null){
      isEdit=true;
      final title = widget.editTodo!['title'];
      final desc = widget.editTodo!['description'];
      titleController.text = title;
      descController.text = desc;
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit?"Edit Todo":"Add Todo", style: const TextStyle(color: Colors.white),),),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: titleController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: "Todo Title",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
            validator: (value){
              if(value!.isEmpty){
                return "Please fill the ${titleController.text}!";
              }
              else{
                return null;
              }
            },
          ),
          const SizedBox(height: 20,),
          TextFormField(
            controller: descController,
            maxLines: 7,
            minLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              labelText: "Title Description",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            validator: (value){
              if(value!.isEmpty){
                return "Please fill the ${descController.text}!";
              }
              else{
                return null;
              }
            },
          ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.only(left: 60, right: 60),
            child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  backgroundColor: MaterialStateProperty.all(Colors.deepPurple[300]),
                ),
                onPressed: (){
                  if(titleController.text.isNotEmpty && descController.text.isNotEmpty){
                    isEdit?updateData():addData();
                    if(isEdit){
                      updateData();
                      showSuccessMessage('Todo updated successfully!');
                    }
                    else{
                      // addData();
                      showSuccessMessage('Todo added successfully!');
                    }

                    Navigator.of(context).pop();
                  }
                  else{
                    showErrorMessage('Please fill all the fields!');
                  }
            }, child: Text(isEdit?"Update":"Add", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),)),
          ),
        ],
      ),
    );
  }
}
