//
//  ContentView.swift
//  BetterRest
//
//  Created by Delwys Glokpor on 6/16/22.
//

import CoreML
import SwiftUI

// UI
struct ContentView: View {
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeUpTime
    @State private var coffeeAmount = 0
    
    // alert popup
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    // button action
    func calculateBedtime() -> String {
        do {
            // config NN
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            // do prediction
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount + 1))
            // compute and return sleep time
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch { // something went wrong
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
            showingAlert = true
            return ""
        }
//        showingAlert = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Your ideal bedtime is..." )
                Text(calculateBedtime())
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Form {
                    Section {
                        Text("When do you want to wake up?")
                            .font(.headline)
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    Section {
                        Text("Desired amount of sleep")
                            .font(.headline)
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    
                    Section {
                        Text("Daily coffee intake")
                            .font(.headline)
                        Picker((coffeeAmount == 0 ? "cup" : "cups"), selection: $coffeeAmount) {
                            ForEach(0..<20) { cups in
                                Text("\(cups + 1)")
                            }
                        }
                    }
                }
                .navigationTitle("BetterRest")
    //            .toolbar {
    //                Text(bedtime)
    //                Button("Calculate", action: calculateBedtime)
    //            }
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK") {}
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
}

// preview UI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

