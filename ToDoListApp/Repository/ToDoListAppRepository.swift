//
//  ToDoListApp.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 16/04/26.
//

import Foundation
import CoreData

final class TodolistAppRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createTask(task : ToDoListModel) throws{
        let taskDB = TasksList(context: context)
        taskDB.taskId = UUID()
        taskDB.title = task.title
        taskDB.isCompleted = task.isCompleted
        taskDB.toDoDescription = task.toDoDescription
        taskDB.dueDate = task.dueDate
        taskDB.reminderTime = task.reminderTime
        taskDB.isReminderEnabled = task.isReminderEnabled
            
        try? context.saveContext()
    }
    
    func fetchTask(predicate: NSPredicate?) throws -> [ToDoListModel]{
        let request: NSFetchRequest<TasksList> = TasksList.fetchRequest()
        if predicate != nil{
            request.predicate = predicate
        }
        let tasks = (try? context.fetch(request)) ?? []
        return tasks.map{
            ToDoListModel(taskId: $0.taskId ??  UUID(),
                          title: $0.title ?? "",
                          toDoDescription: $0.toDoDescription ?? "",
                          isCompleted: $0.isCompleted,
                          dueDate: $0.dueDate ?? nil,
                          reminderTime: $0.reminderTime ?? nil,
                          isReminderEnabled: $0.isReminderEnabled)
        }
    }
    
    func update(taskModel: ToDoListModel) throws{
        let request: NSFetchRequest<TasksList> = TasksList.fetchRequest()
        request.predicate = NSPredicate(
            format: "taskId == %@",
            taskModel.taskId as CVarArg
        )

        guard let task = try context.fetch(request).first else {return}
        task.taskId = taskModel.taskId
        task.title = taskModel.title
        task.dueDate = taskModel.dueDate
        task.toDoDescription = taskModel.toDoDescription
        task.isCompleted = taskModel.isCompleted
        task.isReminderEnabled = taskModel.isReminderEnabled
        task.reminderTime = taskModel.reminderTime
        
        try? context.saveContext()
    }
    
    func deleteTask(taskModel: ToDoListModel) throws{
        let request: NSFetchRequest<TasksList> = TasksList.fetchRequest()
        request.predicate = NSPredicate(
            format: "taskId == %@",
            taskModel.taskId as CVarArg
        )

        guard let task = try context.fetch(request).first else {return}
        context.delete(task)
        try? context.save()
    }
}

