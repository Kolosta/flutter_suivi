import 'package:hive/hive.dart';

import 'local_storage.dart';

/// A class that implements the [LocalStorage] interface using Hive for local storage.
class HiveLocalStorage implements LocalStorage {
  /// Loads a value from the Hive box.
  ///
  /// Opens the Hive box with the given [boxName], retrieves the value associated with the [key],
  /// and then closes the box.
  ///
  /// Returns the value associated with the [key] or `null` if the key does not exist.
  ///
  /// Throws an exception if there is an error during the operation.
  // @override
  // Future<dynamic> load({required String key, String? boxName}) async {
  //   await Hive.openBox(boxName!);
  //   final box = Hive.box(boxName);
  //   try {
  //     final result = await box.get(key);
  //     return result;
  //   } catch (_) {
  //     rethrow;
  //   } finally {
  //     box.close();
  //   }
  // }
  @override
  Future<dynamic> load({required String key, String? boxName}) async {
    final box = await Hive.openBox(boxName!); // Garantir l'ouverture complète
    try {
      return await box.get(key);
    } catch (_) {
      rethrow;
    } finally {
      await box.close();
    }
  }

  /// Saves a value to the Hive box.
  ///
  /// Opens the Hive box with the given [boxName], stores the [value] associated with the [key],
  /// and then closes the box.
  ///
  /// Throws an exception if there is an error during the operation.
  // @override
  // Future<void> save({
  //   required String key,
  //   required dynamic value,
  //   String? boxName,
  // }) async {
  //   await Hive.openBox(boxName!);
  //   final box = Hive.box(boxName);
  //   try {
  //     await box.put(key, value);
  //     return;
  //   } catch (_) {
  //     rethrow;
  //   } finally {
  //     box.close();
  //   }
  // }
  @override
  Future<void> save({
    required String key,
    required dynamic value,
    String? boxName,
  }) async {
    final box = await Hive.openBox(boxName!); // Garantir l'ouverture complète
    try {
      await box.put(key, value);
    } catch (_) {
      rethrow;
    } finally {
      await box.close();
    }
  }

  /// Deletes a value from the Hive box.
  ///
  /// Opens the Hive box with the given [boxName], deletes the value associated with the [key],
  /// and then closes the box.
  ///
  /// Throws an exception if there is an error during the operation.
  @override
  Future<void> delete({required String key, String? boxName}) async {
    await Hive.openBox(boxName!);
    final box = Hive.box(boxName);
    try {
      await box.delete(key);
      return;
    } catch (_) {
      rethrow;
    } finally {
      box.close();
    }
  }
}




// import 'package:hive/hive.dart';
// import 'local_storage.dart';
//
// class HiveLocalStorage implements LocalStorage {
//   Future<Box> _openBox(String boxName) async {
//     if (!Hive.isBoxOpen(boxName)) {
//       return await Hive.openBox(boxName);
//     }
//     return Hive.box(boxName);
//   }
//
//   @override
//   Future<dynamic> load({required String key, String? boxName}) async {
//     final box = await _openBox(boxName!);
//     try {
//       final result = await box.get(key);
//       return result;
//     } catch (_) {
//       rethrow;
//     }
//   }
//
//   @override
//   Future<void> save({
//     required String key,
//     required dynamic value,
//     String? boxName,
//   }) async {
//     final box = await _openBox(boxName!);
//     try {
//       await box.put(key, value);
//     } catch (_) {
//       rethrow;
//     }
//   }
//
//   @override
//   Future<void> delete({required String key, String? boxName}) async {
//     final box = await _openBox(boxName!);
//     try {
//       await box.delete(key);
//     } catch (_) {
//       rethrow;
//     }
//   }
// }