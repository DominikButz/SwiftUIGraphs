//
//  ContentView.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import SwiftUI
import SwiftUIGraphs


struct ContentView: View {

    init() {
        
       // UINavigationBar.appearance().backgroundColor = .clear
    }
    
    var body: some View {

        NavigationView {
            List {
                NavigationLink("Line Chart: Lifting Volume per Workout", destination: BasicLineChartExample())
                NavigationLink("Line Chart: Workout Time", destination: CustomYAxisIntervalExampleLineChart())
                NavigationLink("Bar Chart: Workout Volume per Week", destination: BasicBarChartExample())
                NavigationLink("Pie Chart: Av. US Household Spending", destination: BasicPieChartExample())
                NavigationLink("Ring Chart: Sales per Country", destination: RingChartAndDetailPieChartExample())
                Spacer()
            }.navigationBarTitle("SwiftUIGraphs Examples", displayMode: .inline).padding()
            // add the first destination view in the list one more time as default for iPad in split view mode...
            BasicLineChartExample()
        }
 

    }
    

    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().colorScheme(.light)
    }
}
