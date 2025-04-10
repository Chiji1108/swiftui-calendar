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
