#ifndef FFI_TYPES_H
#define FFI_TYPES_H

// --- General Status Codes (0 to -100) ---
#define SUCCESS 0
#define ERR_UNKNOWN -1

// --- Connection & Auth (-101 to -200) ---
#define ERR_DATABASE_CONNECTION -101
#define ERR_UNAUTHORIZED -103

// --- Validation & Input (-201 to -300) ---
#define ERR_INVALID_INPUT -102
#define ERR_REQUIRED_FIELD_MISSING -201

// --- Business Logic Errors (-501+) ---
// منع الحذف بسبب الديون (القاعدة الصارمة)
#define ERR_CLIENT_HAS_DEBT -501  

#endif