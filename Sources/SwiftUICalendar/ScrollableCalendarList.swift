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

#Preview {
    @Previewable @State var selectedYearMonth: Date = Date.now

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
