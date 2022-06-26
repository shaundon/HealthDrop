//
//  HKUnitExtensions.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 15/11/2020.
//

import Foundation
import HealthKit

extension HKUnit {
  
  static func from(string: String) -> HKUnit {
    switch string {
    case "kcal": return .kilocalorie()
    case "kj": return .jouleUnit(with: .kilo)
    case "km": return .meterUnit(with: .kilo)
    case "mi": return .mile()
    default: fatalError("Must be 'kcal', 'kj', 'km' or 'mi')")
    }
  }

  static func countsPerMinute() -> HKUnit {
    return HKUnit.count().unitDivided(by: HKUnit.minute())
  }
  
}
