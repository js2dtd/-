import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @Binding var player: AVPlayer?
    @Binding var selectedVideoURL: URL?
    @Binding var isPlaying: Bool
    @State private var isShowingImagePicker = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Button(action: {
                self.isShowingImagePicker.toggle()
            }) {
                Text("映像を選択")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 50)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(isPresented: self.$isShowingImagePicker, selectedVideoURL: self.$selectedVideoURL)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear {
                        if let url = self.selectedVideoURL {
                            self.playVideo(url: url)
                        }
                    }
            }
            
            if let player = self.player {
                if isPlaying {
                    VideoPlayer(player: player)
                        .onAppear {
                            player.play()
                            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                                player.seek(to: .zero)
                                player.play()
                            }
                        }
                } else {
                    Color.black
                        .onAppear {
                            player.pause()
                        }
                }
            } else {
                Text("テキスト")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            }
        }
        .background(colorScheme == .dark ? Color.black : Color.white)
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        }
    }

    private func playVideo(url: URL) {
        self.player?.pause() // 停止して前の映像の音声を止める
        self.player = AVPlayer(url: url) // 新しい映像のプレイヤーを作成
        self.isPlaying = true // 新しい映像を再生する準備をする
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedVideoURL: URL?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let videoURL = info[.mediaURL] as? URL {
                parent.selectedVideoURL = videoURL
            }
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
