//
//  HKWorkoutActivityTypeExtensions.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 14/11/2020.
//
// Inspired by https://github.com/georgegreenoflondon/HKWorkoutActivityType-Descriptions/blob/master/HKWorkoutActivityType%2BDescriptions.swift

import Foundation
import HealthKit

extension HKWorkoutActivityType {

  static var allTypes: [HKWorkoutActivityType] {
    return [
      .americanFootball,
      .archery,
      .australianFootball,
      .badminton,
      .barre,
      .baseball,
      .basketball,
      .bowling,
      .boxing,
      .climbing,
      .coreTraining,
      .crossCountrySkiing,
      .crossTraining,
      .curling,
      .cycling,
      .discSports,
      .downhillSkiing,
      .elliptical,
      .equestrianSports,
      .fencing,
      .fishing,
      .fitnessGaming,
      .flexibility,
      .functionalStrengthTraining,
      .golf,
      .gymnastics,
      .handball,
      .handCycling,
      .highIntensityIntervalTraining,
      .hiking,
      .hockey,
      .hunting,
      .jumpRope,
      .kickboxing,
      .lacrosse,
      .martialArts,
      .mindAndBody,
      .mixedCardio,
      .paddleSports,
      .pilates,
      .play,
      .preparationAndRecovery,
      .racquetball,
      .rowing,
      .rugby,
      .running,
      .sailing,
      .skatingSports,
      .snowboarding,
      .snowSports,
      .soccer,
      .softball,
      .squash,
      .stairClimbing,
      .stairs,
      .stepTraining,
      .surfingSports,
      .swimming,
      .tableTennis,
      .taiChi,
      .tennis,
      .trackAndField,
      .traditionalStrengthTraining,
      .volleyball,
      .walking,
      .waterFitness,
      .waterPolo,
      .waterSports,
      .wheelchairRunPace,
      .wheelchairWalkPace,
      .wrestling,
      .yoga
    ]
  }

  /*
   Simple mapping of available workout types to a human readable name.
   */
  var name: String {
    switch self {
    case .americanFootball:             return "American Football"
    case .archery:                      return "Archery"
    case .australianFootball:           return "Australian Football"
    case .badminton:                    return "Badminton"
    case .baseball:                     return "Baseball"
    case .basketball:                   return "Basketball"
    case .bowling:                      return "Bowling"
    case .boxing:                       return "Boxing"
    case .cardioDance:                  return "Cardio Dance"
    case .climbing:                     return "Climbing"
    case .crossTraining:                return "Cross Training"
    case .curling:                      return "Curling"
    case .cycling:                      return "Cycling"
    case .socialDance:                  return "Social Dance"
    case .elliptical:                   return "Elliptical"
    case .equestrianSports:             return "Equestrian Sports"
    case .fencing:                      return "Fencing"
    case .fishing:                      return "Fishing"
    case .functionalStrengthTraining:   return "Functional Strength Training"
    case .golf:                         return "Golf"
    case .gymnastics:                   return "Gymnastics"
    case .handball:                     return "Handball"
    case .hiking:                       return "Hiking"
    case .hockey:                       return "Hockey"
    case .hunting:                      return "Hunting"
    case .lacrosse:                     return "Lacrosse"
    case .martialArts:                  return "Martial Arts"
    case .mindAndBody:                  return "Mind and Body"
    case .mixedCardio:                  return "Mixed Cardio"
    case .paddleSports:                 return "Paddle Sports"
    case .play:                         return "Play"
    case .preparationAndRecovery:       return "Preparation and Recovery"
    case .racquetball:                  return "Racquetball"
    case .rowing:                       return "Rowing"
    case .rugby:                        return "Rugby"
    case .running:                      return "Running"
    case .sailing:                      return "Sailing"
    case .skatingSports:                return "Skating Sports"
    case .snowSports:                   return "Snow Sports"
    case .soccer:                       return "Soccer"
    case .softball:                     return "Softball"
    case .squash:                       return "Squash"
    case .stairClimbing:                return "Stair Climbing"
    case .surfingSports:                return "Surfing Sports"
    case .swimming:                     return "Swimming"
    case .tableTennis:                  return "Table Tennis"
    case .tennis:                       return "Tennis"
    case .trackAndField:                return "Track and Field"
    case .traditionalStrengthTraining:  return "Traditional Strength Training"
    case .volleyball:                   return "Volleyball"
    case .walking:                      return "Walking"
    case .waterFitness:                 return "Water Fitness"
    case .waterPolo:                    return "Water Polo"
    case .waterSports:                  return "Water Sports"
    case .wrestling:                    return "Wrestling"
    case .yoga:                         return "Yoga"
    case .barre:                        return "Barre"
    case .coreTraining:                 return "Core Training"
    case .crossCountrySkiing:           return "Cross Country Skiing"
    case .downhillSkiing:               return "Downhill Skiing"
    case .flexibility:                  return "Flexibility"
    case .highIntensityIntervalTraining: return "High Intensity Interval Training"
    case .jumpRope:                     return "Jump Rope"
    case .kickboxing:                   return "Kickboxing"
    case .pilates:                      return "Pilates"
    case .snowboarding:                 return "Snowboarding"
    case .stairs:                       return "Stairs"
    case .stepTraining:                 return "Step Training"
    case .wheelchairWalkPace:           return "Wheelchair Walk Pace"
    case .wheelchairRunPace:            return "Wheelchair Run Pace"
    case .taiChi:                       return "Tai Chi"
    case .handCycling:                  return "Hand Cycling"
    case .discSports:                   return "Disc Sports"
    case .fitnessGaming:                return "Fitness Gaming"
    default:                            return "Other"
    }
  }
}
