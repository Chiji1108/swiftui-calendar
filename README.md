# SwiftUICalendar 📆

SwiftUICalendar is a beautiful and high-performance calendar component library built with SwiftUI. It supports all platforms including iOS, macOS, tvOS, watchOS, and visionOS.

[![Swift Version](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-lightgrey.svg)](https://developer.apple.com)

![Calendar Preview](https://via.placeholder.com/800x400?text=SwiftUICalendar)

## Features ✨

- 🔄 Scrollable calendar view
- 📱 Paged calendar view
- 🎨 Highly customizable design
- 📊 Week and month view support
- 🔍 Easy date selection and manipulation
- 📈 Performance-optimized layout
- 🌓 Dark mode support

## Installation 💻

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/swiftui-calendar.git", from: "1.0.0")
]
```

## Usage 📝

### ScrollableCalendarList

To display a scrollable calendar list:

```swift
@State var selectedYearMonth: Date = Date.now

ScrollableCalendarList(selectedYearMonth: $selectedYearMonth) { yearMonth in
    VStack {
        // Month header
        Text(yearMonth.formatted(.dateTime.year().month()))
            .font(.headline)

        // Calendar content
        WeekList(yearMonth: yearMonth) { date in
            Text(date.day, format: .number)
                .frame(width: 32, height: 32)
                .foregroundStyle(date.isToday ? .white : .primary)
                .background(date.isToday ? Color.blue : Color.clear)
                .clipShape(Circle())
        }
    }
}
```

### PagedCalendarList

To display a paged calendar:

```swift
@State var selectedYearMonth: Date = Date.now

PagedCalendarList(selectedYearMonth: $selectedYearMonth) { yearMonth in
    VStack {
        // Month header
        Text(yearMonth.formatted(.dateTime.year().month()))
            .font(.headline)

        // Calendar content
        WeekList(yearMonth: yearMonth) { date in
            Text(date.day, format: .number)
                .frame(width: 32, height: 32)
        }
    }
}
```

## Requirements 🔧

- Swift 6.1 or later
- iOS 17.0 or later
- macOS 14.0 or later
- tvOS 17.0 or later
- watchOS 10.0 or later
- visionOS 1.0 or later

## License 📄

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Support and Contribution 🤝

If you find a bug or have a feature request, please open an issue. Pull requests are welcome!

---

Made with ❤️ in Swift
