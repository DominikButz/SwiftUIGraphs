//
//  DYPieChartView.swift
//  
//
//  Created by Dominik Butz on 23/3/2021.
//

import SwiftUI

/// DYPieChartView
public struct DYPieChartView<L: View>: View, DYPieChartModifiableProperties {
    
    @Binding private var selectedSlice: DYPieFraction?
    
    var data: [DYPieFraction] = []

    var sliceLabelView: (DYPieFraction)->L
    var totalValue: Double {

        return data.reduce(0) { $0 + $1.value}
    }

    var animationNamespace: Namespace.ID
    public var settings: DYPieChartSettings
    
    /// DYPieChartView initializer
    /// - Parameters:
    ///   - data: Array of DYChartFraction structs. The fraction values will not be reordered, so the slices will be arranged exactly in the order of the DYChartFraction structs in the array - starting at 12 o'clock, in clockwise direction.
    ///   - selectedId: The id of the DYChartFraction that is currently selected. Can be nil.
    ///   - sliceLabelView: The view that should be displayed on top of each pie chart slice. If the fraction of a given slice is smaller than the visibility threshold defined in the DYPieChartSettings, the label view will be shown outside the pie chart. Return an EmptyView if no label should be displayed.
    ///   - shouldHideMultiFractionSliceOnSelection: This Bool determines whether or not a slice should be hidden on selection in case the DYChartFraction struct of the slice has at least two elements in the detailFractions array. Setting this value to true only makes sense if another DYPieChartView or other view (visualizing the detailFractions) is shown once the slice disappears. Default is false.
    ///   - animationNamespace: set the @Namespace property in the parent view of your main DYPieChartView and pass it into this initializer. This only has an effect in conjunction with a matchedGeometryEffect property set on a second DYPieChartView - see the property shouldHideMultiFractionSliceOnSelection.
    ///  - settings: settings struct. if you don't set this parameter, all values set will be the default values - see DYPieChartSettings for details.
    public init(data: [DYPieFraction], selectedSlice: Binding<DYPieFraction?>, sliceLabelView: @escaping (DYPieFraction)->L,  animationNamespace: Namespace.ID) {
        self.data  = data
        self._selectedSlice = selectedSlice
        self.sliceLabelView = sliceLabelView
        self.animationNamespace = animationNamespace
        self.settings = DYPieChartSettings()
    }
    
    public var body: some View {
        
        GeometryReader {proxy in
            ZStack(alignment: .center) {
                ForEach(self.data) { fraction in
                    
                    if self.showSliceCondition(fraction: fraction) {
                        PieChartSlice(startAngle: self.startAngleFor(fraction: fraction) , endAngle: self.endAngleFor(fraction: fraction))
                            .fill(fraction.color, opacity: 1, strokeWidth: settings.sliceOutlineWidth, strokeColor: settings.sliceOutlineColor)
                            .scaleEffect(selectedSlice == fraction && self.settings.allowUserInteraction ? settings.selectedSliceScaleEffect : 1, anchor: .center)
                            .shadow(color: self.selectedSliceShadow(fraction: fraction).color, radius: self.selectedSliceShadow(fraction: fraction).radius, x: self.selectedSliceShadow(fraction: fraction).x, y: self.selectedSliceShadow(fraction: fraction).y)
                            .matchedGeometryEffect(id: fraction.id, in: animationNamespace)
                            .onTapGesture {
                                if self.settings.allowUserInteraction {
                                    withAnimation(.default) {
                                        if self.selectedSlice != fraction {
                                            self.selectedSlice = fraction
                                        } else {
                                            self.selectedSlice = nil
                                        }
                                    }
                                }
                            }
                    }
                }.mask(Circle().stroke(Color.black, lineWidth: min(proxy.size.width, proxy.size.height) * (1 - settings.innerCircleRadiusFraction)))
                
                ForEach(self.data) { fraction in
                    if self.showSliceCondition(fraction: fraction) {
                        self.sliceLabelView(fraction)
                            .offset(self.labelOffsetFor(fraction: fraction, diameter: min(proxy.size.width, proxy.size.height)))
                            .scaleEffect(self.selectedSlice == fraction ? settings.selectedSliceScaleEffect: 1, anchor: .center)
                            .allowsHitTesting(false)

                    }
                }
            }
        }
          
    }
    
    private func selectedSliceShadow(fraction: DYPieFraction)->Shadow {
        
        if self.selectedSlice != fraction
            || self.settings.allowUserInteraction == false  {
            return Shadow(color: .clear, radius: 0, x: 0, y: 0)
        } else {
            return self.settings.selectedSliceDropShadow
        }
        
    }
    
    private func showSliceCondition(fraction: DYPieFraction)->Bool {
        
        if fraction.detailFractions.count < 2 || settings.shouldHideMultiFractionSliceOnSelection == false  {
            return true
        } else {
            return fraction != self.selectedSlice
        }
      
    }

    
    private func cumulativeFractionValueUpUntil(fraction: DYPieFraction)->Double {
        
        var currentValue:Double = 0
        var index = 0
        var currentId = self.data[0].id
        
        while currentId != fraction.id {
            let currentFraction = self.data[index]
            currentId = currentFraction.id
            if currentFraction.id != fraction.id {
                currentValue += currentFraction.value
            }
            index += 1
        }
        return currentValue
    }
        

    private func startAngleFor(fraction: DYPieFraction)->Angle {
        var value = self.cumulativeFractionValueUpUntil(fraction: fraction)
        value += fraction.value
       // print("value start: \(value)")
        let startAngleValue = (value / self.totalValue) * 360 - 90

        let angle = Angle(degrees: startAngleValue)
       // print("end angle \(angle)")
        return angle
    }
    
    private func endAngleFor(fraction: DYPieFraction)->Angle {
        let value:Double = self.cumulativeFractionValueUpUntil(fraction: fraction)
       // print("value start: \(value)")
        let startAngleValue = (value / self.totalValue) * 360 - 90
        let angle = Angle(degrees: startAngleValue)
       // print("start angle \(angle)")
        return angle

    }
    
    private func midAngleFor(fraction: DYPieFraction)->Angle {
        
        var value:Double = self.cumulativeFractionValueUpUntil(fraction: fraction)
        value += fraction.value / 2
        
        let midAngleValue = (value / self.totalValue) * 360 - 90
        let angle = Angle(degrees: midAngleValue)
       // print("end angle \(angle)")
        return angle
    }
    
    private func labelOffsetFor(fraction: DYPieFraction, diameter: CGFloat)->CGSize {
        let midAngle = self.midAngleFor(fraction: fraction)
        let fractionPercentage = fraction.value / self.totalValue
        let offsetFactor = fractionPercentage >= self.settings.minimumFractionForSliceLabelOffset ? 0.6 : 1.3
        let x = offsetFactor * Double(diameter / 2 ) * cos(midAngle.degrees * Double.pi / 180) / (1 -  (Double(settings.innerCircleRadiusFraction) / 2))
        let y = offsetFactor * Double(diameter / 2) * sin(midAngle.degrees * Double.pi / 180) / (1 -  (Double(settings.innerCircleRadiusFraction) / 2))
        
        return CGSize(width: x, height: y)
    }
    


}

// combine fill color






struct DYPieChartView_Previews: PreviewProvider {
    @Namespace static var placeholder
    static var previews: some View {
        let data = DYPieFraction.exampleData()
        DYPieChartView(data: data, selectedSlice: .constant(data.first!), sliceLabelView: { fraction in
            VStack {
                Text(fraction.title).font(.body)
                Text(fraction.value.toCurrencyString()).font(.callout).bold()
                Text(fraction.value.percentageString(totalValue: data.reduce(0) { $0 + $1.value})).font(.callout)
                
            }
        }, animationNamespace: Self.placeholder).padding()
    }

}

public protocol DYPieChartModifiableProperties where Self: View {
    
    associatedtype L: View  // slice label view
    var settings: DYPieChartSettings {get set }
    
}


public extension View where Self: DYPieChartModifiableProperties {
    
    /// inner circle radius fraction: value > 0 turns a pie chart into a doughnut chart.
    /// - Parameter fraction: value between 0 and 1. E.g. 0.5 means the inner circle radius is half as long as the pie chart radius. Default is 0.
    /// - Returns: modified DYPieChartView
    func innerCircleRadiusFraction(_ fraction: CGFloat)->DYPieChartView<L> {
        var modView = self
        if fraction < 0 || fraction > 1 {
            assertionFailure("inner circle radius fraction must be between 0 and 1 ")
        }
        modView.settings.innerCircleRadiusFraction = fraction
        return modView as! DYPieChartView<L>
    }
    
    /// userInteraction
    /// - Parameter enabled: if set to true, users can select pie chart slices by tapping. Default is true.
    /// - Returns: modified DYPieChartView
    func userInteraction(enabled: Bool)->DYPieChartView<L> {
        var modView = self
        modView.settings.allowUserInteraction = enabled
        return modView as! DYPieChartView<L>
    }
    
    /// selectedSlice visual effects
    /// - Parameters:
    ///   - scaleEffect: determines by which percentage the selected slice should enlarge when selected. default value is 1.05 (= 5%)
    ///   - dropShadow: shadow under the selected slice.
    /// - Returns: modified DYPieChartView
    func selectedSlice(scaleEffect: CGFloat = 1.05, dropShadow: Shadow = Shadow(color: .gray.opacity(0.7), radius: 10, x: 0, y: 0))->DYPieChartView<L> {
        var modView = self
        modView.settings.selectedSliceScaleEffect = scaleEffect
        modView.settings.selectedSliceDropShadow = dropShadow
        return modView as! DYPieChartView<L>
    }
    
    /// sliceBorderLine
    /// - Parameters:
    ///   - width: width of the slice border line.
    ///   - color: color of the slice border line.
    /// - Returns: modified DYPieChartView
    func sliceBorderLine(width: CGFloat = 1, color: Color = .primary)->DYPieChartView<L> {
        var modView = self
        modView.settings.sliceOutlineWidth = width
        modView.settings.sliceOutlineColor = color
        return modView as! DYPieChartView<L>
    }
    
    /// minimumFractionForSliceLabelOffset
    /// - Parameter fraction: slice fraction. If the fraction of a slice is lower than this value, the slice label will be show outside the pie chart instead of inside the slice.
    /// - Returns: modified DYPieChartView
    func minimumFractionForSliceLabelOffset(_ fraction: CGFloat = 0.1)->DYPieChartView<L> {
        var modView = self
        modView.settings.minimumFractionForSliceLabelOffset = fraction
        return modView as! DYPieChartView<L>
    }
    
    
    /// hideMultiFractionSliceOnSelection
    /// - Parameter hide:  if set to true, the selected slice will be hidden. This only makes sense in conjuction with a second pie chart that shows the detail slices of the hidden slice in the first pie chart. Default is false.
    /// - Returns: modified DYPieChartView
    func hideMultiFractionSliceOnSelection(_ hide: Bool = false)->DYPieChartView<L> {
        var modView = self
        modView.settings.shouldHideMultiFractionSliceOnSelection = hide
        return modView as! DYPieChartView<L>
    }
    
    
}




