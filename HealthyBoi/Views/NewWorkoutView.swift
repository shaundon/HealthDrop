//
//  NewWorkoutView.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 13/11/2020.
//

import SwiftUI
import HealthKit

struct NewWorkoutView: View {

  @State private var workoutType: HKWorkoutActivityType = .running
  @State private var startDate = Date()
  @State private var endDate = Date()
  @State private var includeCalories = false
  @State private var calories: Double = 0
  @State private var includeDistance = false
  @State private var distance: Double = 0
  @State private var includeHeartRate = false

  @State private var inProgress = false
  @State private var isError = false
  @State private var errorMessage: String? = nil
  @State private var isSuccess = false

  let hkUtils = HealthKitUtilities()

  var body: some View {
    Form {

      Section(header: Text("\(Image(systemName: "bolt")) Workout type")) {
        Picker(
          selection: $workoutType,
          label: Text("Workout type")
        ) {
          ForEach(HKWorkoutActivityType.allTypes, id: \.rawValue) { activityType in
            Text("\(activityType.name)").tag(activityType)
          }
        }
      }

      Section(header: Text("\(Image(systemName: "clock")) Time and date")) {
        DatePicker(
          selection: $startDate,
          displayedComponents: [.date, .hourAndMinute],
          label: { Text("Start")}
        )
        DatePicker(
          selection: $endDate,
          displayedComponents: [.date, .hourAndMinute],
          label: { Text("End")}
        )
      }

      Section(header: Text("\(Image(systemName: "flame")) Calories")) {
        Toggle("Include calories", isOn: $includeCalories)
        if includeCalories {
          HStack {
            Slider(value: $calories, in: 0...2000, step: 50)
            Text("\(Int(calories)) kcal")
          }
        }
      }

      Section(header: Text("\(Image(systemName: "arrow.right.circle")) Distance")) {
        Toggle("Include distance", isOn: $includeDistance)
        if includeDistance {
          HStack {
            Slider(value: $distance, in: 0...100, step: 1)
            Text("\(Int(distance)) km")
          }
        }
      }

      Section(header: Text("\(Image(systemName: "heart")) Heart rate")) {
        Toggle("Include heart rate readings", isOn: $includeHeartRate)
        if includeHeartRate {
          Text("Random(ish) heart rate measurements will be added to your workout.").font(.caption)
        }
      }

    }
    .navigationTitle("New Workout")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(action: {
          inProgress = true
          hkUtils.saveWorkoutToStore(
            activityType: workoutType,
            start: startDate,
            end: endDate,
            duration: endDate.timeIntervalSince(startDate),
            totalEnergyBurned: includeCalories ? HKQuantity(unit: .kilocalorie(), doubleValue: calories) : nil,
            totalDistance: includeDistance ? HKQuantity(unit: .meterUnit(with: .kilo), doubleValue: distance): nil,
            includeHeartRate: includeHeartRate) { (success, errorOrNil) in
            if let error = errorOrNil {
              print(error.localizedDescription)
              errorMessage = error.localizedDescription
              isError = true
            } else {
              isSuccess = true
            }
            inProgress = false
          }
        }) {
          if inProgress {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
          } else {
            Text("Save")
          }
        }
      }
    }
    .alert(isPresented: $isError) {
      Alert(title: Text("Something went wrong"), message: Text(errorMessage!), dismissButton: .default(Text("Ok")))
    }
    .alert(isPresented: $isSuccess) {
      Alert(title: Text("Workout saved"), message: Text("You can view it in the Health app."), dismissButton: .default(Text("Ok")))
    }
  }
}

struct NewWorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      NewWorkoutView()
    }
  }
}

/*
 Heart rate
 Location
 */
