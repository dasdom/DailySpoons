//  Created by Dominik Hauser on 07.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//

import WidgetKit

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> DayEntry {
    DayEntry(date: Date(), day: DDHDay())
  }

  func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
    let entry = DayEntry(date: Date(),
                         day: DDHDay(amountOfSpoons: 12,
                                     plannedActions: [
                                      DDHAction(name: "a", spoons: 4),
                                      DDHAction(name: "b", spoons: 2),
                                      DDHAction(name: "c", spoons: 1)
                                     ], completedActions: [
                                      DDHAction(name: "a", spoons: 4)
                                     ]))
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
