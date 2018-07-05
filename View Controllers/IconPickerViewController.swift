//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Gustavo Quenca on 26/04/18.
//  Copyright © 2018 Quenca. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [ "No Icon", "Appointments", "Birthdays", "Chores",
    "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    // Obtain a table view cell and give it a title and an image
    override func tableView(_ tableView: UITableView,
                               cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "IconCell",
                for: indexPath)
            
            let iconName = icons[indexPath.row]
            cell.textLabel!.text = iconName
            cell.imageView!.image = UIImage(named: iconName)
            
            return cell
    }
    
    // Set the icons on the checklist
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}
