//
//  NSManagedObjectContext+Extensions.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 17/04/26.
//

import CoreData

extension NSManagedObjectContext {
    func saveContext() throws {
        if hasChanges {
            try? save()
        }
    }
}
