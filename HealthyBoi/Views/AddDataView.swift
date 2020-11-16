//
//  AddDataView.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 15/11/2020.
//

import SwiftUI

struct AddDataView: View {
    var body: some View {
      List {
        NavigationLink(destination: NewWorkoutView()) {
          HStack {
            Image(systemName: "figure.walk")
            Text("Add a workout")
          }
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("HealthDrop")
    }
}

struct AddDataView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
        AddDataView()
      }
    }
}
