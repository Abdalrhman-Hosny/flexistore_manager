#include "client_functions.h"
#include <iostream>
#include <string>
#include <cstdlib> // عشان دالة malloc
#include <cstring> // عشان دالة strcpy

extern "C" {
    // دالة لجلب كل العملاء على هيئة JSON
    EXPORT const char* get_all_clients(int user_id) {
        // مؤقتاً: سنرجع بيانات وهمية (Mock Data) بصيغة JSON
        // لاحظ: في C++ الحقيقي، سنستخدم مكتبة مثل nlohmann/json
        std::string mock_json = "[{\"id\":1, \"name\":\"Ahmed\", \"phone\":\"010...\", \"debt\":0.0}]";
        
        // يجب حجز مساحة في الذاكرة لكي لا تختفي السلسلة بعد انتهاء الدالة
        char* buffer = (char*)malloc(mock_json.length() + 1);
        strcpy(buffer, mock_json.c_str());
        
        return buffer; 
    }
}