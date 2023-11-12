//
//  AddNewMXRecordView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/20/23.
//

import SwiftUI

struct AddNewMXRecordView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var vehicle: UserVehicle?
    @State var dateCompleted: String = ""
    @State var mileageCompleted: Int = 0
    @State var logTitle: String = ""
    @State var serviceInterval: String = ""
    @State var selectedInterval: Int = 1
    @State var selectedIntervalType: Int = 0
    @State var workPerformed: String = ""
    
    var recordModel = RecordModel()

    //Main view that handles the logic for the UI elements required to add a new mx record
    var body: some View {
        VStack {
            Spacer()
            
            //Image logo
            Image(systemName: "pencil.and.list.clipboard.rtl")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(Color("MXBlue"))
            
            Spacer()
            
            //Screen title
            Text("Add New Record")
                .font(.system(size: 48))
                .foregroundStyle(Color("MXPurple"))
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
            //Display the vehicle header information for the current vehicle
            Text("\(vehicle?.year ?? "") \(vehicle?.make ?? "") \(vehicle?.model ?? "")")
                .font(.system(size: 28))
                .foregroundStyle(Color.black)
                .fontWeight(.bold)
                .fontDesign(.rounded)

            Spacer()
            
            //Get the maintenance record details
            Form {
                //Date Completed field
                HStack {
                    Text("Date Completed:")
                    Spacer()
                    TextField("MM/DD/YYYY", text: $dateCompleted)
                        .textFieldStyle(.roundedBorder)
                        .frame(width:150)
                        .multilineTextAlignment(.trailing)
                }
                
                //Mileage Completed field
                HStack {
                    Text("Mileage Completed:")
                    Spacer()
                    TextField("150000", value: $mileageCompleted, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width:150)
                        .multilineTextAlignment(.trailing)
                }
                
                //Short Log Title field
                HStack {
                    Text("Log Title (short):")
                    Spacer()
                    TextField("Short description", text: $logTitle)
                        .textFieldStyle(.roundedBorder)
                        .frame(width:150)
                        .multilineTextAlignment(.trailing)
                }
                
                //Service Interval field
                HStack {
                    Text("Service Interval:")
                    Spacer()
                    HStack {
                        Picker(selection: $selectedInterval, label: Text("")) {
                            ForEach(1...12, id: \.self) { month in
                                Text("\(month)").tag(month)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())

                        Picker(selection: $selectedIntervalType, label: Text("")) {
                            Text("Months").tag(0)
                            Text("Years").tag(1)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100)
                    }
                }
                
                //Work Performed field
                HStack {
                    Text("Work Performed:")
                    Spacer()
                    TextField("Long description", text: $workPerformed)
                        .textFieldStyle(.roundedBorder)
                        .frame(width:150)
                        .multilineTextAlignment(.trailing)
                }
            }
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            //Add New Record Button
            Button {
                
                // Create a new vehicle maintenance record using RecordModel
                let record = recordModel.addNewRecord(
                    dateCompleted: dateCompleted,
                    mileageCompleted: mileageCompleted,
                    workPerformed: workPerformed,
                    serviceInterval: calculateServiceInterval(),
                    logTitle: logTitle
                )

                // Associate the record with the vehicle
                if let vehicle = vehicle {
                    vehicle.addToMaintenanceRecords(record)
                    do {
                        try vehicle.managedObjectContext?.save()
                    } catch {
                        // Handle the error appropriately
                        print("Error saving context: \(error)")
                    }
                }

                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Record")
                }
            } //Format the button's appearance
            .frame(width: 260, height: 30)
            .padding()
            .font(.title)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .background(LinearGradient(gradient: Gradient(colors: [Color("MXPurple"), Color.purple]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: Color("MXPurple"), radius: 5, y: 5)
            
            Spacer()
        }
        //Custom back button that dismissses the screen when pressed
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                Text("Back")
            }
        )
    }
    
    //Helper function to create a service interval string
    func calculateServiceInterval() -> String {
        let intervalValue = selectedInterval == 1 ? "1" : "\(selectedInterval)"
        let intervalType = selectedIntervalType == 0 ? "Months" : "Years"
        return "\(intervalValue) \(intervalType)"
    }
}

#Preview {
    AddNewMXRecordView(vehicle: .constant(UserVehicle()))
}
