//
//  StickyScrollView.swift
//  FunDraw
//
//  Created by Tibin Thomas on 2024-02-25.
//

import SwiftUI

struct StickyScrollView: View {
    @State private var frames: [CGRect] = []
    
    var body: some View {
        ScrollView {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            HStack {
                Text("Heading last")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .background(Color.primary.opacity(0.1))
                    .sticky(frames: frames)
            
            Text("Hello seconf")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .background(Color.primary.opacity(0.1))
                    .sticky(frames: frames)
                
            }
            Text("Hello ")
            Text("Hello ")
            ForEach(0..<5) { ix in
                
                   
                    
                    
                    Text("Heading \(ix)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .background(Color.primary.opacity(0.1))
                        .sticky(frames: frames)
                
                Text("Hello, world!\nTest 1 2 3")
            }
           
        }
        .coordinateSpace(name: "container")
        .onPreferenceChange(FramePreference.self, perform: {
                    frames = $0.sorted(by: { $0.minY < $1.minY })
                })
        .overlay(alignment: .center) {
            let text = frames.map { "\(Int($0.minY)) "}.joined(separator: "\n")
            Text(text)
                .foregroundStyle(.white)
                .background(.black)
        }
    }
}
struct FramePreference: PreferenceKey {
    static var defaultValue: [CGRect] = []
    

    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}
//
//var isSticking: Bool {
//        frame.minY < 0
//    }
//
//    var offset: CGFloat {
//        guard isSticking else { return 0 }
//        var o = -frame.minY
//        if let idx = stickyRects.firstIndex(where: { $0.minY > frame.minY && $0.minY < frame.height }) {
//            let other = stickyRects[idx]
//            o -= frame.height - other.minY
//        }
//        return o
//    }

struct Sticky: ViewModifier {
    var stickyRects: [CGRect]
    @State private var frame: CGRect = .zero

    var isSticking: Bool {
        frame.minY < 0
    }

    var offset: CGFloat {
        guard isSticking else { return 0 }
        var o = -frame.minY
        if let idx = stickyRects.firstIndex(where: { $0.minY > frame.minY && $0.minY < frame.height }) {
            let other = stickyRects[idx]
            o -= frame.height - other.minY
        }
        return o
    }

    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .zIndex(isSticking ? .infinity : 0)
            .overlay(GeometryReader { proxy in
                let f = proxy.frame(in: .named("container"))
                Color.clear
                    .onAppear { frame = f }
                    .onChange(of: f) { frame = $0 }
                    .preference(key: FramePreference.self, value: [frame])
            })
    }
}

struct Sticky2: ViewModifier {
    @State private var frame: CGRect = .zero
    var frames: [CGRect] = []

    var isSticking: Bool {
        let negMinys = frames.map { $0.minY }.filter { $0 <= 0 }
        
        let shouldStick = frame.minY == negMinys.last
        return shouldStick && frame.minY < 0
    }

    func body(content: Content) -> some View {
        content
            .offset(y: isSticking ? -frame.minY : 0)
            .zIndex(isSticking ? .infinity : 0)
            .overlay(GeometryReader { proxy in
                let f = proxy.frame(in: .named("container"))
                Color.clear
                    .onAppear { frame = f }
                    .onChange(of: f) { frame = $0 }
                    .preference(key: FramePreference.self, value: [frame])
            })
    }
}


extension View {
    func sticky(frames: [CGRect]) -> some View {
        self.modifier(Sticky(stickyRects: frames))
    }
}

#Preview {
    StickyScrollView()
}
