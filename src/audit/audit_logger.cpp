#include "audit_logger.h"
#include <iostream>
#include <fstream>
#include <mutex>
#include <chrono>
#include <ctime>

// A global mutex to ensure thread-safety. 
// It prevents multiple threads from writing to the log file simultaneously,
// which could lead to file corruption or data loss.
std::mutex log_mutex;

/**
 * Helper function to append a log entry to the file safely.
 * @param log_entry: The formatted string containing the operation details.
 */
void log_to_file(const std::string& log_entry) {
    // Acquire the lock before accessing the shared resource (the file).
    // The lock_guard automatically unlocks when the scope ends.
    std::lock_guard<std::mutex> lock(log_mutex);
    
    // Open the file in append mode. 'std::ios_base::app' ensures that
    // new logs are added to the end of the file instead of overwriting it.
    std::ofstream outfile;
    outfile.open("audit_logs.txt", std::ios_base::app);
    
    if (outfile.is_open()) {
        outfile << log_entry << std::endl;
        outfile.close(); // Always close the file to release system resources.
    }
}

extern "C" {
    /**
     * Logs changes in inventory (e.g., additions, sales, or deletions).
     * Exposed to Flutter via FFI as a C-compatible function.
     */
    void log_inventory_change(int product_id, int user_id, const char* action_type, int qty_changed) {
        // Formatting the log entry string. 
        // We use std::to_string to convert numeric values to readable text.
        std::string entry = "[Inventory] Product: " + std::to_string(product_id) + 
                            " | User: " + std::to_string(user_id) + 
                            " | Action: " + action_type + 
                            " | Qty: " + std::to_string(qty_changed);
        
        log_to_file(entry); // Pass the formatted string to the file writer.
    }

    /**
     * Logs financial transactions (e.g., cash payments, debt increases, refunds).
     * Exposed to Flutter via FFI as a C-compatible function.
     */
    void log_transaction(int user_id, const char* action_type, double amount) {
        // Formatting the financial entry. 
        // Note: 'amount' is treated as a double to preserve precision for currency.
        std::string entry = "[Transaction] User: " + std::to_string(user_id) + 
                            " | Action: " + action_type + 
                            " | Amount: " + std::to_string(amount);
                            
        log_to_file(entry); // Pass the formatted string to the file writer.
    }
}