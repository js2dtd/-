import SwiftUI
import AVKit

struct ContentView: View {
    @State private var player: AVPlayer?
    @State private var selectedVideoURL: URL?
    @ObservedObject private var locationManagerDelegate = LocationManagerDelegate()

    var body: some View {
        VStack {
            VideoPlayerView(player: $player, selectedVideoURL: $selectedVideoURL, isPlaying: $locationManagerDelegate.isPlaying)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            locationManagerDelegate.player = player
        }
    }
}

#Preview {
    ContentView()
}
