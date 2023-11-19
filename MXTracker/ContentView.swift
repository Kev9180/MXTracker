//
//  ContentView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import SwiftUI
import CoreData

//ContentView is the driver view for the program
struct ContentView: View {
    @ObservedObject var locationDataManager : LocationDataManager
    @ObservedObject var vehicleVM = VehicleViewModel()

    //Main view that displays the UI elements and handles the logic for those elements
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                //Image logo
                Image(systemName: "wrench.and.screwdriver.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Spacer()
                
                //Screen title
                Text("MXTracker")
                    .font(.system(size: 48))
                    .foregroundStyle(Color("MXPurple"))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                Spacer()
                
                //HStack to hold the My Vehicles and Maintenance Log buttons
                HStack {
                    Spacer()
                    
                    //VStack to hold the My Vehicles text and button
                    VStack {
                        Text("My Vehicles")
                            .foregroundStyle(Color.red)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        //My Vehicles button
                        NavigationLink {
                            MyVehiclesView(vehicleVM: vehicleVM)
                        } label: {
                            ZStack {
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 5)
                                    .frame(width: 125, height: 125)
                                    .cornerRadius(3.0)
                                
                                Image(systemName: "car")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    //VStack to hold the MX Log text and button
                    VStack {
                        Text("MX Log")
                            .foregroundStyle(Color("MXBlue"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        //MX Log button
                        NavigationLink {
                            MXLogView(vehicleVM: vehicleVM)
                        } label: {
                            ZStack {
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 5)
                                    .frame(width: 125, height: 125)
                                    .cornerRadius(3.0)
                                
                                Image(systemName: "pencil.and.list.clipboard.rtl")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color("MXBlue"))
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                //HStack to hold the bottom two buttons (Reminders and Parts Stores)
                HStack {
                    Spacer()
                    
                    //VStack to hold the Reminders text and button
                    VStack {
                        Text("Reminders")
                            .foregroundStyle(Color("MXOrange"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        //Reminders button
                        NavigationLink {
                            MyRemindersView(vehicleVM: vehicleVM)
                        } label: {
                            ZStack {
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 5)
                                    .frame(width: 125, height: 125)
                                    .cornerRadius(3.0)
                                
                                Image(systemName: "bell.badge")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color("MXOrange"))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    //VStack to hold the Parts Stores text and button
                    VStack {
                        Text("Map")
                            .foregroundStyle(Color("MXGreen"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        //Parts Stores button
                        NavigationLink {
                            MapSearchView()
                        } label: {
                            ZStack {
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 5)
                                    .frame(width: 125, height: 125)
                                    .cornerRadius(3.0)
                                
                                Image(systemName: "location.magnifyingglass")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color("MXGreen"))
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView(locationDataManager: LocationDataManager()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
