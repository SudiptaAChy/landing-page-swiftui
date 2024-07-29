import SwiftUI

struct LandingScreen: View {
    
    var image: String
    var title: String
    var subTitle: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(title)
                                .font(.largeTitle)
                            Text(subTitle)
                                .font(.title)
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .padding(.bottom, geo.size.height * 0.2)
                        
                        Spacer()
                    }
                    .background(
                        LinearGradient(colors: [Color.black, Color.clear], startPoint: .bottom, endPoint: .top)
                    )
                }
            }
        }
    }
}

#Preview {
    LandingScreen(
        image: "flight",
        title: "Plan your",
        subTitle: "Luxurious\nVacation"
    )
}
