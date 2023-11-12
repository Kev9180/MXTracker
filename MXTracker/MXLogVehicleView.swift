//
//  MXLogVehicleView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/20/23.
//

import SwiftUI

struct MXLogVehicleView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var vehicle: UserVehicle?
    @ObservedObject var recordVM = RecordViewModel()

    //Main view that handles the logic for displaying the UI elements for each vehicle's maintenance records
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
            
            //Display the vehicle header information for the current vehicle
            Text("\(vehicle?.year ?? "") \(vehicle?.make ?? "") \(vehicle?.model ?? "")")
                .font(.system(size: 28))
                .foregroundStyle(Color.black)
                .fontWeight(.bold)
                .fontDesign(.rounded)

            Spacer()
            
            //Display the records for this vehicle
            List {
                //Check if the vehicle has any maintenance records that have been added
                if let maintenanceRecords = vehicle?.maintenanceRecords as? Set<MaintenanceRecord>, !maintenanceRecords.isEmpty {
                    //Convert the set of records to an array and then display each of the records
                    ForEach(Array(maintenanceRecords), id: \.id) { record in
                        NavigationLink(destination: MXRecordDetailView()) {
                            HStack {
                                Text("\(record.dateCompleted ?? "")")
                                Spacer()
                                Text("\(record.logTitle ?? "")")
                            }
                        }
                    }
                    .onDelete(perform: deleteRecord)
                } else {
                    Text("No maintenance records found for this vehicle! Add one now to get started!")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.red)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .multilineTextAlignment(.center)
                        .offset(x:15)
                }
            }
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            //Add New Record Button
            NavigationLink {
                //Take the user to the AddNewMXRecordView
                AddNewMXRecordView(vehicle: $vehicle)
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add New Record")
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
    
    //Function that calculates the index of the vehicle and then calls the deleteVehicle function in VehicleViewModel to delete the vehicle
    func deleteRecord(at offsets: IndexSet) {
        if let maintenanceRecords = vehicle?.maintenanceRecords as? Set<MaintenanceRecord> {
            let recordsArray = Array(maintenanceRecords)

            for index in offsets {
                let recordToDelete = recordsArray[index]
                recordVM.deleteRecord(recordToDelete)
            }

            vehicle?.removeFromMaintenanceRecords(recordsArray[offsets.first!])
        }
    }

}

#Preview {
    MXLogVehicleView()
}
