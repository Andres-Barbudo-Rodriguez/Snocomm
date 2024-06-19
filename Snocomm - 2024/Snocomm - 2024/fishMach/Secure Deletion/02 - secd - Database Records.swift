//
//  02 - secd - Database Records.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import SQLite3

func secureDeleteRecord(id: Int) {
    var db: OpaquePointer?
    if sqlite3_open("/path/to/database.sqlite", &db) == SQLITE_OK {
        let updateSQL = "UPDATE records SET sensitive_column = ? WHERE id = ?;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateSQL, -1, &statement, nil) == SQLITE_OK {
            let randomData = Data(count: 256) // Assuming sensitive_column is a 256-byte blob
            sqlite3_bind_blob(statement, 1, (randomData as NSData).bytes, Int32(randomData.count), nil)
            sqlite3_bind_int(statement, 2, Int32(id))
            if sqlite3_step(statement) == SQLITE_DONE {
                let deleteSQL = "DELETE FROM records WHERE id = ?;"
                if sqlite3_prepare_v2(db, deleteSQL, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_int(statement, 1, Int32(id))
                    if sqlite3_step(statement) == SQLITE_DONE {
                        print("Record securely deleted")
                    } else {
                        print("Error deleting record")
                    }
                }
            } else {
                print("Error overwriting sensitive data")
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(db)
    }
}

// Usage
secureDeleteRecord(id: 123)
