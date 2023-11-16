//
//  AddNewReminderView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 11/11/23.
//

import SwiftUI
import UserNotifications

//AddNewReminderView is the view that allows the user to add a new reminder for a specific vehicle
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
                    HStack {
                        Spacer()
                        Button("Allow notifications?") {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
                                if success {
                                    pushNotificationsEnabled = true
                                } else if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                        Spacer()
                    }
    
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
                
                    HStack {
                        Spacer()
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
                        .frame(height: 60)
                        .buttonStyle(.bordered)
                        Spacer()
                    }
                
                    //Date Completed field
                    HStack {
                        Text("Next Service Due:")
                        Spacer()
                        Text("\(nextServiceDueText)")
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
                
                //Create the notification that will be sent to the user
                let content = UNMutableNotificationContent()
                content.title = "MXTracker: Maintenance Time!"
                content.subtitle = "Reminder: \(reminderTitle) for \(vehicle?.make ?? "your vehicle")"
                content.sound = UNNotificationSound.default
                
                //Logic for sending the notification based on the nextServiceDue date
//                let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextServiceDue)
//                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                
                //Line for testing
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)

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
            .disabled(!pushNotificationsEnabled || reminderTitle.isEmpty)
            
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
    
    //Function to calculate the next service due date
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
