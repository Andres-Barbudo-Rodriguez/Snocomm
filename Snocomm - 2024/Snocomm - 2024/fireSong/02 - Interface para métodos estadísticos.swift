//
//  02 - Interface para métodos estadísticos.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/22/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import UIKit
import Charts


func createBarChart(data: [(String, Double)]) -> BarChartView {
    let barChart = BarChartView()
    
    var dataEntries: [BarChartDataEntry] = []
    
    for (index, entry) in data.enumerated() {
        let dataEntry = BarChartDataEntry(x: Double(index), y: entry.1)
        dataEntries.append(dataEntry)
    }
    
    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Cantidad")
    chartDataSet.colors = ChartColorTemplates.colorful()
    
    let chartData = BarChartData(dataSet: chartDataSet)
    barChart.data = chartData
    
    
    barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: data.map { $0.0 })
    barChart.xAxis.granularity = 1
    barChart.xAxis.labelRotationAngle = 90
    barChart.xAxis.labelPosition = .bottom
    
    barChart.rightAxis.enabled = false
    barChart.animate(yAxisDuration: 1.0, easingOption: .easeInOutCubic)
    
    return barChart
}


let sequenceData: [(String, Double)] = [
    ("Centro 1", 150.0),
    ("Centro 2", 120.0),
    ("Centro 3", 100.0),
    ("Centro 4", 180.0),
    ("Centro 5", 130.0)
]


let barChartView = createBarChart(data: sequenceData)


barChartView.frame = CGRect(x: 0, y: 0, width: 400, height: 300)
barChartView.center = CGPoint(x: 200, y: 150)


if let viewController = UIApplication.shared.windows.first?.rootViewController {
    viewController.view.addSubview(barChartView)
}


func saveChartAsImage(barChart: BarChartView, fileName: String) {
    UIGraphicsBeginImageContextWithOptions(barChart.bounds.size, barChart.isOpaque, 0.0)
    barChart.drawHierarchy(in: barChart.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    if let pngData = image?.pngData() {
        let filePath = NSTemporaryDirectory() + fileName
        try? pngData.write(to: URL(fileURLWithPath: filePath))
        print("Gráfico guardado en \(filePath)")
    }
}


saveChartAsImage(barChart: barChartView, fileName: "out.png")
