//  Created by Dominik Hauser on 04.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


import WidgetKit

class WidgetContentLoader: NSObject {
  @objc public static func reloadWidgetContent() {
    WidgetCenter.shared.reloadAllTimelines()
  }
}
