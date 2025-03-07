//  Created by Dominik Hauser on 04.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


import WidgetKit
import SwiftUI

struct DotsWidgetsEntryView : View {
  var entry: Provider.Entry
  @Environment(\.widgetFamily) var family

  var body: some View {
    DotsView(day: entry.day, numberOfColumns: family == .systemSmall ? 4 : 6)
  }
}

struct DotsWidget: Widget {
  let kind: String = "DotsWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      DotsWidgetsEntryView(entry: entry)
    }
    .configurationDisplayName("Dots Widget")
    .description("This widget shows your current spoon buget.")
  }
}
