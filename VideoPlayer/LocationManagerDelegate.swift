import Foundation
import CoreLocation
import AVKit

class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @Published var isPlaying = false
    var player: AVPlayer?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        handleDeviceHeading(newHeading)
    }

    private func handleDeviceHeading(_ heading: CLHeading) {
        let targetHeading = 215.797966
        let tolerance: Double = 10.0
        if abs(heading.trueHeading - targetHeading) <= tolerance {
            isPlaying = true
            player?.play()
        } else {
            isPlaying = false
            player?.pause()
        }
    }
}
