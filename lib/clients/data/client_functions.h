#ifndef CLIENT_FUNCTIONS_H
#define CLIENT_FUNCTIONS_H

#include "ffi_types.h" 

#ifdef _WIN32
    #define EXPORT __declspec(dllexport)
#else
    #define EXPORT __attribute__((visibility("default")))
#endif

extern "C" {
    EXPORT int add_client(int user_id, const char* name, const char* phone);
    EXPORT int update_client(int user_id, int client_id, const char* name, const char* phone);
    EXPORT int delete_client(int user_id, int client_id);
}

#endif