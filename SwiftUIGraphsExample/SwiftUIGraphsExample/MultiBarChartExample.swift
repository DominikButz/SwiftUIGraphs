//
//  MultiBarChartExample.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/9/2022.
//

import SwiftUI
import SwiftUIGraphs

struct MultiBarChartExample: View {
    
    let colors: [Color] = [.blue, .orange, .green]
    @State var exampleData: [DYBarDataSet] = []
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
//                DYStackedBarChartView(barDataSets: <#T##[DYBarDataSet]#>, settings: <#T##DYStackedBarChartSettings#>, plotAreaHeight: self.chartHeight(proxy: proxy), yValueAsString: { yValue in
//                    
//                })
//                .frame(height: self.chartHeight(proxy: proxy) + 30)
//                .padding()
                
//                if self.exampleData.isEmpty == false {
//                    self.legendView.padding()
//
//                }
                Spacer()
            }

        }.navigationTitle("Some Random Data Sets")
            .onAppear {
                //self.exampleData = generateExampleData()
            }
    }
    
    func chartHeight(proxy: GeometryProxy)->CGFloat {
        return proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65
    }
    
}

struct MultiBarChartExample_Previews: PreviewProvider {
    static var previews: some View {
        MultiBarChartExample()
    }
}
