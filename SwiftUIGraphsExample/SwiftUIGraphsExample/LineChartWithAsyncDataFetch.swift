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
    @State var selectedIndex:Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            Group {
                    VStack {
                        TextField("US Stock Symbol", text: $viewModel.stockSymbol, onCommit: {
                            viewModel.loadDataPoints()
                            
                        }).textFieldStyle(RoundedBorderTextFieldStyle()).font(.headline).foregroundColor(.orange).padding()
                       
                        if self.viewModel.token == "" {
                            HStack {
                                Text("Get a free auth token from https://iexcloud.io to get started.").foregroundColor(.red)
                                Spacer()
                            }.padding()
                        }
                        
                        DYGridChartHeaderView(title: "\(self.viewModel.stockSymbol) Share Price, last 30 days", dataPoints: self.viewModel.dataPoints, selectedIndex: self.$selectedIndex, isLandscape: proxy.size.height < proxy.size.width, xValueConverter: { (xValue) -> String in
                        return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM-yyyy")
                    }, yValueConverter: { (yValue) -> String in
                        
                        return  yValue.toCurrencyString(maxDigits: 2)
                        
                    })
                        
                        DYMultiLineChartView(lineDataSets: [self.dataSet], settings: DYLineChartSettingsNew(xAxisSettings: DYLineChartXAxisSettingsNew(xAxisInterval: 172800, xAxisFontSize: fontSize), yAxisSettings: YAxisSettingsNew(yAxisFontSize: fontSize)), xValueAsString: { xValue in
                            return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")
                        }, yValueAsString: { yValue in
                            let formatter = NumberFormatter()
                            formatter.maximumFractionDigits = 2
                            return formatter.string(for: yValue)!
                        })
                        .frame(height:proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65)

                }.padding()
            }.onAppear {
                if viewModel.stockSymbol == "" {
                    viewModel.stockSymbol = "AAPL"
                    viewModel.loadDataPoints()
                }
            }
        }.navigationTitle("Stock price")
            

    }
    
    var dataSet: DYLineDataSet {
        DYLineDataSet(dataPoints: viewModel.dataPoints, selectedDataPoint: nil, pointView: { dataPoint in
            DYLineDataSet.defaultPointView(color: .orange)
        }, labelView: { dataPoint in
            self.labelView(dataPoint: dataPoint)
        }, selectorView: DYLineDataSet.defaultSelectorPointView(color: .red), settings: DYLineSettings(xValueSelectedDataPointLineColor: .red,  yValueSelectedDataPointLineColor: .red))
    }
    
    func labelView(dataPoint: DYDataPoint)-> AnyView {
        if let index = self.viewModel.dataPoints.firstIndex(where: {$0.id == dataPoint.id}) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            formatter.maximumFractionDigits = 2
            return Text(index % 2 == 0 ? "" : formatter.string(for: dataPoint.yValue)!).bold().font(.caption).foregroundColor(.primary).eraseToAnyView()
        }
      
        return Text("").eraseToAnyView()
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
    
    
    init(token: String) {
        self.token = token
        self.session = URLSession.shared
    }
    
    func loadDataPoints() {
        self.objectWillChange.send()
        withAnimation {
            self.dataPoints.removeAll()
        }
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
                                        withAnimation {
                                            self.dataPoints.append(DYDataPoint(xValue: timeInterval, yValue: closePrice))
                                        }
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
