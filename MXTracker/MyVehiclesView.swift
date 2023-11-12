//
//  MyVehiclesView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import SwiftUI

struct MyVehiclesView: View {
    @ObservedObject var vehicleVM = VehicleViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    //Main view that displays the UI elements and handles the logic for those elements
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
            Text("My Vehicles")
                .font(.system(size: 48))
                .foregroundStyle(Color("MXPurple"))
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
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
                        
                        //Create a navigationlink for each vehicle that will go to the VehicleDetailsView when clicked
                        NavigationLink(destination: VehicleDetailsView(vehicle: vehicle)) {
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
        vehicleVM.fetchVehicles() // Refresh the list
    }

}

#Preview {
    MyVehiclesView()
}
