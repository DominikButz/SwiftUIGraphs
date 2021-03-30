//
//  LineChartWithAsyncDataFetch.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 28/3/2021.
//

import SwiftUI
import SwiftUIGraphs

struct LineChartWithAsyncDataFetch: View {
    //TODO: sign up with https://iexcloud.io to get a free auth token and insert it here
    @StateObject var viewModel = StockPriceDataViewModel(token: "")
    
    var body: some View {
        GeometryReader { proxy in
            Group {
                    VStack {
                        TextField("US Stock Symbol", text: $viewModel.stockSymbol, onCommit: {
                            viewModel.loadDataPoints()
                        }).textFieldStyle(RoundedBorderTextFieldStyle()).font(.headline).foregroundColor(.orange).padding()
                        
                        DYGridChartHeaderView(title: "\(self.viewModel.stockSymbol) Share Price, last 30 days", dataPoints: self.viewModel.dataPoints, selectedIndex: self.$viewModel.selectedIndex, isLandscape: proxy.size.height < proxy.size.width, xValueConverter: { (xValue) -> String in
                        return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM-yyyy")
                    }, yValueConverter: { (yValue) -> String in
                        
                        return  yValue.toCurrencyString(maxDigits: 2)
                        
                    })
                    
                    DYLineChartView(dataPoints: self.viewModel.dataPoints, selectedIndex: self.$viewModel.selectedIndex, xValueConverter: { (xValue) -> String in
                        // this is for the x-Axis values - date should be short
                        return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")
                    }, yValueConverter: { (yValue) -> String in
                        // return without currency symbol
                        let formatter = NumberFormatter()
                        formatter.maximumFractionDigits = 2
                        return formatter.string(for: yValue)!
                        //  return TimeInterval(yValue).toString() ?? ""
                    }, chartFrameHeight: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65,  settings: DYLineChartSettings(showPointMarkers: true, lateralPadding: (0, 0), yAxisSettings: YAxisSettings(yAxisFontSize: fontSize), xAxisSettings: DYLineChartXAxisSettings(showXAxis: true, xAxisInterval: 172800, xAxisFontSize: fontSize)))  //seconds per 48 hours
                    Spacer()
                }.padding()
            }
        }.navigationTitle("Stock price")

    }
    
    var fontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10
    }
    var yAxisWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 35 : 45
    }
}

struct LineChartWithAsyncDataFetch_Previews: PreviewProvider {
    static var previews: some View {
        LineChartWithAsyncDataFetch()
    }
}

final class StockPriceDataViewModel: ObservableObject {
    
    var token: String
    var session: URLSession
    @Published var stockSymbol: String = ""
    
    @Published var dataPoints:[DYDataPoint] = []
    @Published var selectedIndex:Int = 0
    
    init(token: String) {
        self.token = token
        self.session = URLSession.shared
    }
    
    func loadDataPoints() {
        self.objectWillChange.send()
        self.dataPoints.removeAll()
        let url = "https://cloud.iexapis.com/stable/stock/\(self.stockSymbol)/chart/1m?token=\(self.token)"
        
        if let url = URL(string:url ) {
            let request = URLRequest(url: url)

            let task = self.session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    if let dataArray =  try? JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String, Any>]{
                        //print(dataArray)
                        for quotation in dataArray {
                            // get the close price for each date and create data points
                            if let closePrice = quotation["close"] as? Double, let dateString = quotation["date"] as? String {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                dateFormatter.timeZone = TimeZone.init(abbreviation: "EST")
                                dateFormatter.locale = Locale.current
                                
                                if let date = dateFormatter.date(from: dateString) {
                                    let timeInterval = date.timeIntervalSinceReferenceDate
                                    // let's make sure the data points array is updated on the main thread!
                                    DispatchQueue.main.async {
                                        self.dataPoints.append(DYDataPoint(xValue: timeInterval, yValue: closePrice))
                                    }
             
                                }
                            }
                        }
                    }
                } else {
                    print("no data returned")
                }
            }
            task.resume()
            
        }
    }
    
    
}
