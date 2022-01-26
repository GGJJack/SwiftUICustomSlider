
import SwiftUI

public enum ValueIndicatorPosition {
    case top(offset: CGFloat)
    case bottom(offset: CGFloat)
    case center
}

//SwiftUICustomSlider
public struct SwiftUICustomSlider: View {
    
    private var progress: Binding<CGFloat>
    private var max: Binding<CGFloat>
    
    private var trackHeight: CGFloat = 5
    private var cornerRadius: CGFloat? = 5
    private var step: CGFloat? = nil
    
    private var activeTrack: AnyView = AnyView(Color.blue)
    private var inactiveTrack: AnyView = AnyView(Color.gray)
    private var indicator: AnyView? = AnyView(Circle().fill(Color.white).shadow(radius: 3).frame(width: 20, height: 20, alignment: .center))
    private var valueIndicator: AnyView? = nil
    private var valueIndicatorPosition: ValueIndicatorPosition = .top(offset: 2)
    private var isEnabled: Bool = true
    
    private var onProgressStart: ((CGFloat) -> Void)? = nil
    private var onProgressChange: ((CGFloat) -> Void)? = nil
    private var onProgressEnd: ((CGFloat) -> Void)? = nil
    
    @State private var indicatorFrame: CGSize = .zero
    @State private var valueIndicatorFrame: CGSize = .zero
    @State private var isDragging: Bool = false
    
    public init(_ progress: Binding<CGFloat>, max: Binding<CGFloat> = Binding.constant(100)) {
        self.progress = progress
        self.max = max
    }
    
    public init(_ progress: Binding<CGFloat>, max: CGFloat) {
        self.progress = progress
        self.max = Binding.constant(max)
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                inactiveTrack
                    .frame(width: geo.size.width, height: trackHeight, alignment: .center)
                    .cornerRadius(cornerRadius ?? 0)
                activeTrack
                    .frame(width: geo.size.width * (progress.wrappedValue / max.wrappedValue), height: trackHeight, alignment: .center)
                    .cornerRadius(cornerRadius ?? 0)
                if let view = indicator {
                    ChildSizeReader(size: $indicatorFrame) {
                        view.offset(
                            x: geo.size.width * (progress.wrappedValue / max.wrappedValue) - indicatorFrame.width / 2,
                            y: 0
                        )
                    }
                }
                if let view = valueIndicator {
                    ChildSizeReader(size: $valueIndicatorFrame) {
                        view.offset(
                            x: geo.size.width * (progress.wrappedValue / max.wrappedValue) - valueIndicatorFrame.width / 2,
                            y: getValueIndicatorFrame()
                        )
                    }
                }
            }
            .frame(width: geo.size.width, alignment: .leading)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        updateProgress(value: value, geo: geo)
                    })
                    .onEnded({ value in
                        endProgress(value: value, geo: geo)
                    })
            )
        }
        .frame(height: Swift.max(indicatorFrame.height, trackHeight), alignment: .top)
    }
    
    private func getValueIndicatorFrame() -> CGFloat {
        switch valueIndicatorPosition {
        case .center:
            return 0
        case .top(let offset):
            return -valueIndicatorFrame.height - offset
        case .bottom(let offset):
            return valueIndicatorFrame.height + offset
        }
    }
    
    private func updateProgress(value: DragGesture.Value, geo: GeometryProxy) {
        if !isEnabled { return }
        var percent = (value.location.x / geo.size.width)
        if percent < 0 {
            percent = 0
        } else if percent > 1 {
            percent = 1
        }
        var progress = max.wrappedValue * percent
        //print("[Drag]Width : \(geo.size.width), Touch : \(value.location.x), Progress : \(progress), Percent : \(percent)")
        if let step = step {
            let quotient = Int(progress / step)
            let remainder = progress.remainder(dividingBy: step)
            let adder = remainder < step / 2 ? 0 : step
            progress = CGFloat(quotient) * step + adder
        }
        if !isDragging {
            isDragging = true
            onProgressStart?(progress)
        }
        self.progress.wrappedValue = progress
        onProgressChange?(progress)
    }
    
    private func endProgress(value: DragGesture.Value, geo: GeometryProxy) {
        if !isEnabled { return }
        var percent = (value.location.x / geo.size.width)
        if percent < 0.01 {
            percent = 0
        } else if 0.99 < percent {
            percent = 1
        }
        var progress = max.wrappedValue * percent
        //print("[End]Width : \(geo.size.width), Touch : \(value.location.x), Progress : \(progress), Percent : \(percent)")
        if let step = step {
            let quotient = Int(progress / step)
            let remainder = progress.remainder(dividingBy: step)
            let adder = remainder < step / 2 ? 0 : step
            progress = CGFloat(quotient) * step + adder
        }
        self.progress.wrappedValue = progress
        onProgressEnd?(progress)
        self.isDragging = false
    }
    
    public func step(_ value: CGFloat?) -> Self {
        var mySelf = self
        mySelf.step = value
        return mySelf
    }

    public func indicator(_ view: AnyView?) -> Self {
        var mySelf = self
        mySelf.indicator = view
        return mySelf
    }
    
    public func valueIndicator(_ view: AnyView?) -> Self {
        var mySelf = self
        mySelf.valueIndicator = view
        return mySelf
    }
    
    public func valueIndicatorPosition(_ position: ValueIndicatorPosition) -> Self {
        var mySelf = self
        mySelf.valueIndicatorPosition = position
        return mySelf
    }
    
    public func activeTrack(_ view: AnyView) -> Self {
        var mySelf = self
        mySelf.activeTrack = view
        return mySelf
    }
    
    public func inactiveTrack(_ view: AnyView) -> Self {
        var mySelf = self
        mySelf.inactiveTrack = view
        return mySelf
    }
    
    public func trackSize(_ size: CGFloat) -> Self {
        var mySelf = self
        mySelf.trackHeight = size
        return mySelf
    }
    
    public func cornerRadius(_ value: CGFloat?) -> Self {
        var mySelf = self
        mySelf.cornerRadius = value
        return mySelf
    }
    
    public func step(_ value: CGFloat) -> Self {
        var mySelf = self
        mySelf.step = value
        return mySelf
    }
    
    public func onStartProgress(_ listener: ((CGFloat) -> Void)?) -> Self {
        var mySelf = self
        mySelf.onProgressStart = listener
        return mySelf
    }
    
    public func onChangeProgress(_ listener: ((CGFloat) -> Void)?) -> Self {
        var mySelf = self
        mySelf.onProgressChange = listener
        return mySelf
    }
    
    public func onEndProgress(_ listener: ((CGFloat) -> Void)?) -> Self {
        var mySelf = self
        mySelf.onProgressEnd = listener
        return mySelf
    }
    
    public func userInput(_ isUserInputable: Bool) -> Self {
        var mySelf = self
        mySelf.isEnabled = isUserInputable
        return mySelf
    }
}

public struct ChildSizeReader<Content: View>: View {
    var size: Binding<CGSize>
    let content: () -> Content
    
    public init(size: Binding<CGSize>, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                )
        }
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.size.wrappedValue = preferences
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero
    
    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}

//public struct Bubble: Shape {
//    var isActive: Bool
////    var coordinate: CGFloat
//
//    public var animatableData: Bool {
//        get { isActive }
//        set {
//            print(newValue)
//            isActive = newValue
//        }
//    }
//
//    public func path(in rect: CGRect) -> Path {
//        Path { path in
//            path.move(to: CGPoint(x: 20, y: 0))
//            path.addQuadCurve(to: CGPoint(x: 20, y: isActive ? 40 : -40), control: CGPoint(x: 40, y: isActive ? 40 : -40))
//            path.addQuadCurve(to: CGPoint(x: 20, y: 0), control: CGPoint(x: 0, y: isActive ? 40 : -40))
//
////                                if isDragging {
////                                    path.addRect(CGRect(x: 0, y: 0, width: 20, height: 20))
////                                } else {
////                                    path.addEllipse(in: CGRect(x: 0, y: 0, width: 20, height: 20))
////                                }
////                                if isDragging {
////                                    path.move(to: CGPoint(x: 20, y: 0))
////                                    path.addQuadCurve(to: CGPoint(x: 20, y: 40), control: CGPoint(x: 40, y: 40))
////                                    path.addQuadCurve(to: CGPoint(x: 20, y: 0), control: CGPoint(x: 0, y: 40))
////                                } else {
////                                    path.move(to: CGPoint(x: 20, y: 0))
////                                    path.addQuadCurve(to: CGPoint(x: 20, y: -40), control: CGPoint(x: 40, y: -40))
////                                    path.addQuadCurve(to: CGPoint(x: 20, y: 0), control: CGPoint(x: 0, y: -40))
////                                }
//
////                                path.move(to: CGPoint(x: rect.size.width/2, y: 0))
////                                path.addQuadCurve(to: CGPoint(x: rect.size.width/2, y: rect.size.height), control: CGPoint(x: rect.size.width, y: rect.size.height))
////                                path.addQuadCurve(to: CGPoint(x: rect.size.width/2, y: 0), control: CGPoint(x: 0, y: rect.size.height))
//                path.closeSubpath()
//        }
//    }
//}

struct CustomSliderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .center, spacing: 0) {
            SwiftUICustomSlider(Binding.constant(25))
                .activeTrack(AnyView(Color.red))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(50))
                .activeTrack(AnyView(Color.green))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(75))
                .activeTrack(AnyView(Color.blue))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(75))
                .indicator(AnyView(
                    Text("75")
                        .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                ))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(75))
                .indicator(nil)
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(75))
                .indicator(nil)
                .trackSize(10)
                .cornerRadius(nil)
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(25))
                .activeTrack(AnyView(Color.red))
                .valueIndicator(AnyView(Text("25")))
                .padding(EdgeInsets(top: 50, leading: 10, bottom: 0, trailing: 10))
        }
        .previewDevice(PreviewDevice(rawValue: "iPod touch (7th generation)"))
        VStack(alignment: .center, spacing: 0) {
            SwiftUICustomSlider(Binding.constant(25))
                .activeTrack(AnyView(Color.red))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(50))
                .activeTrack(AnyView(Color.green))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(75))
                .activeTrack(AnyView(Color.blue))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(75))
                .indicator(AnyView(
                    Text("75")
                        .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                ))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(75))
                .indicator(nil)
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(75))
                .indicator(nil)
                .trackSize(10)
                .cornerRadius(nil)
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            SwiftUICustomSlider(Binding.constant(25))
                .activeTrack(AnyView(Color.red))
                .valueIndicator(AnyView(Text("25")))
                .padding(EdgeInsets(top: 50, leading: 10, bottom: 0, trailing: 10))
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}

//struct StatusView: View {
//    @ObservedObject var vm: StatusViewModel = StatusViewModel()
//    @State var progress: CGFloat = 80
//    @State var isDragging = false
//
//    var body: some View {
//        VStack {
//            Text("Status")
//                .padding()
//            SwiftUICustomSlider($progress)
//                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
//            SwiftUICustomSlider($progress)
//                .activeTrack(AnyView(Color.green))
//                .indicator(AnyView(Rectangle().fill(Color.white).shadow(radius: 3).frame(width: 20, height: 20, alignment: .center)))
//                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
//            SwiftUICustomSlider($progress)
//                .activeTrack(AnyView(Color.red))
//                .indicator(AnyView(Rectangle().fill(Color.white).shadow(radius: 3).frame(width: 10, height: 20, alignment: .center)))
//                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
//            SwiftUICustomSlider($progress)
//                .indicator(AnyView(
//                    Text("\(Int(progress))")
//                        .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
//                        .background(Color.white)
//                        .cornerRadius(20)
//                        .shadow(radius: 5)
//                ))
//                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
//            SwiftUICustomSlider($progress)
//                .indicator(nil)
//                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
//            SwiftUICustomSlider($progress)
//                .indicator(nil)
//                .trackSize(isDragging ? 20 : 10)
//                .cornerRadius(nil)
//                .onStartProgress({ _ in
//                    withAnimation {
//                        isDragging = true
//                    }
//                })
//                .onEndProgress({ _ in
//                    withAnimation {
//                        isDragging = false
//                    }
//                })
//                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
//            SwiftUICustomSlider($progress)
//                .activeTrack(AnyView(Color.red))
//                .indicator(nil)
//                .valueIndicator(AnyView(
//                        Text("\(Int(progress))")
//                            .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
//                            .background(Color.white)
//                            .cornerRadius(20)
//                            .shadow(radius: 5)
//                ))
//                .valueIndicatorPosition(isDragging ? .top(offset: 5) : .center)
//                .onStartProgress({ _ in
//                    withAnimation {
//                        isDragging = true
//                    }
//                })
//                .onEndProgress({ _ in
//                    withAnimation {
//                        isDragging = false
//                    }
//                })
//                .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
//            SwiftUICustomSlider($progress)
//                .activeTrack(AnyView(Color.red))
//                .valueIndicator(AnyView(Text("\(progress)")))
//                .padding(EdgeInsets(top: 40, leading: 20, bottom: 0, trailing: 20))
//            SwiftUICustomSlider($progress)
//                .valueIndicatorPosition(.bottom(offset: 5))
//                .activeTrack(AnyView(Color.red))
//                .valueIndicator(AnyView(Text("\(Int(progress))")))
//                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
//        }
//    }
//}

