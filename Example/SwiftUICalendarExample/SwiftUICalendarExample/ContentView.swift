//
//  ContentView.swift
//  SwiftUICalendarExample
//
//  Created by 千々岩真吾 on 2025/04/11.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedYearMonth: Date = Date()

    var body: some View {
        TabView {
            Tab("Paged", systemImage: "book") {
                PagedCalendar(selectedYearMonth: $selectedYearMonth)
            }

            Tab("Scroll", systemImage: "scroll") {
                ScrollableCalendar(selectedYearMonth: $selectedYearMonth)
            }
        }
    }
}

#Preview {
    ContentView()
}
