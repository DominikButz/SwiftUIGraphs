//
//  ContentView.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import SwiftUI
import SwiftUIGraphs


struct ContentView: View {

    var body: some View {

        NavigationView {
            List {
                Section(header: HStack {
                    Image(systemName: "waveform.path")
                    Text("Line Charts")
                }) {
                   // NavigationLink("Weight Lifting Volume per Workout", destination: BasicLineChartExample())
                    NavigationLink("Stock Prices (asyn data fetch)", destination: LineChartWithAsyncDataFetch())
                    NavigationLink("Workout Time per Week", destination: CustomYAxisIntervalExampleLineChart())
                }
                
                Section(header: HStack{
                    Image(systemName: "chart.bar.fill")
                    Text("Bar Charts")
                }) {
                    NavigationLink("Workout Volume", destination: BasicBarChartExample())
                }
                Section(header: HStack{
                    Image(systemName: "chart.pie.fill")
                    Text("Pie Charts")
                }) {
                    NavigationLink("Av. US Household Spending", destination: BasicPieChartExample())
                    NavigationLink("Sales per Country", destination: RingChartAndDetailPieChartExample())
                }

            }.navigationBarTitle("SwiftUIGraphs Examples", displayMode: .inline).padding()
            
            // add the first destination view in the list one more time as default for iPad in split view mode, otherwise the detail view will be empty
            if UIDevice.current.userInterfaceIdiom == .pad {
                LineChartWithAsyncDataFetch()
            }
        }
 

    }
    

    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().colorScheme(.light)
    }
}
