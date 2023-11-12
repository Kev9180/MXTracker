//
//  RecordModel.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import Foundation

//
class RecordModel {
    let viewContext = PersistenceController.shared.container.viewContext
    
    //Function to create a new CoreData MaintenanceRecord entity
    func addNewRecord(dateCompleted: String, mileageCompleted: Int, workPerformed: String, serviceInterval: String, logTitle: String) -> MaintenanceRecord {
        let newRecord = MaintenanceRecord(context: viewContext)
        newRecord.id = UUID()
        newRecord.dateCompleted = dateCompleted
        newRecord.mileageCompleted = Int64(mileageCompleted)
        newRecord.workPerformed = workPerformed
        newRecord.serviceInterval = serviceInterval
        newRecord.logTitle = logTitle
        
        do {
            try viewContext.save()
            return newRecord
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
