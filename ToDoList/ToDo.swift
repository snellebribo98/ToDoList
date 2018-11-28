//
//  ToDo.swift
//  ToDoList
//
//  Created by Brian van de Velde on 27-11-18.
//  Copyright © 2018 Brian van de Velde. All rights reserved.
//

import UIKit

struct ToDo: Codable
{
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static let dueDateFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func loadToDos() -> [ToDo]?
    {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL)
        else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    static func loadSampleToDos() -> [ToDo]
    {
        let todo1 = ToDo(title: "Cooking", isComplete: false, dueDate: Date(), notes: "Cook some psaghetti")
        let todo2 = ToDo(title: "Cleaning", isComplete: false, dueDate: Date(), notes: "Clean your mess")
        let todo3 = ToDo(title: "Crying", isComplete: false, dueDate: Date(), notes: "Cry because your worthless")
        
        return [todo1, todo2, todo3]
    }
    
    static func saveToDos(_ todos: [ToDo])
    {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
}
