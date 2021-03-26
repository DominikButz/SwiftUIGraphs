@_private(sourceFile: "DYLineChartView.swift") import SwiftUIGraphsExample
import SwiftUI
import SwiftUI

extension DYLineChartView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 257)
        AnyView(__designTimeSelection(GeometryReader { proxy in
            __designTimeSelection(DYLineChartView(dataPoints: __designTimeSelection(DYDataPoint.exampleData, "#1706.[2].[0].property.[0].[0].arg[0].value.[0].arg[0].value"), selectedIndex: .constant(__designTimeInteger("#1706.[2].[0].property.[0].[0].arg[0].value.[0].arg[1].value.arg[0].value", fallback: 0))).frame(maxHeight: proxy.size.height / 3), "#1706.[2].[0].property.[0].[0].arg[0].value.[0]")
        }, "#1706.[2].[0].property.[0].[0]"))
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: yScaleFor(height:)) private func __preview__yScaleFor(height: CGFloat)->CGFloat {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 231)
        
        let yValues = dataPoints.map({__designTimeSelection($0.yValue, "#1706.[1].[19].[0].value.modifier[0].arg[0].value.[0]")})
        
        
        let maxY = yValues.reduce(__designTimeInteger("#1706.[1].[19].[1].value.modifier[0].arg[0].value", fallback: 0)) { (res, value) -> Double in
            return __designTimeSelection(max(__designTimeSelection(res, "#1706.[1].[19].[1].value.modifier[0].arg[1].value.[0].arg[0].value"), __designTimeSelection(value, "#1706.[1].[19].[1].value.modifier[0].arg[1].value.[0].arg[1].value")), "#1706.[1].[19].[1].value.modifier[0].arg[1].value.[0]")
        }
        let maxYRoundedUp = maxY.rounded(digits: __designTimeInteger("#1706.[1].[19].[2].value.modifier[0].arg[0].value", fallback: 3), roundingRule: .up)
       
        let minY = yValues.reduce(__designTimeInteger("#1706.[1].[19].[3].value.modifier[0].arg[0].value", fallback: 0), {(res, value)->Double in
           return __designTimeSelection(min(__designTimeSelection(res, "#1706.[1].[19].[3].value.modifier[0].arg[1].value.[0].arg[0].value"), __designTimeSelection(value, "#1706.[1].[19].[3].value.modifier[0].arg[1].value.[0].arg[1].value")), "#1706.[1].[19].[3].value.modifier[0].arg[1].value.[0]")
       })
        
        let minYRoundedDown = minY.rounded(digits: __designTimeInteger("#1706.[1].[19].[4].value.modifier[0].arg[0].value", fallback: 3), roundingRule: .down)

       let maxMinDiff = maxYRoundedUp - minYRoundedDown
       return  height / CGFloat(maxMinDiff)

    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: dragOnEnded(value:geo:)) private func __preview__dragOnEnded(value: DragGesture.Value, geo: GeometryProxy) {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 218)
        let xPos = value.location.x
        self.isSelected = false
        let index = (xPos - leadingMargin) / (((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)))

        if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < CGFloat(self.dataPoints.count - 1) {
            self.selectedIndex = Int(index) + 1
        } else {
            self.selectedIndex = Int(index)
        }
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: dragOnChanged(value:geo:)) private func __preview__dragOnChanged(value: DragGesture.Value, geo: GeometryProxy) {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 197)
        let xPos = value.location.x
        self.isSelected = true
        let index = (xPos - leadingMargin) / (((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)))

        if index > 0 && index < CGFloat(self.dataPoints.count - 1) {
            let m = (dataPoints[Int(index) + 1].yValue - dataPoints[Int(index)].yValue)
            self.selectedYPos = CGFloat(m) * index.truncatingRemainder(dividingBy: 1) + CGFloat(dataPoints[Int(index)].yValue)
        }


        if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < CGFloat(self.dataPoints.count  - 1) {
            self.selectedIndex = Int(index) + 1
        } else {
            self.selectedIndex = Int(index)
        }
        self.selectedXPos = min(max(leadingMargin, xPos), geo.size.width - leadingMargin)
        self.lineOffset = min(max(leadingMargin, xPos), geo.size.width - leadingMargin)
        
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: addUserInteraction()) private func __preview__addUserInteraction() -> some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 155)
        AnyView(__designTimeSelection(GeometryReader { geo in

            let yScale = self.yScaleFor(height: __designTimeSelection(geo.size.height, "#1706.[1].[16].[0].arg[0].value.[0].value.modifier[0].arg[0].value"))

            __designTimeSelection(ZStack(alignment: .leading) {
                
                __designTimeSelection(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].arg[2].value", fallback: 0))
                                .frame(width: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value", fallback: 2))
                                .opacity(__designTimeSelection(self.isSelected, "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[1].arg[0].value.if") ? __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[1].arg[0].value.then", fallback: 1) : __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[1].arg[0].value.else", fallback: 0)) // hide the vertical indicator line if user not touching the chart
                                .overlay(
                                    __designTimeSelection(Circle()
                                        .frame(width: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[0].arg[0].value", fallback: 24), height: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[0].arg[1].value", fallback: 24), alignment: .center)
                                        .foregroundColor(__designTimeSelection(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[1].arg[0].value.arg[2].value", fallback: 0)), "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[1].arg[0].value"))
                                        .opacity(__designTimeFloat("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[2].arg[0].value", fallback: 0.2))
                                        .overlay(
                                            __designTimeSelection(Circle()
                                                .fill()
                                                .frame(width: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[3].arg[0].value.modifier[1].arg[0].value", fallback: 12), height: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[3].arg[0].value.modifier[1].arg[1].value", fallback: 12), alignment: .center)
                                                .foregroundColor(__designTimeSelection(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[3].arg[0].value.modifier[2].arg[0].value.arg[2].value", fallback: 0)), "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[3].arg[0].value.modifier[2].arg[0].value")), "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[3].arg[0].value")
                                        )
                                        .offset(x: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[4].arg[0].value", fallback: 0), y: isSelected ? CGFloat(self.dataPoints.count) - (selectedYPos * yScale) : CGFloat(self.dataPoints.count) - (CGFloat(dataPoints[selectedIndex].yValue) * yScale)), "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value")
                                    , alignment: .bottom)

                    .offset(x: isSelected ? lineOffset : leadingMargin + ((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1) ) * CGFloat(selectedIndex), y: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[3].arg[1].value", fallback: 0))
                                .animation(__designTimeSelection(Animation.spring().speed(__designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[4].arg[0].value.modifier[0].arg[0].value", fallback: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[4].arg[0].value.arg[0].value", fallback: 4))), "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[4].arg[0].value")), "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0]")
                
                __designTimeSelection(Color.white.opacity(__designTimeFloat("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[0].arg[0].value", fallback: 0.1))
                    .gesture(
                        __designTimeSelection(DragGesture(minimumDistance: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[1].arg[0].value.arg[0].value", fallback: 0))
                            .onChanged { dragValue in
                               __designTimeSelection(dragOnChanged(value: __designTimeSelection(dragValue, "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[1].arg[0].value.modifier[0].arg[0].value.[0].arg[0].value"), geo: __designTimeSelection(geo, "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[1].arg[0].value.modifier[0].arg[0].value.[0].arg[1].value")), "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[1].arg[0].value.modifier[0].arg[0].value.[0]")
                            }
                            .onEnded { dragValue in
                                __designTimeSelection(dragOnEnded(value: __designTimeSelection(dragValue, "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[1].arg[0].value.modifier[1].arg[0].value.[0].arg[0].value"), geo: __designTimeSelection(geo, "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[1].arg[0].value.modifier[1].arg[0].value.[0].arg[1].value")), "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[1].arg[0].value.modifier[1].arg[0].value.[0]")
                            }, "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[1].arg[0].value")
                    ), "#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1]")
            }, "#1706.[1].[16].[0].arg[0].value.[1]")

        }, "#1706.[1].[16].[0]"))
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: points()) private func __preview__points()->some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 137)
        AnyView(__designTimeSelection(GeometryReader { geo in

            let yScale = self.yScaleFor(height: __designTimeSelection(geo.size.height, "#1706.[1].[15].[0].arg[0].value.[0].value.modifier[0].arg[0].value"))

            __designTimeSelection(ForEach(__designTimeSelection(dataPoints.indices, "#1706.[1].[15].[0].arg[0].value.[1].arg[0].value")) { i in
                __designTimeSelection(Circle()
                    .stroke(style: __designTimeSelection(StrokeStyle(lineWidth: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value.arg[0].value", fallback: 4), lineCap: .round, lineJoin: .round, miterLimit: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value.arg[3].value", fallback: 80), dash: [], dashPhase: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value.arg[5].value", fallback: 0)), "#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value"))
                    .frame(width: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[1].arg[0].value", fallback: 10), height: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[1].arg[1].value", fallback: 10), alignment: .center)
                    .foregroundColor(__designTimeSelection(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.arg[2].value", fallback: 0)), "#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value"))
                    .background(__designTimeSelection(Color(.systemBackground), "#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[3].arg[0].value"))
                    .cornerRadius(__designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[4].arg[0].value", fallback: 5))
                    .offset(x: leadingMargin + ((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)) * CGFloat(i) - 5, y: (geo.size.height - (CGFloat(dataPoints[i].yValue) * yScale)) - 5), "#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0]")
            }, "#1706.[1].[15].[0].arg[0].value.[1]")
        }, "#1706.[1].[15].[0]"))
        
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: gradient()) private func __preview__gradient() -> some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 103)
        AnyView(__designTimeSelection(LinearGradient(gradient: __designTimeSelection(Gradient(colors: [__designTimeSelection(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[14].[0].arg[0].value.arg[0].value.[0].arg[2].value", fallback: 0)), "#1706.[1].[14].[0].arg[0].value.arg[0].value.[0]"), .white]), "#1706.[1].[14].[0].arg[0].value"), startPoint: .top, endPoint: .bottom)
            .padding(.leading, __designTimeSelection(leadingMargin, "#1706.[1].[14].[0].modifier[0].arg[1].value"))
            .padding(.trailing, __designTimeSelection(trailingMargin, "#1706.[1].[14].[0].modifier[1].arg[1].value"))
            .padding(.bottom, __designTimeInteger("#1706.[1].[14].[0].modifier[2].arg[1].value", fallback: 1))
            .opacity(__designTimeFloat("#1706.[1].[14].[0].modifier[3].arg[0].value", fallback: 0.8))
            .mask(
                 __designTimeSelection(GeometryReader { geo in
                     __designTimeSelection(Path { p in

                        let yScale = self.yScaleFor(height: __designTimeSelection(geo.size.height, "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[0].value.modifier[0].arg[0].value"))

                         var index: CGFloat = __designTimeInteger("#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[1].value", fallback: 0)

                         // Move to the starting point on graph
                         __designTimeSelection(p.move(to: __designTimeSelection(CGPoint(x: __designTimeSelection(leadingMargin, "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[2].modifier[0].arg[0].value.arg[0].value"), y: geo.size.height - (CGFloat(dataPoints[Int(index)].yValue) * yScale)), "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[2].modifier[0].arg[0].value")), "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[2]")

                         // draw lines
                         for _ in __designTimeSelection(dataPoints, "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[3].sequence") {
                             if index != 0 {
                                __designTimeSelection(p.addLine(to: __designTimeSelection(CGPoint(x: leadingMargin + ((geo.size.width - marginSum) / CGFloat(dataPoints.count - 1)) * index, y: geo.size.height - (CGFloat(dataPoints[Int(index)].yValue) * yScale)), "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[3].[0].[0].[0].modifier[0].arg[0].value")), "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[3].[0].[0].[0]")
                             }
                             index += 1
                         }

                         // Finally close the subpath off by looping around to the beginning point.
                         __designTimeSelection(p.addLine(to: __designTimeSelection(CGPoint(x: leadingMargin + ((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)) * (index - 1), y: __designTimeSelection(geo.size.height, "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[4].modifier[0].arg[0].value.arg[1].value")), "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[4].modifier[0].arg[0].value")), "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[4]")
                         __designTimeSelection(p.addLine(to: __designTimeSelection(CGPoint(x: __designTimeSelection(leadingMargin, "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[5].modifier[0].arg[0].value.arg[0].value"), y: __designTimeSelection(geo.size.height, "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[5].modifier[0].arg[0].value.arg[1].value")), "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[5].modifier[0].arg[0].value")), "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[5]")
                         __designTimeSelection(p.closeSubpath(), "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[6]")
                     }, "#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0]")
                 }, "#1706.[1].[14].[0].modifier[4].arg[0].value")
             ), "#1706.[1].[14].[0]"))
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: line()) private func __preview__line()->some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 79)
        AnyView(__designTimeSelection(GeometryReader { geo in
            __designTimeSelection(Path { p in

                let yScale = self.yScaleFor(height: __designTimeSelection(geo.size.height, "#1706.[1].[13].[0].arg[0].value.[0].arg[0].value.[0].value.modifier[0].arg[0].value"))

                var index: CGFloat = __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].arg[0].value.[1].value", fallback: 0)

                // move to first dataPoint
                __designTimeSelection(p.move(to: __designTimeSelection(CGPoint(x: __designTimeSelection(leadingMargin, "#1706.[1].[13].[0].arg[0].value.[0].arg[0].value.[2].modifier[0].arg[0].value.arg[0].value"), y: geo.size.height - (CGFloat(dataPoints[0].yValue) * yScale)), "#1706.[1].[13].[0].arg[0].value.[0].arg[0].value.[2].modifier[0].arg[0].value")), "#1706.[1].[13].[0].arg[0].value.[0].arg[0].value.[2]")

                for _ in __designTimeSelection(dataPoints, "#1706.[1].[13].[0].arg[0].value.[0].arg[0].value.[3].sequence") {
                    if index != 0 {
                        __designTimeSelection(p.addLine(to: __designTimeSelection(CGPoint(x: leadingMargin + ((geo.size.width - marginSum) / CGFloat(dataPoints.count - 1)) * index, y: geo.size.height - (CGFloat(dataPoints[Int(index)].yValue) * yScale)), "#1706.[1].[13].[0].arg[0].value.[0].arg[0].value.[3].[0].[0].[0].modifier[0].arg[0].value")), "#1706.[1].[13].[0].arg[0].value.[0].arg[0].value.[3].[0].[0].[0]")
                    }
                    index += 1
                }
            }
            .stroke(style: __designTimeSelection(StrokeStyle(lineWidth: __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].modifier[0].arg[0].value.arg[0].value", fallback: 2), lineCap: .round, lineJoin: .round, miterLimit: __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].modifier[0].arg[0].value.arg[3].value", fallback: 80), dash: [], dashPhase: __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].modifier[0].arg[0].value.arg[5].value", fallback: 0)), "#1706.[1].[13].[0].arg[0].value.[0].modifier[0].arg[0].value"))
            .foregroundColor(__designTimeSelection(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].modifier[1].arg[0].value.arg[2].value", fallback: 0)), "#1706.[1].[13].[0].arg[0].value.[0].modifier[1].arg[0].value")), "#1706.[1].[13].[0].arg[0].value.[0]")
        }, "#1706.[1].[13].[0]"))
 
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: grid()) private func __preview__grid() -> some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 58)
       AnyView(__designTimeSelection(GeometryReader { geo in
           __designTimeSelection(VStack(spacing: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[0].value", fallback: 0)) {
               __designTimeSelection(Color.primary.frame(height: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[0].modifier[0].arg[0].value", fallback: 1), alignment: .center), "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[0]")
               __designTimeSelection(HStack(spacing: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[0].value", fallback: 0)) {
                   __designTimeSelection(Color.clear
                       .frame(width: __designTimeSelection(leadingMargin, "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[0].value"), height: __designTimeSelection(geo.size.height, "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[1].value")), "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[0]")
                    __designTimeSelection(ForEach(0..<(self.dataPoints.count - 1)) { i in
                       __designTimeSelection(Color.primary.frame(width: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[0].value", fallback: 1), height: __designTimeSelection(geo.size.height, "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[1].value"), alignment: .center), "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0]")
                       __designTimeSelection(Spacer(), "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1]")

                   }, "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[1]")
                   __designTimeSelection(Color.primary.frame(width: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[2].modifier[0].arg[0].value", fallback: 1), height: __designTimeSelection(geo.size.height, "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[2].modifier[0].arg[1].value"), alignment: .center), "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[2]")
                   __designTimeSelection(Color.clear
                       .frame(width: __designTimeSelection(trailingMargin, "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[3].modifier[0].arg[0].value"), height: __designTimeSelection(geo.size.height, "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[3].modifier[0].arg[1].value")), "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[3]")
               }, "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1]")
               __designTimeSelection(Color.primary.frame(height: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[2].modifier[0].arg[0].value", fallback: 1), alignment: .center), "#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[2]")
           }, "#1706.[1].[12].[0].arg[0].value.[0]")
       }, "#1706.[1].[12].[0]"))
   #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 38)
        AnyView(__designTimeSelection(ZStack {
            __designTimeSelection(self.grid().opacity(__designTimeFloat("#1706.[1].[11].property.[0].[0].arg[0].value.[0].modifier[1].arg[0].value", fallback: 0.2)), "#1706.[1].[11].property.[0].[0].arg[0].value.[0]")
           if self.showWithAnimation {
                __designTimeSelection(Group {
                    __designTimeSelection(self.line(), "#1706.[1].[11].property.[0].[0].arg[0].value.[1].[0].[0].arg[0].value.[0]")
                    __designTimeSelection(self.gradient(), "#1706.[1].[11].property.[0].[0].arg[0].value.[1].[0].[0].arg[0].value.[1]")
                    __designTimeSelection(self.points(), "#1706.[1].[11].property.[0].[0].arg[0].value.[1].[0].[0].arg[0].value.[2]")
                    __designTimeSelection(self.addUserInteraction(), "#1706.[1].[11].property.[0].[0].arg[0].value.[1].[0].[0].arg[0].value.[3]")
                }.transition(__designTimeSelection(AnyTransition.opacity, "#1706.[1].[11].property.[0].[0].arg[0].value.[1].[0].[0].modifier[0].arg[0].value")), "#1706.[1].[11].property.[0].[0].arg[0].value.[1].[0].[0]")
            }
        }.background(__designTimeSelection(Color(.systemBackground), "#1706.[1].[11].property.[0].[0].modifier[0].arg[0].value"))
        .onAppear {
            __designTimeSelection(withAnimation(__designTimeSelection(Animation.easeIn(duration: 1.2).delay(__designTimeInteger("#1706.[1].[11].property.[0].[0].modifier[1].arg[0].value.[0].arg[0].value.modifier[0].arg[0].value", fallback: __designTimeInteger("#1706.[1].[11].property.[0].[0].modifier[1].arg[0].value.[0].arg[0].value.arg[0].value", fallback: 1))), "#1706.[1].[11].property.[0].[0].modifier[1].arg[0].value.[0].arg[0].value")) {
                self.showWithAnimation = true
            }, "#1706.[1].[11].property.[0].[0].modifier[1].arg[0].value.[0]")
        }, "#1706.[1].[11].property.[0].[0]"))
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: marginSum) private var __preview__marginSum: CGFloat {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 27)
        return leadingMargin + trailingMargin
    #sourceLocation()
    }
}

import struct SwiftUIGraphsExample.DYLineChartView
import struct SwiftUIGraphsExample.DYLineChartView_Previews