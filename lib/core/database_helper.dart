import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/isar_todo.dart';

class DatabaseHelper {
  static Isar? _isar;

  static Future<Isar> getDatabase() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([TodoIsarSchema], directory: dir.path);
    return _isar!;
  }
}
