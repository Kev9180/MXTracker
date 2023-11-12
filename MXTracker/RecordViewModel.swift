//
//  RecordViewModel.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import Foundation
import CoreData

//Define the RecordViewModel class
public class RecordViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    
    //Initialize viewContext
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        fetchRecords()
    }
    
    //Function to fetch MaintenanceRecords
    func fetchRecords() {
        let fetchRequest: NSFetchRequest<MaintenanceRecord> = MaintenanceRecord.fetchRequest()

        do {
            _ = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    //Function to delete a previously-added MaintenanaceRecord entity
    func deleteRecord(_ record: MaintenanceRecord) {
        viewContext.delete(record)

        do {
            try viewContext.save()
        } catch {
            print("Error saving context after deleting vehicle: \(error)")
        }
    }
}
