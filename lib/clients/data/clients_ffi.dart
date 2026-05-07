import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';

// --- تعريفات الـ Signature للدوال ---

// إضافة عميل (تحديث لتشمل كافة الحقول)
typedef AddClientNative = Int32 Function(
    Int32 userId, 
    Pointer<Utf8> name, 
    Pointer<Utf8> phone,
    Pointer<Utf8> email,
    Pointer<Utf8> address,
    Pointer<Utf8> notes
);
typedef AddClientDart = int Function(
    int userId, 
    Pointer<Utf8> name, 
    Pointer<Utf8> phone,
    Pointer<Utf8> email,
    Pointer<Utf8> address,
    Pointer<Utf8> notes
);

// جلب العملاء
typedef GetAllClientsNative = Pointer<Utf8> Function(Int32 userId);
typedef GetAllClientsDart = Pointer<Utf8> Function(int userId);

// دالة تنظيف الذاكرة (مهمة جداً)
typedef FreeStringNative = Void Function(Pointer<Utf8> str);
typedef FreeStringDart = void Function(Pointer<Utf8> str);

class ClientsFFI {
  late DynamicLibrary _dylib;

  ClientsFFI() {
    // تحميل المكتبة
    _dylib = DynamicLibrary.open('flexi_store_backend.dll');
  }

  // --- دالة الإضافة مع إدارة الذاكرة ---
  int addClient({
    required int userId,
    required String name,
    required String phone,
    String email = "",
    String address = "",
    String notes = "",
  }) {
    final addFn = _dylib.lookupFunction<AddClientNative, AddClientDart>('add_client');

    // تحويل النصوص لـ Pointers
    final pName = name.toNativeUtf8();
    final pPhone = phone.toNativeUtf8();
    final pEmail = email.toNativeUtf8();
    final pAddress = address.toNativeUtf8();
    final pNotes = notes.toNativeUtf8();

    try {
      // استدعاء الدالة
      return addFn(userId, pName, pPhone, pEmail, pAddress, pNotes);
    } finally {
      // --- تنظيف الذاكرة (إجباري) ---
      malloc.free(pName);
      malloc.free(pPhone);
      malloc.free(pEmail);
      malloc.free(pAddress);
      malloc.free(pNotes);
    }
  }

  // --- دالة الجلب مع إدارة الذاكرة القادمة من C++ ---
  String getAllClients(int userId) {
    final getFn = _dylib.lookupFunction<GetAllClientsNative, GetAllClientsDart>('get_all_clients');
    final freeFn = _dylib.lookupFunction<FreeStringNative, FreeStringDart>('free_client_string');

    final Pointer<Utf8> rawPtr = getFn(userId);
    
    if (rawPtr == nullptr) return "[]";

    final String dartString = rawPtr.toDartString();

    // --- تنظيف الذاكرة في C++ بعد القراءة ---
    freeFn(rawPtr); 

    return dartString;
  }
}