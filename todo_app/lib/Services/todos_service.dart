import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoService{
  static Future<bool> deleteById(String id)async{
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    print('${response.statusCode}');
    return response.statusCode==200;
  }

  static Future<List?> fetchTodo()async{
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: {
      "accept": "application/json",
    });
    if(response.statusCode==200){
      print("Data has been fetched successfully!");
      final json = jsonDecode(response.body);
      print("Response: ${jsonDecode(response.body)}");
      final result = json['items'];
      return result;
    }
    else{
      return null;
    }
  }

  static Future<bool> addData(body)async{
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json"
      },
    );
    print('${response.statusCode}');
    print(response.body);
    return response.statusCode==201;
  }

  static Future<bool> updateData(String id, body)async{
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri, body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json"
      },
    );
    print(response.statusCode);
    print(response.body);
    return response.statusCode==200;
  }
}


