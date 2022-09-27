//
//  DYPlotChartHeaderView.swift
//  
//
//  Created by Dominik Butz on 23/9/2022.
//

import SwiftUI

public struct DYLineInfoView: View, DYLineInfoViewModifiableProperties {

    var titleLabel: Text?
    @Binding var selectedDataPoint: DYDataPoint?
    var selectedYValueAsString: (Double)->String
    var selectedXValueAsString: (Double)->String
    var minValueLabels: (y: Text, x:Text)?
    var maxValueLabels: (y: Text, x:Text)?
    
    //access only through selectedLabel modifier
    public var selectedYLabelFont: Font = .headline
    public var selectedXLabelFont: Font = .callout
    public var selectedYLabelTextColor: Color = .orange
    public var selectedXLabelTextColor: Color = .secondary
   
    @StateObject var orientationObserver = OrientationObserver()
    
    public init(titleLabel: Text? = nil, selectedDataPoint: Binding<DYDataPoint?>, selectedYValueAsString: @escaping (Double)->String, selectedXValueAsString: @escaping (Double)->String,  minValueLabels: (y: Text, x: Text)? = nil, maxValueLabels: (y: Text, x: Text)? = nil) {
        self.titleLabel = titleLabel
        self._selectedDataPoint = selectedDataPoint
        self.selectedYValueAsString = selectedYValueAsString
        self.selectedXValueAsString = selectedXValueAsString
        self.minValueLabels = minValueLabels
        self.maxValueLabels = maxValueLabels

    }
    

    public var body: some View {

        VStack(alignment: .leading, spacing: 5) {
            if let title = self.titleLabel {
                title
     
            }
            if self.orientationObserver.orientation == .portrait {
                VStack {
                    minMaxView
                }
            } else {
                HStack(spacing: 10) {
                    minMaxView
                }
            }
            Divider()
            if let selectedDataPoint =  self.selectedDataPoint {
                HStack {
                    Text(self.selectedYValueAsString(selectedDataPoint.yValue)).font(selectedYLabelFont).bold().foregroundColor(selectedYLabelTextColor)
                    Text(self.selectedXValueAsString(selectedDataPoint.xValue)).font(selectedXLabelFont).foregroundColor(selectedXLabelTextColor)
               
                }
             
            }
            
            //Spacer()
        }
    }
    
    var minMaxView: some View {
        Group {
            if let maxValue = maxValueLabels {
                HStack {
                    maxValue.y
                    maxValue.x
                    if self.orientationObserver.orientation == .portrait {
                        Spacer()
                    } else {
                        Text(" | ")
                    }
                }
            }

            if let minValue = minValueLabels {
                HStack {
                    minValue.y
                    minValue.x
                    Spacer()
                }
            }
            if self.orientationObserver.orientation == .landscape {
                Spacer()
            }
            
        }
    }
}


public protocol DYLineInfoViewModifiableProperties {
    
    var selectedYLabelFont: Font {get set }
    var selectedXLabelFont: Font {get set }
    var selectedYLabelTextColor: Color  {get set }
    var selectedXLabelTextColor: Color {get set }
    
}



public extension View where Self: DYLineInfoViewModifiableProperties {
    
    func selectedDataPointLabel(yFont: Font = .headline, yColor: Color = .orange, xFont: Font = .callout, xColor: Color = .secondary)-> some View {
        var newView = self
        newView.selectedYLabelFont = yFont
        newView.selectedYLabelTextColor = yColor
        newView.selectedXLabelFont = xFont
        newView.selectedXLabelTextColor = xColor
        return newView
    }
}



//struct DYPlotChartHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        DYPlotChartHeaderView(titleLabel:Text("Volume (kg)").font(.headline), selectedValueLabels: (y: Text("1,784 kg").font(.headline).foregroundColor(.orange), x: Text("30/8/2022, 8:05")), minValueLabels: (y: Text("1,498kg").bold(), x: Text("26/7/2022, 8:22").foregroundColor(.gray)), maxValueLabels: (y: Text("1,971 kg").bold(), x: Text("16/8/2022, 8:16").foregroundColor(.gray)))
//            .padding()
//            Spacer()
////            .previewLayout(.fixed(width: 812, height: 375))
////            .environment(\.horizontalSizeClass, .compact) // 2
////            .environment(\.verticalSizeClass, .compact) // 3
//    }
//}
