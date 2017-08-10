//
//  The MIT License (MIT)
//
//  Copyright © 2017 Tony Arnold (@tonyarnold)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Files
import Foundation
import Regex

final class StoryboardScanner: ResourceScanning {

    static let fileExtensions = ["storyboard"]

    static let ignoredTags = [
        "deployment",
        "plugIn"
    ]

    var filesToScan = [File]()

    func scan(file: File) -> Set<ScanResult> {
        // Open Storyboard, and scan for:
        guard let fileContents = try? file.readAsString() else {
            return []
        }

        var results = Set<ScanResult>()

        let fileResult = ScanResult(type: .storyboardName, identifier: file.nameExcludingExtension)
        results.insert(fileResult)

        type(of: self).storyboardIdentifierRegex.allMatches(in: fileContents).forEach { match in
            guard let identifier = match.captures[0] else { return }

            let newResult = ScanResult(type: .storyboardSceneIdentifier, identifier: identifier)
            results.insert(newResult)
        }

        type(of: self).identifierRegex.allMatches(in: fileContents).forEach { match in
            guard
                let tagName = match.captures[0],
                let identifier = match.captures[1],
                StoryboardScanner.ignoredTags.contains(tagName) == false
            else {
                return
            }

            let resultType: ResultType = tagName == "segue" ? .storyboardSegueIdentifier : .userInterfaceItemIdentifier
            let newResult = ScanResult(type: resultType, identifier: identifier)
            results.insert(newResult)
        }

        return results
    }

    private static let identifierRegex = Regex("<([A-Za-z0-9]+).* identifier=\"([^\"]+)\".*$", options: .anchorsMatchLines)
    private static let storyboardIdentifierRegex = Regex("<[windowController|viewController].* storyboardIdentifier=\"([^\"]+)\".*$", options: .anchorsMatchLines)
}
