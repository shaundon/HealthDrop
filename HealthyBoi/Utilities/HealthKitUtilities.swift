//
//  HealthKitUtilities.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 15/11/2020.
//

import Foundation
import HealthKit
import CoreLocation

struct HealthKitUtilities {

  let sharePermissions =  Set([
    HKObjectType.workoutType(),
    HKSeriesType.workoutRoute(),
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!,
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming)!,
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWheelchair)!,
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceDownhillSnowSports)!
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
  
  func workoutRepresentation(fromJsonData jsonData: Data) -> WorkoutRepresentation {
    
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    do {
      return try decoder.decode(WorkoutRepresentation.self, from: jsonData)
    }
    catch let error {
      fatalError(error.localizedDescription)
    }
  }
  
  func addToStore(workoutRepresentation: WorkoutRepresentation) {
    
    // Energy.
    var energyBurned: HKQuantity? = nil
    if let energy = workoutRepresentation.totalEnergyBurned {
      energyBurned = HKQuantity(unit: .kilocalorie(), doubleValue: energy)
    }
    
    // Distance.
    var totalDistance: HKQuantity? = nil
    if let distance = workoutRepresentation.totalDistance {
      totalDistance = HKQuantity(unit: .meterUnit(with: .kilo), doubleValue: distance)
    }
    
    // Swimming stroke count.
    var swimmingStrokeCount: HKQuantity? = nil
    if let strokeCount = workoutRepresentation.swimmingData?.totalStrokeCount {
      swimmingStrokeCount = HKQuantity(unit: .count(), doubleValue: strokeCount)
    }
    
    // Device.
    var device: HKDevice? = nil
    if let workoutDevice = workoutRepresentation.device {
      device = HKDevice(
        name: workoutDevice.name,
        manufacturer: workoutDevice.manufacturer,
        model: workoutDevice.model,
        hardwareVersion: workoutDevice.hardwareVersion,
        firmwareVersion: workoutDevice.firmwareVersion,
        softwareVersion: workoutDevice.softwareVersion,
        localIdentifier: nil,
        udiDeviceIdentifier: nil
      )
    }
    
    // Workout events.
    var events: [HKWorkoutEvent]? = nil
    if let workoutEvents = workoutRepresentation.workoutEvents {
      events = [HKWorkoutEvent]()
      for workoutEvent in workoutEvents {
        events?.append(
          HKWorkoutEvent(
            type: HKWorkoutEventType(rawValue: workoutEvent.type)!,
            dateInterval: DateInterval(
              start: workoutEvent.start,
              end: workoutEvent.end
            ),
            metadata: nil
          ))
      }
    }
    
    // Metadata.
    var metadata = [String: Any]()
    if let indoors = workoutRepresentation.indoors {
      metadata[HKMetadataKeyIndoorWorkout] = indoors
    }
    if let weatherHumidity = workoutRepresentation.weatherHumidity {
      metadata[HKMetadataKeyWeatherHumidity] = HKQuantity(unit: .percent(), doubleValue: weatherHumidity)
    }
    if let weatherTemperature = workoutRepresentation.weatherTemperature {
      metadata[HKMetadataKeyWeatherTemperature] = HKQuantity(unit: .degreeCelsius(), doubleValue: weatherTemperature)
    }
    if let elevationAscended = workoutRepresentation.elevationAscended {
      metadata[HKMetadataKeyElevationAscended] = HKQuantity(unit: .meter(), doubleValue: elevationAscended)
    }
    
    // TODO this causes a crash right now because
    // "Open water swimming should not have lap length"
    // Get it working later.
    
//    if let poolLength = workoutRepresentation.swimmingData?.poolLength {
//      metadata[HKMetadataKeyLapLength] = HKQuantity(unit: .meter(), doubleValue: poolLength)
//    }
//    if let swimmingLocationType = workoutRepresentation.swimmingData?.locationType {
//      metadata[HKMetadataKeySwimmingLocationType] = HKWorkoutSwimmingLocationType(rawValue: swimmingLocationType)!
//    }
    
    
    let workout = HKWorkout(
      activityType: HKWorkoutActivityType(rawValue: workoutRepresentation.activityType)!,
      start: workoutRepresentation.startDate,
      end: workoutRepresentation.endDate,
      workoutEvents: events,
      totalEnergyBurned: energyBurned,
      totalDistance: totalDistance,
      totalSwimmingStrokeCount: swimmingStrokeCount,
      device: device,
      metadata: metadata
    )
    
    healthStore.save(workout) { success, errorOrNil in
      if let error = errorOrNil {
        print(error.localizedDescription)
      }
      
      if success {
        
        // Add heart rate samples.
        if let heartRateSamples = workoutRepresentation.heartRateSamples,
           !heartRateSamples.isEmpty {
          var samplesToSave = [HKSample]()
          for heartRateSample in heartRateSamples {
            samplesToSave.append(HKQuantitySample(
              type: HKObjectType.quantityType(forIdentifier: .heartRate)!,
              quantity: HKQuantity(unit: .countsPerMinute(), doubleValue: heartRateSample.quantity),
              start: heartRateSample.startDate,
              end: heartRateSample.endDate
            ))
          }
          healthStore.add(samplesToSave, to: workout) { success, errorOrNil in
            if let error = errorOrNil {
              print(error.localizedDescription)
            }
            if success {
              print("saved heart rate samples")
            }
          }
        }
        
        // Add quantity samples.
        if let quantitySamples = workoutRepresentation.quantitySamples,
           !quantitySamples.isEmpty {
          var samplesToSave = [HKSample]()
          for quantitySample in quantitySamples {
            samplesToSave.append(
              HKQuantitySample(
                type: HKObjectType.quantityType(forIdentifier: workout.workoutActivityType.quantityTypeIdentifier!)!,
                quantity: HKQuantity(unit: .meter(), doubleValue: quantitySample.quantity),
                start: quantitySample.startDate,
                end: quantitySample.endDate
              )
            )
          }
          healthStore.add(samplesToSave, to: workout) { success, errorOrNil in
            if let error = errorOrNil {
              print(error.localizedDescription)
            }
            if success {
              print("saved quantity samples")
            }
          }
        }
        
        // Add location data.
        if let locationData = workoutRepresentation.locationData,
           !locationData.isEmpty {
          let routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
          var locations = [CLLocation]()
          for locationSample in locationData {
            locations.append(
              CLLocation(
                coordinate: CLLocationCoordinate2D(
                  latitude: locationSample.latitude,
                  longitude: locationSample.longitude
                ),
                altitude: CLLocationDistance(locationSample.altitude),
                horizontalAccuracy: CLLocationAccuracy.zero,
                verticalAccuracy: CLLocationAccuracy.zero,
                timestamp: locationSample.timestamp
              )
            )
          } // for
          routeBuilder.insertRouteData(locations) { success, errorOrNil in
            if let error = errorOrNil {
              print(error.localizedDescription)
            }
            if success {
              routeBuilder.finishRoute(with: workout, metadata: nil) { routeOrNil, errorOrNil in
                if let error = errorOrNil {
                  print(error.localizedDescription)
                }
                if routeOrNil != nil {
                  print("Saved workout route")
                }
              }
            }
          }
        }
        
      } // success
    }
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
