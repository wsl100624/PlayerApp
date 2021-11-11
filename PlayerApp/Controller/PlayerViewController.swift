//
//  PlayerViewController.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private lazy var playPauseButton = UIButton(image: .playIcon,
                                                target: self,
                                                action: #selector(playPauseButtonPressed))
    
    private lazy var scrubberView = ScrubberView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupPlayPauseButton()
        layout()
    }
    
    private func setupPlayPauseButton() {
        let barButtonItem = UIBarButtonItem(customView: playPauseButton)
        toolbarItems = [.flexibleSpace(), barButtonItem, .flexibleSpace()]
    }
    
    private func layout() {
        view.addSubview(scrubberView)
        [
            scrubberView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrubberView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrubberView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrubberView.heightAnchor.constraint(equalToConstant: .cellHeight)
        ].forEach { $0.isActive = true }
    }
    
    
    // MARK: - Action

    @objc private func playPauseButtonPressed() {
        playPauseButton.setPauseIcon()
    }
}
