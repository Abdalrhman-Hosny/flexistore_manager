#include "client_functions.h"
#include <iostream>
#include <string>
#include <cstdlib> 
#include <cstring> 

extern "C" {
    // --- دالة جلب البيانات ---
    EXPORT const char* get_all_clients(int user_id) {
        // بيانات وهمية تحاكي ما سيأتي من MySQL لاحقاً
        // أضفت لك بيانات أكثر لتجربة الجدول بشكل واقعي
        std::string mock_json = "["
            "{\"id\":1, \"name\":\"John Doe\", \"phone\":\"+123456\", \"email\":\"john@test.com\", \"status\":\"Active\", \"debt\":0.0},"
            "{\"id\":2, \"name\":\"Sarah Smith\", \"phone\":\"+987654\", \"email\":\"sarah@test.com\", \"status\":\"Has Debt\", \"debt\":1200.50}"
        "]";
        
        // حجز مساحة ثابتة في الذاكرة (Heap)
        char* buffer = (char*)malloc(mock_json.length() + 1);
        if (buffer == nullptr) return nullptr; // حماية ضد فشل الحجز
        
        strcpy(buffer, mock_json.c_str());
        
        return buffer; 
    }

    // --- دالة ضرورية جداً لتنظيف الذاكرة ---
    EXPORT void free_client_string(char* ptr) {
        if (ptr != nullptr) {
            free(ptr);
            std::cout << "[DB Mock] Memory freed for JSON string." << std::endl;
        }
    }
}