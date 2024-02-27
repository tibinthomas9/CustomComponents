//
//  SineWave.swift
//  FunDraw
//
//  Created by Tibin Thomas on 2024-02-27.
//


import SwiftUI


// Sinewave with slider knob and customizable percentage(progress), frequency, amplitude
struct SineWave: View {
    var frequency = 2.0
    var amplitude = 0.7
    @State private var offsetY: Double = 0
    @Binding var percentage: Double

    var body: some View {
        GeometryReader { geometry in
            let path = createSineWavePath(in: geometry)

            path
                .stroke(Color.blue, lineWidth: 2)
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.01))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let x = value.location.x
                                    let xy = getXYfor(x: x, geometry: geometry)
                                    offsetY = xy.y
                                    percentage = (Double(xy.x / geometry.size.width) * 100.0)
                                }
                        )
                )
                .onAppear {
                    offsetY = getXYfor(x: percentage * geometry.size.width / 100, geometry: geometry).y
                }
                .onChange(of: percentage, perform: { value in
                        offsetY = getXYfor(x: percentage * geometry.size.width / 100, geometry: geometry).y
                })

            Circle()
                .frame(width: 30)
                .offset(x: (percentage * geometry.size.width / 100) - 15, y: offsetY - 15)
                .foregroundStyle(.blue)
        }
        .frame(height: 150)
    }

    private func createSineWavePath(in geometry: GeometryProxy) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))

        for angle in stride(from: 0, through: 360 * frequency, by: 1.0) {
            let pointX = ((Double(angle) * geometry.size.width) / (360 * frequency))
            let x = Double(angle) * Double.pi / 180
            let y = sin(x) * amplitude * (geometry.size.height / 2)
            let point = CGPoint(x: pointX, y: geometry.size.height / 2 - CGFloat(y))
            path.addLine(to: point)
        }

        return path
    }
    
//    private func createSineWavePathWithPercentageNode(in geometry: GeometryProxy, percentage : Double) -> Path {
//        var path = Path()
//        //path.animatableData = percentage
//        
//        let  offsetY = getXYfor(x: percentage * geometry.size.width / 100, geometry: geometry).y
//        let  offsetX = percentage * geometry.size.width / 100
//        path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
//
//        for angle in stride(from: 0, through: 360 * frequency, by: 1.0) {
//            let pointX = ((Double(angle) * geometry.size.width) / (360 * frequency))
//            let x = Double(angle) * Double.pi / 180
//            let y = sin(x) * amplitude * (geometry.size.height / 2)
//            let point = CGPoint(x: pointX, y: geometry.size.height / 2 - CGFloat(y))
//            path.addLine(to: point)
//            if  Int(point.x) == Int (offsetX) &&  Int(point.y) == Int(offsetY) {
//                path.addEllipse(in: CGRect(x: offsetX - 15, y: offsetY - 15, width: 30, height: 30))
//            }
//        }
//        
//        path.move(to: CGPoint(x: offsetX, y: offsetY))
//        //path.addEllipse(in: CGRect(x: offsetX - 15, y: offsetY - 15, width: 30, height: 30))
//
//        return path
//    }

    private func getXYfor(x: Double, geometry: GeometryProxy) -> (x: Double, y: Double) {
        let angle = (x * 360 * frequency) / geometry.size.width
        let radianX = Double(angle) * Double.pi / 180
        let yValue = geometry.size.height / 2 - CGFloat(sin(radianX) * amplitude * (geometry.size.height / 2))
        return (x, yValue)
    }
}

// (aw/f) / d      aw/ fd
#Preview {
    SineWave(percentage: .constant(50))
}

