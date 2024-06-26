//
//  PlayerService.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import AVFoundation

final class PlayerService: PlayerServiceProtocol {
    
    // MARK: - Public Properties
    static let shared = PlayerService()
    weak var delegate: PlayerServiceDelegate?
    
    // MARK: - Private Properties
    private var player: AVPlayer?
    private var timeObserverToken: Any?
    
    // MARK: - Init
    
    private init() {}
    
    deinit {
        removePeriodicTimeObserver()
    }
    
    // MARK: - Public Methods
    var duration: Double {
        return player?.currentItem?.duration.seconds ?? 0
    }
    
    func configure(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        addPeriodicTimeObserver()
    }
    
    func play() {
        guard let player = player else { return }
        player.play()
        delegate?.didChangePlayStatus(isPlaying: true)
    }
    
    func pause() {
        guard let player = player else { return }
        player.pause()
        delegate?.didChangePlayStatus(isPlaying: false)
    }
    
    func rewind(by seconds: Double) {
        seek(by: -seconds)
    }
    
    func fastForward(by seconds: Double) {
        seek(by: seconds)
    }
    
    func seek(to seconds: Double) {
        guard let player = player else {
            return
        }
        let cmTime = CMTime(seconds: seconds, preferredTimescale: 1)
        player.seek(to: cmTime)
    }
    
    // MARK: - Private Methods
    private func seek(by seconds: Double) {
        guard let currentTime = player?.currentTime() else { return }
        var newTime = CMTimeGetSeconds(currentTime) + seconds
        if newTime < 0 { newTime = 0 }
        player?.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1.0, preferredTimescale: 1)
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let currentTime = time.seconds
            let duration = self?.player?.currentItem?.duration.seconds ?? 0
            self?.delegate?.didUpdateProgress(currentTime: currentTime, duration: duration)
        }
    }
    
    private func removePeriodicTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}
