//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Brian van de Velde on 28-11-18.
//  Copyright © 2018 Brian van de Velde. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController
{
    // defining outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func textEditingChanged(_ sender: UITextField)
    {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField)
    {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton)
    {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker)
    {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    // defining variables
    var isEndDatePickerHidden = true
    var todo: ToDo?
    
    // loads initial screen
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateSaveButtonState()
        
        if let todo = todo
        {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
        }
        else
        {
            dueDatePickerView.date =
            Date().addingTimeInterval(24*60*60)
        }
        
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    // sets the style of the rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
    
        switch(indexPath)
        {
            case [1,0]: //Due Date Cell
            return isEndDatePickerHidden ? normalCellHeight : largeCellHeight
        
            case [2,0]: //Notes Cell
            return largeCellHeight
        
            default: return normalCellHeight
        }
    }
    
    // hides and shows the date picker once it's clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch (indexPath)
        {
            case [1,0]:
                isEndDatePickerHidden = !isEndDatePickerHidden
            
            dueDateLabel.textColor =
                isEndDatePickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
    }
    
    // if there is something in the textfield, the save button is available
    func updateSaveButtonState()
    {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func updateDueDateLabel(date: Date)
    {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
    Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
}
