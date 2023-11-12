//
//  BindingExtension.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/22/23.
//

import Foundation
import SwiftUI

//Custom initializer that will work with the optional String bindings used in AddNewVehicleView since some values might be 'nil'. If the value is nil, it will be replaced with whatever 'defaultValue' is
extension Binding {
    init(_ source: Binding<Value?>, updateNilValueWith defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}

//Custom initializer that will handle the optional Double binding used in the engine displacement field in the AddNewVehicleView. If the value is nil, it will be replaced with a default value
extension Binding where Value == Double? {
    var numberOrNil: Binding<Double> {
        return Binding<Double>(
            get: { self.wrappedValue ?? 0 },
            set: { self.wrappedValue = $0 }
        )
    }
}


