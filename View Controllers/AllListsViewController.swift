//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Gustavo Quenca on 19/04/18.
//  Copyright © 2018 Quenca. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Protocols
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishingAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()

        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishingEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Was the back button tapped?
        if viewController === self {
           dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    /*    // Add placeholder data
        var list = Checklist(name: "Birthdays")
        dataModel.lists.append(list)
        
        list = Checklist(name: "Groceries")
        dataModel.lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        dataModel.lists.append(list)
        
        list = Checklist(name: "To Do")
        dataModel.lists.append(list)
 
        // Add a placeholder item date
        for list in dataModel.lists {
            let item = ChecklistItem()
            item.text = "Item for \(list.name)"
            list.items.append(item)
        }*/
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Make itself delegate
        navigationController?.delegate = self
        // If is different than -1 the user was viewing a checklist
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Set large title
        navigationController?.navigationBar.prefersLargeTitles = true
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    // Put some text into the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(for: tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All Done"
        } else {
        cell.detailTextLabel!.text = "\(count) Remaining"
        }
        
        // Adding an image to the cell
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        return cell
    }
    
    // Create a cell into the table
    func makeCell(for: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                               didSelectRowAt indexPath: IndexPath) {
       dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    // Delete a cell
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // This methos is called right before the segue happens 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
}
