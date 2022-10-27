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
                            
                        }).textFieldStyle(RoundedBorderTextFieldStyle()).font(.headline).foregroundColor(.orange).padding(.horizontal)
                       
                        if self.viewModel.token == "" {
                            HStack {
                                Text("Get a free auth token from https://iexcloud.io to get started.").foregroundColor(.red)
                                Spacer()
                            }.padding()
                        }
                        
                        DYLineInfoView(titleLabel: Text("\(self.viewModel.stockSymbol) Share Price, last 30 days"), selectedDataPoint: $viewModel.selectedDataPoint, minValueLabels: minValueLabels, maxValueLabels: maxValueLabels)
                        .selectedXStringValue( { xValue in
                            Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM-yyyy")
                        })
                        .selectedYStringValue({ yValue in
                            yValue.toCurrencyString(maxDigits: 2)
                        })
                        .padding()
                        
                        
                        DYLineChartView(allDataPoints: viewModel.dataPoints, lineViews: { parentProps in
                            
                            DYLineView(dataPoints: viewModel.dataPoints, selectedDataPoint: $viewModel.selectedDataPoint, pointView: { _ in
                                DYLinePointView()
                            }, selectorView: DYSelectorPointView(),  parentViewProperties: parentProps)
                                .lineStyle(color: .orange)
                                .selectedPointIndicatorLineStyle(xLineColor: .red, yLineColor: .red)
                                .area(gradient: LinearGradient(colors: [.orange, .orange.opacity(0.1)], startPoint: .top, endPoint: .bottom), shadow: nil)
           
                            
                        })
                        .xAxisScalerOverride(minMax: (self.viewModel.dataPoints.first?.xValue, nil), interval: 172800)
                        .xAxisLabelFont(self.font)
                        .xAxisLabelStringValue({ xValue in Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")
                        })
                        .yAxisLabelFont(self.font)
                        .yAxisLabelStringValue({ yValue in
                            let formatter = NumberFormatter()
                           formatter.maximumFractionDigits = 2
                           return formatter.string(for: yValue)!
                        })
                        .frame(height:proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65)


                }.padding()
                    .onAppear {
                        
                        if viewModel.stockSymbol == "" {
                            viewModel.stockSymbol = "AAPL"
                            viewModel.loadDataPoints()
                        }
                    }
            }
        }.navigationTitle("Stock price")
            

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
    
    var font: UIFont {
        let size:CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10
        return UIFont.systemFont(ofSize: size)
    }


    var yAxisWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 35 : 45
    }
    
    var minValueLabels: (y: Text, x:Text)? {
  
        let minY =  self.viewModel.dataPoints.map({$0.yValue}).min() ?? 0
        let minYDataPoint = self.viewModel.dataPoints.filter({$0.yValue == minY}).first
        
        let xString = Date(timeIntervalSinceReferenceDate: minYDataPoint?.xValue ?? 0).toString(format:"dd-MM-yyyy")
        let yString = "Min: " +  minY.toCurrencyString(maxDigits: 2)
        return (y:Text(yString).font(.caption).bold(), x:Text(xString).font(.caption).foregroundColor(.gray))
    }
    
    var maxValueLabels: (y: Text, x:Text)? {

        let maxY =  self.viewModel.dataPoints.map({$0.yValue}).max() ?? 0
        let maxYDataPoint = self.viewModel.dataPoints.filter({$0.yValue == maxY}).first
        
        let xString = Date(timeIntervalSinceReferenceDate: maxYDataPoint?.xValue ?? 0).toString(format:"dd-MM-yyyy")
        let yString = "Max: " +  maxY.toCurrencyString(maxDigits: 2)
        return (y:Text(yString).font(.caption).bold(), x:Text(xString).font(.caption).foregroundColor(.gray))
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
    @Published var selectedDataPoint:DYDataPoint?
    
    
    init(token: String) {
        self.token = token
        self.session = URLSession.shared
    }
    
    func loadDataPoints() {
        //self.objectWillChange.send()
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
                                      //  withAnimation {
                                            self.dataPoints.append(DYDataPoint(xValue: timeInterval, yValue: closePrice))
                                     //   }
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
