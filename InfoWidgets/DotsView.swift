//  Created by Dominik Hauser on 16.04.23.
//  
//


import SwiftUI

struct DotsView: View {

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
    GeometryReader { geometryProxy in
      LazyVGrid(columns: spoonColumns, spacing: 2) {
        ForEach(0..<numberOfSpoons, id: \.self, content: { index in
          Image(systemName: imageName(for: index))
            .frame(height: geometryProxy.size.height / CGFloat(numberOfRows))
        })
        .accessibilityHidden(true)
      }
      }
      .containerBackground(for: .widget) {
        Color(UIColor.systemBackground)
      }
      .ignoresSafeArea()
  }

  private func imageName(for index: Int) -> String {
    if index < day.completedSpoons() {
      return "circle.slash"
    } else if index < day.plannedSpoons() {
      return "circle"
    } else if index < day.plannedSpoons() + day.completedSpoonSources() {
      return "circle.slash.fill"
    } else {
      return "circle.fill"
    }
  }
}
