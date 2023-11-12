//
//  MXLogView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/20/23.
//

import SwiftUI

struct MXLogView: View {
    @ObservedObject var vehicleVM: VehicleViewModel
    @Environment(\.presentationMode) var presentationMode
    
    //Main view that displays the UI elements and handles the logic for those elements
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
            Text("MX Log")
                .font(.system(size: 48))
                .foregroundStyle(Color("MXPurple"))
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
            Spacer()
            
            //Screen instruction prompt
            Text("Select a vehicle from your list to see its maintenance records")
                .font(.system(size: 24))
                .foregroundStyle(Color.black)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .padding(.leading)
                .padding(.trailing)
            
            Spacer()
            
            //Vehicles List
            List {
                
                if vehicleVM.vehiclesList.count == 0 {
                    Text("There are no vehicles in your list. Add one now to get started!")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.red)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .multilineTextAlignment(.center)
                } else {
                    //Iterate through each of the vehicles in the list
                    ForEach(vehicleVM.vehiclesList, id: \.id) {vehicle in
                        
                        //Create a navigationlink for each vehicle that will go to the MXLogVehicleView when clicked
                        NavigationLink(destination: MXLogVehicleView(vehicle: vehicle)) {
                            Text("\(vehicle.year ?? "Year") \(vehicle.make ?? "Make") \(vehicle.model ?? "Model")")
                        }
                    }
                    .onDelete(perform: deleteVehicle)
                }
            }
            .scrollContentBackground(.hidden)
            .onAppear{vehicleVM.fetchVehicles()}
            
            Spacer()
            
            //Add New Vehicle Button that will take the user to AddNewVehicleView
            NavigationLink {
                AddNewVehicleView(vehicleVM: vehicleVM)
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add New Vehicle")
                }
            } //Format the button's appearance
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
    
    //Function that calculates the index of the vehicle and then calls the deleteVehicle function in VehicleViewModel to delete the vehicle
    func deleteVehicle(at offsets: IndexSet) {
        for index in offsets {
            let vehicle = vehicleVM.vehiclesList[index]
            vehicleVM.deleteVehicle(vehicle)
        }
        vehicleVM.fetchVehicles()
    }
}

struct MXLogView_Previews: PreviewProvider {
    static var previews: some View {
        let vehicleVM = VehicleViewModel()
        MXLogView(vehicleVM: vehicleVM)
    }
}
