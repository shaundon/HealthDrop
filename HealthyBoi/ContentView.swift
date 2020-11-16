//
//  ContentView.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 13/11/2020.
//

import SwiftUI
import HealthKit

struct ContentView: View {
  @State private var healthKitStatus: HKAuthorizationRequestStatus? = nil

  let healthKitUtils = HealthKitUtilities()

  var body: some View {

    NavigationView {

      switch healthKitStatus {

      case .shouldRequest:
        SyncWithHealthKitView(healthKitStatus: $healthKitStatus)

      case .unnecessary:
        AddDataView()

      case .unknown:
        HealthKitUnknownView()

      default:
        HealthKitUnknownView()

      }
    }
    .onAppear {
      healthKitUtils.getAuthStatus() { status in
        healthKitStatus = status
      }
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
