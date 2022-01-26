//
//  ViewController.swift
//  SwiftUICustomSlider
//
//  Created by GGJJack on 08/20/2021.
//  Copyright (c) 2021 ggaljjak. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftUICustomSlider

struct MainView: View {
    @State var defaultProgress: CGFloat = 0
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BasicUseView()) {
                    Text("Basic use")
                }
                NavigationLink(destination: WithIndicatorView()) {
                    Text("With indicator")
                }
                NavigationLink(destination: ValueProgressView()) {
                    Text("Value progress")
                }
            }
            .navigationBarTitle("Home")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice(PreviewDevice(rawValue: "iPod touch (7th generation)"))
        MainView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let contentViewController = UIHostingController(rootView: MainView())
        contentViewController.navigationController?.isNavigationBarHidden = true
        self.addChild(contentViewController)
        self.view.addSubview(contentViewController.view)
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

