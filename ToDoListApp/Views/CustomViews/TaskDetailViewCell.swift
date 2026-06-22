//
//  TaskDetailViewCell.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 08/06/26.
//

import UIKit

enum TaskDetailViewCellType: String, CaseIterable {
    case title = "titleCell"
    case description = "descriptionCell"
    case dueDate = "dueDateCell"
    case reminderTime = "reminderTimeCell"
    case action = "actionCell"
}

class TaskDetailViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var reminderTimeLabel: UILabel!
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureActionButtons() {
        editButton.addAction(UIAction{[weak self] _ in
            self?.onEditTapped?()
        }, for: .touchUpInside)
    }
    
    func setData(task: ToDoListModel) {
        titleLabel?.text = task.title
        descriptionLabel?.text = task.toDoDescription
        
        dueDateLabel?.text = task.dueDate?.convertToString(formatType: .date)
        reminderTimeLabel?.text = task.reminderTime?.convertToString(formatType: .time)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
