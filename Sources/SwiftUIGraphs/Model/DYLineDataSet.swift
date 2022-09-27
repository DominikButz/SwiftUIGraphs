//
//  File.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import Foundation
import SwiftUI

public class DYLineDataSet: Identifiable, Equatable, ObservableObject {
    public static func == (lhs: DYLineDataSet, rhs: DYLineDataSet) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id: UUID
    var title: String?
    @Published public var dataPoints: [DYDataPoint]
    @Published public var selectedDataPoint: DYDataPoint?
    @Published internal var selectedIndex: Int?
//    @Binding var selectedIndex: Int
    var pointView: ((DYDataPoint)-> AnyView)?
    var labelView: ((DYDataPoint)->AnyView?)?
    var colorPerLineSegment: ((DYDataPoint)->Color)?
    var selectorView: AnyView?
    var settings: DYLineSettings
    
    /// Line Data Set initialiser
    /// - Parameters:
    ///   - id: a unique id
    ///   - dataPoints: an array of data points which are connected to draw a line.
    ///   - pointView: a view to mark each data point on the line. Default is nil - no point view.
    ///   - labelView: a label view to appear above each point. Default is nil - no label.
    ///   - colorPerLineSegment: Set a different color for each line segment (connecting two points) if needed. Default is nil, which means the complete line will have the color specified in the settings.
    ///   - selectorView: A marker view that will appear on top of the selected point and which will move along the line while swiping horizontally over the plot area.
    ///   - settings: settings for the line data set. 
    public init(id: UUID = UUID(), title: String? = nil, dataPoints: [DYDataPoint], selectedDataPoint: DYDataPoint?, pointView: ((DYDataPoint)-> AnyView)? = nil, labelView: ((DYDataPoint)->AnyView?)? = nil, colorPerLineSegment: ((DYDataPoint)->Color)? = nil, selectorView: AnyView? = nil, settings: DYLineSettings = DYLineSettings()) {
        self.id = id
        self.title = title
        self.dataPoints = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.selectedDataPoint = selectedDataPoint
        self.labelView = labelView
        self.pointView = pointView
        self.colorPerLineSegment = colorPerLineSegment
        self.selectorView = selectorView
        self.settings = settings
        
    }
    
    public var xValuesMinMax: (min: Double, max: Double) {
        let xValues = dataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        return (minX, maxX)
    }
    
    public var yValuesMinMax: (min: Double, max: Double) {
        let yValues = dataPoints.map({$0.yValue})
        let maxY = yValues.max() ?? 0
        let minY = yValues.min() ?? 0
        return (minY, maxY)
    }
    
    func setSelected(index: Int) {
        if Range(0...self.dataPoints.count).contains(index) {
            self.objectWillChange.send()
            withAnimation {
                self.selectedDataPoint = self.dataPoints[index]
                self.selectedIndex = index
            }
        }
    }
    
    public static func defaultSelectorPointView(color: Color)->AnyView {
        AnyView(
            Circle()
                .frame(width: 26, height: 26, alignment: .center)
                .foregroundColor(color)
                .opacity(0.2)
                .overlay(
                    Circle()
                        .fill()
                        .frame(width: 14, height: 14, alignment: .center)
                        .foregroundColor(color)
                )
        )
    }
    
    public static func defaultPointView(color: Color)-> AnyView {
        AnyView(Circle().pointStyle(color: color, edgeLength: 12).cornerRadius(6).background(Color(.systemBackground)).clipShape(Circle()))
    }
    
    
}


