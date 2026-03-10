import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class ApiService {
  // IMPORTANT: Replace this with your actual database URL from Firebase!
  // You can find this in your Firebase console under Realtime Database > Data > URL
  static const String baseUrl = 'https://todo-flutter-5930f-default-rtdb.firebaseio.com/';

  // GET: Fetch all tasks for the logged-in user
  Future<List<Task>> fetchTasks(String userId) async {
    // Notice we add .json at the end of the URL for Firebase REST APIs
    final url = Uri.parse('$baseUrl/tasks/$userId.json');
    final response = await http.get(url);

    if (response.statusCode == 200 && response.body != 'null') {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Task> loadedTasks = [];
      
      extractedData.forEach((taskId, taskData) {
        loadedTasks.add(Task.fromJson(taskId, taskData));
      });
      return loadedTasks;
    }
    return [];
  }

  // POST: Create a new task
  Future<String?> addTask(String userId, Task task) async {
    final url = Uri.parse('$baseUrl/tasks/$userId.json');
    final response = await http.post(
      url,
      body: json.encode(task.toJson()),
    );
    
    if (response.statusCode == 200) {
      // Firebase returns the newly generated unique ID inside a key called 'name'
      return json.decode(response.body)['name']; 
    }
    return null;
  }

  // PATCH: Update a task (edit title or mark as completed)
  Future<void> updateTask(String userId, Task task) async {
    final url = Uri.parse('$baseUrl/tasks/$userId/${task.id}.json');
    await http.patch(
      url,
      body: json.encode(task.toJson()),
    );
  }

  // DELETE: Remove a task
  Future<void> deleteTask(String userId, String taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$userId/$taskId.json');
    await http.delete(url);
  }
}