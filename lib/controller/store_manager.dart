import 'package:objectbox/objectbox.dart';
import 'package:imp_approval/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class StoreManager {
  static final StoreManager _singleton = StoreManager._internal();
  Store? _store;  // Ubah ini menjadi nullable
  bool _isInitialized = false;  // Tambahkan flag untuk mengecek inisialisasi

  StoreManager._internal();

  static Future<StoreManager> getInstance() async {
    if (!_singleton._isInitialized) {
      await _singleton._init();
    }
    return _singleton;
  }

  _init() async {
    final directory = await getApplicationDocumentsDirectory();
    final model = getObjectBoxModel();  
    _store = Store(model, directory: directory.path + '/objectbox');
    _isInitialized = true;  // Set flag inisialisasi ke true setelah inisialisasi
  }

  Store get store {
    if (!_isInitialized) {
      throw Exception("StoreManager belum diinisialisasi!");
    }
    return _store!;
  }
}

