//
//  WithAnimationView.swift
//  SwiftUICustomSlider_Example
//
//  Created by GGJJack on 2021/08/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUICustomSlider
import Combine

struct ValueProgressView: View {
    @State var defaultProgress: CGFloat = 0
    var body: some View {
        VStack {
            Button("Start Progress") {
//                Timer.publish(every: 1, tolerance: <#T##TimeInterval?#>, on: <#T##RunLoop#>, in: <#T##RunLoop.Mode#>, options: <#T##RunLoop.SchedulerOptions?#>)
            }
            SwiftUICustomSlider($defaultProgress)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        }
        .navigationBarTitle("Value progress")
    }
}

struct ValueProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ValueProgressView()
    }
}
