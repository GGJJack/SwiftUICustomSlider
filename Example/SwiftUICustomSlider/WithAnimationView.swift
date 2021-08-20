//
//  WithAnimationView.swift
//  SwiftUICustomSlider_Example
//
//  Created by GGJJack on 2021/08/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUICustomSlider

struct WithAnimationView: View {
    @State var defaultProgress: CGFloat = 0
    var body: some View {
        VStack {
            SwiftUICustomSlider($defaultProgress)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        }
        .navigationBarTitle("With animation")
    }
}

struct WithAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        WithIndicatorView()
    }
}
