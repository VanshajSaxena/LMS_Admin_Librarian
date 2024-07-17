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
        .shadow(radius: 5)
    }
}

struct GenrePieChart: View {
    let data: [(genre: String, percentage: Double)]
    let totalBooks: Int
    let colorNames: [String] = ["ThemeOrange", "Graph1", "Graph2", "Graph3"]
    
    var body: some View {
        VStack(spacing: 15) { // Increased spacing
            ZStack {
                Chart(data, id: \.genre) { item in
                    SectorMark(
                        angle: .value("Percentage", item.percentage),
                        innerRadius: .ratio(0.6),
                        angularInset: 1.5
                    )
                    .foregroundStyle(Color(colorNames[data.firstIndex { $0.genre == item.genre } ?? 0 % colorNames.count]))
                }
                
                VStack {
                    Text("Total Books")
                        .font(.headline) // Larger font
                    Text("\(totalBooks)")
                        .font(.largeTitle.bold()) // Larger font
                }
            }
            .frame(height: 300) // Increased height
            
            VStack(alignment: .leading, spacing: 12) { // Increased spacing
                ForEach(data, id: \.genre) { item in
                    HStack {
                        Circle()
                            .fill(Color(colorNames[data.firstIndex { $0.genre == item.genre } ?? 0 % colorNames.count]))
                            .frame(width: 12, height: 12) // Increased size
                        Text(item.genre)
                            .font(.subheadline) // Larger font
                        Spacer()
                        Text("\(Int(item.percentage))%")
                            .font(.subheadline) // Larger font
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: 400, height: 500) // Increased size
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .shadow(radius: 5)
    }
}

struct GraphView: View {
    let issueReturnData: [(month: String, issued: Int, returned: Int)] = [
        ("Jan", 600, 400),
        ("Feb", 800, 700),
        ("Mar", 640, 480),
        ("Apr", 760, 440),
        ("May", 860, 600),
        ("Jun", 840, 420)
    ]
    
    let genreData: [(genre: String, percentage: Double)] = [
        ("Romantic", 37),
        ("Comedy", 13),
        ("Drama", 31),
        ("Horror", 19)
    ]
    
    var body: some View {
        HStack(alignment: .top, spacing: 30) { // Increased spacing
            IssueAndReturnsChart(data: issueReturnData)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white)).shadow(radius: 5)
            
            GenrePieChart(data: genreData, totalBooks: 1430)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white)).shadow(radius: 5)
        }
        .padding()
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad Pro 11-inch")
    }
}
