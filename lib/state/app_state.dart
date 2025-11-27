import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../models/scene_block.dart';
import '../models/render_job.dart';

class AppState extends ChangeNotifier {
  String script = '';
  List<Character> characters = [];
  List<SceneBlock> scenes = [];
  RenderJob? currentJob;

  void updateScript(String s) { script = s; notifyListeners(); }
  void setCharacters(List<Character> c) { characters = c; notifyListeners(); }
  void setScenes(List<SceneBlock> s) { scenes = s; notifyListeners(); }
  void setJob(RenderJob job) { currentJob = job; notifyListeners(); }
  void clearJob() { currentJob = null; notifyListeners(); }
}
