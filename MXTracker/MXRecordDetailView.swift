//
//  MXRecordDetailView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 11/11/23.
//

import SwiftUI

struct MXRecordDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var vehicle: UserVehicle?
    @State var record: MaintenanceRecord?
    
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
            
            //Display the vehicle header information for the current vehicle
            Text("\(vehicle?.year ?? "") \(vehicle?.make ?? "") \(vehicle?.model ?? "")")
                .font(.system(size: 28))
                .foregroundStyle(Color.black)
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
            Spacer()
            
            //Screen instruction prompt
            Text("Record for \(record?.dateCompleted ?? "") - \(record?.logTitle ?? "")")
                .font(.system(size: 24))
                .foregroundStyle(Color.black)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .padding(.leading)
                .padding(.trailing)
            
            Spacer()
            
            //Display the vehicle details
            List {
                
                //HStack to hold the date completed display
                HStack {
                    Text("Date Completed:")
                        .frame(alignment: .leading)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(record?.dateCompleted ?? "")")
                        .foregroundStyle(Color("MXBlue"))
                        .frame(alignment: .trailing)
                }
                
                //HStack to hold the mileage completed display
                HStack {
                    Text("Mileage Completed:")
                        .frame(alignment: .leading)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(record?.mileageCompleted ?? 0)")
                        .foregroundStyle(Color("MXBlue"))
                        .frame(alignment: .trailing)
                }
                
                //HStack to hold the service interval display
                HStack {
                    Text("Service Interval:")
                        .frame(alignment: .leading)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(record?.serviceInterval ?? "")")
                        .foregroundStyle(Color("MXBlue"))
                        .frame(alignment: .trailing)
                }
                
                //HStack to hold the work performed display
                HStack {
                    Text("Work Performed:")
                        .frame(alignment: .topLeading)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(record?.workPerformed ?? "")")
                        .foregroundStyle(Color("MXBlue"))
                        .frame(width: 200, alignment: .topTrailing)
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
    MXRecordDetailView()
}
