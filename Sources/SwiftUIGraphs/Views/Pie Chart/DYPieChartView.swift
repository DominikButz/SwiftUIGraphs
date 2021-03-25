//
//  DYPieChartView.swift
//  
//
//  Created by Dominik Butz on 23/3/2021.
//

import SwiftUI

public struct DYPieChartView<L: View>: View {
    
    @Binding private var selectedId:String?
    
    var data: [DYChartFraction] = []

    var sliceLabelView: (DYChartFraction)->L
    var totalValue: Double {

        return data.reduce(0) { $0 + $1.value}
    }
    var settings: DYPieChartSettings
    
    
    /// DYPieChartView initializer
    /// - Parameters:
    ///   - data: Array of DYChartFraction structs. The fraction values will not be reordered, so the slices will be arranged exactly in the order of the DYChartFraction structs in the array - starting at 12 o'clock, in clockwise direction.
    ///   - selectedId: The id of the DYChartFraction that is currently selected. Can be nil.
    ///   - sliceLabelView: The view that should be displayed on top of each pie chart slice. If the fraction of a given slice is smaller than the visibility threshold defined in the DYPieChartSettings, the label view will not be shown. Return an EmptyView if no label should be displayed.
    ///   - settings: DYPieChartSettings
    public init(data: [DYChartFraction], selectedId: Binding<String?>, sliceLabelView: @escaping (DYChartFraction)->L, settings: DYPieChartSettings = DYPieChartSettings()) {
        self.data  = data
        self._selectedId = selectedId
        self.sliceLabelView = sliceLabelView
        self.settings = settings
    }
    
    public var body: some View {
        
        GeometryReader {proxy in
            ZStack(alignment: .center) {
                ForEach(self.data) { fraction in
                        PieChartSlice(startAngle: self.startAngleFor(fraction: fraction) , endAngle: self.endAngleFor(fraction: fraction))
                            .foregroundColor(fraction.color)
                            .scaleEffect(self.selectedId == fraction.id ? settings.selectedSliceScaleEffect : 1, anchor: .center)
                            .shadow(radius: self.selectedId == fraction.id ? 5 : 0)
                            .onTapGesture {
                                withAnimation {
                                    if self.selectedId != fraction.id {
                                        self.selectedId = fraction.id
                                    } else {
                                        self.selectedId = nil
                                    }
                                }
                            }
                    
                }.mask(Circle().stroke(Color.black, lineWidth: min(proxy.size.width, proxy.size.height) * (1 - settings.innerCircleRadiusFraction)))
                
                ForEach(self.data) { fraction in
                    if fraction.value / totalValue >= settings.sliceLabelVisibilityThreshold {
                        self.sliceLabelView(fraction)
                            .offset(self.labelOffsetFor(fraction: fraction, radius: min(proxy.size.width, proxy.size.height) / 2))
                            .scaleEffect(self.selectedId == fraction.id ? settings.selectedSliceScaleEffect: 1, anchor: .center)
                            .allowsHitTesting(false)

                    }
                }
            }
        }
        
        
    }

    
    private func cumulativeFractionValueUpUntil(fraction: DYChartFraction)->Double {
        
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
        

    private func startAngleFor(fraction: DYChartFraction)->Angle {
        var value = self.cumulativeFractionValueUpUntil(fraction: fraction)
        value += fraction.value
       // print("value start: \(value)")
        let startAngleValue = (value / self.totalValue) * 360 - 90

        let angle = Angle(degrees: startAngleValue)
       // print("end angle \(angle)")
        return angle
    }
    
    private func endAngleFor(fraction: DYChartFraction)->Angle {
        let value:Double = self.cumulativeFractionValueUpUntil(fraction: fraction)
       // print("value start: \(value)")
        let startAngleValue = (value / self.totalValue) * 360 - 90
        let angle = Angle(degrees: startAngleValue)
       // print("start angle \(angle)")
        return angle

    }
    
    private func midAngleFor(fraction: DYChartFraction)->Angle {
        
        var value:Double = self.cumulativeFractionValueUpUntil(fraction: fraction)
        value += fraction.value / 2
        
        let midAngleValue = (value / self.totalValue) * 360 - 90
        let angle = Angle(degrees: midAngleValue)
       // print("end angle \(angle)")
        return angle
    }
    
    private func labelOffsetFor(fraction: DYChartFraction, radius: CGFloat)->CGSize {
        let midAngle = self.midAngleFor(fraction: fraction)

        let x = Double(radius / 2 ) * cos(midAngle.degrees * Double.pi / 180) / (1 -  (Double(settings.innerCircleRadiusFraction) / 2))
        let y = Double(radius / 2) * sin(midAngle.degrees * Double.pi / 180) / (1 -  (Double(settings.innerCircleRadiusFraction) / 2))
        
        return CGSize(width: x, height: y)
    }

}


struct PieChartSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
   func path(in rect: CGRect) -> Path {
        let center = CGPoint.init(x: (rect.origin.x + rect.width)/2, y: (rect.origin.y + rect.height)/2)
        let radius = min(center.x, center.y)
            let path = Path { p in
                p.addArc(center: center,
                         radius: radius,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: true)
                p.addLine(to: center)
            
            }
            return path
   }
}


struct DYPieChartView_Previews: PreviewProvider {
    static var previews: some View {
        let data = DYChartFraction.exampleData()
        DYPieChartView(data: data, selectedId: .constant(data.first!.id), sliceLabelView: { fraction in
            VStack {
                Text(fraction.title).font(.body)
                Text(DYChartFraction.exampleFormatter(value: fraction.value)).font(.callout).bold()
                Text(fraction.value.percentageString(totalValue: data.reduce(0) { $0 + $1.value})).font(.callout)
                
            }
        }, settings: DYPieChartSettings(innerCircleRadiusFraction: 0.3)).padding()
    }

}


