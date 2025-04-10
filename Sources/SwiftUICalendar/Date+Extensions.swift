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

    /// Checks if the given date is in the same year and month as this date
    /// - Parameter date: The date to compare with
    /// - Returns: true if the dates are in the same year and month, false otherwise
    func isInSameYearMonth(_ date: Date) -> Bool {
        self.startOfMonth == date.startOfMonth
    }

    // MARK: - Standalone Symbol
    /// Defines the display style for month and weekday symbols
    enum SymbolStyle {
        case full
        case short
        case veryShort
    }

    /// Returns the month name in the specified style
    /// - Parameter style: The display style for the month name
    /// - Returns: The month name as a string
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
    /// - Parameter style: The display style for the weekday name
    /// - Returns: The weekday name as a string
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

    // MARK: - for WeekRow
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

    // MARK: - for WeekList
    /// Returns the number of weeks in the month containing this date
    var weeksInMonth: Int {
        Calendar.current.range(of: .weekOfMonth, in: .month, for: self)!.count
    }

    // MARK: - for CalendarList
    /// Returns an array of dates representing months around this date
    /// - Parameter bufferSize: The number of months to include before and after the current month
    /// - Returns: An array of dates representing the first day of each month
    func monthsAround(bufferSize: Int) -> [Date] {
        (-bufferSize...bufferSize).compactMap { month in
            Calendar.current.date(byAdding: .month, value: month, to: self)
        }
    }
}
