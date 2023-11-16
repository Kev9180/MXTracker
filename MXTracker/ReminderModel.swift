//
//  ReminderModel.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import Foundation

//Define the ReminderModel class
class ReminderModel {
    
    let viewContext = PersistenceController.shared.container.viewContext
    
    //Function to create a new ActivityEntry entity
    func addNewReminder(reminderTitle: String, dateCompleted: String, serviceInterval: String, nextServiceDue: Date, pushNotificationsEnabled: Bool) -> VehicleReminder {
        
        let newReminder = VehicleReminder(context: viewContext)
        
        newReminder.reminderTitle = reminderTitle
        newReminder.dateCompleted = dateCompleted
        newReminder.serviceInterval = serviceInterval
        newReminder.nextServiceDue = nextServiceDue
        newReminder.pushNotificationsEnabled = pushNotificationsEnabled
        
        do {
            try viewContext.save()
            return newReminder
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
