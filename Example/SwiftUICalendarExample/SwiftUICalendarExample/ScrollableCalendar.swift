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
