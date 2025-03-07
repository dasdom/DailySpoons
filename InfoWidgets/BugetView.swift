//  Created by Dominik Hauser on 16.04.23.
//  
//


import SwiftUI

struct BudgetView: View {

  let day: DDHDay
  let numberOfColumns: Int
  private var spoonColumns: [GridItem] {
    Array(repeatElement(GridItem(), count: numberOfColumns))
  }
  private var numberOfSpoons: Int {
    return day.amountOfSpoons - day.carryOverSpoons
  }
  private var numberOfRows: Int {
    return Int(ceil(CGFloat(numberOfSpoons) / CGFloat(spoonColumns.count)))
  }

  var body: some View {
//    VStack(spacing: 10) {
    GeometryReader { geometryProxy in
      LazyVGrid(columns: spoonColumns, spacing: 2) {
        ForEach(0..<numberOfSpoons,
                id: \.self, content: { index in
          if index < day.completedSpoons() {
            Image(systemName: "circle.slash")
          } else if index < day.plannedSpoons() {
            Image(systemName: "circle")
              .frame(height: geometryProxy.size.height / CGFloat(numberOfRows))
          } else if index < day.plannedSpoons() + day.completedSpoonSources() {
            Image(systemName: "circle.slash.fill")
          } else {
            Image(systemName: "circle.fill")
              .frame(height: geometryProxy.size.height / CGFloat(numberOfRows))
          }
        })
        //      }
        .accessibilityHidden(true)
      }
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
      .containerBackground(for: .widget) {
        Color(UIColor.systemBackground)
      }
      .ignoresSafeArea()
//    .padding()
//    .background {
//      Color(UIColor.systemGray4)
//    }
//    .cornerRadius(20)
  }
}
