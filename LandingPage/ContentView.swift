import SwiftUI

struct ContentView: View {
    
    private let progressDuration: Double = 100.0
    private let timerInterval: TimeInterval = 0.05
    private let progressIncrement: TimeInterval = 1
    private let slidingTransition = AsymmetricTransition(
        insertion: .move(edge: .leading),
        removal: .move(edge: .trailing)
    )
    
    @State private var currentPage = 0
    @State private var sliderProgress: [Double] = Array(repeating: 0.0, count: 3)
    
    @AppStorage("has_seen_landing_page") private var hasSeenLandingPage: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                switch currentPage {
                case 0:
                    placeLandingScreen
                        .transition(slidingTransition)
                case 1:
                    hotelLandingScreen
                        .transition(slidingTransition)
                default:
                    flightLandingScreen
                        .transition(slidingTransition)
                }
                
                VStack {
                    pageIndicators
                    
                    Spacer()
                    
                    bottomButton(size: geo.size)
                }
            }
            .onAppear(perform: startProgressSlider)
        }
    }
}

// MARK: ui components
extension ContentView {
    func bottomButton(size: CGSize) -> some View {
        Button(action: exploreButtonTapped, label: {
            Text("explore".uppercased())
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, size.width * 0.05)
                .padding(.bottom, size.height * 0.02)
        })
    }
    
    var placeLandingScreen: some View {
        LandingScreen(
            image: "glacier-mountains",
            title: "Plan your",
            subTitle: "Luxurious\nVacation"
        )
    }
    
    var hotelLandingScreen: some View {
        LandingScreen(
            image: "hotel",
            title: "Book your",
            subTitle: "Luxurious\nHotel Stay"
        )
    }
    
    var flightLandingScreen: some View {
        LandingScreen(
            image: "flight",
            title: "Book your",
            subTitle: "Luxurious\nFlight Experience"
        )
    }
    
    var pageIndicators: some View {
        HStack(alignment: .center) {
            ForEach(0..<3) {index in
                ZStack {
                    ProgressView(value: 100, total: progressDuration)
                        .tint(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    ProgressView(value: sliderProgress[index], total: progressDuration)
                        .tint(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .animation(nil, value: sliderProgress)
                }
                .onTapGesture {
                    onProgressSliderTapped(at: index)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: functionalities
extension ContentView {
    private func startProgressSlider() {
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            if sliderProgress[currentPage] >= progressDuration {
                moveToNextLandingPage()
            } else {
                sliderProgress[currentPage] += progressIncrement
            }
        }
    }
    
    private func moveToNextLandingPage() {
        withAnimation {
            if currentPage < 2 {
                if sliderProgress[currentPage] < progressDuration {
                    sliderProgress[currentPage] = progressDuration
                }
                currentPage += 1
            } else {
                currentPage = 0
                sliderProgress = Array(repeating: 0.0, count: 3)
            }
        }
    }
    
    private func onProgressSliderTapped(at index: Int) {
        withAnimation {
            for i in 0..<3 {
                if i < index {
                    sliderProgress[i] = progressDuration
                } else {
                    sliderProgress[i] = 0
                }
            }
            currentPage = index
        }
    }
    
    private func exploreButtonTapped() {
        hasSeenLandingPage = true
    }
}

#Preview {
    ContentView()
}
