//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Gustavo Quenca on 10/04/18.
//  Copyright © 2018 Quenca. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    override init() {
     itemID = DataModel.nextChecklistItemID()
     super.init()
     }
    
    //The special deinit method will be invoked when you delete an individual ChecklistItem but also when you delete a whole Checklist
    deinit {
        removeNotification()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    //Schedule Notification
    func scheduleNotification() {
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
            // Put the text into notifications message
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            // Extration day, hour, minute etc from dueDate
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            // Test local notifications
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // Get the id of the date
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            // Add a new notification
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Schedule: \(request) for itemID: \(itemID)")
        }
    }
    
    // This removes the local notification for this ChecklistItem, if it exists
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(
            withIdentifiers: ["\(itemID)"])
    }
}


