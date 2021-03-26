@_private(sourceFile: "DYPieChartView.swift") import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension DYPieChartView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 172)
        let data = DYChartFraction.exampleData()
        DYPieChartView(data: data, selectedId: .constant(data.first!.id)) { (value) -> String in
            return DYChartFraction.exampleFormatter(value: value)
            
        }.padding()
    #sourceLocation()
    }
}

extension PieChartSlice {
    @_dynamicReplacement(for: path(in:)) private func __preview__path(in rect: CGRect) -> Path {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 154)
        let center = CGPoint.init(x: (rect.origin.x + rect.width)/2, y: (rect.origin.y + rect.height)/2)
        let radius = min(center.x, center.y)
            let path = Path { p in
                p.addArc(center: center,
                         radius: radius,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: __designTimeBoolean("#40639.[2].[2].[2].value.arg[0].value.[0].modifier[0].arg[4].value", fallback: true))
                p.addLine(to: center)
            
            }
            return path
   #sourceLocation()
    }
}

extension DYPieChartView {
    @_dynamicReplacement(for: percentageStringFor(value:)) private func __preview__percentageStringFor(value: Double)->String {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 139)
        let fractionValue = value / self.totalValue
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        return formatter.string(for: fractionValue)!
        
    #sourceLocation()
    }
}

extension DYPieChartView {
    @_dynamicReplacement(for: labelOffsetFor(fraction:radius:)) private func __preview__labelOffsetFor(fraction: DYChartFraction, radius: CGFloat)->CGSize {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 130)
        let midAngle = self.midAngleFor(fraction: fraction)

        let x = Double(radius / 2 ) * cos(midAngle.degrees * Double.pi / 180) / (1 -  (Double(settings.innerCircleFraction) / 2))
        let y = Double(radius / 2) * sin(midAngle.degrees * Double.pi / 180) / (1 -  (Double(settings.innerCircleFraction) / 2))
        
        return CGSize(width: x, height: y)
    #sourceLocation()
    }
}

extension DYPieChartView {
    @_dynamicReplacement(for: midAngleFor(fraction:)) private func __preview__midAngleFor(fraction: DYChartFraction)->Angle {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 120)
        
        var value:Double = self.cumulativeFractionValueUpUntil(fraction: fraction)
        value += fraction.value / 2
        
        let midAngleValue = (value / self.totalValue) * 360 - 90
        let angle = Angle(degrees: midAngleValue)
       // print("end angle \(angle)")
        return angle
    #sourceLocation()
    }
}

extension DYPieChartView {
    @_dynamicReplacement(for: endAngleFor(fraction:)) private func __preview__endAngleFor(fraction: DYChartFraction)->Angle {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 109)
        let value:Double = self.cumulativeFractionValueUpUntil(fraction: fraction)
       // print("value start: \(value)")
        let startAngleValue = (value / self.totalValue) * 360 - 90
        let angle = Angle(degrees: startAngleValue)
       // print("start angle \(angle)")
        return angle

    #sourceLocation()
    }
}

extension DYPieChartView {
    @_dynamicReplacement(for: startAngleFor(fraction:)) private func __preview__startAngleFor(fraction: DYChartFraction)->Angle {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 98)
        var value = self.cumulativeFractionValueUpUntil(fraction: fraction)
        value += fraction.value
       // print("value start: \(value)")
        let startAngleValue = (value / self.totalValue) * 360 - 90

        let angle = Angle(degrees: startAngleValue)
       // print("end angle \(angle)")
        return angle
    #sourceLocation()
    }
}

extension DYPieChartView {
    @_dynamicReplacement(for: cumulativeFractionValueUpUntil(fraction:)) private func __preview__cumulativeFractionValueUpUntil(fraction: DYChartFraction)->Double {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 81)
        
        var currentValue:Double = __designTimeInteger("#40639.[1].[8].[0].value", fallback: 0)
        var index = __designTimeInteger("#40639.[1].[8].[1].value", fallback: 0)
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
    #sourceLocation()
    }
}

extension DYPieChartView {
    @_dynamicReplacement(for: sliceText(fraction:circleRadius:)) private func __preview__sliceText(fraction: DYChartFraction, circleRadius: CGFloat)->some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 64)
        AnyView(VStack {
            Text(fraction.title).font(.body)
            Text(self.valueConverter(fraction.value)).font(.callout).bold()
            if settings.showPercentageInSliceText {
                Text(self.percentageStringFor(value: fraction.value)).font(.callout)
            }
        }.offset(self.labelOffsetFor(fraction: fraction, radius: circleRadius))
        .allowsHitTesting(__designTimeBoolean("#40639.[1].[7].[0].modifier[1].arg[0].value", fallback: false)))
    #sourceLocation()
    }
}

extension DYPieChartView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 31)
        
        AnyView(GeometryReader {proxy in
            ZStack(alignment: .center) {
                ForEach(self.data) { fraction in
                        PieChartSlice(startAngle: self.startAngleFor(fraction: fraction) , endAngle: self.endAngleFor(fraction: fraction))
                            .foregroundColor(fraction.color)
                            .mask(Circle()
                                    .stroke(Color.black, lineWidth: min(proxy.size.width, proxy.size.height) * (1 - settings.innerCircleFraction))
                            )
                            .scaleEffect(self.selectedId == fraction.id ? settings.selectedSliceScaleEffect : 1, anchor: .center)
                            .onTapGesture {
                                withAnimation {
                                    if self.selectedId != fraction.id {
                                        self.selectedId = fraction.id
                                    } else {
                                        self.selectedId = nil
                                    }
                                }
                            }
                    
                }
                
                ForEach(self.data) { fraction in
                    if fraction.value / totalValue >= settings.sliceTextVisibilityThreshold {
                        self.sliceText(fraction: fraction, circleRadius: min(proxy.size.width, proxy.size.height) / 2).scaleEffect(self.selectedId == fraction.id ? settings.selectedSliceScaleEffect: 1, anchor: .center)
                    }
                }
            }.background(Circle().shadow(radius: __designTimeInteger("#40639.[1].[6].property.[0].[0].arg[0].value.[0].modifier[0].arg[0].value.modifier[0].arg[0].value", fallback: 5)))
        })
        
        
    #sourceLocation()
    }
}

extension DYPieChartView {
    @_dynamicReplacement(for: totalValue) private var __preview__totalValue: Double {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYPieChartView.swift", line: 18)

        return data.reduce(__designTimeInteger("#40639.[1].[3].property.[0].[0].modifier[0].arg[0].value", fallback: 0)) { $0 + $1.value}
    #sourceLocation()
    }
}

import struct SwiftUIGraphs.DYPieChartView
import struct SwiftUIGraphs.PieChartSlice
import struct SwiftUIGraphs.DYPieChartView_Previews