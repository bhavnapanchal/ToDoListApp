//
//  CreateTaskView.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 19/04/26.
//

import UIKit

class CreateTaskView: UIView {
    
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var reminderStackView: UIStackView!

    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    
    @IBOutlet weak var datePickerContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reminderToggle: UISwitch!
    @IBOutlet weak var contrainerViewDatePicker: UIView!
    @IBOutlet weak var reminderDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var timePickerContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var contrainerViewTimePicker: UIView!
    @IBOutlet weak var timeToggle: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var reminderTime: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    var isDateShow: Bool = false
    var isTimeShow: Bool = false
    
    var selectedDate: Date?
    var selectedTime: Date?

    var onTitleChange: ((String) -> Void)?
    var onDescriptionChange: ((String) -> Void)?
    var onReminderDateChange: ((Date) -> Void)?
    var onReminderTimeChange: ((Date) -> Void)?
    var onDateToggleChange: ((Bool, Date?) -> Void)?
    var onTimeToggleChange: ((Bool, Date?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        titleStackView.verticalStyle()
        reminderStackView.verticalStyle()
        
        setupDatePicker()
        setupTimePicker()

        taskDescriptionTextView.setPlaceholder("Description")
        
        reminderToggle.addTarget(self, action: #selector(dateToggle(_:)), for: .valueChanged)
        contrainerViewDatePicker.clipsToBounds = true
        
        timeToggle.addTarget(self, action: #selector(timeToggle(_:)), for: .valueChanged)
        contrainerViewTimePicker.clipsToBounds = true
        
        taskDescriptionTextView.delegate = self
        
        taskTitleTextField.addAction(UIAction{[weak self] _ in
            self?.onTitleChange?(self?.taskTitleTextField.text ?? "")
        }, for: .editingChanged)
        
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        lblDate.addGestureRecognizer(dateTapGesture)
        
        let timeTapGesture = UITapGestureRecognizer(target: self, action: #selector(timeTapped))
        lblTime.addGestureRecognizer(timeTapGesture)
    }

    
    private func setupDatePicker(){
        datePicker.minimumDate = Date()
        datePicker.addAction(UIAction{[weak self] action in
            guard let self = self,
                  let picker = action.sender as? UIDatePicker else {return}
            
            self.selectedDate = picker.date
            if let selectedDate = self.selectedDate {
                self.reminderDate.text = selectedDate.convertToString(formatType: .date)
                self.onReminderDateChange?(selectedDate)
            }
        }, for: .valueChanged)
    }
    
    private func setupTimePicker(){
        
        timePicker.addAction(UIAction{[weak self] action in
            guard let self = self,
            let picker = action.sender as? UIDatePicker else {return}
            
            self.selectedTime = picker.date
            if let selectedTime = self.selectedTime {
                self.reminderTime.text = selectedTime.convertToString(formatType: .time)
                self.onReminderTimeChange?(selectedTime)
            }
        }, for: .valueChanged)
    }
    
    func setData(task: ToDoListModel){
        taskTitleTextField.text = task.title
        self.onTitleChange?(task.title ?? "")

        taskDescriptionTextView.text = task.toDoDescription
        self.onDescriptionChange?(task.toDoDescription ?? "")
        taskDescriptionTextView.updatePlaceholder()
        
        if let date = task.dueDate{
            selectedDate = date
            reminderToggle.isOn = true
            reminderDate.isHidden = false
            reminderDate.text = date.convertToString(formatType: .date)
            datePicker.minimumDate = nil
            datePicker.setDate(date, animated: false)
            self.onReminderDateChange?(date)
        }
        
        if let time = task.reminderTime{
            selectedTime = time
            timeToggle.isOn = true
            reminderTime.isHidden = false
            reminderTime.text = time.convertToString(formatType: .time)
            timePicker.minimumDate = nil
            timePicker.date = time
            self.onReminderTimeChange?(time)
        }
    }
    
    func updateTimePickerMinimumDate(){
        if Calendar.current.isDateInToday(selectedDate ?? Date()) {
            timePicker.minimumDate = Date()
        }
        else{
            timePicker.minimumDate = nil
        }
    }
}

//MARK: TextView Delegate
extension CreateTaskView : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        onDescriptionChange?(textView.text)
    }
}

//MARK: Picker show/hide
extension CreateTaskView
{
    func showPicker(isOn: Bool,
                    containerView: UIView,
                    label: UILabel?,
                    picker: UIDatePicker,
                    constraintHeight: NSLayoutConstraint,
                    pickerValue: Date?)
    {
        self.layoutIfNeeded()
        let height = picker.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        if isOn {
            containerView.isHidden = false
            label?.isHidden = false

            // Start collapsed
            constraintHeight.constant = 0
            self.layoutIfNeeded()
        }

        constraintHeight.constant = isOn ? height : 0

        UIView.animate(withDuration: 0.3){
            containerView.isHidden = !isOn
            label?.isHidden = !isOn && pickerValue == nil
            self.layoutIfNeeded()
        }
    }
    
    func closePicker(containerView: UIView,
                     constraintHeight: NSLayoutConstraint,
                     completion: (() -> Void)? = nil){
        
        constraintHeight.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: {_ in
            containerView.isHidden = true
            completion?()
        }
    }
}

//MARK: Actions
extension CreateTaskView{
    @objc func dateToggle(_ sender: UISwitch) {

        let showPicker = { [weak self] in
            guard let self = self else { return }
            self.showPicker(isOn: sender.isOn,
                            containerView: contrainerViewDatePicker,
                            label: reminderDate,
                            picker: datePicker,
                            constraintHeight: datePickerContainerHeight,
                            pickerValue: selectedDate)
        }
        if (sender.isOn){
            if selectedDate == nil{
                selectedDate = datePicker.date
                reminderDate.text = selectedDate?.convertToString(formatType: .date)
            }
            
            closePicker(containerView: contrainerViewTimePicker,
                        constraintHeight: timePickerContainerHeight,
                        completion: showPicker)
            
            isTimeShow = false
            
        }
        else{
            selectedDate = nil
            datePicker.setDate(Date(), animated: false)
            showPicker()
        }
        
        isDateShow = sender.isOn
        lblDate.isUserInteractionEnabled = sender.isOn
        onDateToggleChange?(sender.isOn, selectedDate)
    }
    
    @objc func timeToggle(_ sender: UISwitch){

        let showPicker = { [weak self] in
            guard let self = self else { return }
            updateTimePickerMinimumDate()
            self.showPicker(isOn: sender.isOn,
                            containerView: contrainerViewTimePicker,
                            label: reminderTime,
                            picker: timePicker,
                            constraintHeight: timePickerContainerHeight,
                            pickerValue: selectedTime)
        }
        if (sender.isOn){
            if selectedTime == nil{
                selectedTime = timePicker.date
                reminderTime.text = selectedTime!.convertToString(formatType: .time)
            }
            closePicker(containerView: contrainerViewDatePicker,
                        constraintHeight: datePickerContainerHeight,
                        completion: showPicker)
            isDateShow = false
        }
        else{
            selectedTime = nil
            timePicker.setDate(Date(), animated: false)
            showPicker()
        }
        
        isTimeShow = sender.isOn
        lblTime.isUserInteractionEnabled = sender.isOn
        onTimeToggleChange?(sender.isOn, selectedTime)
    }
    
    @objc func dateTapped(){
        guard reminderToggle.isOn else { return }
        self.showPicker(isOn: !isDateShow,
                        containerView: contrainerViewDatePicker,
                        label: reminderDate,
                        picker: datePicker,
                        constraintHeight: datePickerContainerHeight,
                        pickerValue: selectedDate)
        
        if !isDateShow{
            closePicker(containerView: contrainerViewTimePicker,
                        constraintHeight: timePickerContainerHeight)
            isTimeShow = false
        }
        isDateShow.toggle()
    }
    
    @objc func timeTapped(){
        guard timeToggle.isOn else { return }
        updateTimePickerMinimumDate()
        self.showPicker(isOn: !isTimeShow,
                        containerView: contrainerViewTimePicker,
                        label: reminderTime,
                        picker: timePicker,
                        constraintHeight: timePickerContainerHeight,
                        pickerValue: selectedTime)
        if !isTimeShow{
            closePicker(containerView: contrainerViewDatePicker,
                        constraintHeight: datePickerContainerHeight)
            isDateShow = false
        }

        isTimeShow.toggle()
    }
}


