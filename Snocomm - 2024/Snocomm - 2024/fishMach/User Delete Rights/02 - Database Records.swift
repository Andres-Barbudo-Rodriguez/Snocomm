//
//  02 - Database Records.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 6/19/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import SQLite3

func deleteRecord(id: Int) {
    var db: OpaquePointer?
    if sqlite3_open("/path/to/database.sqlite", &db) == SQLITE_OK {
        let deleteSQL = "DELETE FROM records WHERE id = ?;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Record deleted")
            } else {
                print("Error deleting record")
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(db)
    }
}

// Usage
deleteRecord(id: 123)
