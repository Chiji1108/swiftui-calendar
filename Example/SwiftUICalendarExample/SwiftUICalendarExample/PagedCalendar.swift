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
