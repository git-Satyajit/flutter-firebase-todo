import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final ApiService _apiService = ApiService();
  
  List<Task> get tasks => _tasks;

  // Fetch from Firebase Realtime DB
  Future<void> fetchTasks(String userId) async {
    _tasks = await _apiService.fetchTasks(userId);
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(String userId, String title) async {
    final newTask = Task(id: '', title: title); 
    final id = await _apiService.addTask(userId, newTask);
    
    if (id != null) {
      newTask.id = id; // Assign the Firebase-generated ID
      _tasks.add(newTask);
      notifyListeners();
    }
  }

  // Check/Uncheck a task
  Future<void> toggleTaskCompletion(String userId, Task task) async {
    task.isCompleted = !task.isCompleted;
    await _apiService.updateTask(userId, task);
    notifyListeners();
  }

  // Delete a task
  Future<void> deleteTask(String userId, String taskId) async {
    await _apiService.deleteTask(userId, taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }
}