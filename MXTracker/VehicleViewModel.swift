//
//  VehicleViewModel.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import Foundation
import CoreData

//Stores the array of results from the response from the API call
struct ModelResult: Decodable {
    let Make_ID: Int
    let Make_Name: String
    let Model_ID: Int
    let Model_Name: String
}

//Stores the response from the NHTSA API call
struct ResponseFromAPICall: Decodable {
    let Count: Int
    let Message: String
    let SearchCriteria: String?
    let Results: [ModelResult]
}

//VehicleViewModel class that handles all the logic for managing vehicles
class VehicleViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    @Published var vehiclesList: [UserVehicle] = []     //Array to hold a list of vehicles added by the user
    @Published var modelResults: [String] = []          //Array to hold a list of vehicle models returned from the API call
    
    let dateFormatter: DateFormatter
    
    //Initialize function to initialize the viewContext and dateFormatter
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yyyy"
        
        fetchVehicles()
    }
    
    //Function to fetch UserVehicles
    func fetchVehicles() {
        let fetchRequest: NSFetchRequest<UserVehicle> = UserVehicle.fetchRequest()

        do {
            let vehicles = try viewContext.fetch(fetchRequest)
            
            //Update the vehiclesList array
            DispatchQueue.main.async {
                self.vehiclesList = vehicles
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    //Function to delete a previously-added UserVehicle entity
    func deleteVehicle(_ vehicle: UserVehicle) {
        viewContext.delete(vehicle)

        do {
            try viewContext.save()
            
            DispatchQueue.main.async {
                self.vehiclesList.removeAll { $0 == vehicle }
            }
        } catch {
            print("Error saving context after deleting vehicle: \(error)")
        }
    }
    
    //Function to perform the API call
    func analyze(makeStr: String, yearStr: String) {
        let make = makeStr
        let year = yearStr
        
        //URL address that will be used in the API call
        let urlAsString = "https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformakeyear/make/\(make)/modelyear/\(year)?format=json"
        
        let url = URL(string: urlAsString)!
        let urlSession = URLSession.shared
        
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if 200 ..< 300 ~= httpResponse.statusCode {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let jsonResult = try decoder.decode(ResponseFromAPICall.self, from: data)

                            let modelNames = jsonResult.Results.compactMap { $0.Model_Name }

                            DispatchQueue.main.async {
                                self.modelResults = modelNames
                            }
                        } catch {
                            print("Error decoding the JSON file: \(error)")
                        }
                    }
                } else {
                    print("Error, HTTP Code \(httpResponse.statusCode)")
                }
            }
        })
        jsonQuery.resume()
    }
}
