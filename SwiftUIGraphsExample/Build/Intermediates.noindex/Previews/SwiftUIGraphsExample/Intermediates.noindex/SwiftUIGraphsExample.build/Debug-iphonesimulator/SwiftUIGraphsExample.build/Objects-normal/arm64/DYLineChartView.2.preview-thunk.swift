@_private(sourceFile: "DYLineChartView.swift") import SwiftUIGraphsExample
import SwiftUI
import SwiftUI

extension DYLineChartView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 257)
        AnyView(GeometryReader { proxy in
            DYLineChartView(dataPoints: DYDataPoint.exampleData, selectedIndex: .constant(__designTimeInteger("#1706.[2].[0].property.[0].[0].arg[0].value.[0].arg[1].value.arg[0].value", fallback: 0))).frame(maxHeight: proxy.size.height / 3)
        })
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: yScaleFor(height:)) private func __preview__yScaleFor(height: CGFloat)->CGFloat {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 231)
        
        let yValues = dataPoints.map({$0.yValue})
        
        
        let maxY = yValues.reduce(__designTimeInteger("#1706.[1].[19].[1].value.modifier[0].arg[0].value", fallback: 0)) { (res, value) -> Double in
            return max(res, value)
        }
        let maxYRoundedUp = maxY.rounded(digits: __designTimeInteger("#1706.[1].[19].[2].value.modifier[0].arg[0].value", fallback: 3), roundingRule: .up)
       
        let minY = yValues.reduce(__designTimeInteger("#1706.[1].[19].[3].value.modifier[0].arg[0].value", fallback: 0), {(res, value)->Double in
           return min(res, value)
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
        AnyView(GeometryReader { geo in

            let yScale = self.yScaleFor(height: geo.size.height)

            ZStack(alignment: .leading) {
                
                Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].arg[2].value", fallback: 0))
                                .frame(width: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value", fallback: 2))
                                .opacity(self.isSelected ? __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[1].arg[0].value.then", fallback: 1) : __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[1].arg[0].value.else", fallback: 0)) // hide the vertical indicator line if user not touching the chart
                                .overlay(
                                    Circle()
                                        .frame(width: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[0].arg[0].value", fallback: 24), height: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[0].arg[1].value", fallback: 24), alignment: .center)
                                        .foregroundColor(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[1].arg[0].value.arg[2].value", fallback: 0)))
                                        .opacity(__designTimeFloat("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[2].arg[0].value", fallback: 0.2))
                                        .overlay(
                                            Circle()
                                                .fill()
                                                .frame(width: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[3].arg[0].value.modifier[1].arg[0].value", fallback: 12), height: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[3].arg[0].value.modifier[1].arg[1].value", fallback: 12), alignment: .center)
                                                .foregroundColor(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[3].arg[0].value.modifier[2].arg[0].value.arg[2].value", fallback: 0)))
                                        )
                                        .offset(x: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.modifier[4].arg[0].value", fallback: 0), y: isSelected ? CGFloat(self.dataPoints.count) - (selectedYPos * yScale) : CGFloat(self.dataPoints.count) - (CGFloat(dataPoints[selectedIndex].yValue) * yScale))
                                    , alignment: .bottom)

                    .offset(x: isSelected ? lineOffset : leadingMargin + ((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1) ) * CGFloat(selectedIndex), y: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[3].arg[1].value", fallback: 0))
                                .animation(Animation.spring().speed(__designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[4].arg[0].value.modifier[0].arg[0].value", fallback: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[0].modifier[4].arg[0].value.arg[0].value", fallback: 4))))
                
                Color.white.opacity(__designTimeFloat("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[0].arg[0].value", fallback: 0.1))
                    .gesture(
                        DragGesture(minimumDistance: __designTimeInteger("#1706.[1].[16].[0].arg[0].value.[1].arg[1].value.[1].modifier[1].arg[0].value.arg[0].value", fallback: 0))
                            .onChanged { dragValue in
                               dragOnChanged(value: dragValue, geo: geo)
                            }
                            .onEnded { dragValue in
                                dragOnEnded(value: dragValue, geo: geo)
                            }
                    )
            }

        })
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: points()) private func __preview__points()->some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 137)
        AnyView(GeometryReader { geo in

            let yScale = self.yScaleFor(height: geo.size.height)

            ForEach(dataPoints.indices) { i in
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value.arg[0].value", fallback: 4), lineCap: .round, lineJoin: .round, miterLimit: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value.arg[3].value", fallback: 80), dash: [], dashPhase: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value.arg[5].value", fallback: 0)))
                    .frame(width: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[1].arg[0].value", fallback: 10), height: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[1].arg[1].value", fallback: 10), alignment: .center)
                    .foregroundColor(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value.arg[2].value", fallback: 0)))
                    .background(Color(.systemBackground))
                    .cornerRadius(__designTimeInteger("#1706.[1].[15].[0].arg[0].value.[1].arg[1].value.[0].modifier[4].arg[0].value", fallback: 5))
                    .offset(x: leadingMargin + ((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)) * CGFloat(i) - 5, y: (geo.size.height - (CGFloat(dataPoints[i].yValue) * yScale)) - 5)
            }
        })
        
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: gradient()) private func __preview__gradient() -> some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 103)
        AnyView(LinearGradient(gradient: Gradient(colors: [Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[14].[0].arg[0].value.arg[0].value.[0].arg[2].value", fallback: 0)), .white]), startPoint: .top, endPoint: .bottom)
            .padding(.leading, leadingMargin)
            .padding(.trailing, trailingMargin)
            .padding(.bottom, __designTimeInteger("#1706.[1].[14].[0].modifier[2].arg[1].value", fallback: 1))
            .opacity(__designTimeFloat("#1706.[1].[14].[0].modifier[3].arg[0].value", fallback: 0.8))
            .mask(
                 GeometryReader { geo in
                     Path { p in

                        let yScale = self.yScaleFor(height: geo.size.height)

                         var index: CGFloat = __designTimeInteger("#1706.[1].[14].[0].modifier[4].arg[0].value.arg[0].value.[0].arg[0].value.[1].value", fallback: 0)

                         // Move to the starting point on graph
                         p.move(to: CGPoint(x: leadingMargin, y: geo.size.height - (CGFloat(dataPoints[Int(index)].yValue) * yScale)))

                         // draw lines
                         for _ in dataPoints {
                             if index != 0 {
                                p.addLine(to: CGPoint(x: leadingMargin + ((geo.size.width - marginSum) / CGFloat(dataPoints.count - 1)) * index, y: geo.size.height - (CGFloat(dataPoints[Int(index)].yValue) * yScale)))
                             }
                             index += 1
                         }

                         // Finally close the subpath off by looping around to the beginning point.
                         p.addLine(to: CGPoint(x: leadingMargin + ((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)) * (index - 1), y: geo.size.height))
                         p.addLine(to: CGPoint(x: leadingMargin, y: geo.size.height))
                         p.closeSubpath()
                     }
                 }
             ))
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: line()) private func __preview__line()->some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 79)
        AnyView(GeometryReader { geo in
            Path { p in

                let yScale = self.yScaleFor(height: geo.size.height)

                var index: CGFloat = __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].arg[0].value.[1].value", fallback: 0)

                // move to first dataPoint
                p.move(to: CGPoint(x: leadingMargin, y: geo.size.height - (CGFloat(dataPoints[0].yValue) * yScale)))

                for _ in dataPoints {
                    if index != 0 {
                        p.addLine(to: CGPoint(x: leadingMargin + ((geo.size.width - marginSum) / CGFloat(dataPoints.count - 1)) * index, y: geo.size.height - (CGFloat(dataPoints[Int(index)].yValue) * yScale)))
                    }
                    index += 1
                }
            }
            .stroke(style: StrokeStyle(lineWidth: __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].modifier[0].arg[0].value.arg[0].value", fallback: 2), lineCap: .round, lineJoin: .round, miterLimit: __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].modifier[0].arg[0].value.arg[3].value", fallback: 80), dash: [], dashPhase: __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].modifier[0].arg[0].value.arg[5].value", fallback: 0)))
            .foregroundColor(Color(red: 251/255, green: 82/255, blue: __designTimeInteger("#1706.[1].[13].[0].arg[0].value.[0].modifier[1].arg[0].value.arg[2].value", fallback: 0)))
        })
 
    #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: grid()) private func __preview__grid() -> some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 58)
       AnyView(GeometryReader { geo in
           VStack(spacing: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[0].value", fallback: 0)) {
               Color.primary.frame(height: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[0].modifier[0].arg[0].value", fallback: 1), alignment: .center)
               HStack(spacing: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[0].value", fallback: 0)) {
                   Color.clear
                       .frame(width: leadingMargin, height: geo.size.height)
                    ForEach(0..<(self.dataPoints.count - 1)) { i in
                       Color.primary.frame(width: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[0].value", fallback: 1), height: geo.size.height, alignment: .center)
                       Spacer()

                   }
                   Color.primary.frame(width: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[2].modifier[0].arg[0].value", fallback: 1), height: geo.size.height, alignment: .center)
                   Color.clear
                       .frame(width: trailingMargin, height: geo.size.height)
               }
               Color.primary.frame(height: __designTimeInteger("#1706.[1].[12].[0].arg[0].value.[0].arg[1].value.[2].modifier[0].arg[0].value", fallback: 1), alignment: .center)
           }
       })
   #sourceLocation()
    }
}

extension DYLineChartView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLineChartView.swift", line: 38)
        AnyView(ZStack {
            self.grid().opacity(__designTimeFloat("#1706.[1].[11].property.[0].[0].arg[0].value.[0].modifier[1].arg[0].value", fallback: 0.2))
           if self.showWithAnimation {
                Group {
                    self.line()
                    self.gradient()
                    self.points()
                    self.addUserInteraction()
                }.transition(AnyTransition.opacity)
            }
        }.background(Color(.systemBackground))
        .onAppear {
            withAnimation(Animation.easeIn(duration: 1.2).delay(__designTimeInteger("#1706.[1].[11].property.[0].[0].modifier[1].arg[0].value.[0].arg[0].value.modifier[0].arg[0].value", fallback: __designTimeInteger("#1706.[1].[11].property.[0].[0].modifier[1].arg[0].value.[0].arg[0].value.arg[0].value", fallback: 1)))) {
                self.showWithAnimation = true
            }
        })
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