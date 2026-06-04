//
//  CreateTaskViewModel.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 17/04/26.
//

import Foundation

class CreateTaskViewModel{
    
    //MARK: Form Validation
    var title: String = ""{
        didSet{
            validate()
        }
    }
    var description: String = ""{
        didSet{
            validate()
        }
    }
    var reminderDate: Date?{
        didSet{
            validate()
        }
    }
    var isDateOn: Bool = false{
        didSet{
            validate()
        }
    }
    var isTimeOn: Bool = false
    var reminderTime: Date?
    
    var isSaveEnabled: Bool = false{
        didSet{
            onValidationChange?(isSaveEnabled)
        }
    }
    
    var onValidationChange : ((Bool) -> Void)?
    
    private func validate(){
        isSaveEnabled = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && (!isDateOn || reminderDate != nil)
        
        onValidationChange?(isSaveEnabled)
    }
    
    //MARK: CoreData Operations
    private let repository = TodolistAppRepository(context: CoreDataStack.shared.viewContext)

    func addTask (isCompleted: Bool, completion: @escaping (Result<ToDoListModel, Error>) -> Void){
        
        if reminderTime != nil && reminderDate == nil{
            reminderDate = Date()
        }
        
        let task = ToDoListModel(taskId: UUID(),
                                 title: title,
                                 toDoDescription: description,
                                 isCompleted: isCompleted,
                                 dueDate: reminderDate,
                                 reminderTime: reminderTime,
                                 isReminderEnabled: (isDateOn || isTimeOn))
        do {
            try repository.createTask(task: task)
            completion(.success((task)))
        }catch {
            completion(.failure(error))
        }
    }
    
    func updateTask(task:ToDoListModel, completion: @escaping (Result<ToDoListModel, Error>) -> Void)  {
        do{
            var updatedTask = task
            if !title.isEmpty{
                updatedTask.title = title
            }
            
            if !description.isEmpty{
                updatedTask.toDoDescription = description
            }
            
            updatedTask.dueDate = reminderDate ?? updatedTask.dueDate
            updatedTask.reminderTime = reminderTime ?? updatedTask.reminderTime
            updatedTask.isCompleted = task.isCompleted
            
            let newReminderState = (isDateOn || isTimeOn)
            if (updatedTask.isReminderEnabled != newReminderState){
                updatedTask.isReminderEnabled = newReminderState
            }

            try repository.update(taskModel: updatedTask)
            completion(.success(updatedTask))
        }catch{
            completion(.failure(error))
        }
    }
}


