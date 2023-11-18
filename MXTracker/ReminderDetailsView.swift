//
//  ReminderDetailsView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 11/11/23.
//

import SwiftUI

struct ReminderDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var vehicle: UserVehicle?
    @State var reminder: VehicleReminder?
    
    //Main view that displays the UI elements and handles the logic for those elements
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
            
            //Screen instruction prompt
            Text("\(reminder?.reminderTitle ?? "")")
                .font(.system(size: 24))
                .foregroundStyle(Color.black)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .padding(.leading)
                .padding(.trailing)
            
            Spacer()
            
            //Display the vehicle reminder details
            List {
                
                //HStack to hold the reminder title display
                HStack {
                    Text("Reminder Title:")
                        .frame(alignment: .leading)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(reminder?.reminderTitle ?? "")")
                        .foregroundStyle(Color("MXBlue"))
                        .frame(alignment: .trailing)
                }
                
                //HStack to hold the date last completed display
                HStack {
                    Text("Date Last Completed:")
                        .frame(alignment: .leading)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(reminder?.dateCompleted ?? "")")
                        .foregroundStyle(Color("MXBlue"))
                        .frame(alignment: .trailing)
                }
                
                //HStack to hold the service interval display
                HStack {
                    Text("Service Interval:")
                        .frame(alignment: .leading)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(reminder?.serviceInterval ?? "")")
                        .foregroundStyle(Color("MXBlue"))
                        .frame(alignment: .trailing)
                }
                
                //HStack to hold the next service due display
                HStack {
                    Text("Next Service Due:")
                        .frame(alignment: .leading)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(reminder?.nextServiceDue?.formatted(date: .abbreviated, time: .omitted) ?? "")
                        .foregroundStyle(Color("MXBlue"))
                        .frame(alignment: .trailing)
                }
                
                //HStack to hold the push notifications enabled display
                HStack {
                    Text("Push Notifications Enabled?")
                        .frame(alignment: .leading)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(reminder?.pushNotificationsEnabled.description ?? "")")
                        .foregroundStyle(Color("MXBlue"))
                        .frame(alignment: .trailing)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(GroupedListStyle())
            
            Spacer()
        }
        //Custom back button that will dismiss the current view when pressed
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
}

#Preview {
    ReminderDetailsView()
}
