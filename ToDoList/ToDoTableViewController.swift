//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Brian van de Velde on 27-11-18.
//  Copyright © 2018 Brian van de Velde. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate, UISearchBarDelegate
{
    // defining outlet
    @IBOutlet weak var searchBar: UISearchBar!
    
    // defining variable
    var todos = [ToDo]()
    var CurrentTodos = [ToDo]()
    
    // defining delegate
    private func SearchBar ()
    {
        searchBar.delegate = self
    }
    
    // function that searches your letter/word
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        guard !searchText.isEmpty else
        {
            todos = CurrentTodos
            tableView.reloadData()
            return
        }
        todos = CurrentTodos.filter({ (ToDo) -> Bool in
            ToDo.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    // function that saves the todos you already have so that if you
    // close the searchbar all the todos are still there
    func Copy()
    {
        CurrentTodos = todos
    }
    
    // checks if the chechmark is tapped
    func checkmarkTapped(sender: ToDoCell)
    {
        if let indexPath = tableView.indexPath(for: sender)
        {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // saves the new to do and goes to the new list
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue)
    {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ToDoViewController
        
        if let todo = sourceViewController.todo
        {
            if let selectedIndexPath = tableView.indexPathForSelectedRow
            {
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else
            {
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                todos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        Copy()
        ToDo.saveToDos(todos)
    }
    
    // determines the amount of rows needed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return todos.count
    }
    
    // fills in the cells with the information given
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell
        else
        {
            fatalError("Could not dequeue a cell")
        }
        let todo = todos[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        cell.delegate = self
        return cell
    }
    
    // Loads the screen by adding all the todos
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedToDos = ToDo.loadToDos()
        {
            todos = savedToDos
        }
        else
        {
            todos = ToDo.loadSampleToDos()
        }
        Copy()
    }
    
    // enables editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    // enables removing todos
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    
    // send all the info of your todo to the show list
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDetails"
        {
            let todoViewController = segue.destination
            as! ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = todos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }
}
