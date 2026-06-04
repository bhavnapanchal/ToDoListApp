//
//  ToDoListViewController.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 19/03/26.
//

import UIKit

class ToDoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let toDoListViewModel = ToDoListViewModel()
    var toDoListArray : [ToDoSection : [ToDoListModel]] = [:]
    let order: [ToDoSection: Int] = [
        .completed: 0,
        .overdue: 1,
        .today: 2,
        .tomorrow: 3,
        .upcoming: 4
    ]
    var noOfSections : [ToDoSection]{
        Array(toDoListArray.keys).sorted {
            order[$0]! < order[$1]!
        }
    }
    
    var currentFilter: ToDoSection?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DB FIle:", FileManager.default.urls(for: .documentDirectory,
                                       in: .userDomainMask).first!)

        self.title = "To Do List"
        
        tableView.delegate = self
        tableView.dataSource = self
 
        toDoListArray = toDoListViewModel.fetchTask()
        
        setRightBarButton()
        setleftBarButton()
    }
    
    //MARK: - Navigationbar setup
    func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Background color
        appearance.backgroundColor = UIColor(named: "PrimaryColor") // or .systemBlue

        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica​Neue​-​Medium", size: 25) ?? UIFont.systemFont(ofSize: 25)
        ]
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica​Neue​-​Medium", size: 34) ?? UIFont.boldSystemFont(ofSize: 34)
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    func setleftBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapLeftButton)
        )
    }
    
    func setRightBarButton() {
        let filterMenu = UIMenu(
            title: "",
            children: [
                UIAction(title: "All"){ [weak self] _ in
                    guard let self = self else {return}
                    self.currentFilter = nil
                    self.toDoListArray = self.toDoListViewModel.fetchTask()
                    self.tableView.reloadData()
                },
                UIAction(title: "Completed"){ [weak self] _ in
                    guard let self = self else {return}
                    self.currentFilter = .completed
                    self.toDoListArray = self.toDoListViewModel.fetchTask(for: .completed)
                    self.tableView.reloadData()
                },
                UIAction(title: "Overdue"){ [weak self] _ in
                    guard let self = self else {return}
                    self.currentFilter = .overdue
                    self.toDoListArray = self.toDoListViewModel.fetchTask(for: .overdue)
                    self.tableView.reloadData()
                },
                UIAction(title: "Today"){[weak self] _ in
                    guard let self = self else {return}
                    self.currentFilter = .today
                    self.toDoListArray = self.toDoListViewModel.fetchTask(for: .today)
                    self.tableView.reloadData()
                },
                UIAction(title: "Tomorrow"){[weak self] _ in
                    guard let self = self else {return}
                    self.currentFilter = .tomorrow
                    self.toDoListArray = self.toDoListViewModel.fetchTask(for: .tomorrow)
                    self.tableView.reloadData()
                },
                UIAction(title: "Upcoming"){[weak self] _ in
                    guard let self = self else {return}
                    self.currentFilter = .upcoming
                    self.toDoListArray = self.toDoListViewModel.fetchTask(for: .upcoming)
                    self.tableView.reloadData()
                }
            ]
        )

        let barImage = UIImage(named: "filter")?.withRenderingMode(.alwaysOriginal)
        if #available(iOS 16.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                                image: barImage,
                                                                primaryAction: nil,
                                                                menu: filterMenu)
        } else {
            // Fallback on earlier versions
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: barImage,
                style: .plain,
                target: self,
                action: #selector(didTapRightButton)
            )
        }
    }
    
    @objc private func didTapLeftButton() {
        openCreateVC(isUpdate: false, task: nil)
    }

    @objc private func didTapRightButton() {
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Open Create/Update View
    func openCreateVC(isUpdate: Bool, task: ToDoListModel?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createTaskVC = storyboard.instantiateViewController(withIdentifier: "CreateTaskViewController") as! CreateTaskViewController

        let navVC = UINavigationController(rootViewController: createTaskVC)
        navVC.modalPresentationStyle = .pageSheet
        
        if let sheet = navVC.sheetPresentationController{
            sheet.detents = [.large()]
        }
        
        if isUpdate{
            createTaskVC.mode = .edit(task)
            createTaskVC.onTaskUpdate = {[weak self] (message, task) in
                guard let self = self else { return }
                self.showAlert(message: message)
                updateTask(task: task)
            }
        }
        else
        {
            createTaskVC.mode = .create
            createTaskVC.onTasksave = {[weak self] (message, task) in
                guard let self = self else {return}
                
                self.showAlert(message: message)
                
                let section = toDoListViewModel.fetchSection(task: task)
                
                if currentFilter == section || currentFilter == nil{
                    self.toDoListArray[section, default: []].append(task)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        navVC.isModalInPresentation = true
        present(navVC, animated: true)
    }
    
    func updateTask(task: ToDoListModel){
        // remove task from old section
        self.toDoListArray = self.toDoListViewModel.removeTask(
            task: task,
            tasksArray: self.toDoListArray
        )

        // add task to new section
        let section = task.isCompleted ? .completed:self.toDoListViewModel.fetchSection(task: task)
        
        if currentFilter == section || currentFilter == nil{
            self.toDoListArray[section, default: []].append(task)
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: -
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

//MARK: - UITableView Delegate
extension ToDoListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
                     ?? UITableViewHeaderFooterView(reuseIdentifier: "header")

        let title = noOfSections[section].rawValue
        var content = header.defaultContentConfiguration()
        content.text = title
        content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 25) ?? .systemFont(ofSize: 18)
        if title == ToDoSection.overdue.rawValue {
            content.textProperties.color = UIColor.red
        }
        else if title == ToDoSection.completed.rawValue{
            content.textProperties.color = UIColor.gray
        }
        else{
            content.textProperties.color = UIColor.black
        }
        header.contentConfiguration = content

        // Set background color
        header.contentView.backgroundColor = .white

        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = noOfSections[indexPath.section]
        let task = toDoListArray[section]?[indexPath.row]
        openCreateVC(isUpdate: true, task: task)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") {[weak self] _, _, completion in
            guard let self = self else {return}
            let section = self.noOfSections[indexPath.section]
            if let task = self.toDoListArray[section]?[indexPath.row]
            {
                toDoListViewModel.deleteTask(task: task) { [self] result in
                    switch result {
                    case .success(()):
                        self.toDoListArray =  self.toDoListViewModel.removeTask(task: task, tasksArray: self.toDoListArray)
                        tableView.reloadData()

                        completion(true)
                    case .failure(let error):
                        print("failed to delete", error.localizedDescription)
                        completion(false)
                    }
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

//MARK: - UITableView Datasource
extension ToDoListViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return noOfSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = noOfSections[section]
        return toDoListArray[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell", for: indexPath) as? ToDoListCell else { return UITableViewCell() }
        
        let section = noOfSections[indexPath.section]
        var model = toDoListArray[section]?[indexPath.row]
        if model != nil{
            cell.update(with: model!)
        }
        
        cell.onFinishTaskTap = {[weak self] isCompleted in
            guard let self else { return }

            if model != nil{
                model?.isCompleted = isCompleted
                toDoListViewModel.updateCompletedTask(task: model!) { result in
                    switch result {
                        case .success(()):
                            self.updateTask(task: model!)
                            print("success")
                        case .failure(let error):
                            print("failed to update:", error.localizedDescription)
                    }

                }
            }
        }
        return cell
    }
}
