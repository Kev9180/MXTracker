//
//  VehicleRemindersView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 11/11/23.
//

import SwiftUI

struct VehicleRemindersView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var vehicle: UserVehicle?
    @ObservedObject var reminderVM = ReminderViewModel()

    //Main view that handles the logic for displaying the UI elements for each vehicle's active reminders
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
            Text("Reminders")
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
            
            //Display the records for this vehicle
            List {
                //Check if the vehicle has any active reminders that have been added
                if let vehicleReminders = vehicle?.vehicleReminders as? Set<VehicleReminder>, !vehicleReminders.isEmpty {
                    //Convert the set of reminders to an array and then display each of the records
                    ForEach(Array(vehicleReminders), id: \.id) { reminder in
                        NavigationLink(destination: ReminderDetailsView(vehicle: vehicle, reminder: reminder)) {
                            HStack {
                                Text("\(reminder.reminderTitle ?? "")")
                                    .fontWeight(.semibold)
                                    .frame(alignment: .leading)
                            }
                        }
                    }
                    .onDelete(perform: deleteReminder)
                } else {
                    Text("No active reminders found for this vehicle! Add one now to get started!")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.red)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .multilineTextAlignment(.center)
                }
            }
            .scrollContentBackground(.hidden)
            .onAppear{
                reminderVM.fetchReminders()
            }
            
            Spacer()
            
            //Add New Record Button
            NavigationLink {
                //Take the user to the AddNewReminderView
                AddNewReminderView(vehicle: $vehicle)
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add New Reminder")
                }
            } //Format the button's appearance
            .frame(width: 290, height: 30)
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
    
    //Function that calculates the index of the vehicle and then calls the deleteVehicle function in VehicleViewModel to delete the vehicle
    func deleteReminder(at offsets: IndexSet) {
        if let vehicleReminders = vehicle?.vehicleReminders as? Set<VehicleReminder> {
            let remindersArray = Array(vehicleReminders)

            for index in offsets {
                let reminderToDelete = remindersArray[index]
                reminderVM.deleteReminder(reminderToDelete)
            }

            vehicle?.removeFromVehicleReminders(remindersArray[offsets.first!])
        }
    }
}

#Preview {
    VehicleRemindersView()
}
