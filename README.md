# swiftui-calendar 📆

Build your own calendars with SwiftUI.

[![Swift Version](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Requirements 🔧

All versions listed are minimum required (or later versions).

| Platform | Version |
| -------- | ------- |
| Swift    | 6.1     |
| iOS      | 17.0    |
| macOS    | 14.0    |
| tvOS     | 17.0    |
| watchOS  | 10.0    |
| visionOS | 1.0     |

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

## Example 📝

### ScrollableCalendar

![Simulator Screen Recording - iPhone 16 Pro - 2025-04-11 at 14 59 30](https://github.com/user-attachments/assets/7e6f6272-57be-46d9-a867-348374704067)

<details>
<summary>code</summary>

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

### PagedCalendar

![Simulator Screen Recording - iPhone 16 Pro - 2025-04-11 at 14 56 57](https://github.com/user-attachments/assets/671b7f39-63b4-4491-a5ad-ddc6738c5d81)

<details>
<summary>code</summary>

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

## API Reference 📚

### Date+Extensions

A collection of Date extensions that provide useful helper methods for working with dates in calendar views.

<details>
<summary>Implementation</summary>

```swift
import Foundation

public extension Date {
    /// Returns the numeric year value of this date
    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    /// Returns the numeric month value of this date
    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    /// Returns the numeric day value of this date
    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    /// Returns the numeric weekday value of this date
    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }

    /// Returns the numeric week of the month value of this date
    var weekOfMonth: Int {
        Calendar.current.component(.weekOfMonth, from: self)
    }

    /// Returns whether the date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Returns whether the date falls on a weekend
    var isWeekend: Bool {
        Calendar.current.isDateInWeekend(self)
    }

    /// Returns the first day of the month containing this date
    var startOfMonth: Date {
        Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    /// Returns the first day of the week containing this date
    var startOfWeek: Date {
        Calendar.current.date(
            from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    /// Returns an array of dates representing all days in the week containing this date
    var weekDates: [Date] {
        let startDate = self.startOfWeek
        let totalDays = Calendar.current.weekdaySymbols.count

        return (0..<totalDays).compactMap { day in
            Calendar.current.date(byAdding: .day, value: day, to: startDate)
        }
    }

    /// Returns the number of weeks in the month containing this date
    var weeksInMonth: Int {
        Calendar.current.range(of: .weekOfMonth, in: .month, for: self)!.count
    }

    /// Checks if the given date is in the same year and month as this date
    func isInSameYearMonth(_ date: Date) -> Bool {
        self.startOfMonth == date.startOfMonth
    }

    /// Returns an array of dates representing months around this date
    func monthsAround(bufferSize: Int) -> [Date] {
        (-bufferSize...bufferSize).compactMap { month in
            Calendar.current.date(byAdding: .month, value: month, to: self)
        }
    }

    /// Defines the display style for month and weekday symbols
    enum SymbolStyle {
        case full
        case short
        case veryShort
    }

    /// Returns the month name in the specified style
    func monthSymbol(_ style: SymbolStyle) -> String {
        switch style {
        case .full:
            Calendar.current.standaloneMonthSymbols[self.month - 1]
        case .short:
            Calendar.current.shortStandaloneMonthSymbols[self.month - 1]
        case .veryShort:
            Calendar.current.veryShortStandaloneMonthSymbols[self.month - 1]
        }
    }

    /// Returns the weekday name in the specified style
    func weekdaySymbol(_ style: SymbolStyle) -> String {
        switch style {
        case .full:
            Calendar.current.standaloneWeekdaySymbols[self.weekday - 1]
        case .short:
            Calendar.current.shortStandaloneWeekdaySymbols[self.weekday - 1]
        case .veryShort:
            Calendar.current.veryShortStandaloneWeekdaySymbols[self.weekday - 1]
        }
    }
}
```

</details>

<details>
<summary>Usage</summary>

```swift
// Get the month name
let monthName = Date().monthSymbol(.full) // "January", "February", etc.

// Get the weekday name
let weekdayName = Date().weekdaySymbol(.short) // "Mon", "Tue", etc.

// Check if a date is today
let isToday = Date().isToday // true or false

// Check if a date is on a weekend
let isWeekend = Date().isWeekend // true or false

// Get the start of the month
let firstDayOfMonth = Date().startOfMonth

// Get all dates in the current week
let weekDates = Date().weekDates // Array of 7 dates

// Get the number of weeks in the current month
let weekCount = Date().weeksInMonth // Usually 4, 5, or 6

// Check if two dates are in the same year and month
let isSameMonth = Date().isInSameYearMonth(anotherDate) // true or false

// Get a range of months around the current date
let monthsAround = Date().monthsAround(bufferSize: 3) // 7 dates, representing 7 months
```

</details>

### ScrollableCalendarList

A vertically scrollable infinite calendar view with automatic month detection and smooth scrolling.

<details>
<summary>Implementation</summary>

```swift
import SwiftUI

public struct ScrollableCalendarList<Content>: View where Content: View {
    @Binding var selectedYearMonth: Date
    let content: (_ yearMonth: Date) -> Content

    @State private var yearMonths: [Date] = []
    @State private var isInitialRendering = true

    public init(
        selectedYearMonth: Binding<Date>,
        @ViewBuilder content: @escaping (_ yearMonth: Date) -> Content
    ) {
        self._selectedYearMonth = selectedYearMonth
        self.content = content
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(yearMonths, id: \.startOfMonth) { yearMonth in
                    content(yearMonth)
                        .onAppear {
                            appendMonthsIfNeeded(for: yearMonth)
                            if isInitialRendering, yearMonth.isInSameYearMonth(selectedYearMonth) {
                                isInitialRendering = false
                            }
                        }
                }
            }
            .scrollTargetLayout()
        }
        .defaultScrollAnchor(.center)
        .scrollPosition(id: isInitialRendering ? initialScrolledID : scrolledID, anchor: .center)
        .onAppear {
            loadMonthsIfNeeded()
        }
        .onChange(of: selectedYearMonth) {
            loadMonthsIfNeeded()
        }
        .onDisappear {
            isInitialRendering = true
            yearMonths.removeAll()
        }
    }

    // MARK: - Private Methods
    private var scrolledID: Binding<Date?> {
        Binding {
            selectedYearMonth.startOfMonth
        } set: { newValue in
            if let newValue {
                selectedYearMonth = newValue
            }
        }
    }

    private var initialScrolledID: Binding<Date?> {
        Binding(get: { nil }, set: { _ in })
    }

    private func loadMonthsIfNeeded() {
        let bufferSize = 10
        let isCurrentMonthLoaded = yearMonths.contains { $0.isInSameYearMonth(selectedYearMonth) }

        guard !isCurrentMonthLoaded else { return }

        yearMonths = selectedYearMonth.monthsAround(bufferSize: bufferSize)
    }

    private func appendMonthsIfNeeded(for yearMonth: Date) {
        if yearMonths.first == yearMonth,
            let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: yearMonth)
        {
            yearMonths.insert(previousMonth, at: 0)
        }

        if yearMonths.last == yearMonth,
            let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: yearMonth)
        {
            yearMonths.append(nextMonth)
        }
    }
}
```

</details>

<details>
<summary>Usage</summary>

```swift
import SwiftUI
import SwiftUICalendar

struct MyCalendarView: View {
    @State private var selectedMonth = Date()

    var body: some View {
        ScrollableCalendarList(selectedYearMonth: $selectedMonth) { yearMonth in
            VStack {
                // Month header
                Text(yearMonth.formatted(.dateTime.year().month()))
                    .font(.headline)

                // Calendar content for this month
                WeekList(yearMonth: yearMonth) { date in
                    Text(date.day, format: .number)
                        .padding(8)
                        .background(date.isToday ? Color.blue : Color.clear)
                        .foregroundStyle(date.isToday ? .white : .primary)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
    }
}
```

</details>

### PagedCalendarList

A horizontally paginated calendar view that lets users swipe between months.

<details>
<summary>Implementation</summary>

```swift
import SwiftUI

public struct PagedCalendarList<Content>: View where Content: View {
    @Binding var selectedYearMonth: Date
    let content: (_ yearMonth: Date) -> Content

    @State private var yearMonths: [Date] = []
    @State private var isInitialRendering = true

    public init(
        selectedYearMonth: Binding<Date>,
        @ViewBuilder content: @escaping (_ yearMonth: Date) -> Content
    ) {
        self._selectedYearMonth = selectedYearMonth
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(yearMonths, id: \.startOfMonth) { yearMonth in
                        content(yearMonth)
                            .onAppear {
                                appendMonthsIfNeeded(for: yearMonth)
                                if isInitialRendering,
                                    yearMonth.isInSameYearMonth(selectedYearMonth)
                                {
                                    isInitialRendering = false
                                }
                            }
                            .frame(width: geometry.size.width)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .defaultScrollAnchor(.center)
            .scrollPosition(
                id: isInitialRendering ? initialScrolledID : scrolledID, anchor: .center
            )
            .onAppear {
                loadMonthsIfNeeded()
            }
            .onChange(of: selectedYearMonth) {
                loadMonthsIfNeeded()
            }
            .onDisappear {
                isInitialRendering = true
                yearMonths.removeAll()
            }
        }
    }

    // Private methods omitted for brevity (same logic as ScrollableCalendarList)
}
```

</details>

<details>
<summary>Usage</summary>

```swift
import SwiftUI
import SwiftUICalendar

struct MyPagedCalendarView: View {
    @State private var selectedMonth = Date()

    var body: some View {
        PagedCalendarList(selectedYearMonth: $selectedMonth) { yearMonth in
            VStack {
                // Month header
                Text(yearMonth.formatted(.dateTime.year().month()))
                    .font(.headline)

                // Weekday row
                WeekRow { date in
                    Text(date.weekdaySymbol(.veryShort))
                        .font(.caption)
                }

                // Calendar content for this month
                WeekList(yearMonth: yearMonth) { date in
                    Text(date.day, format: .number)
                        .frame(height: 40)
                        .foregroundStyle(date.isInSameYearMonth(yearMonth) ? .primary : .secondary)
                }
            }
            .padding()
        }
    }
}
```

</details>

### WeekList

A view that displays all weeks in a month, with customizable day cells.

<details>
<summary>Implementation</summary>

```swift
import SwiftUI

public struct WeekList<Content>: View where Content: View {
    let yearMonth: Date
    let content: (_ date: Date) -> Content

    public init(
        yearMonth: Date,
        @ViewBuilder content: @escaping (_ date: Date) -> Content
    ) {
        self.yearMonth = yearMonth
        self.content = content
    }

    public var body: some View {
        VStack {
            ForEach(weeksInCurrentMonth(), id: \.self) { startOfWeek in
                WeekRow(date: startOfWeek) { date in
                    content(date)
                }
            }
        }
    }

    // MARK: - Private Methods
    private func weeksInCurrentMonth() -> [Date] {
        (0..<yearMonth.weeksInMonth).compactMap { weekIndex in
            Calendar.current.date(
                byAdding: .weekOfMonth,
                value: weekIndex,
                to: yearMonth.startOfMonth
            )
        }
    }
}
```

</details>

<details>
<summary>Usage</summary>

```swift
import SwiftUI
import SwiftUICalendar

struct MonthView: View {
    let month = Date() // Current month

    var body: some View {
        VStack {
            // Month header
            Text(month.monthSymbol(.full))
                .font(.headline)

            // Week days header
            WeekRow { date in
                Text(date.weekdaySymbol(.veryShort))
                    .font(.caption)
            }

            // Calendar grid
            WeekList(yearMonth: month) { date in
                Text(date.day, format: .number)
                    .padding(8)
                    .background(date.isToday ? Color.blue : Color.clear)
                    .foregroundStyle(
                        date.isInSameYearMonth(month)
                            ? (date.isToday ? .white : .primary)
                            : .secondary
                    )
                    .clipShape(Circle())
            }
        }
    }
}
```

</details>

### WeekRow

A horizontal row of seven days, perfect for weekday headers or a single week view.

<details>
<summary>Implementation</summary>

```swift
import SwiftUI

public struct WeekRow<Content>: View where Content: View {
    let date: Date
    let content: (_ date: Date) -> Content

    public init(
        date: Date = Date.now,
        @ViewBuilder content: @escaping (_ date: Date) -> Content
    ) {
        self.date = date
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(date.weekDates, id: \.self) { weekDate in
                content(weekDate)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
```

</details>

<details>
<summary>Usage</summary>

```swift
import SwiftUI
import SwiftUICalendar

struct WeekdayHeaderView: View {
    var body: some View {
        WeekRow { date in
            Text(date.weekdaySymbol(.short))
                .font(.caption)
                .foregroundStyle(date.isWeekend ? .secondary : .primary)
        }
    }
}

struct WeekView: View {
    let weekStart = Date().startOfWeek

    var body: some View {
        WeekRow(date: weekStart) { date in
            VStack {
                Text(date.day, format: .number)
                    .font(.title3)

                Text(date.weekdaySymbol(.veryShort))
                    .font(.caption)

                // Indicator for today
                if date.isToday {
                    Circle()
                        .fill(.blue)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(8)
            .background(date.isToday ? Color.blue.opacity(0.1) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
```

</details>

## License 📄

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Support and Contribution 🤝

If you find a bug or have a feature request, please open an issue. Pull requests are welcome!

---

Made with ❤️ in Swift
