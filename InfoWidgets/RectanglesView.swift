//  Created by Dominik Hauser on 07.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


import SwiftUI

struct RectanglesView: View {
  let day: DDHDay
  let numberOfColumns: Int
  private var spoonColumns: [GridItem] {
    Array(repeatElement(GridItem(spacing: 1), count: numberOfColumns))
  }
  private var numberOfSpoons: Int {
    return day.amountOfSpoons - day.carryOverSpoons
  }
  private var numberOfRows: Int {
    return Int(ceil(CGFloat(numberOfSpoons) / CGFloat(spoonColumns.count)))
  }

  var body: some View {
    GeometryReader { geometryProxy in
      LazyVGrid(columns: spoonColumns, spacing: 1) {
        ForEach(0..<numberOfSpoons, id: \.self, content: { index in
          color(for: index)
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

  private func color(for index: Int) -> Color {
    if index < day.completedSpoons() {
      return Color(UIColor.systemGray3)
    } else if index < day.plannedSpoons() {
      return Color(UIColor.systemGray5)
    } else if index < day.plannedSpoons() + day.completedSpoonSources() {
      return Color(UIColor.systemGray)
    } else {
      return Color(UIColor.label)
    }
  }
}
