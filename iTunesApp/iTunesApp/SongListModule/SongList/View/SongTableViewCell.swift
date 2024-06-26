//  SongTableViewCell.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import UIKit

final class SongTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    private let songImageView = UIImageView()
    private let songTitleLabel = UILabel()
    private let artistNameLabel = UILabel()
    
    private enum Constants {
        static let imageLeadingPadding: CGFloat = 8
        static let imageTopBottomPadding: CGFloat = 8
        static let imageSize: CGFloat = 60
        static let labelLeadingPadding: CGFloat = 12
        static let labelTrailingPadding: CGFloat = -8
        static let labelTopPadding: CGFloat = 8
        static let labelBottomPadding: CGFloat = -8
        static let labelSpacing: CGFloat = 4
        static let titleLabelFontSize: CGFloat = 16
        static let artistLabelFontSize: CGFloat = 14
        static let artistLabelTextColor: UIColor = .gray
        static let placeholderImageName = "placeholder"
    }
    
    // MARK: - Initialization
    override func prepareForReuse() {
        super.prepareForReuse()
        songImageView.image = UIImage(named: Constants.placeholderImageName)
        songTitleLabel.text = nil
        artistNameLabel.text = nil
    }
    
    // MARK: - Public Methods
    func configure(with song: Song, presenter: SongListPresenterProtocol?) {
        setupViews()
        layoutViews()
        
        songTitleLabel.text = song.trackName
        artistNameLabel.text = song.artistName
        if let urlString = song.artworkUrl100, let url = URL(string: urlString) {
            presenter?.loadImage(from: url) { [weak self] image in
                self?.songImageView.image = image ?? UIImage(named: Constants.placeholderImageName)
            }
        } else {
            songImageView.image = UIImage(named: Constants.placeholderImageName)
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        songImageView.contentMode = .scaleAspectFill
        songImageView.clipsToBounds = true
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(songImageView)
        
        songTitleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleLabelFontSize)
        songTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(songTitleLabel)
        
        artistNameLabel.font = UIFont.systemFont(ofSize: Constants.artistLabelFontSize)
        artistNameLabel.textColor = Constants.artistLabelTextColor
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(artistNameLabel)
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            songImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.imageLeadingPadding),
            songImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.imageTopBottomPadding),
            songImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.imageTopBottomPadding),
            songImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            songImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            songTitleLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: Constants.labelLeadingPadding),
            songTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.labelTrailingPadding),
            songTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelTopPadding),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: Constants.labelLeadingPadding),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.labelTrailingPadding),
            artistNameLabel.topAnchor.constraint(equalTo: songTitleLabel.bottomAnchor, constant: Constants.labelSpacing),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.labelBottomPadding)
        ])
    }
}
