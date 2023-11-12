//
//  AddNewReminderView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 11/11/23.
//

import SwiftUI

struct AddNewReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var vehicle: UserVehicle?
    @State var reminderTitle: String = ""
    @State var dateCompleted: String = ""
    @State var serviceInterval: String = ""
    @State var selectedInterval: Int = 1
    @State var selectedIntervalType: Int = 0
    @State var nextServiceDue: Date = Date()
    @State var nextServiceDueText: String = ""
    @State var pushNotificationsEnabled = false
    @StateObject var reminderVM = ReminderViewModel()
    var reminderModel = ReminderModel()

    //Main view that handles the logic for the UI elements required to add a new vehicle reminder
    var body: some View {
        VStack {
            Spacer()
            
            //Image logo
            Image(systemName: "bell.badge")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(Color("MXOrange"))
            
            Spacer()
            
            //Screen title
            Text("Add New Reminder")
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
            
            //Get the reminder details from the user
            Form {
                Section {
                    //Short Log Title field
                    HStack {
                        Text("Reminder Title:")
                        Spacer()
                        TextField("Oil change", text: $reminderTitle)
                            .textFieldStyle(.roundedBorder)
                            .frame(width:150)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    //Date Completed field
                    HStack {
                        Text("Date Last Completed:")
                        Spacer()
                        TextField("MM/DD/YYYY", text: $dateCompleted)
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
                
                    Button {
                        if let dateLastCompleted = reminderVM.convertDate(dateString: dateCompleted) {
                            let interval = selectedIntervalType == 0 ? selectedInterval : selectedInterval * 12
                            nextServiceDue = reminderVM.calculateNextServiceDueDate(from: dateLastCompleted, intervalMonths: interval)
                            nextServiceDueText = reminderVM.dateFormatter.string(from: nextServiceDue)
                        }
                    } label: {
                        Text("Calculate Next Service Due Date")
                    }
                    .disabled(dateCompleted.isEmpty)
                    .frame(alignment: .center)
                    .frame(height: 60)
                
                    //Date Completed field
                    HStack {
                        Text("Next Service Due:")
                        Spacer()
                        Text("\(nextServiceDueText)")
                    }
                    
                    Toggle(isOn: $pushNotificationsEnabled) {
                        Text("Allow push notifications?")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            //Add New Reminder Button
            Button {
                
                // Create a new vehicle maintenance record using RecordModel
                let reminder = reminderModel.addNewReminder(
                    reminderTitle: reminderTitle,
                    dateCompleted: dateCompleted,
                    serviceInterval: calculateServiceInterval(),
                    nextServiceDue: nextServiceDue,
                    pushNotificationsEnabled: pushNotificationsEnabled
                )

                // Associate the record with the vehicle
                if let vehicle = vehicle {
                    vehicle.addToVehicleReminders(reminder)
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
                    Text("Add Reminder")
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
            .disabled(!pushNotificationsEnabled)
            
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
    
    //
    func calculateNextServiceDue() {
        if let dateLastCompleted = reminderVM.convertDate(dateString: dateCompleted) {
            let interval = selectedIntervalType == 0 ? selectedInterval : selectedInterval * 12
            let nextServiceDate = reminderVM.calculateNextServiceDueDate(from: dateLastCompleted, intervalMonths: interval)
            nextServiceDueText = reminderVM.dateFormatter.string(from: nextServiceDate)
        }
    }
}

#Preview {
    AddNewReminderView(vehicle: .constant(UserVehicle()))
}
