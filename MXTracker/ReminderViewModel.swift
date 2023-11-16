//
//  ReminderViewModel.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import Foundation
import CoreData

//Define the ReminderViewModel class
public class ReminderViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    
    //Initialize viewContext
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        fetchReminders()
    }
    
    //Function to fetch VehicleReminders
    func fetchReminders() {
        let fetchRequest: NSFetchRequest<VehicleReminder> = VehicleReminder.fetchRequest()

        do {
            _ = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    //Function to delete a previously-added VehicleReminder entity
    func deleteReminder(_ reminder: VehicleReminder) {
        viewContext.delete(reminder)

        do {
            try viewContext.save()
        } catch {
            print("Error saving context after deleting vehicle: \(error)")
        }
    }
    
    //Date formatter to format a date
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yyyy"
        return formatter
    }()

    //Function to convert a date from a string to an actual date
    func convertDate(dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }

    //Function to calculate the next service due date
    func calculateNextServiceDueDate(from date: Date, intervalMonths: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: intervalMonths, to: date) ?? date
    }
}

