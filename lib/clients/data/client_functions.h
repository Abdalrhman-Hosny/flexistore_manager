#ifndef CLIENT_FUNCTIONS_H
#define CLIENT_FUNCTIONS_H

#include "ffi_types.h" 

#ifdef _WIN32
    #define EXPORT __declspec(dllexport)
#else
    #define EXPORT __attribute__((visibility("default")))
#endif

extern "C" {
    // إضافة عميل: تم تحديث التوقيع ليشمل الحقول الجديدة
    EXPORT int add_client(int user_id, 
                          const char* name, 
                          const char* phone, 
                          const char* email, 
                          const char* address, 
                          const char* notes);

    // تعديل عميل: تم تحديث التوقيع ليتناسب مع تحديث البيانات الأساسية
    EXPORT int update_client(int user_id, 
                             int client_id, 
                             const char* name, 
                             const char* phone,
                             const char* email,
                             const char* address);

    // حذف عميل: يبقى كما هو (يحتاج فقط المعرف والمسؤول)
    EXPORT int delete_client(int user_id, int client_id);
}

#endif