// SongListViewController.swift
// iTunesApp
//
// Created by Висент Щепетков on 25.06.2024.
//

import UIKit

final class SongListViewController: UIViewController {
    
    // MARK: - Private properties
    private var presenter: SongListPresenterProtocol?
    private var songs: [Song] = []
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var searchTimer: Timer?
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private enum Constants {
        static let searchBarPlaceholder = "Enter artist or song name"
        static let songCellIdentifier = "SongCell"
        static let errorTitle = "Error"
        static let okActionTitle = "OK"
        static let searchTextMinLength = 3
        static let searchTimerInterval: TimeInterval = 1.0
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.resignFirstResponder()
        deselectAllRows()
    }
    
    // MARK: - Configuration
    func configure(presenter: SongListPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
        setupLoadingIndicator()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = Constants.searchBarPlaceholder
        navigationItem.titleView = searchBar
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: Constants.songCellIdentifier)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func deselectAllRows() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in selectedIndexPaths {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

// MARK: - SongListViewProtocol
extension SongListViewController: SongListPresenterOutput {
    func showSongs(_ songs: [Song]) {
        DispatchQueue.main.async {
            self.songs = songs
            self.tableView.reloadData()
            self.hideLoading()
        }
    }
    
    func appendSongs(_ songs: [Song]) {
        DispatchQueue.main.async {
            let startIndex = self.songs.count
            let endIndex = startIndex + songs.count
            let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
            self.songs.append(contentsOf: songs)
            self.tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            self.hideLoading()
            let alert = UIAlertController(title: Constants.errorTitle, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.okActionTitle, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource
extension SongListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.songCellIdentifier, for: indexPath) as? SongTableViewCell else {
            return UITableViewCell()
        }
        let song = songs[indexPath.row]
        cell.configure(with: song, presenter: presenter)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SongListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        presenter?.didSelectSong(song)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            presenter?.loadMoreSongs()
        }
    }
}

// MARK: - UISearchBarDelegate
extension SongListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        guard searchText.count > Constants.searchTextMinLength else { return }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: Constants.searchTimerInterval, repeats: false) { [weak self] _ in
            self?.presenter?.searchSongs(with: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
