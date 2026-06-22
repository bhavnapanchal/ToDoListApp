//
//  CreateTaskViewController.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 19/04/26.
//

import UIKit
import CoreData

enum TaskMode{
    case create
    case edit(ToDoListModel?)
}
class CreateTaskViewController: UIViewController {

    private var createtaskViewModel = CreateTaskViewModel()
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var createTaskView: CreateTaskView!
    var onTasksave: ((String,ToDoListModel)-> Void)?
    var onTaskUpdate: ((String,ToDoListModel)-> Void)?

    var mode: TaskMode = .create

    override func viewDidLoad() {
        super.viewDidLoad()
        setRightBarCloseButton(target: self, action: #selector(didTapCloseButton))

        setupBindings()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let style = NavigationBarStyle.popUpStyle()
        applyNavigationStyle(appearance: style.appearance,
                             tintColor: style.tintColor,
                             prefersLargeTitles: style.large)
    }
    
    func setupUI(){
        saveButton.backgroundColor = .lightGray

        switch mode{
            case .create:
                self.title = "Create Task"
                saveButton.isEnabled = false
                saveButton.setTitle("Save", for: .normal)
                createTask()
            case .edit(let task):
                self.title = "Update Task"
                saveButton.setTitle("Save Changes", for: .normal)
                createTaskView.setData(task: task!)
                updateTask(task: task!)
        }
    }
    
    func setupBindings(){
        createtaskViewModel.onValidationChange = {[weak self] isEnabled in
            self?.saveButton.isEnabled = isEnabled
            self?.saveButton.backgroundColor = isEnabled ? UIColor(named: "PrimaryColor") : .lightGray
        }
        
        createTaskView.onTitleChange = {[weak self] title in
            self?.createtaskViewModel.title = title
        }
        
        createTaskView.onDescriptionChange = {[weak self]  descriptionText in
            self?.createtaskViewModel.description = descriptionText
        }
        
        createTaskView.onReminderDateChange = {[weak self] date in
            self?.createtaskViewModel.reminderDate = date
        }
        
        createTaskView.onDateToggleChange = { [weak self] isDateOn, date in
            self?.createtaskViewModel.isDateOn = isDateOn
            self?.createtaskViewModel.reminderDate = date
        }
        
        createTaskView.onReminderTimeChange = { [weak self] time in
            self?.createtaskViewModel.reminderTime = time
        }
        
        createTaskView.onTimeToggleChange = {[weak self] isTimeOn, time in
            self?.createtaskViewModel.isTimeOn = isTimeOn
            self?.createtaskViewModel.reminderTime = time
        }
    }

    @objc func didTapCloseButton(){
        dismiss(animated: true)
    }

    private func createTask(){
        saveButton.addAction(UIAction{[weak self] _ in

            guard let self = self else {return}
            self.createtaskViewModel.addTask(isCompleted: false) { result in
                switch result {
                case .success(let task):
                    self.dismiss(animated: true)
                    self.onTasksave!("Added Successfully!", task)
                case .failure(let error):
                    print("failed to save:", error.localizedDescription)
                }
            }
        }, for: .touchUpInside)
    }

    private func updateTask(task: ToDoListModel){
        saveButton.addAction(UIAction{[weak self] _ in
            guard let self = self else {return}
            
            self.createtaskViewModel.updateTask(task: task) { result in
                switch result{
                    case .success(let updatedTask):
                    self.dismiss(animated: true)
                    self.onTaskUpdate!("Updated Successfully!", updatedTask)
                    case .failure(let error):
                        print("failed to update:", error.localizedDescription)
                }
            }
        }, for: .touchUpInside)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
