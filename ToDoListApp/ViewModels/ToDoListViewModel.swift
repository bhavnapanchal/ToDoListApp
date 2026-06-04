//
//  ToDoListViewModel.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 23/03/26.
//

import Foundation

enum ToDoSection: String, CaseIterable {
    case completed = "Completed"
    case overdue = "Overdue"
    case today = "Today"
    case tomorrow = "Tomorrow"
    case upcoming = "Upcoming"
}

class ToDoListViewModel{
    var arrAllList: [ToDoListModel] = []
    let order: [ToDoSection: Int] = [
        .completed: 0,
        .overdue: 1,
        .today: 2,
        .tomorrow: 3,
        .upcoming: 4,
    ]

    func groupedTasks(tasksList: [ToDoListModel]) -> [ToDoSection: [ToDoListModel]]{
        var grouped: [ToDoSection: [ToDoListModel]] = [:]
        for task in tasksList {

            let section =  task.isCompleted ? .completed : fetchSection(task: task)
            switch section {
            case .overdue:
                grouped[.overdue, default: []].append(task)
            case .today:
                grouped[.today, default: []].append(task)
            case .tomorrow:
                grouped[.tomorrow, default: []].append(task)
            case .upcoming:
                grouped[.upcoming, default: []].append(task)
            case .completed:
                grouped[.completed, default: []].append(task)
            }
        }
        return grouped
    }
    
    func fetchSection(task : ToDoListModel)-> ToDoSection{

        //Note: should check time also when reminder time is available
        
        let section: ToDoSection
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let date = task.dueDate
        let time = task.reminderTime
        
        var reminderDateAndTime: Date = Date()
        
        var currentDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        
        if date != nil && time != nil{
            reminderDateAndTime = Date.combineDateAndTime(date: date!, time: time!)
        }
        else if date == nil && time != nil{
            reminderDateAndTime = Date.combineDateAndTime(date: reminderDateAndTime, time: time!)
        }
        else if date != nil && time == nil{
            reminderDateAndTime = date ?? Date()
            currentDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        }
        let today = calendar.date(from: currentDateComponents)!
        
        if  reminderDateAndTime < today{
            section = .overdue
        } else if Calendar.current.isDateInToday(reminderDateAndTime){
            section = .today
        } else if calendar.isDateInTomorrow(reminderDateAndTime) {
            section = .tomorrow
        } else {
            section = .upcoming
        }

        return section
    }
    func removeTask(task : ToDoListModel, tasksArray:[ToDoSection: [ToDoListModel]]) -> [ToDoSection: [ToDoListModel]]{
        var taskArray = tasksArray
        for section in ToDoSection.allCases{
            if let index = taskArray[section]?
                .firstIndex(where: { $0.taskId == task.taskId }) {

                taskArray[section]?.remove(at: index)
                if (taskArray[section]?.count == 0){
                    taskArray.removeValue(forKey: section)
                }
                break
            }
        }
        
        return taskArray
    }

    //MARK: CoreData Operations
    private let repository = TodolistAppRepository(context: CoreDataStack.shared.viewContext)
    
    func fetchTask(for filter: ToDoSection? = nil) -> [ToDoSection: [ToDoListModel]]{
        do{
            var calendar  = Calendar.current
            calendar.timeZone = TimeZone.current
            
            let date = Date()
            var predicate : NSPredicate? = NSPredicate()
            
            switch filter{
                case .today:
                    let todayStart = calendar.startOfDay(for: date)
                    let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)!

                    predicate = NSPredicate(format: "(dueDate >= %@ && dueDate < %@) || dueDate == nil",
                                            todayStart as NSDate,
                                            todayEnd as NSDate)
                
                case .completed:
                    predicate = NSPredicate(format: "isCompleted == YES")
                case .tomorrow:
                    let tomorrowStart = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date))!
                    let tomorrowEnd = calendar.date(byAdding: .day, value: 1, to: tomorrowStart)!
                    
                    predicate = NSPredicate(format: "dueDate >= %@ && dueDate < %@",
                                            tomorrowStart as NSDate,
                                            tomorrowEnd as NSDate)

                case .overdue:
                    let todayStart = Calendar.current.startOfDay(for: date)
                    predicate = NSPredicate(format: "dueDate < %@ && isCompleted == NO",
                                            todayStart as NSDate)
                case .upcoming:
                    let todayStart = Calendar.current.startOfDay(for: date)
                    let upcomingStart = calendar.date(byAdding: .day, value: 2, to: todayStart)!
                    predicate = NSPredicate(format: "dueDate >= %@", upcomingStart as NSDate)
                case .none:
                    print("")
                predicate = nil
                
            }
            let taskList = try repository.fetchTask(predicate: predicate)
            return groupedTasks(tasksList: taskList)
        }catch{
            print(error.localizedDescription)
            return[:]
        }
    }
    
    func deleteTask(task: ToDoListModel, completion: @escaping (Result<Void, Error>) -> Void){
        do{
            try repository.deleteTask(taskModel: task)
            completion(.success(()))
        }catch{
            completion(.failure(error))
        }
    }
    
    func updateCompletedTask(task: ToDoListModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do{
            try repository.update(taskModel: task)
            completion(.success(()))
        }catch{
            completion(.failure(error))
        }
    }
}
