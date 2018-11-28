//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Brian van de Velde on 28-11-18.
//  Copyright © 2018 Brian van de Velde. All rights reserved.
//

import UIKit

@objc protocol ToDoCellDelegate: class
{
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell
{
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func completeButtonTapped()
    {
        delegate?.checkmarkTapped(sender: self)
    }
    
    var delegate: ToDoCellDelegate?
}
