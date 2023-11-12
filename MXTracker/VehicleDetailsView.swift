//
//  VehicleDetailsView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import SwiftUI

struct VehicleDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    var vehicle: UserVehicle?

    var body: some View {
        VStack {
            Spacer()
            
            //Image logo
            Image(systemName: "car")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(Color.red)
            
            Spacer()
            
            //Screen title
            Text("Vehicle Details")
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
            
            //Display the vehicle details
            VStack {
                Divider()
                HStack {
                    Text("Year:")
                        .padding(.leading)
                    Spacer()
                    Text("\(vehicle?.year ?? "")")
                        .padding(.trailing)
                }
                Divider()
                HStack {
                    Text("Make:")
                        .padding(.leading)
                    Spacer()
                    Text("\(vehicle?.make ?? "")")
                        .padding(.trailing)
                }
                Divider()
                HStack {
                    Text("Model:")
                        .padding(.leading)
                    Spacer()
                    Text("\(vehicle?.model ?? "")")
                        .padding(.trailing)
                }
                Divider()
                HStack {
                    Text("Trim:")
                        .padding(.leading)
                    Spacer()
                    Text("\(vehicle?.trim ?? "")")
                        .padding(.trailing)
                }
                Divider()
                HStack {
                    Text("Engine Displacement (L):")
                        .padding(.leading)
                    Spacer()
                    if let displacement = vehicle?.displacement {
                        let formattedDisplacement = String(format: "%.1f", displacement)
                        Text(formattedDisplacement)
                            .padding(.trailing)
                    } else {
                        Text("Error")
                            .padding(.trailing)
                    }
                }
                Divider()
                HStack {
                    Text("Cylinders:")
                        .padding(.leading)
                    Spacer()
                    Text("\(vehicle?.cylinders ?? 0)")
                        .padding(.trailing)
                }
                Divider()
                HStack {
                    Text("Drive:")
                        .padding(.leading)
                    Spacer()
                    Text("\(vehicle?.drive ?? "")")
                        .padding(.trailing)
                }
                Divider()
            }
            
            Spacer()
            
            //View Maintenance Log Button
            NavigationLink {
                
                //Take the user to the mx log for this vehicle
                MXLogVehicleView(vehicle: vehicle)
                
            } label: {
                HStack {
                    Image(systemName: "pencil.and.list.clipboard.rtl")
                    Text("View MX Log")
                }
            } //Format the button's appearance
            .frame(width: 250, height: 30)
            .padding()
            .font(.title)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .background(LinearGradient(gradient: Gradient(colors: [Color("MXPurple"), Color.purple]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: Color("MXPurple"), radius: 5, y: 5)
            
            Spacer()
            
            //View Reminders Button
            NavigationLink {
                //Take the user to the reminders for this vehicle
                
                //***TODO*** still need to implement reminders functionality
                
            } label: {
                HStack {
                    Image(systemName: "bell.badge")
                    Text("View Reminders")
                }
            } //Format the button's appearance
            .frame(width: 250, height: 30)
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
}

#Preview {
    VehicleDetailsView()
}
