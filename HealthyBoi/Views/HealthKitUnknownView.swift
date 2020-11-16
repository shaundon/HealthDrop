//
//  HealthKitUnknownView.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 15/11/2020.
//

import SwiftUI

struct HealthKitUnknownView: View {
  var body: some View {
    VStack(spacing: 15) {
      Text("Couldn't connect to Apple Health").font(.headline)
      Text("Apple Health is only available on iPhone.")
    }
  }
}

struct HealthKitUnknownView_Previews: PreviewProvider {
  static var previews: some View {
    HealthKitUnknownView()
  }
}
