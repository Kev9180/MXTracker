//
//  VehicleModel.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import Foundation
import CoreData

//VehicleModel class handles creating a new CoreData UserVehicle entity
class VehicleModel {
    let viewContext = PersistenceController.shared.container.viewContext
    
    //Function to create a new UserVehicle entity
    func addNewVehicle(year: String, make: String, model: String, trim: String, displacement: Double, cylinders: Int, drive: String) -> UserVehicle {
        let newVehicle = UserVehicle(context: viewContext)
        newVehicle.id = UUID()
        newVehicle.year = year
        newVehicle.make = make
        newVehicle.model = model
        newVehicle.trim = trim
        newVehicle.displacement = displacement
        newVehicle.cylinders = Int64(cylinders)
        newVehicle.drive = drive
        
        do {
            try viewContext.save()
            return newVehicle
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
