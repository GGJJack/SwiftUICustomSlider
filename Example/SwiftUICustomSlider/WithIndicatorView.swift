//
//  WithIndicatorView.swift
//  SwiftUICustomSlider_Example
//
//  Created by GGJJack on 2021/08/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUICustomSlider

struct WithIndicatorView: View {
    @State var indicatorDefaultValue: CGFloat = 10
    @State var indicatorAnimateValue: CGFloat = 30
    @State var indicatorAnimatePosition: ValueIndicatorPosition = .center
    @State var indicatorAnimate2Value: CGFloat = 50
    @State var indicatorAnimate2Position: ValueIndicatorPosition = .center
    @State var indicatorAnimate3Value: CGFloat = 70
    @State var animation: Animation? = nil

    var body: some View {
        GeometryReader { geometry in
            VStack {
                SwiftUICustomSlider($indicatorDefaultValue)
                    .valueIndicator(AnyView(Text("\(Int(indicatorDefaultValue))").padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)).background(Color.white).cornerRadius(5).shadow(radius: 3)))
                    .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
                SwiftUICustomSlider($indicatorAnimateValue)
                    .activeTrack(AnyView(Color.red))
                    .indicator(nil)
                    .valueIndicator(AnyView(Text("\(Int(indicatorAnimateValue))").padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)).background(Color.white).cornerRadius(14).shadow(radius: 3)))
                    .valueIndicatorPosition(indicatorAnimatePosition)
                    .onStartProgress({ _ in
                        withAnimation {
                            indicatorAnimatePosition = .bottom(offset: 2)
                        }
                    })
                    .onEndProgress({ _ in
                        withAnimation {
                            indicatorAnimatePosition = .center
                        }
                    })
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                SwiftUICustomSlider($indicatorAnimate2Value)
                    .activeTrack(AnyView(Color.green))
                    .indicator(nil)
                    .valueIndicator(AnyView(Text("\(Int(indicatorAnimate2Value))").padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)).background(Color.white).cornerRadius(14).shadow(radius: 3)))
                    .valueIndicatorPosition(indicatorAnimate2Position)
                    .onStartProgress({ _ in
                        withAnimation {
                            indicatorAnimate2Position = .top(offset: 2)
                        }
                    })
                    .onEndProgress({ _ in
                        withAnimation {
                            indicatorAnimate2Position = .center
                        }
                    })
                    .padding(EdgeInsets(top: 40, leading: 20, bottom: 10, trailing: 20))
                SwiftUICustomSlider($indicatorAnimate3Value)
                    .activeTrack(AnyView(Color.orange))
                    .indicator(nil)
                    .valueIndicator(AnyView(Text("\(Int(indicatorAnimate3Value))").padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)).background(Color.white).cornerRadius(14).shadow(radius: 3).animation(animation)))
                    .valueIndicatorPosition(.center)
                    .animation(animation)
                    .padding(EdgeInsets(top: 40, leading: 20, bottom: 10, trailing: 20))
            }
            .navigationBarTitle("With indicator")
            .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                animation = .easeInOut(duration: 0.3)
            }}
        }
    }
}

struct WithIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        WithIndicatorView()
    }
}
