import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _recycleProgressKey = 'recycle_progress';
  static const String _compostProgressKey = 'compost_progress';
  static const String _landfillProgressKey = 'landfill_progress';

  // Get progress for a specific category
  static Future<int> getProgress(String category) async {
    final prefs = await SharedPreferences.getInstance();
    switch (category) {
      case 'Recycle':
        return prefs.getInt(_recycleProgressKey) ?? 0;
      case 'Compost':
        return prefs.getInt(_compostProgressKey) ?? 0;
      case 'Landfill':
        return prefs.getInt(_landfillProgressKey) ?? 0;
      default:
        return 0;
    }
  }

  // Update progress for a specific category
  static Future<void> updateProgress(String category, int progress) async {
    final prefs = await SharedPreferences.getInstance();
    switch (category) {
      case 'Recycle':
        await prefs.setInt(_recycleProgressKey, progress);
        break;
      case 'Compost':
        await prefs.setInt(_compostProgressKey, progress);
        break;
      case 'Landfill':
        await prefs.setInt(_landfillProgressKey, progress);
        break;
    }
  }

  // Get total questions for a category
  static int getTotalQuestions(String category) {
    switch (category) {
      case 'Recycle':
        return 6; // Number of items in recyclableItems list
      case 'Compost':
        return 5; // Update this when implementing compost quiz
      case 'Landfill':
        return 5; // Update this when implementing landfill quiz
      default:
        return 0;
    }
  }
} 