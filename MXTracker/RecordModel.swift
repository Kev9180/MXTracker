//
//  RecordModel.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import Foundation

////Define the Maintenance Record structure
//struct MaintenanceRecord: Identifiable {
//    var id = UUID()
//    var dateCompleted = String()
//    var mileageCompleted = Int()
//    var workPerformed = String()
//    var serviceInterval = String()
//    var logTitle = String()
//}

//
class RecordModel {
    
    let viewContext = PersistenceController.shared.container.viewContext
    
    //Function to create a new ActivityEntry entity
    func addNewRecord(dateCompleted: String, mileageCompleted: Int, workPerformed: String, serviceInterval: String, logTitle: String) -> MaintenanceRecord {
        
        let newRecord = MaintenanceRecord(context: viewContext)
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
