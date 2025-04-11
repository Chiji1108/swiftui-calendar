# swiftui-calendar 📆

Build your own calendars with SwiftUI.

[![Swift Version](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-lightgrey.svg)](https://developer.apple.com)

![Calendar Preview](https://via.placeholder.com/800x400?text=SwiftUICalendar)

## Requirements 🔧

- Swift 6.1 or later
- iOS 17.0 or later
- macOS 14.0 or later
- tvOS 17.0 or later
- watchOS 10.0 or later
- visionOS 1.0 or later

## Features ✨

- 🔄 Infinite scrolling support
- 🎨 Truly unlimited customization possibilities
- 📱 Support for both Vertical (pagination) and Horizontal (scrollable) layouts
- 🌍 Compatible with user-defined calendars beyond the Gregorian calendar
- 🗣️ Multi-language support based on user preferences
- 📅 Customizable week start day
- 🌓 Dark mode support
- 📊 Both Month View and Week View support
- 📈 High-performance design using modern APIs

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

<details>
<summary>To display a scrollable calendar list (click to expand):</summary>

```swift
import SwiftUI
import SwiftUICalendar

struct ScrollableCalendar: View {
    @Binding var selectedYearMonth: Date

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: Weekday Symbols
                WeekRow { date in
                    Text(date.weekdaySymbol(.veryShort))
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(date.isWeekend ? .secondary : .primary)
                }
                .background(.gray.opacity(0.1))

                Divider()

                ScrollableCalendarList(selectedYearMonth: $selectedYearMonth) { yearMonth in
                    VStack(spacing: 4) {
                        // MARK: YearMonth Symbol
                        WeekRow { date in
                            if date.weekday == yearMonth.startOfMonth.weekday {
                                VStack {
                                    Text(yearMonth.formatted(.dateTime.year()))
                                        .font(.system(size: 12, weight: .bold))
                                    Text(yearMonth.formatted(.dateTime.month()))
                                        .font(.system(size: 24, weight: .bold))
                                }
                                .foregroundStyle(
                                    yearMonth.isInSameYearMonth(Date.now) ? .accentColor : Color.primary
                                )
                            } else {
                                Spacer()
                            }
                        }

                        // MARK: Calendar Body
                        WeekList(yearMonth: yearMonth) { date in
                            VStack {
                                Divider()

                                ZStack {
                                    if date.isToday {
                                        Circle()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(.tint)
                                    }

                                    Text(date.day, format: .number)
                                        .font(.system(size: 12, weight: date.isToday ? .bold : .light))
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(
                                            date.isToday
                                                ? .white : date.isWeekend ? .secondary : .primary
                                        )

                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                            }
                            .frame(height: 96)
                            .opacity(date.isInSameYearMonth(yearMonth) ? 1 : 0)
                        }
                    }
                }
            }
            .navigationTitle(selectedYearMonth.monthSymbol(.full))
            .toolbar {
                if !selectedYearMonth.isInSameYearMonth(Date.now) {
                    Button("Today") {
                        withAnimation {
                            selectedYearMonth = Date.now
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedYearMonth = Date.now
    ScrollableCalendar(selectedYearMonth: $selectedYearMonth)
}
```

</details>

### PagedCalendarList

<details>
<summary>To display a paged calendar (click to expand):</summary>

```swift
import SwiftUI
import SwiftUICalendar

struct PagedCalendar: View {
    @Binding var selectedYearMonth: Date

    var body: some View {
        NavigationStack {
            PagedCalendarList(selectedYearMonth: $selectedYearMonth) { yearMonth in
                VStack(spacing: 0) {
                    // MARK: Weekday Symbols
                    WeekRow { date in
                        Text(date.weekdaySymbol(.veryShort))
                            .font(.system(size: 12, weight: .light))
                    }

                    // MARK: Calendar Body
                    WeekList(yearMonth: yearMonth) { date in
                        ZStack {
                            if date.isToday {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.gray.opacity(0.2))
                            }

                            Text(date.day, format: .number)
                                .padding(4)
                                .font(.system(size: 12, weight: .light))
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .frame(height: 80)
                        .opacity(date.isInSameYearMonth(yearMonth) ? 1 : 0.4)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 8)
            }
            .navigationTitle(selectedYearMonth.monthSymbol(.full))
            .toolbar {
                if !selectedYearMonth.isInSameYearMonth(Date.now) {
                    Button("Today") {
                        withAnimation {
                            selectedYearMonth = Date.now
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedYearMonth = Date.now
    PagedCalendar(selectedYearMonth: $selectedYearMonth)
}
```

</details>

## License 📄

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Support and Contribution 🤝

If you find a bug or have a feature request, please open an issue. Pull requests are welcome!

---

Made with ❤️ in Swift
