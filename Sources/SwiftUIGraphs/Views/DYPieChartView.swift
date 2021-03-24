//
//  DYPieChartView.swift
//  
//
//  Created by Dominik Butz on 23/3/2021.
//

import SwiftUI

public struct DYPieChartView: View {
    
    
    @State private var selectedId:UUID?
    
    var data: [DYChartFraction] = []
    var valueConverter: (Double)->String
    var totalValue: Double {

        return data.reduce(0) { $0 + $1.value}
    }
    var innerCircleRadiusPercentage: CGFloat = 0
    
    public init(data: [DYChartFraction], valueConverter: @escaping (Double)->String) {
        self.data  = data
        self.valueConverter = valueConverter
        self.selectedId = data.first!.id
    }
    
    public var body: some View {
        
        GeometryReader {proxy in
            ZStack(alignment: .center) {
                ForEach(self.data) { fraction in
                    ZStack {
                        PieChartSlice(startAngle: self.startAngleFor(fraction: fraction) , endAngle: self.endAngleFor(fraction: fraction))
                            .foregroundColor(fraction.color)
                            .mask(Circle()
                                    .stroke(Color.black, lineWidth: min(proxy.size.width, proxy.size.height) * (1 - innerCircleRadiusPercentage))
                            )
                            .scaleEffect(self.selectedId == fraction.id ? 1.05 : 1, anchor: .center)
                        
                        if fraction.value / totalValue >= 0.15 {
                            VStack {
                                Text(fraction.title).font(.body)
                                Text(self.valueConverter(fraction.value)).font(.callout).bold()
                                Text(self.percentageStringFor(value: fraction.value)).font(.callout)
                            }.offset(self.labelOffsetFor(fraction: fraction, radius: min(proxy.size.width, proxy.size.height) / 2))
                        }
                    }.onTapGesture {
                        withAnimation {
                            if self.selectedId != fraction.id {
                                self.selectedId = fraction.id
                            } else {
                                self.selectedId = nil
                            }
                        }
                    }
                    
                }
            }.background(Circle().shadow(radius: 5))
        }
        
        
    }
    
//    private func indexOf(fraction: DYChartFraction)->Int {
//        let ids = self.data.map({$0.id})
//        return ids.firstIndex(of: fraction.id)!
//    }
    
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

        let x = Double(radius / 2 ) * cos(midAngle.degrees * Double.pi / 180) / (1 -  (Double(innerCircleRadiusPercentage) / 2))
        let y = Double(radius / 2) * sin(midAngle.degrees * Double.pi / 180) / (1 -  (Double(innerCircleRadiusPercentage) / 2))
        
        return CGSize(width: x, height: y)
    }
    
    private func percentageStringFor(value: Double)->String {
        let fractionValue = value / self.totalValue
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        return formatter.string(for: fractionValue)!
        
    }
  
}

public struct DYChartFraction: Identifiable {
    
    public var id: UUID
    public var value: Double
    public var color: Color
    public var title: String
    
    public init(value: Double, color: Color, title: String) {
        self.id = UUID()
        self.value = value
        self.color = color
        self.title = title
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
        DYPieChartView(data: [
                        DYChartFraction(value: 500, color: Color.blue, title: "Blue"),
            DYChartFraction(value: 100, color: .green, title: "Green"),
            DYChartFraction(value: 250, color: .orange, title: "Orange"), DYChartFraction(value: 150, color: .yellow, title: "Yellow")
                      
        ]) { (value) -> String in
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "USD"
            formatter.maximumFractionDigits = 2
            return formatter.string(for: value)!
            
        }.padding()
    }
}


