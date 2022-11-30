//
//  BasicPieChartExample.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 23/3/2021.
//

import SwiftUI
import SwiftUIGraphs

struct BasicPieChartExample: View {
    
    @StateObject var viewModel = BasicPieChartViewModel()
    @Namespace var animationNamespace
    @State private var pieScale:CGSize = .zero
    
    var body: some View {
    
        return GeometryReader { proxy in
            Group {
                ZStack(alignment: Alignment.topLeading) {
                    if proxy.size.height > proxy.size.width {
                        // portrait
                        VStack {
                            self.content()
                        }
                    } else {
                        // landscape
                        HStack(alignment: .center) {
                    
                            self.content()
                        }
                    }
                    if self.viewModel.selectedSlice != nil {
                        DYFractionChartInfoView(title: "", data: viewModel.data, selectedSlice: $viewModel.selectedSlice) { (value) -> String in
                            value.toCurrencyString()
                        }.padding(5).infoBoxBackground()
                        .padding(infoBoxPadding)
                    }
                }
            }
        }.navigationTitle("Av. US household spending, 2019")
    }
    
    func content()->some View {
        Group {
            
            Spacer(minLength: 50)
            
            DYPieChartView(data: viewModel.data, selectedSlice: $viewModel.selectedSlice, sliceLabelView: {fraction in
                self.sliceLabelView(fraction: fraction, data: viewModel.data)
            }, animationNamespace: animationNamespace)
            .background(Circle().fill(Color.defaultPlotAreaBackgroundColor)
            .shadow(radius: 8))
            .scaleEffect(self.pieScale)
            .padding(10)
            
            DYFractionChartLegendView(data: viewModel.data, font: font, textColor: .white).frame(width: 250, height: 250).padding(10).infoBoxBackground().padding(10)
  
            
        }.onAppear {
            withAnimation(.spring()) {
                self.pieScale = CGSize(width: 1, height: 1)
            }
        }
    }
    
    func sliceLabelView(fraction: DYPieFraction, data: [DYPieFraction])->some View {
        Group {
            if fraction.value / data.reduce(0, { $0 + $1.value}) >= 0.11  {
                VStack {
                    Text(fraction.title).font(font).bold().lineLimit(2).frame(maxWidth: 85)
                    Text(fraction.value.toCurrencyString()).font(font).bold()
                    Text(fraction.value.percentageString(totalValue: data.reduce(0) { $0 + $1.value})).font(font)
                    
                }
            }
        }
    }
    
    var font: Font {
        var font: Font?
        #if os(iOS)
        font = UIDevice.current.userInterfaceIdiom == .phone ? .caption : .callout
        #else
         font = .body
        #endif
        return font!
    }
    
    var infoBoxPadding: CGFloat {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad ? 20 : 10
        #else
        return 20
        #endif
    }

    
}

final class BasicPieChartViewModel: ObservableObject {
    
    @Published var data: [DYPieFraction]
    @Published var selectedSlice: DYPieFraction?
    
    init() {
        self.data = DYPieFraction.exampleData()
        
    }
    
}

extension View {
    
    func infoBoxBackground()->some View {
        self.background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)).shadow(radius: 5))
    }
}

struct BasicPieChartExample_Previews: PreviewProvider {
    static var previews: some View {
        BasicPieChartExample()
    }
}


//,
