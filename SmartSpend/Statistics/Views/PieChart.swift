//
//  PieChart.swift
//  SmartSpend
//
//  Created by shortcut mac on 12.9.25.
//

import SwiftUI
import Charts

struct CategorySpending: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
    let color: Color
    let icon: String
}


struct PieChart: View {
    
    @State private var categoryData: [CategorySpending] = [
       CategorySpending(category: "Food", amount: 2500, color: .orange, icon: "fork.knife"),
       CategorySpending(category: "Transport", amount: 1800, color: .blue, icon: "car.fill"),
       CategorySpending(category: "Shopping", amount: 3200, color: .purple, icon: "bag.fill"),
       CategorySpending(category: "Bills", amount: 1200, color: .red, icon: "bolt.fill"),
       CategorySpending(category: "Entertainment", amount: 900, color: .green, icon: "tv.fill"),
       CategorySpending(category: "Health", amount: 600, color: .pink, icon: "heart.fill"),
       CategorySpending(category: "Education", amount: 800, color: .indigo, icon: "book.fill")
   ]
    
    var isOnHomeView: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            if isOnHomeView {
                HStack {
                    Spacer()
                    NavigationLink("View More") {
                        StatsView()
                    }
                    .font(.footnote)
                    .foregroundColor(.MainColor)
                    .padding(.horizontal)
                    .padding(.top)
                }
                .padding(.horizontal)
            }
            
            Chart(categoryData) { item in
                SectorMark(angle: .value("Category", item.amount), angularInset: 2)
                    .foregroundStyle(by: .value("category", item.category))
                    .cornerRadius(5)
                    .annotation(position: .overlay) {
                        Text(item.category)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                    }
            }
            .chartLegend(.hidden)
            .frame(height: 320)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.MainColor.opacity(0.2))
                //                .stroke(Color.MainColor, lineWidth: 1)
                    .padding(.horizontal)
                
            )
            .frame(maxWidth: .infinity)
            
        }
    }
}

#Preview {
    NavigationStack {
        PieChart(isOnHomeView: false)
    }
}



//
//  PieChart.swift
//  SmartSpend
//
//  Created by shortcut mac on 12.9.25.
//

//import SwiftUI
//import Charts
//
//// MARK: - Data Models
//struct CategorySpending: Identifiable {
//    let id = UUID()
//    let category: String
//    let amount: Double
//    let color: Color
//    let icon: String
//}
//
//struct StatisticsResponse: Codable {
//    let data: [StatisticsData]
//}
//
//struct StatisticsData: Codable {
//    let statistics: [String: Double]
//    let totalExpenses: Double
//    let totalIncome: Double
//    let from: String
//    let to: String
//    
//    enum CodingKeys: String, CodingKey {
//        case statistics
//        case totalExpenses = "total_expenses"
//        case totalIncome = "total_income"
//        case from, to
//    }
//}
//
//// MARK: - API Service
//class StatisticsService: ObservableObject {
//    @Published var categoryData: [CategorySpending] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    @Published var totalExpenses: Double = 0
//    @Published var totalIncome: Double = 0
//    @Published var dateRange: String = ""
//    
//    private let baseURL = URL(string: "https://9cf0c623356c.ngrok-free.app/api")!
//    
//    // Category colors and icons mapping
//    private let categoryMapping: [String: (color: Color, icon: String)] = [
//        "Food": (.orange, "fork.knife"),
//        "Transport": (.blue, "car.fill"),
//        "Shopping": (.purple, "bag.fill"),
//        "Bills": (.red, "bolt.fill"),
//        "Entertainment": (.green, "tv.fill"),
//        "Health": (.pink, "heart.fill"),
//        "Education": (.indigo, "book.fill"),
//        // Add more categories as needed
//        "Other": (.gray, "questionmark.circle.fill")
//    ]
//    
//    func fetchStatistics(from: String? = nil, to: String? = nil) {
//        isLoading = true
//        errorMessage = nil
//        
//        var urlComponents = URLComponents(string: "\(baseURL)/statistics")!
//        var queryItems: [URLQueryItem] = []
//        
//        if let from = from {
//            queryItems.append(URLQueryItem(name: "from", value: from))
//        }
//        if let to = to {
//            queryItems.append(URLQueryItem(name: "to", value: to))
//        }
//        
//        if !queryItems.isEmpty {
//            urlComponents.queryItems = queryItems
//        }
//        
//        guard let url = urlComponents.url else {
//            errorMessage = "Invalid URL"
//            isLoading = false
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        // Add authentication header if needed
//        // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                
//                if let error = error {
//                    self?.errorMessage = "Network error: \(error.localizedDescription)"
//                    return
//                }
//                
//                guard let data = data else {
//                    self?.errorMessage = "No data received"
//                    return
//                }
//                
//                do {
//                    let statisticsResponse = try JSONDecoder().decode(StatisticsResponse.self, from: data)
//                    self?.processStatisticsData(statisticsResponse)
//                } catch {
//                    self?.errorMessage = "Failed to decode data: \(error.localizedDescription)"
//                }
//            }
//        }.resume()
//    }
//    
//    private func processStatisticsData(_ response: StatisticsResponse) {
//        guard let data = response.data.first else {
//            errorMessage = "No statistics data available"
//            return
//        }
//        
//        totalExpenses = data.totalExpenses
//        totalIncome = data.totalIncome
//        dateRange = "\(data.from) - \(data.to)"
//        
//        // Convert statistics dictionary to CategorySpending array
//        categoryData = data.statistics.compactMap { (category, amount) in
//            let mapping = categoryMapping[category] ?? categoryMapping["Other"]!
//            return CategorySpending(
//                category: category,
//                amount: amount,
//                color: mapping.color,
//                icon: mapping.icon
//            )
//        }.sorted { $0.amount > $1.amount } // Sort by amount descending
//    }
//}
//
//// MARK: - PieChart View
//struct PieChart: View {
//    @StateObject private var statisticsService = StatisticsService()
//    var isOnHomeView: Bool
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            if isOnHomeView {
//                HStack {
//                    Spacer()
//                    NavigationLink("View More") {
//                        StatsView()
//                    }
//                    .font(.footnote)
//                    .foregroundColor(.MainColor)
//                    .padding(.horizontal)
//                    .padding(.top)
//                }
//                .padding(.horizontal)
//            }
//            
//            if statisticsService.isLoading {
//                ProgressView("Loading...")
//                    .frame(height: 320)
//                    .padding()
//            } else if let errorMessage = statisticsService.errorMessage {
//                VStack {
//                    Image(systemName: "exclamationmark.triangle")
//                        .foregroundColor(.orange)
//                        .font(.title)
//                    Text(errorMessage)
//                        .foregroundColor(.secondary)
//                        .multilineTextAlignment(.center)
//                    Button("Retry") {
//                        statisticsService.fetchStatistics()
//                    }
//                    .foregroundColor(.MainColor)
//                }
//                .frame(height: 320)
//                .padding()
//            } else if statisticsService.categoryData.isEmpty {
//                VStack {
//                    Image(systemName: "chart.pie")
//                        .foregroundColor(.gray)
//                        .font(.title)
//                    Text("No spending data available")
//                        .foregroundColor(.secondary)
//                }
//                .frame(height: 320)
//                .padding()
//            } else {
//                Chart(statisticsService.categoryData) { item in
//                    SectorMark(angle: .value("Category", item.amount), angularInset: 2)
//                        .foregroundStyle(item.color)
//                        .cornerRadius(5)
//                        .annotation(position: .overlay) {
//                            Text(item.category)
//                                .font(.system(size: 12, weight: .bold))
//                                .foregroundColor(.white)
//                                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
//                        }
//                }
//                .chartLegend(.hidden)
//                .frame(height: 320)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color.MainColor.opacity(0.2))
//                        .padding(.horizontal)
//                )
//                .frame(maxWidth: .infinity)
//                
//                // Optional: Show totals
//                if !isOnHomeView {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Total Expenses")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                            Text("$\(statisticsService.totalExpenses, specifier: "%.2f")")
//                                .font(.headline)
//                                .foregroundColor(.red)
//                        }
//                        
//                        Spacer()
//                        
//                        VStack(alignment: .trailing) {
//                            Text("Total Income")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                            Text("$\(statisticsService.totalIncome, specifier: "%.2f")")
//                                .font(.headline)
//                                .foregroundColor(.green)
//                        }
//                    }
//                    .padding(.horizontal, 32)
//                    
//                    Text(statisticsService.dateRange)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .padding(.bottom)
//                }
//            }
//        }
//        .onAppear {
//            statisticsService.fetchStatistics()
//        }
//        .refreshable {
//            statisticsService.fetchStatistics()
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        PieChart(isOnHomeView: false)
//    }
//}
