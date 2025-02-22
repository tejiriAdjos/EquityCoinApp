//
//  PerformanceChartView.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//


import SwiftUI
import Charts

struct PerformanceChartView: View {
    let dataEntries: [Double]
    
    var body: some View {
        Chart {
            ForEach(Array(dataEntries.enumerated()), id: \.offset) { index, value in
                LineMark(
                    x: .value("Time", index),
                    y: .value("Performance", value)
                )
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartYScale(domain: yDomain)
        .frame(height: 200)
    }
    
    private var yDomain: ClosedRange<Double> {
        guard let minValue = dataEntries.min(),
              let maxValue = dataEntries.max() else {
            return 0...1
        }
        let range = maxValue - minValue
        let padding = range == 0 ? 1 : range * 0.1
        return (minValue - padding)...(maxValue + padding)
    }
}
