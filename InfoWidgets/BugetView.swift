//  Created by Dominik Hauser on 16.04.23.
//  
//


import SwiftUI

struct BudgetView: View {

  let day: DDHDay
  private let spoonColumns = [
    GridItem(), GridItem(), GridItem(), GridItem(), GridItem(), GridItem()
  ]

  var body: some View {
//    VStack(spacing: 10) {
      LazyVGrid(columns: spoonColumns, spacing: 16) {
        ForEach(0..<(day.amountOfSpoons - day.carryOverSpoons),
                id: \.self, content: { index in
          if index < day.completedSpoons() {
            Image(systemName: "circle.slash")
          } else if index < day.plannedSpoons() {
            Image(systemName: "circle")
          } else {
            Image(systemName: "circle.fill")
          }
        })
//      }
      .accessibilityHidden(true)

//      if day.carryOverSpoons > 0 {
//        VStack {
//          HStack {
//            Text("Planned")
//            Text("(\(day.plannedSpoons())-\(day.carryOverSpoons))/\(day.amountOfSpoons)")
//          }
//          HStack {
//            Text("Completed")
//            Text("(\(day.completedSpoons())-\(day.carryOverSpoons))/\(day.amountOfSpoons)")
//          }
//        }
//        .font(.subheadline)
//      } else {
//        VStack {
//          HStack {
//            Text("Planned")
//            Text("\(day.plannedSpoons())/\(day.amountOfSpoons)")
//              .monospaced()
//          }
//          HStack {
//            Text("Completed")
//            Text("\(day.completedSpoons())/\(day.amountOfSpoons)")
//              .monospaced()
//          }
//        }
//        .font(.subheadline)
//      }
    }
    .padding()
//    .background {
//      Color(UIColor.systemGray4)
//    }
//    .cornerRadius(20)
  }
}
