# Resourceror

This tool will generate static variables as extensions to the common AppKit types that accepted typed names, i.e.:

```swift
// Resourceror outputs the following, which you can add to your project:
extension NSImage.Name {
    static let backgroundImage = NSImage.Name(rawValue: "background-image")
}

// Which means you can now do the following:
let backgroundImage = NSImage(named: .backgroundImage)
```

Neato!

Resourceror currently supports extension `NSImage.Name`, `NSNib.Name`, `NSStoryboard.Name`, `NSStoryboard.SceneIdentifier`, `NSStoryboardSegue.Identifier` `NSUserInterfaceItemIdentifier`. Feel free to submit PRs for anything else you'd like to see generated.

It's not quite finished, but you should be able to use it. The project lacks tests,  the code is not polished, and everything needs a bit of work - it meets my needs, and it might be useful to you.

## Usage

Basically, you run this command against a directory containing your images, XIBs, and Storyboards, and it will print a nicely sorted list of properly typed Swift static variables for your resources.

```sh
swift run -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.11" Resourceror generate $PATH_TO_YOUR_DIRECTORY --exclude first_directory,second_directory
```

## Notes

If you use SwiftLint, you'll probably need to surround the output code with commands to disable some checks, like so:

```swift
// swiftlint:disable file_length
// swiftlint:disable identifier_name

extension NSImage.Name {
	// …
}

extension NSNib.Name {
	// …
}

extension NSStoryboard.Name {
	// …
}

extension NSStoryboard.SceneIdentifier {
	// …
}

extension NSStoryboardSegue.Identifier {
	// …
}

extension NSUserInterfaceItemIdentifier {
	// …
}

// swiftlint:enable identifier_name
// swiftlint:enable file_length
```
