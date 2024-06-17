//
//  ChartView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/7/24.
//

import DGCharts
import SwiftUI

struct ChartView: UIViewRepresentable {
    
    let entries: [ChartDataEntry]
    
    func makeUIView(context: Context) -> LineChartView {
        let lineChartView = LineChartView()
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.enabled = false
        lineChartView.legend.enabled = false
        return lineChartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 3
        dataSet.setColor(.brandPoint)
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightColor = .brandPoint
        
        let gradientColors: [CGColor] = [
            UIColor.brandPoint.cgColor,
            UIColor.customWhite.cgColor
        ]
        let gradient =  CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 270)
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        
        // 차트 뷰에 차트 데이터 추가
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
        uiView.data = data
        uiView.pinchZoomEnabled = true
    }
}

#Preview {
    ChartView(entries: [
        ChartDataEntry(x: 0, y: 3234.234234),
        ChartDataEntry(x: 1, y: 3444.234234),
        ChartDataEntry(x: 2, y: 23453.3245),
        ChartDataEntry(x: 3, y: 324234.234234),
        ChartDataEntry(x: 4, y: 324234.234234),
        ChartDataEntry(x: 5, y: 324234.234234),
        ChartDataEntry(x: 6, y: 324234.234234),
        ChartDataEntry(x: 7, y: 324234.234234),
        ChartDataEntry(x: 8, y: 324234.234234),
        ChartDataEntry(x: 9, y: 324234.234234),
        ChartDataEntry(x: 10, y: 324234.234234),
    ])
}
