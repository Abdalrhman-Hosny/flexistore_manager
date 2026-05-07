#include "client_functions.h"
#include <iostream>

// مؤقتاً: هنعرف النجاح هنا عشان الإيرور يختفي لحد ما ffi_types تجهز
#ifndef SUCCESS
#define SUCCESS 0
#endif

extern "C" {

    // إضافة عميل (Mock Implementation)
    int add_client(int user_id, const char* name, const char* phone) {
        if (name == nullptr || phone == nullptr) return -102;

        // بدل ما نكتب في قاعدة البيانات حالياً، هنطبع للـ Console
        std::cout << "[DB Mock] Adding Client to MySQL..." << std::endl;
        std::cout << "Name: " << name << ", Phone: " << phone << std::endl;
        std::cout << "Action by User ID: " << user_id << std::endl;

        return SUCCESS; 
    }

    // تعديل عميل
    int update_client(int user_id, int client_id, const char* name, const char* phone) {
        std::cout << "[DB Mock] Updating Client ID: " << client_id << std::endl;
        return SUCCESS;
    }

    // حذف عميل (مع تطبيق قاعدتك الصارمة)
    int delete_client(int user_id, int client_id) {
        // هنا مستقبلاً هنفحص الديون الأول
        std::cout << "[DB Mock] Deleting Client ID: " << client_id << std::endl;
        return SUCCESS;
    }
}