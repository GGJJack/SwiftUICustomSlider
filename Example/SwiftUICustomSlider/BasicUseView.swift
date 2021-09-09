//
//  BasicUseView.swift
//  SwiftUICustomSlider_Example
//
//  Created by GGJJack on 2021/08/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUICustomSlider

struct BasicUseView: View {
    @State var defaultProgress: CGFloat = 10
    @State var trackCustomProgress: CGFloat = 30
    @State var rectIndicatorProgress: CGFloat = 50
    @State var notIndicatorProgress: CGFloat = 70
    @State var stepProgress: CGFloat = 90
    @State var sizeProgress: CGFloat = 70
    @State var sizeProgressPressed: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                SwiftUICustomSlider($defaultProgress)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                
                SwiftUICustomSlider($trackCustomProgress)
                    .activeTrack(AnyView(Color.red))
                    .inactiveTrack(AnyView(Color.black.opacity(0.2)))
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))

                SwiftUICustomSlider($rectIndicatorProgress)
                    .activeTrack(AnyView(Color.green))
                    .indicator(AnyView(Rectangle().fill(Color.white).frame(width: 20, height: 20, alignment: .center).shadow(radius: 3)))
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                
                SwiftUICustomSlider($notIndicatorProgress)
                    .activeTrack(AnyView(Color.orange))
                    .trackSize(8)
                    .indicator(nil)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                
                SwiftUICustomSlider($stepProgress)
                    .activeTrack(AnyView(Color.pink))
                    .step(10)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                
                SwiftUICustomSlider($sizeProgress)
                    .activeTrack(AnyView(Color.purple))
                    .trackSize(sizeProgressPressed ? 20 : 8)
                    .indicator(nil)
                    .onStartProgress({ _ in withAnimation { sizeProgressPressed = true } })
                    .onEndProgress({ _ in withAnimation { sizeProgressPressed = false } })
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            }
        }
        .navigationBarTitle("Basic use")
    }
}

struct BasicUseView_Previews: PreviewProvider {
    static var previews: some View {
        BasicUseView()
    }
}
