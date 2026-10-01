# ZenApplication

Reusable tools and architecture components for Swift applications: persistent file references, list models, property wrappers, asynchronous operations, version comparison, and diagnostics. Distributed as a static library through Swift Package Manager.

## Requirements

- Swift tools version **5.10** or later; the package uses Swift 5 language mode.
- Platform minimums declared in `Package.swift`: **iOS 15**, **macOS 10.15**, **tvOS 15**, and **watchOS 6**.
- Dependency: [ZenSwift](https://github.com/roland19deschain/ZenSwift) **2.1.15** or later within the 2.x series.

The current target includes an unconditional UIKit import in `ApplicationNavigator`. The declared platform minimums do not establish compatibility with every listed platform; in particular, the complete target cannot currently be compiled for macOS or watchOS without changes to the UIKit-dependent sources. `FrameTracker` also uses UIKit and is excluded only on macOS.

## Installation

In Xcode, add the package URL through **File → Add Package Dependencies** and select the `ZenApplication` product:

```text
https://github.com/roland19deschain/ZenApplication.git
```

For a Swift package, add the dependency to `Package.swift`:

```swift
.package(
    url: "https://github.com/roland19deschain/ZenApplication.git",
    from: "2.15.0"
)
```

Then add the product to your target's dependencies:

```swift
.product(
    name: "ZenApplication",
    package: "ZenApplication"
)
```

Import the module where needed:

```swift
import ZenApplication
```

## Components

| Area | API | Purpose |
| --- | --- | --- |
| Local files | `LocalFilePath`, `LocalFilePathError` | Persist a root and relative path, resolve a URL for the current sandbox, and check file existence asynchronously. |
| Versions | `ApplicationVersionComparator` | Compare dot-separated numeric version components without integer overflow. |
| Lists | `ListViewModel`, `GroupedListViewModel`, `GroupedListSectionProtocol` | Store list data, iterate over items or sections, and access elements through optional subscripts. |
| Preferences | `@UserDefaultsStorage` | Store values in `UserDefaults.standard` and expose a Combine publisher. |
| Synchronization | `@ThreadSafe`, `Dispatcher` | Protect individual value accesses or explicit mutations with a lock, and execute a block once per token or live object. |
| Operations | `AsyncOperation<Value, Progress>` | Base class for asynchronous `Operation` subclasses with progress and result callbacks. |
| Formatting | `FriendlyNumberFormatter` | Abbreviate integer values using `K`, `M`, `G`, `T`, `P`, and `E` suffixes. |
| Navigation | `ApplicationNavigator`, `PresentationStyle` | Open application settings on the main actor and represent push or modal presentation. |
| Models | `ApplicationError`, `UserType`, `FeedbackEmailModel` | Common errors, user categories, and feedback email data. |
| Combine | `AnyPublisher.init(error:)` | Create an immediately failing publisher from an `ApplicationError` when `Failure == Error`. |
| Diagnostics | `ExecutionTimeAuditor`, `MemoryPressureMonitor`, `FrameTracker` | Measure synchronous execution time and print memory-pressure or dropped-frame diagnostics. |

## Usage

### Persistent file references

Store a relative reference instead of an absolute sandbox URL:

```swift
import Foundation
import ZenApplication

let file = LocalFilePath(
    root: .documents,
    relativePath: "audio/narration.m4a"
)

let storedValue = file.persistedString // "documents:audio/narration.m4a"
let restoredFile = try LocalFilePath(persistedString: storedValue)
let url = try restoredFile.url
let exists = await restoredFile.fileExists
```

Available roots are `.documents`, `.caches`, `.applicationSupport`, and `.bundle`. Resolving a URL does not create a file or its parent directories. Bundle resolution throws when the resource is missing. Relative paths are normalized by removing leading slashes, collapsing repeated separators, and dropping `.` and `..` segments.

### Application versions

```swift
import ZenApplication

let comparator = ApplicationVersionComparator()

let updateAvailable = comparator.compare(
    "1.9.0",
    "1.10.0"
) == .orderedAscending

let sameVersion = comparator.compare(
    "1.2",
    "1.2.0"
) == .orderedSame
```

Missing or empty components count as zero, leading zeroes are ignored, and only the leading decimal digits of each component participate in comparison. For example, `1.2-beta` equals `1.2`. This comparator does not implement Semantic Versioning prerelease precedence.

### List models

```swift
import ZenApplication

let items: ListViewModel<String> = ["First", "Second"]

let firstItem = items[0] // Optional("First")
let missingItem = items[10] // nil

for item in items {
    print(item)
}
```

For sectioned data, make your section model conform to `GroupedListSectionProtocol` and initialize `GroupedListViewModel(sections:)`. It supports section access by `Int`, item access by a two-component `IndexPath`, item and section counts, and searches for a matching section or item.

### User defaults

```swift
import ZenApplication

struct Preferences {
    @UserDefaultsStorage(key: "soundEnabled")
    var soundEnabled: Bool = true
}

var preferences = Preferences()
preferences.soundEnabled = false
```

Use `preferences.$soundEnabled.publisher` to receive the initial value and subsequent writes through that wrapper. `isDefault` reports whether the key is absent. Optional properties can use `@UserDefaultsStorage(key:)` without an initial value; assigning `nil` removes the stored key. Values must be supported by `UserDefaults`; the wrapper does not encode arbitrary `Codable` models or observe writes made through other wrappers or direct `UserDefaults` calls.

### Synchronized mutations

```swift
import ZenApplication

struct Counter {
    @ThreadSafe var value: Int = 0

    mutating func increment() {
        _value.mutate { value in
            value += 1
        }
    }
}
```

`@ThreadSafe` locks each getter and setter separately. Use `mutate` for a read-modify-write operation that must hold the lock for the entire closure.

### Asynchronous operations and diagnostics

- Subclass `AsyncOperation<Value, Progress>`, override `main()`, and complete the operation with `finish(_:)` using a value or error. Send progress with `notify(progress:)`. Callbacks run on the configured queue, which defaults to `.main`; its initializer label is `responceQueue` in the current API.
- `ExecutionTimeAuditor().evaluate(of:)` returns the average duration in seconds for a synchronous closure. Use a positive `iterations` value and `reducePrinting: false` to print timing details.
- Retain a `MemoryPressureMonitor` or `FrameTracker`, call `start()` to begin monitoring, and call `stop()` when finished. Stopping cancels the memory-pressure source or invalidates the display link; create a new monitor or tracker to start another session.

## Repository layout and tests

`Sources/` contains the library, grouped by responsibility. `Tests/` currently contains XCTest coverage for `ApplicationVersionComparator`, including numeric ordering, missing and empty components, leading zeroes, suffixes, and components larger than `Int.max`.

For local development, open `Package.swift` in Xcode and run the `ZenApplicationTests` tests with an iOS Simulator destination. UIKit-dependent sources prevent using a plain macOS `swift test` invocation for the complete target as currently written.

## License

ZenApplication is available under the [MIT License](LICENSE).
