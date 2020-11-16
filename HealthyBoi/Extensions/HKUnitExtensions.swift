//
//  HKUnitExtensions.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 15/11/2020.
//

import Foundation
import HealthKit

extension HKUnit {

  static func countsPerMinute() -> HKUnit {
    return HKUnit.count().unitDivided(by: HKUnit.minute())
  }
}
