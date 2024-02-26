//
//  Wabe.swift
//  FunDraw
//
//  Created by Tibin Thomas on 2024-02-26.
//

import SwiftUI

// With Phase
struct Wave: Shape {
    // allow SwiftUI to animate the wave phase
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }

    // how high our waves should be
    var strength: Double

    // how frequent our waves should be
    var frequency: Double

    // how much to offset our waves horizontally
    var phase: Double

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        // calculate some important values up front
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth

        // split our total width up based on the frequency
        let wavelength = width / frequency

        // start at the left center
        path.move(to: CGPoint(x: 0, y: midHeight))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength

            // find how far we are from the horizontal center
            let distanceFromMidWidth = x - midWidth

            // bring that into the range of -1 to 1
            let normalDistance = oneOverMidWidth * distanceFromMidWidth

            let parabola = -(normalDistance * normalDistance) + 1

            // calculate the sine of that position, adding our phase offset
            let sine = sin(relativeX + phase)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = parabola * strength * sine + midHeight

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return Path(path.cgPath)
    }
}

struct WavePreviewView: View {
    @State private var phase = 0.0

    var body: some View {
        ZStack {
            ForEach(0..<10) { i in
                Wave(strength: 50, frequency: 10, phase: self.phase)
                    .stroke(Color.white.opacity(Double(i) / 10), lineWidth: 5)
                    .offset(y: CGFloat(i) * 10)
            }
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                self.phase = .pi * 2
            }
        }
    }
}


// With No Phase
struct Wave2: Shape {
    // how high our waves should be
    var strength: Double
    
    // how frequent our waves should be
    var frequency: Double
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        // calculate some important values up front
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        
        // split our total width up based on the frequency
        let wavelength = width / frequency
        
        // start at the left center
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength
            // calculate the sine of that position
            let sine = sin(relativeX)
            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = strength * sine + midHeight
            print(x, relativeX,sine, y)
            
            
            path.addLine(to: CGPoint(x: x, y: y))
            
        }
        return Path(path.cgPath)
    }
    
}

struct WavePreviewView2: View {
    var body: some View {
        ZStack {
            Wave2(strength: 50, frequency: 30)
                .stroke(Color.blue, lineWidth: 5)
                .frame(width: 200)
        }
        //.frame(m: 400)
        //  .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
    }
}



struct SineWaveView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geometry.size.height / 2 ))
                for angle in stride(from: 0, to: .pi * 4, by: 0.05) {
                    let x = angle * 50
                    let y = sin(angle) * 50
                    path.addLine(to: CGPoint(x: x, y: y + geometry.size.height / 2))
                }
            }
            .stroke(Color.blue, lineWidth: 4)
        }
        .frame(height: 200)
        .background(Color.gray)
    }
}



struct OneSineWaveView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))

                for angle in stride(from: 0, through:  360, by: 1.0) {
                    let pointX: Double = (Double(angle) * geometry.size.width) / 360.0
                    // Convert Angle to Radians for sin() paramater
                    let x = Double(angle) * Double.pi / 180
                    let y = sin(x) * 50 // Adjust the amplitude as needed
                    
                    let point = CGPoint(x: pointX , y: geometry.size.height / 2 - CGFloat(y))
                   
//                    let point = CGPoint(x: Double(angle) , y: geometry.size.height / 2 - CGFloat(y))
                    path.addLine(to: point)
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
        .frame(height: 150)
    }
}

// customizable sine wave view can custominzer how many sine wave shouble in the view: frequency
struct SineWave: View {
    var frequency = 4.0
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))

                for angle in stride(from: 0, through:  360 * frequency, by: 1.0) {
                    let pointX: Double = (Double(angle) * geometry.size.width / frequency) / 360.0
                    // Convert Angle to Radians for sin() paramater
                    let x = Double(angle) * Double.pi / 180
                    let y = sin(x) * 50 // Adjust the amplitude as needed
                    
                    let point = CGPoint(x: pointX , y: geometry.size.height / 2 - CGFloat(y))
                   
//                    let point = CGPoint(x: Double(angle) , y: geometry.size.height / 2 - CGFloat(y))
                    path.addLine(to: point)
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
        .frame(height: 150)
    }
}

#Preview {
    WavePreviewView()
}










