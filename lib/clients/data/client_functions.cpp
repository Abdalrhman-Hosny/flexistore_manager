#include "client_functions.h"
#include <iostream>

// تعريف أكواد الاستجابة (Status Codes)
#ifndef SUCCESS
#define SUCCESS 0
#endif
#ifndef ERR_NULL_POINTER
#define ERR_NULL_POINTER -102
#endif

extern "C" {

    // --- إضافة عميل جديد ---
    // تم إضافة parameters لتشمل (الإيميل، العنوان، والملاحظات) كما في الـ UI
    int add_client(int user_id, 
                   const char* name, 
                   const char* phone, 
                   const char* email, 
                   const char* address, 
                   const char* notes) {
        
        // التحقق من الحقول الإجبارية (الاسم والموبايل) كما حددنا في الـ UI
        if (name == nullptr || phone == nullptr) {
            return ERR_NULL_POINTER;
        }

        std::cout << "\n[MySQL Admin] Executing: INSERT INTO clients..." << std::endl;
        std::cout << ">> Name: " << name << std::endl;
        std::cout << ">> Phone: " << phone << std::endl;
        std::cout << ">> Email: " << (email ? email : "N/A") << std::endl;
        std::cout << ">> Address: " << (address ? address : "N/A") << std::endl;
        std::cout << ">> Notes: " << (notes ? notes : "None") << std::endl;
        std::cout << ">> Added by User ID: " << user_id << std::endl;
        
        return SUCCESS; 
    }

    // --- تعديل بيانات عميل ---
    int update_client(int user_id, 
                      int client_id, 
                      const char* name, 
                      const char* phone,
                      const char* email,
                      const char* address) {
        
        std::cout << "\n[MySQL Admin] Executing: UPDATE client SET ... WHERE id = " << client_id << std::endl;
        std::cout << ">> New Name: " << name << std::endl;
        return SUCCESS;
    }

    // --- حذف عميل ---
    int delete_client(int user_id, int client_id) {
        // منطق الفحص (الديون) يوضع هنا قبل تنفيذ الـ DELETE
        std::cout << "\n[MySQL Admin] Checking debts for Client ID: " << client_id << "..." << std::endl;
        
        /* مستقبلاً:
           if (has_debt(client_id)) return -405; // لا يمكن الحذف
        */

        std::cout << "[MySQL Admin] Executing: DELETE FROM clients WHERE id = " << client_id << std::endl;
        return SUCCESS;
    }
}