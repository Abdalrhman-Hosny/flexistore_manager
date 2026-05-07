import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';

// تعريف شكل الدوال في C++
typedef AddClientNative = Int32 Function(Int32 userId, Pointer<Utf8> name, Pointer<Utf8> phone);
// تعريف شكل الدوال في Dart
typedef AddClientDart = int Function(int userId, Pointer<Utf8> name, Pointer<Utf8> phone);

typedef GetAllClientsNative = Pointer<Utf8> Function(Int32 userId);
typedef GetAllClientsDart = Pointer<Utf8> Function(int userId);

class ClientsFFI {
  late DynamicLibrary _dylib;

  ClientsFFI() {
    // تحميل ملف الـ DLL اللي أنت لسه عامله Build
    _dylib = DynamicLibrary.open('flexi_store_backend.dll'); 
  }

  int addClient(int userId, String name, String phone) {
    final addFn = _dylib.lookupFunction<AddClientNative, AddClientDart>('add_client');
    return addFn(userId, name.toNativeUtf8(), phone.toNativeUtf8());
  }

  String getAllClients(int userId) {
    final getFn = _dylib.lookupFunction<GetAllClientsNative, GetAllClientsDart>('get_all_clients');
    return getFn(userId).toDartString();
  }
}