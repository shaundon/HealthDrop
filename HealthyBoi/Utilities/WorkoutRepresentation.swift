//
//  WorkoutRepresentation.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 26/06/2022.
//

import Foundation

struct WorkoutRepresentation: Decodable {
  let activityType: UInt
  let duration: Double?
  let startDate: Date
  let endDate: Date
  let indoors: Bool?
  let device: WorkoutRepresentationDeviceDetails?
  let totalDistance: Double?
  let totalEnergyBurned: Double?
  let elevationAscended: Double?
  let weatherHumidity: Double?
  let weatherTemperature: Double?
  let swimmingData: WorkoutRepresentationSwimmingData?
  let locationData: [WorkoutRepresentationLocationData]?
  let heartRateSamples: [WorkoutRepresentationHeartRateData]?
  let quantitySamples: [WorkoutRepresentationQuantitySampleData]? //
  let workoutEvents: [WorkoutRepresentationWorkoutEventData]? //
}

struct WorkoutRepresentationDeviceDetails: Decodable {
  let model: String?
  let firmwareVersion: String?
  let hardwareVersion: String?
  let manufacturer: String?
  let softwareVersion: String?
  let name: String?
}

struct WorkoutRepresentationSwimmingData: Decodable {
  let poolLength: Double?
  let totalStrokeCount: Double?
  let locationType: Int?
}

struct WorkoutRepresentationLocationData: Decodable {
  let latitude: Double
  let longitude: Double
  let altitude: Double
  let timestamp: Date
}

struct WorkoutRepresentationHeartRateData: Decodable {
  let startDate: Date
  let endDate: Date
  let quantity: Double
}

struct WorkoutRepresentationQuantitySampleData: Decodable {
  let startDate: Date
  let endDate: Date
  let quantity: Double
}

struct WorkoutRepresentationWorkoutEventData: Decodable {
  let type: Int
  let start: Date
  let end: Date
  let duration: Double
}
