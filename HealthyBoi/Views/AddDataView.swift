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
          Label("Add a workout manually", systemImage: "plus.circle.fill")
            .symbolRenderingMode(.multicolor)
        }
        NavigationLink(destination: JSONImportView()) {
          Label("Import workout from JSON", systemImage: "folder.badge.plus")
            .symbolRenderingMode(.multicolor)
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
