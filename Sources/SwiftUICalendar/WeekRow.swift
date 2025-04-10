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

#Preview {
    WeekRow { date in
        Text(date.day, format: .number)
    }
}

#Preview("Weekday Symbols", traits: .sizeThatFitsLayout) {
    WeekRow { date in
        Text(date.weekdaySymbol(.veryShort))
            .font(.system(size: 12, weight: .light))
    }
}

#Preview("YearMonth Symbol", traits: .sizeThatFitsLayout) {
    let yearMonth = Date.now

    WeekRow { date in
        if date.weekday == yearMonth.startOfMonth.weekday {
            VStack {
                Text(yearMonth.formatted(.dateTime.year()))
                    .font(.system(size: 12, weight: .bold))
                Text(yearMonth.formatted(.dateTime.month()))
                    .font(.system(size: 24, weight: .bold))
            }
        } else {
            Spacer()
        }
    }
}
