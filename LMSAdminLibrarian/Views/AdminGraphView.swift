//
//  GraphView.swift
//  LMSAdminLibrarian
//
//  Created by Nishant Sinha on 14/07/24.
//
import SwiftUI
import Charts

struct RoundedBarMark: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        return Path(roundedRect: rect, cornerRadius: cornerRadius)
    }
}

struct IssueAndReturnsChart: View {
    let data: [(month: String, issued: Int, returned: Int)]
    let barThickness: CGFloat = 25 // Increased thickness
    let cornerRadius: CGFloat = 8 // Increased corner radius
    let spacing: CGFloat = 10 // Increased space between bars
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Issue and Returns")
                .font(.title2) // Larger font
                .padding(.bottom, 10)
            
            Chart {
                ForEach(data, id: \.month) { item in
                    BarMark(
                        x: .value("Month", item.month),
                        y: .value("Books", item.issued),
                        width: .fixed(barThickness)
                    )
                    .foregroundStyle(Color("ThemeOrange"))
                    .position(by: .value("Type", "Issued"))
                    
                    BarMark(
                        x: .value("Month", item.month),
                        y: .value("Books", item.returned),
                        width: .fixed(barThickness)
                    )
                    .foregroundStyle(Color("Graph1"))
                    .position(by: .value("Type", "Returned"))
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisValueLabel {
                        if let month = value.as(String.self) {
                            Text(month)
                                .font(.subheadline) // Larger font
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic) { value in
                    AxisValueLabel {
                        if let number = value.as(Int.self) {
                            Text("\(number)")
                                .font(.subheadline) // Larger font
                        }
                    }
                }
            }
            .frame(height: 400) // Increased height
            
            HStack {
                Circle()
                    .fill(Color("ThemeOrange"))
                    .frame(width: 15, height: 15) // Increased size
                Text("Issued Books")
                    .font(.subheadline)
                
                Circle()
                    .fill(Color("Graph1"))
                    .frame(width: 15, height: 15) // Increased size
                Text("Returned Books")
                    .font(.subheadline)
            }
            .padding(.top, 10)
        }
        .padding()
        .frame(width: 600, height: 500) // Increased size
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .shadow(radius: 3)
    }
}

struct GenrePieChart: View {
    let data: [(genre: String, percentage: Double)]
    let totalBooks: Int
    let colorNames: [String] = ["ThemeOrange", "Graph1", "Graph2", "Graph3", "Graph4"]
    
    private var top5Data: [(genre: String, percentage: Double)] {
        Array(data.prefix(5))
    }
    
    private var otherPercentage: Double {
        data.dropFirst(5).reduce(0) { $0 + $1.percentage }
    }
    
    private var chartData: [(genre: String, percentage: Double)] {
        var result = top5Data
        if otherPercentage > 0 {
            result.append((genre: "Other", percentage: otherPercentage))
        }
        return result
    }
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Chart(chartData, id: \.genre) { item in
                    SectorMark(
                        angle: .value("Percentage", item.percentage),
                        innerRadius: .ratio(0.6),
                        angularInset: 1.5
                    )
                    .foregroundStyle(color(for: item.genre))
                }
                
                VStack {
                    Text("Total Books")
                        .font(.headline)
                    Text("\(totalBooks)")
                        .font(.largeTitle.bold())
                }
            }
            .frame(height: 300)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(chartData, id: \.genre) { item in
                    HStack {
                        Circle()
                            .fill(color(for: item.genre))
                            .frame(width: 12, height: 12)
                        Text(item.genre)
                            .font(.subheadline)
                        Spacer()
                        Text("\(Int(item.percentage))%")
                            .font(.subheadline)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: 400, height: 500)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .shadow(radius: 5)
    }
    
    func color(for genre: String) -> Color {
        let index = chartData.firstIndex { $0.genre == genre } ?? 0
        return Color(colorNames[index % colorNames.count])
    }
}

struct GraphView: View {
    @StateObject private var viewModel = AdminAnalyticsViewModel()
    @State private var analyticsData: (basicStats: [AnalyticsData], issueReturnsData: [(month: String, issued: Int, returned: Int)], genreData: ([(genre: String, percentage: Double)], Int))?
    
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            if let data = analyticsData {
                IssueAndReturnsChart(data: data.issueReturnsData)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                
                GenrePieChart(data: data.genreData.0, totalBooks: data.genreData.1)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
            } else {
                ProgressView()
            }
        }
        .padding()
        .task {
            analyticsData = await viewModel.createAnalyticsDataObj()
        }
        .background(Color.background)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad Pro 11-inch")
    }
}
