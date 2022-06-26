//
//  JSONImportView.swift
//  HealthyBoi
//
//  Created by Shaun Donnelly on 11/06/2022.
//

import SwiftUI
import FilePicker
import HealthKit

struct JSONImportView: View {
  @State private var jsonFileUrl: URL? = nil
  @State private var isProcessing = false
  
  let healthKitUtilities = HealthKitUtilities()
  
  func clearSelectedFile() {
    isProcessing = false
    jsonFileUrl = nil
  }
  
  func processSelectedFile() {
    isProcessing = true
    guard let jsonFileUrl = jsonFileUrl else {
      fatalError("No file selected")
    }
    do {
      let jsonData = try Data(contentsOf: jsonFileUrl)
      let workout = healthKitUtilities.workoutRepresentation(fromJsonData: jsonData)
      healthKitUtilities.addToStore(workoutRepresentation: workout)
      isProcessing = false
    }
    catch let error as NSError {
      fatalError("Error: \(error.localizedDescription)")
    }
  }
  
  var body: some View {
    Form {
      Section {
        Text("Import a workout from a JSON file to add it to Apple Health.\n\n")
      }
      .font(.callout)
      
      Section {
        if let jsonFileUrl = jsonFileUrl {
          Text("**Selected:** \(jsonFileUrl.lastPathComponent)")
          Button(action: clearSelectedFile) {
            Label("Clear selected file", systemImage: "xmark")
          }
        } else {
          FilePicker(types: [.json], allowMultiple: true) { urls in
            if let selectedFileUrl = urls.first {
              jsonFileUrl = selectedFileUrl
            }
          } label: {
            Label("Choose file", systemImage: "doc.badge.plus")
              .symbolRenderingMode(.multicolor)
          }

        }
      }
      
      if jsonFileUrl != nil {
        Section {
          Button(action: processSelectedFile) {
            Label("Process selected file", systemImage: "bolt.fill")
          }
          .disabled(isProcessing)
          if isProcessing {
            HStack {
              ProgressView()
                .progressViewStyle(.circular)
                .padding(.trailing)
              Text("Processing..")
            }
            .font(.subheadline)
          }
        }
      }
    }
    .navigationTitle("Import workouts")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct JSONImportView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      JSONImportView()
    }
  }
}
