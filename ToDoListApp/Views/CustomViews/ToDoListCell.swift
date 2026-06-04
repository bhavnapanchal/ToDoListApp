//
//  ToDoListCell.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 20/03/26.
//

import Foundation
import UIKit

class ToDoListCell : UITableViewCell {
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDueDate: UILabel!
    @IBOutlet weak var taskReminderTime: UILabel!
    @IBOutlet weak var taskDoneButton : UIButton!
    @IBOutlet weak var TaskReminderStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var dateStackViewConstraintHeight: NSLayoutConstraint!
    
    var onFinishTaskTap: ((Bool) -> Void)?

    var isFinishedTask = false {
        didSet {
            taskDoneButton.setImage(UIImage(named: isFinishedTask ? "Check_Icon" : "UnChecked_Icon"), for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isFinishedTask = false
        buttonConfiguration()
        
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor(named: "ListColor")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isFinishedTask = false
    }

    func buttonConfiguration() {
        taskDoneButton.addAction(UIAction { [weak self] _ in
            guard let self = self else {return}
                    
            self.isFinishedTask.toggle()
            onFinishTaskTap?(self.isFinishedTask)
        }, for: .touchUpInside)
    }
    
    func update(with task: ToDoListModel) {
        taskTitleLabel.text = task.title
        taskDueDate.text = task.dueDate?.convertToString(formatType: .date)
        isFinishedTask = task.isCompleted
        
        dateStackViewConstraintHeight.constant = (task.reminderTime == nil && task.dueDate == nil) ? 0 : 30
        
        if let reminderTime = task.reminderTime  {
            TaskReminderStackView.isHidden = false
            taskReminderTime.text = reminderTime.convertToString(formatType: .time)
        } else {
            TaskReminderStackView.isHidden = true
        }
    }
}
