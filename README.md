</> Markdown

# ToDoListApp

## Project Overview

An iOS To-Do List Application, built using **Swift**, **UIKit**, **Core Data**, **Local Notification** and **MVVM Architecture**. It helps users to manage tasks efficiently with reminder support and task categorisation.

### Features:

- Create New Task
  - Task Title
  - Description
  - Set Reminder
  - Set Due Date
- Tasks List by Category
  - All
  - Completed
  - Overdue
  - Today
  - Tomorrow
  - Upcoming
- Edit Existing Task
- Delete Task
- Filter Task by Category
- Receive Local Notification

## Architecture

This Project follows MVVM(Model-View-ViewModel) Architecture to separate **UI, business logic, data maintenance**.

### Why?
- Improves Code readability
- Reuse business logic
- Easier to maintain
- Cleaner project structure

### Structure
#### Model:
Responsible for data representation.
- Core Data entities
- `ToDoListModel`

#### View:
Handles UI and User Interaction 
- View Controller
  - `CreateTaskViewController`
  - `ToDoListViewController`
- Custom View
  - `CreateTaskView`
  - `ToDoListCell`

#### View Model:
Creates bridge between View and Model layer. Responsible for business logic, processing user request, interacts with data layer and prepare data to display in UI
- `CreateTaskViewModel`
- `ToDoListViewModel`

#### Repository:
Handles all core data operations including **create, fetch, update and delete task**
- `ToDoListAppRepository`

#### Extensions:
Provides additional functionality to existing classes through reusable extensions

- `Date+Formatting`
- `UIStackView+Extension`
- `UITextView+Extensions`
- `UIViewController+Navigation`

#### Helper:
Contains reusable UI styling
- `NavigationBarStyle`


## Technologies used:

- Swift
- UIKit
- Core Data
- Local Notification
- MVVM

## Screenshots:

<p float="left">
    <img scr="Screenshots/TaskList.png" width="250"/>
    <img scr="Screenshots/CreateNewTask.png" width="250"/>
    <img scr="Screenshots/TaskFilterByCategories.png" width="250"/>
    <img scr="Screenshots/UpdateTask.png" width="250"/>
    <img scr="Screenshots/ViewTaskDetail.png" width="250"/>
    <img scr="Screenshots/Edit_DeleteTask.png" width="250"/>
    <img scr="Screenshots/FilteredUpcomingTasks.png" width="250"/>
</p>
