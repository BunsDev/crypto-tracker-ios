//
//  CoinPriceChart.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI
import Charts

/// A view representing a chart for displaying the price of a coin over time.
struct CoinPriceChart: View {
    var manager: CoinDetailManager
    @State private var selectedElement: CoinPricePair?
    
    private var sparkline: Coin.SparklineIn7D {
        manager.coin.unwrappedSparklineIn7D
    }
    
    private var markColor: Color {
        sparkline.price.first ?? 0.0 > sparkline.price.last ?? 0.0 ? .red : .green
    }
    
    var body: some View {
        coinPrice7DChart
    }
    
    private var coinPrice7DChart: some View {
        chartBody
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(TapGesture()
                            .exclusively(before: LongPressGesture(minimumDuration: 1)
                                .onEnded { _ in
                                    longPressFeedback()
                                }
                                .sequenced(before: DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        selectedElement = findElement(proxy: proxy, geo: geo, location: value.location)
                                    }
                                    .onEnded { _ in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                selectedElement = nil
                                            }
                                        }
                                    }
                                )
                            )
                        )
                }
            }
            .chartBackground { proxy in
                GeometryReader { geo in
                    if let selectedElement {
                        let position = findPosition(proxy: proxy, geo: geo, element: selectedElement)
                        let dataMarkerXOffset = max(0, min(geo.size.width - Constant.dataMarkerWidth, position.x - Constant.dataMarkerWidth / 2))
                        
                        ZStack(alignment: .topLeading) {
                            VStack {
                                Text(selectedElement.price.asCurrencyWithDecimals())
                                    .font(.title3.bold())
                                Text(selectedElement.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: Constant.dataMarkerWidth)
                            .background {
                                RoundedRectangle(cornerRadius: Constant.dataMarkerCornerRadius)
                                    .stroke(.secondary, lineWidth: Constant.dataMarkerOutlineWidth)
                            }
                            .offset(x: dataMarkerXOffset, y: Constant.stemYOffset - 40)
                            
                            Path { path in
                                path.move(to: CGPoint(x: position.x, y: position.y))
                                path.addLine(to: CGPoint(x: position.x + 1, y: position.y))
                                path.addLine(to: CGPoint(x: position.x + 1, y: Constant.stemYOffset))
                                path.addLine(to: CGPoint(x: position.x, y: Constant.stemYOffset))
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
    }
    
    private var chartBody: some View {
        Chart(manager.coinPrice7D, id: \.self) { coinPricePair in
            LineMark(x: .value("Date", coinPricePair.date),
                     y: .value("Price", coinPricePair.price))
            AreaMark(x: .value("Date", coinPricePair.date),
                     yStart: .value("MinPrice", sparkline.min7D),
                     yEnd: .value("Price", coinPricePair.price))
            .foregroundStyle( Gradient(colors: [markColor, .clear]).opacity(Constant.areaMarkopacity) )
        }
        .foregroundStyle(markColor)
        .chartYScale(domain: sparkline.min7D ... sparkline.max7D)
        .frame(height: Constant.chartBodyHeight)
    }
    
    private func longPressFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    private func findPosition(proxy: ChartProxy, geo: GeometryProxy, element: CoinPricePair) -> CGPoint {
        let dateInterval = Calendar.current.dateInterval(of: .minute, for: element.date) ?? DateInterval()
        let xStartPosition = proxy.position(forX: dateInterval.start) ?? 0
        let currentX = xStartPosition + geo[proxy.plotFrame!].origin.x
        let yBottomPosition = proxy.position(forY: element.price) ?? 0
        let currentY = yBottomPosition + geo[proxy.plotFrame!].origin.y
        return CGPoint(x: currentX, y: currentY)
    }
    
    private func findElement(proxy: ChartProxy, geo: GeometryProxy, location: CGPoint) -> CoinPricePair? {
        let currentX = location.x - geo[proxy.plotFrame!].origin.x
        guard let date = proxy.value(atX: currentX, as: Date.self),
              let lastElement = manager.coinPrice7D.last else { return nil }
        let selectedElement = manager.coinPrice7D.first { $0.date > date }
        return (date >= manager.coin.endDate) ? lastElement : selectedElement
    }
    
    // MARK: constant variables
    private struct Constant {
        static let chartBodyHeight: CGFloat = 300
        static let xAxisLabelFontSize: CGFloat = 11
        static let areaMarkopacity: Double = 0.5
        static let dataMarkerCornerRadius: CGFloat = 5
        static let dataMarkerOutlineWidth: CGFloat = 1
        static let dataMarkerWidth: CGFloat = 150
        static let stemYOffset: CGFloat = -10
    }
}
