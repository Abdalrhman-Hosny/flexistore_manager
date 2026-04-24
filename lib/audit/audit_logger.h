#ifndef AUDIT_LOGGER_H
#define AUDIT_LOGGER_H

#include <string>

extern "C" {
    
    void log_inventory_change(int product_id, int user_id, const char* action_type, int qty_changed);

    void log_transaction(int user_id, const char* action_type, double amount);
}

#endif