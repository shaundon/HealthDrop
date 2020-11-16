//
//  HealthKitUtilities.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 15/11/2020.
//

import Foundation
import HealthKit

struct HealthKitUtilities {

  let sharePermissions =  Set([
    HKObjectType.workoutType(),
    HKSeriesType.workoutRoute(),
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
  ])
  let readPermissions: Set<HKSampleType> = Set([])

  let healthStore = HKHealthStore()

  func getAuthStatus(onComplete: @escaping (HKAuthorizationRequestStatus) -> Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
      onComplete(HKAuthorizationRequestStatus.unknown)
      return
    }

    healthStore.getRequestStatusForAuthorization(toShare: sharePermissions, read: readPermissions) { status, errorOrNil in
      onComplete(status)
    }
  }

  func requestHealthKitAccess(onComplete: @escaping (HKAuthorizationRequestStatus) -> Void) {
    healthStore.requestAuthorization(toShare: sharePermissions, read: readPermissions) { (granted, errorOrNil) in
      if let error = errorOrNil {
        print("Error requesting health kit access: \(error.localizedDescription)")
        onComplete(HKAuthorizationRequestStatus.unknown)
      } else {
        onComplete(HKAuthorizationRequestStatus.unnecessary)
      }
    }
  }

  private func generateHeartRateSamples(startDate: Date, endDate: Date) -> [HKSample] {
    var samples = [HKSample]()
    var intermediateDate = startDate
    while intermediateDate < endDate {
      let sample = HKQuantitySample(
        type: HKObjectType.quantityType(forIdentifier: .heartRate)!,
        quantity: HKQuantity(unit: .countsPerMinute(), doubleValue: Double(Int.random(in: 72...180))),
        start: intermediateDate,
        end: intermediateDate
      )
      samples.append(sample)
      intermediateDate = intermediateDate.addingTimeInterval(5)
    }
    return samples
  }

  func saveWorkoutToStore(
    activityType: HKWorkoutActivityType,
    start: Date,
    end: Date,
    duration: TimeInterval,
    totalEnergyBurned: HKQuantity?,
    totalDistance: HKQuantity?,
    includeHeartRate: Bool,
    onComplete: @escaping (Bool, Error?) -> Void) {

    let workout = HKWorkout(
      activityType: activityType,
      start: start,
      end: end,
      duration: duration,
      totalEnergyBurned: totalEnergyBurned,
      totalDistance: totalDistance,
      device: nil,
      metadata: nil
    )

    healthStore.save(workout) { success, errorOrNil in
      if let error = errorOrNil {
        print(error.localizedDescription)
      }

      if success {
        if includeHeartRate {
          healthStore.add(generateHeartRateSamples(startDate: start, endDate: end), to: workout) { (success, errorOrNil) in
            if let error = errorOrNil {
              print(error.localizedDescription)
            }
          }
        }
      }

      onComplete(success, errorOrNil)
    }
  }
}
