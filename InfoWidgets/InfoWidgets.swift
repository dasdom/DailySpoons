//  Created by Dominik Hauser on 04.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> DayEntry {
    DayEntry(date: Date(), day: DDHDay())
  }

  func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
    let entry = DayEntry(date: Date(), day: DDHDay())
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

    let dataStore = DDHDataStore()
    let day = dataStore.day

    let entries = [DayEntry(date: Date(), day: day)]

    let timeline = Timeline(entries: entries, policy: .never)
    completion(timeline)
  }
}

struct DayEntry: TimelineEntry {
  let date: Date
  let day: DDHDay
}

struct InfoWidgetsEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    BudgetView(day: entry.day)
  }
}

struct InfoWidgets: Widget {
  let kind: String = "InfoWidgets"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      InfoWidgetsEntryView(entry: entry)
    }
    .configurationDisplayName("Spoon Budget")
    .description("This widget shows your current spoon buget.")
  }
}

struct InfoWidgets_Previews: PreviewProvider {
  static var previews: some View {
    InfoWidgetsEntryView(entry: DayEntry(date: Date(), day: DDHDay()))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
