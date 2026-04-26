import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

// --- Native Signatures (How functions look in C++) ---

typedef LogInventoryNative = ffi.Void Function(
    ffi.Int32 productId, ffi.Int32 userId, ffi.Pointer<Utf8> actionType, ffi.Int32 qtyChanged);

typedef LogTransactionNative = ffi.Void Function(
    ffi.Int32 userId, ffi.Pointer<Utf8> actionType, ffi.Double amount);

// --- Dart Signatures (How we will call them in Flutter) ---

typedef LogInventoryDart = void Function(
    int productId, int userId, ffi.Pointer<Utf8> actionType, int qtyChanged);

typedef LogTransactionDart = void Function(
    int userId, ffi.Pointer<Utf8> actionType, double amount);

class AuditFFI {
  late LogInventoryDart _logInventoryChange;
  late LogTransactionDart _logTransaction;

  AuditFFI() {
    // 1. Load the dynamic library
    // On Android: 'libaudit.so', On Windows: 'audit.dll'
    final dylib = _loadLibrary();

    // 2. Link the C++ functions to Dart functions
    _logInventoryChange = dylib
        .lookup<ffi.NativeFunction<LogInventoryNative>>('log_inventory_change')
        .asFunction();

    _logTransaction = dylib
        .lookup<ffi.NativeFunction<LogTransactionNative>>('log_transaction')
        .asFunction();
  }

  // Helper method to load the library based on the platform
  ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) return ffi.DynamicLibrary.open('libaudit.so');
    if (Platform.isWindows) return ffi.DynamicLibrary.open('audit.dll');
    return ffi.DynamicLibrary.process();
  }

  // --- Public Methods to be used in UI ---

  /// Logs changes in product inventory
  void logInventoryChange(int productId, int userId, String action, int qty) {
    // Convert Dart String to C-style String (char*)
    final actionPtr = action.toNativeUtf8();
    
    _logInventoryChange(productId, userId, actionPtr, qty);
    
    // Crucial: Free the memory allocated for the string to avoid memory leaks
    malloc.free(actionPtr);
  }

  /// Logs financial transactions
  void logTransaction(int userId, String action, double amount) {
    final actionPtr = action.toNativeUtf8();
    
    _logTransaction(userId, actionPtr, amount);
    
    malloc.free(actionPtr);
  }
}