//
//  SliderView.swift
//  Bookworm
//
//  Created by Tibin Thomas on 2024-02-16.
//

import SwiftUI

struct SliderView: View {
    @State private var sliderPercentage = 0.0
    @State var parentWidth = 0.0
    
    var body: some View {
        GeometryReader { geo in
            //parent
            RoundedRectangle(cornerRadius: 25)
                .fill(.black)
            //child
            RoundedRectangle(cornerRadius: 25)
                .fill(.gray)
                .frame(width: geo.size.width * sliderPercentage)
            Color.clear
                .onAppear {
                    parentWidth = geo.size.width
                }
            // knob
            Circle()
                .fill(.yellow)
                .frame(height: geo.size.height)
                .offset(x: max(0,geo.size.width * sliderPercentage - 20))
                .foregroundStyle(Color.white)
        }.clipped()
        .frame(height: 20)
        .gesture(DragGesture(minimumDistance: 0)
            .onChanged { value in
                updateSliderPercentage(width: value.location.x, parentWidth: parentWidth)
            }
            .onEnded { value in
                updateSliderPercentage(width: value.location.x, parentWidth: parentWidth)
            })
        .padding()
    }
    
    func updateSliderPercentage(width: Double, parentWidth: Double) {
        withAnimation {
            sliderPercentage =  max(0,min(1, width / parentWidth))
        }
        
    }
}

#Preview {
    SliderView()
}



