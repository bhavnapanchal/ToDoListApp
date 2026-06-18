//
//  TaskDetailViewController.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 08/06/26.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    var task : ToDoListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        setRightBarCloseButton(target: self, action: #selector(didTapCloseButton))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let style = NavigationBarStyle.popUpStyle()
        applyNavigationStyle(appearance: style.appearance,
                             tintColor: style.tintColor,
                             prefersLargeTitles: style.large)
    }

    @objc func didTapCloseButton() {
        dismiss(animated: true)
    }
}
extension TaskDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let cellType = TaskDetailViewCellType.allCases[indexPath.row]

        var height = UITableView.automaticDimension
        switch cellType {
        case .title:
            height = 80
        case .dueDate:
            height = task?.dueDate == nil ? 0 : UITableView.automaticDimension
        case .reminderTime:
            height = task?.reminderTime == nil ? 0 : UITableView.automaticDimension
        case .action:
            height = 100
        default:
            height = UITableView.automaticDimension
        }
        
        return height
    }
}
extension TaskDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskDetailViewCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = TaskDetailViewCellType.allCases[indexPath.row].rawValue
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? TaskDetailViewCell
        else { return UITableViewCell() }
        
        if let task = task {
            cell.setData(task: task)
        }

        return cell
    }
}
