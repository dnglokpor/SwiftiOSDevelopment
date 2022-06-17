//
//  ContentView.swift
//  WeSplit
//
//  Created by Delwys Glokpor on 6/13/22.
//

import SwiftUI

// custom modifier

struct RedText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.red)
    }
}

struct ContentView: View {
    let tipPercentages = 0...100
    var currencyFormat: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currencyCode ?? "USD")
    }
    @State private var checkAmount = 0.0
    @FocusState private var amountIsFocused: Bool
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    var peopleCount: Double {
        return Double(numberOfPeople + 2)
    }
    var grandTotal: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        return checkAmount + tipValue
    }
    var totalPerPerson: Double {
        return grandTotal / peopleCount
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Total", value: $checkAmount, format: currencyFormat)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                Section {
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<99) {
                            Text("\($0) people")
                        }
                    }
                }
                Section {
                    Picker("Tip percentages", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                } header: {
                    Text("How much tip do you want to leave?")
                }
                Section {
                    if tipPercentage != 0 {
                        Text(grandTotal, format: currencyFormat)
                    } else {
                        Text(grandTotal, format: currencyFormat)
                            .modifier(RedText())
                    }
                } header: {
                    Text("Total including tip")
                }
                Section {
                    Text(totalPerPerson, format: currencyFormat)
                } header: {
                    Text("Amount per person")
                }
            }
                .navigationTitle("WeSplit")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            amountIsFocused = false
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
