//
//  Copyright © 2017 Tony Arnold (@tonyarnold)
//  Licensed under the MIT license. See the LICENSE file for details.

import Foundation

enum ResultType: String, Hashable {
  case audio = "NSSound.Name"
  case image = "NSImage"
  case namedColor = "NSColor"
  case nibName = "NSNib"
  case storyboardName = "NSStoryboard"

  case storyboardSceneIdentifier = "NSStoryboard.SceneIdentifier"
  case storyboardSegueIdentifier = "NSStoryboardSegue.Identifier"
  case userInterfaceItemIdentifier = "NSUserInterfaceItemIdentifier"

  case browserColumnsAutosaveName = "NSBrowser.ColumnsAutosaveName"
  case searchFieldRecentsAutosaveName = "NSSearchField.RecentsAutosaveName"
  case splitViewAutosaveName = "NSSplitView.AutosaveName"
  case tableViewAutosaveName = "NSTableView.AutosaveName"
  case windowFrameAutosaveName = "NSWindow.FrameAutosaveName"

  func hash(into hasher: inout Hasher) { hasher.combine(rawValue) }

  static func == (lhs: ResultType, rhs: ResultType) -> Bool { return lhs.rawValue == rhs.rawValue }

  func outputLine(for fileName: String) -> String {
    let name = variableName(using: fileName)
    switch self {
    case .audio, .image, .namedColor: return "static let \(name) = \(rawValue)(named: \"\(fileName)\")!"
    case .nibName: return "static let \(name) = NSNib(nibNamed: \"\(fileName)\", bundle: .main)!"
    case .storyboardName: return "static let \(name) = NSStoryboard(name: \"\(fileName)\", bundle: .main)"
    case .userInterfaceItemIdentifier: return "static let \(name) = NSUserInterfaceItemIdentifier(rawValue: \"\(fileName)\")"
    default: return "static let \(name) = \"\(fileName)\""
    }
  }

  private func variableName(using fileName: String) -> String { return fileName.camelCased() }
}
