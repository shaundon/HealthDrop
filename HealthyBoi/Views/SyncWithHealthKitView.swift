//
//  SyncWithHealthKitView.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 15/11/2020.
//

import SwiftUI
import HealthKit

struct SyncWithHealthKitView: View {
  @Binding var healthKitStatus: HKAuthorizationRequestStatus?

  let healthKitUtils = HealthKitUtilities()

  @State private var inProgress = false

  var body: some View {
    VStack(spacing: 20) {
      Text("\(Image(systemName: "heart.fill")) HealthDrop")
        .font(.system(.largeTitle, design: .rounded))
        .fontWeight(.bold)
        .padding()
        .foregroundColor(.accentColor)
        .cornerRadius(12.0)
      Text("HealthDrop is a utility for adding workouts to your iPhone's Apple Health database.")
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .padding(.bottom)
      Text("To get started, connect to Apple Health.").font(.headline)
      Button(action: {
        inProgress = true
        healthKitUtils.requestHealthKitAccess { status in
          healthKitStatus = status
          inProgress = false
        }
      }) {
        if inProgress {
          ProgressView().progressViewStyle(CircularProgressViewStyle())
        } else {
          Text("Connect to Apple Health")
        }
      }
      .buttonStyle(.borderedProminent)
      .buttonBorderShape(.capsule)
    }
  }
}

struct SyncWithHealthKitView_Previews: PreviewProvider {
  static var previews: some View {
    SyncWithHealthKitView(
      healthKitStatus: .constant(HKAuthorizationRequestStatus.shouldRequest))
  }
}
