//
//  AddNewVehicleView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import SwiftUI

struct AddNewVehicleView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vehicleVM: VehicleViewModel
    @State private var selectedYear: String? = nil
    @State private var selectedMake: String? = nil
    @State private var selectedModel: String? = nil
    @State private var selectedTrim: String? = nil
    @State private var selectedDisplacement: Double? = nil
    @State private var selectedCylinders: Int? = nil
    @State private var selectedDrive: String? = nil
    
    var vehicleModel = VehicleModel()
    
    //Define a string array for the vehicle year dropdown
    let years = (1950...2023).map { "\($0)" }.reversed()
    
    //Define an array of vehicle makes for the user to choose from. Makes array is only applicable in this view, so defining here instead of in VehicleViewModel
    let makes = ["AMC","Acura","Alfa Romeo","Aston Martin","Audi","BMW","Bentley","Bugatti", "Buick", "Cadillac", "Chevrolet", "Chrysler", "Daewoo", "Datsun", "DeLorean", "Dodge", "Eagle", "FIAT", "Ferrari", "Fisker", "Ford", "Freightliner", "GMC", "Genesis", "Geo", "HUMMER", "Honda", "Hyundai", "Infiniti", "Isuzu", "Jaguar", "Jeep", "Karma", "Kia", "Lamborghini", "Land Rover", "Lexus", "Lincoln", "Lotus", "Lucid", "Mazda", "MINI", "Maserati", "Maybach", "McLaren", "Mercedes-Benz", "Mercury", "Mitsubishi", "Nissan", "Oldsmobile", "Plymouth", "Polestar", "Pontiac", "Porsche", "RAM", "Rivian", "Rolls-Royce", "SRT", "Saab", "Saturn", "Scion", "Smart", "Subaru", "Suzuki", "Tesla", "Toyota", "Volkswagen", "Volvo", "Yugo"]
    
    //Define arrays for cylinder options and drive options
    var cylinderOptions = [1,2,3,4,5,6,8,10,12]
    var driveOptions = ["FWD", "RWD", "AWD", "4WD"]
    
    //Number formatter for the displacement field
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    //Main view that displays all the UI elements
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
            Text("Add Vehicle")
                .font(.system(size: 48))
                .foregroundStyle(Color("MXPurple"))
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
            Spacer()
            
            //Form to collect vehicle specific information to add a new vehicle to the list
            Form {
                //Year picker
                Picker("Year", selection: $selectedYear) {
                    Text("Select a Year").tag(nil as String?)
                    ForEach(years, id: \.self) { year in
                        Text(year).tag(year as String?)
                    }
                }

                //Make picker
                Picker("Make", selection: $selectedMake) {
                    Text("Select a Make").tag(nil as String?)
                    ForEach(makes, id: \.self) { make in
                        Text(make).tag(make as String?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .disabled(selectedYear == nil)

                //Model picker
                Picker("Model", selection: $selectedModel) {
                    Text("Select a Model").tag(nil as String?)
                    ForEach(vehicleVM.modelResults, id: \.self) { model in
                        Text(model).tag(model as String?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .disabled(selectedMake == nil || vehicleVM.modelResults.isEmpty)

                //Trim field
                HStack {
                    Text("Trim")
                    Spacer()
                    TextField("Trim", text: Binding($selectedTrim, updateNilValueWith: ""))
                        .textFieldStyle(.roundedBorder)
                        .frame(width:150)
                        .multilineTextAlignment(.trailing)
                        .disabled(selectedModel == nil)
                }

                //Displacement field
                HStack {
                    Text("Displacement")
                    Spacer()
                    TextField("Displacement", value: $selectedDisplacement.numberOrNil, formatter: numberFormatter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                        .multilineTextAlignment(.trailing)
                        .disabled(selectedTrim == nil)
                }

                //Cylinders Picker
                Picker("Cylinders:", selection: Binding($selectedCylinders, updateNilValueWith: cylinderOptions.first ?? 1)) {
                    ForEach(cylinderOptions, id: \.self) { cylinder in
                        Text("\(cylinder)").tag(cylinder)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .disabled(selectedDisplacement == nil)

                //Drive Picker
                Picker("Drive:", selection: Binding($selectedDrive, updateNilValueWith: driveOptions.first ?? "")) {
                    ForEach(driveOptions, id: \.self) { drive in
                        Text(drive).tag(drive)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .disabled(selectedCylinders == nil)
            }
            //On change of selectedMake, make the API call to get the applicable models for the year and make that are selected
            .onChange(of: selectedMake) {
                if selectedYear != nil && selectedMake != nil {
                    vehicleVM.analyze(makeStr: selectedMake!, yearStr: selectedYear!)
                }
            }
            .scrollContentBackground(.hidden)

            //Add New Vehicle Button
            Button {
                //Add the new vehicle to the list
                
                //Create a new UserVehicle entity from the provided information
                let vehicle = vehicleModel.addNewVehicle(
                    year: selectedYear!,
                    make: selectedMake!,
                    model: selectedModel!,
                    trim: selectedTrim!,
                    displacement: selectedDisplacement!,
                    cylinders: selectedCylinders!,
                    drive: selectedDrive!
                )
                
                //Add the vehicle to the list of user vehicles
                vehicleVM.vehiclesList.append(vehicle)
                
                //Dismiss the screen and take the user back to the MyVehiclesView
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Vehicle")
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
            .disabled(selectedYear == nil || selectedMake == nil || selectedModel == nil || selectedTrim == nil || selectedDisplacement == nil || selectedCylinders == nil || selectedDrive == nil)
            
            Spacer()
        }
    }
    
    //Helper function to get the list of available models for a given vehicle year and make. Only applicable in AddNewVehicleView so is declared here instead of in VehicleViewModel
    func getModels(year: String, make: String) {
        vehicleVM.analyze(makeStr: make, yearStr: year)
    }
}

struct AddNewVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        let vehicleVM = VehicleViewModel()
        AddNewVehicleView(vehicleVM: vehicleVM)
    }
}
