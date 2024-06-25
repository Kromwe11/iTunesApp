//
//  SongDetailViewController.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import AVFoundation
import MediaPlayer
import UIKit

/// Протокол для отображения деталей песни
protocol SongDetailViewProtocol: AnyObject {
    /// Отображает детали песни
    /// - Parameter song: объект песни для отображения
    func showSongDetail(with song: Song)
    
    /// Обновляет заголовок кнопки воспроизведения
    /// - Parameter isPlaying: флаг, указывающий, воспроизводится ли в данный момент песня
    func updatePlayButtonTitle(isPlaying: Bool)
    
    /// Обновляет прогресс воспроизведения
    /// - Parameters:
    ///   - currentTime: текущее время воспроизведения
    ///   - duration: общая продолжительность песни
    func updateProgress(currentTime: Double, duration: Double)
}

final class SongDetailViewController: UIViewController {
    
    // MARK: - Public properties
    var presenter: SongDetailPresenterProtocol?
    
    // MARK: - Private properties
    private let imageView = UIImageView()
    private let songLabel = UILabel()
    private let artistLabel = UILabel()
    private let playPauseButton = UIButton(type: .system)
    private let rewindButton = UIButton(type: .system)
    private let fastForwardButton = UIButton(type: .system)
    private let progressSlider = UISlider()
    private let shareButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserverToken: Any?
    
    private enum Constants {
        static let imageShadowOpacity: Float = 0.8
        static let imageShadowOffset = CGSize(width: 0, height: 2)
        static let imageShadowRadius: CGFloat = 10
        static let imageHeight: CGFloat = 500
        static let labelFontSize: CGFloat = 18
        static let artistLabelFontSize: CGFloat = 16
        static let padding: CGFloat = 20
        static let bigPadding: CGFloat = 40
        static let smallPadding: CGFloat = 10
        static let seekTime: Double = 10.0
        static let sliderUpdateInterval: Double = 1.0
        static let buttonTintColor: UIColor = .white
        static let playIcon = "play.fill"
        static let pauseIcon = "pause.fill"
        static let backButtonIcon = "chevron.left"
        static let backwardIcon = "backward.fill"
        static let forwardIcon = "forward.fill"
        static let shareIcon = "square.and.arrow.up"
        static let favoriteIcon = "heart"
        static let placeholder = "placeholder"
        static let backgroundColor = "BackgroundColor"
        static let authorText = "Author:"
        static let songPlaceholder = "Song: Unknown"
        static let artistPlaceholder = "Author: Unknown"
        static let songText = "Song:"
        static let listeningText = "Слушаю %@ от %@"
        static let invalidURL = "Invalid URL"
        static let highResImageURLSuffix = "600x600bb"
        static let lowResImageURLSuffix = "100x100bb"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        presenter?.viewDidLoad()
    }
    
    deinit {
        removePeriodicTimeObserver()
    }
    
    // MARK: - Private Methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.backButtonIcon),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: Constants.backgroundColor)
        
        setupImageView()
        setupLabel(songLabel, fontSize: Constants.labelFontSize)
        setupLabel(artistLabel, fontSize: Constants.artistLabelFontSize, textColor: .lightGray)
        setupButton(playPauseButton, systemName: Constants.playIcon, action: #selector(playPauseButtonTapped))
        setupButton(rewindButton, systemName: Constants.backwardIcon, action: #selector(rewindButtonTapped))
        setupButton(fastForwardButton, systemName: Constants.forwardIcon, action: #selector(fastForwardButtonTapped))
        setupSlider(progressSlider, action: #selector(progressSliderChanged))
        setupButton(shareButton, systemName: Constants.shareIcon, action: #selector(shareButtonTapped))
        setupButton(favoriteButton, systemName: Constants.favoriteIcon, action: nil)
        
        setupLayoutConstraints()
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOpacity = Constants.imageShadowOpacity
        imageView.layer.shadowOffset = Constants.imageShadowOffset
        imageView.layer.shadowRadius = Constants.imageShadowRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    }
    
    private func setupLabel(_ label: UILabel, fontSize: CGFloat, textColor: UIColor = .white) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        label.textColor = textColor
        label.numberOfLines = 0
        view.addSubview(label)
    }
    
    private func setupButton(_ button: UIButton, systemName: String, action: Selector?) {
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.tintColor = Constants.buttonTintColor
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    private func setupSlider(_ slider: UISlider, action: Selector) {
        slider.addTarget(self, action: action, for: .valueChanged)
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .gray
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.smallPadding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.smallPadding),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            
            songLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.padding),
            songLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            songLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            
            artistLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: Constants.smallPadding),
            artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            
            shareButton.bottomAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: Constants.bigPadding),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            
            favoriteButton.bottomAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: Constants.bigPadding),
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            
            progressSlider.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: Constants.padding),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            
            rewindButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: Constants.padding),
            rewindButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            
            playPauseButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: Constants.padding),
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            fastForwardButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: Constants.padding),
            fastForwardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
        ])
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: Constants.sliderUpdateInterval, preferredTimescale: 1)
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let currentTime = time.seconds
            let duration = self?.player?.currentItem?.duration.seconds ?? 0
            self?.presenter?.updateProgress(currentTime: currentTime, duration: duration)
        }
    }
    
    private func removePeriodicTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    // MARK: - Actions
    @objc private func playPauseButtonTapped() {
        if player?.timeControlStatus == .playing {
            player?.pause()
            playPauseButton.setImage(UIImage(systemName: Constants.playIcon), for: .normal)
        } else {
            player?.play()
            playPauseButton.setImage(UIImage(systemName: Constants.pauseIcon), for: .normal)
        }
    }
    
    @objc private func rewindButtonTapped() {
        let currentTime = player?.currentTime() ?? CMTime.zero
        var newTime = CMTimeGetSeconds(currentTime) - Constants.seekTime
        if newTime < 0 {
            newTime = 0
        }
        player?.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }
    
    @objc private func fastForwardButtonTapped() {
        guard let duration = player?.currentItem?.duration else { return }
        let currentTime = player?.currentTime() ?? CMTime.zero
        var newTime = CMTimeGetSeconds(currentTime) + Constants.seekTime
        if newTime > CMTimeGetSeconds(duration) {
            newTime = CMTimeGetSeconds(duration)
        }
        player?.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }
    
    @objc private func progressSliderChanged(sender: UISlider) {
        let totalDuration = player?.currentItem?.duration.seconds ?? 0
        let newTime = totalDuration * Double(sender.value)
        player?.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }
    
    @objc private func shareButtonTapped() {
        guard let songName = songLabel.text, let artistName = artistLabel.text else { return }
        let textToShare = String(format: Constants.listeningText, songName, artistName)
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - SongDetailViewProtocol
extension SongDetailViewController: SongDetailViewProtocol {
    func showSongDetail(with song: Song) {
        songLabel.text = "\(Constants.songText) \(song.trackName ?? Constants.songPlaceholder)"
        artistLabel.text = "\(Constants.authorText) \(song.artistName ?? Constants.artistPlaceholder)"
        
        if let urlString = song.artworkUrl100?.replacingOccurrences(of: Constants.lowResImageURLSuffix, with: Constants.highResImageURLSuffix), let url = URL(string: urlString) {
            imageView.load(url: url, placeholder: UIImage(named: Constants.placeholder))
        } else if let urlString = song.artworkUrl100, let url = URL(string: urlString) {
            imageView.load(url: url, placeholder: UIImage(named: Constants.placeholder))
        } else {
            imageView.image = UIImage(named: Constants.placeholder)
        }
        
        if let previewUrlString = song.previewUrl, let previewUrl = URL(string: previewUrlString) {
            playerItem = AVPlayerItem(url: previewUrl)
            player = AVPlayer(playerItem: playerItem)
            addPeriodicTimeObserver()
        } else {
            playPauseButton.isEnabled = false
            playPauseButton.setTitle(Constants.invalidURL, for: .normal)
        }
    }
    
    func updatePlayButtonTitle(isPlaying: Bool) {
        playPauseButton.setImage(
            isPlaying ? UIImage(systemName: Constants.pauseIcon) : UIImage(systemName: Constants.playIcon), for: .normal
        )
    }
    
    func updateProgress(currentTime: Double, duration: Double) {
        progressSlider.value = Float(currentTime / duration)
    }
}
