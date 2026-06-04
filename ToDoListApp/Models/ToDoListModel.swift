//
//  ToDoListModel.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 22/03/26.
//

import Foundation

struct ToDoListModel {
    var taskId: UUID
    var title: String?
    var toDoDescription: String?
    var isCompleted: Bool
    var dueDate: Date?
    var reminderTime: Date?
    var isReminderEnabled: Bool
}
