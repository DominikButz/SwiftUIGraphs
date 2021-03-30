//
//  RingChartAndDetailPieChartExample.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 26/3/2021.
//

import SwiftUI
import SwiftUIGraphs

struct RingChartAndDetailPieChartExample: View {

    @State var detailChartSelectedId: String?
    @StateObject var chartModel: ChartModel = ChartModel()
    @Namespace var animationNamespace
    
    var body: some View {
        GeometryReader { proxy in
            if proxy.size.height > proxy.size.width {
                VStack {
                    self.contentView(isPortrait: true)
                }
            } else {
                HStack {
                    self.contentView(isPortrait: false)
                }
            }
        }.navigationTitle("Sales by Country")
    }
    
    func contentView(isPortrait: Bool)-> some View {
        Group {
            self.mainPieChart(isPortrait: isPortrait)
            
            if detailChartVisibleCondition {
                self.otherCategoryDetailsPieChart()
            }
        }
    }
    
    func mainPieChart(isPortrait: Bool)->some View {
        VStack(spacing: 10) {
            DYPieChartView(data: chartModel.data, selectedId: $chartModel.selectedId, sliceLabelView: { (fraction)  in
                self.sliceLabelContentView(fraction: fraction, data:self.chartModel.data, textColor: .white)
            }, shouldHideMultiFractionSliceOnSelection: true, animationNamespace: animationNamespace, settings: DYPieChartSettings(innerCircleRadiusFraction: 0.3))
            .background(Circle().fill(Color(.systemBackground)).shadow(color: detailChartVisibleCondition ? .clear : .gray, radius:5))
            .rotationEffect(detailChartVisibleCondition ? Angle(degrees: isPortrait ? 45 : -40) : Angle(degrees: 0))

        }.padding()

    }
    
    func otherCategoryDetailsPieChart()->some View {
        VStack(spacing: 5) {
            DYPieChartView(data: chartModel.data[1].detailFractions, selectedId: $detailChartSelectedId, sliceLabelView: { (fraction) in
                self.detailChartSliceLabelView(fraction: fraction, data: chartModel.data[1].detailFractions)
   
            }, animationNamespace: animationNamespace, settings: DYPieChartSettings(minimumFractionForSliceLabelOffset: 0.11))
            .background(Circle().fill(Color(.systemBackground)).shadow(radius: 10))
            .padding(50)
            .matchedGeometryEffect(id: self.chartModel.data[1].id, in: self.animationNamespace)

        }
    }
    

    
    func detailChartSliceLabelView(fraction: DYChartFraction, data: [DYChartFraction])->some View {
        Group {
            if fraction.value / data.reduce(0, { $0 + $1.value}) >= 0.11 || self.detailChartSelectedId == fraction.id {
                self.sliceLabelContentView(fraction: fraction, data:data, textColor: fraction.value / data.reduce(0, { $0 + $1.value}) >= 0.11 ? .white : .primary)
            }
        }
    }
    
    func sliceLabelContentView(fraction: DYChartFraction, data:[DYChartFraction], textColor: Color)-> some View {
        VStack {
            Text(fraction.title).font(sliceLabelViewFont).lineLimit(2).frame(maxWidth: 85)
            Text(String(format:"%.0f units", fraction.value)).font(sliceLabelViewFont).bold()
            Text(fraction.value.percentageString(totalValue: data.reduce(0) { $0 + $1.value})).font(sliceLabelViewFont)
            
        }.foregroundColor(textColor)
    }
    
    var sliceLabelViewFont: Font {
       return UIDevice.current.userInterfaceIdiom == .pad ? .callout : .caption
    }
    
    var detailChartVisibleCondition: Bool {
        self.chartModel.selectedId == chartModel.data[1].id
    }
}

struct RingChartAndDetailPieChartExample_Previews: PreviewProvider {
    static var previews: some View {
        RingChartAndDetailPieChartExample()
    }
}

final class ChartModel: ObservableObject {
    
    @Published var data: [DYChartFraction]
    @Published var selectedId: String?
    
    init() {
        self.data = Self.data
        
    }
    
    static var data: [DYChartFraction] {
        let parentColors = Color.shadesOf(color: Color.blue, number: 6)
        let childColors = Color.shadesOf(color: Color.orange, number: 7)
        return [DYChartFraction(value: 254, color: parentColors[0], title: "United States",  detailFractions: []),
                DYChartFraction(value: 90, color: parentColors[1], title: "Other", detailFractions: [DYChartFraction(value: 30, color:childColors[0], title: "France", detailFractions: []),    DYChartFraction(value: 20, color:childColors[1],  title: "UK", detailFractions: []), DYChartFraction(value: 15, color:childColors[2], title: "Spain", detailFractions: []), DYChartFraction(value: 10, color:childColors[3], title: "Portugal", detailFractions: []), DYChartFraction(value: 10, color:childColors[4],  title: "Italy", detailFractions: []), DYChartFraction(value: 8, color:childColors[5], title: "Poland",  detailFractions: []), DYChartFraction(value: 7, color:childColors[6], title: "Bulgaria", detailFractions: [])]),
               DYChartFraction(value: 128, color: parentColors[2], title: "Brazil",  detailFractions: []),
               DYChartFraction(value: 130,  color: parentColors[3], title: "India", detailFractions: []),
               DYChartFraction(value: 120, color: parentColors[4], title: "Germany", detailFractions: []),
               DYChartFraction(value: 100, color: parentColors[5], title: "Australia", detailFractions: [])]
    }
}
