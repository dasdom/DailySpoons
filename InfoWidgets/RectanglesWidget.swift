//  Created by Dominik Hauser on 07.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//

import WidgetKit
import SwiftUI

struct RectangleWidgetsEntryView : View {
  var entry: Provider.Entry
  @Environment(\.widgetFamily) var family

  var body: some View {
    RectanglesView(day: entry.day, numberOfColumns: family == .systemSmall ? 4 : 6)
  }
}

struct RectanglesWidget: Widget {
  let kind: String = "RectanglesWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      RectangleWidgetsEntryView(entry: entry)
    }
    .configurationDisplayName("Rectangles Widget")
    .description("This widget shows your current spoon buget.")
    .contentMarginsDisabled()
  }
}

