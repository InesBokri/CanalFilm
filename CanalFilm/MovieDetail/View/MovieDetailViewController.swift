//
//  MovieDetailViewController.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 24/07/2022.
//

import AVFoundation
import UIKit

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    public var movieDetailViewModel: MovieDetailModeling?
    var movieUrl: String = ""
    var movieDetails:  MovieDetail?
    var overlay : UIView?
    private var videoPlayer: AVPlayer?
    
    // MARK: - IBOutlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieInformationLabel: UILabel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.removeLoader()
            if let movieDetail = self.movieDetails {
                self.setupViews(with: movieDetail)
            } else {
                self.showAlert(with: "Une erreur est survenue veuillez réessayer ultérieurement.")
            }
        }
    }
    
    // MARK: - Functions
    func setupViews(with detail: MovieDetail) {
        setupLayout()
        
        slider.isHidden = true
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        
        movieImageView.loadImageUsingCache(withUrl: detail.imageURL)
        
        summaryLabel.text = detail.summary
        movieTitleLabel.text = detail.title
        movieInformationLabel.text = detail.information
    }
    
    private func setupLayout() {
        playerButton.layer.cornerRadius = 20
        playerButton.clipsToBounds = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let player = object as? AVPlayer, player == videoPlayer, keyPath == "status" {
            if player.status == .readyToPlay {
                videoPlayer?.play()
            }
        }
    }
    
    func playMovie(with movieUrl: String) {
        if let videoPlayer = videoPlayer {
            videoPlayer.play()
        } else {
            startPlayer(with: movieUrl)
        }
    }
    
    private func startPlayer(with movieUrl: String) {
        
        if let url = URL(string: movieUrl) {
            let asset = AVURLAsset(url: url, options: nil)
            let playerItem = AVPlayerItem(asset: asset)
            videoPlayer = AVPlayer(playerItem: playerItem)
            videoPlayer?.addObserver(self, forKeyPath: "status", options: [], context: nil)
            videoPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: Double(1), preferredTimescale: 2), queue: DispatchQueue.main) { [weak self] (sec) in
                guard let self = self else { return }
                let seconds = CMTimeGetSeconds(sec)
                let (hours, minutes, second) = self.getHoursMinutesSecondsFrom(seconds: seconds)
                self.title = "\(hours):\(minutes):\(second)"
            }
            videoPlayer?.volume = 1.0
            
            let layer: AVPlayerLayer = AVPlayerLayer(player: videoPlayer)
            layer.frame = playerView.bounds
            layer.videoGravity = .resizeAspectFill
            playerView.layer.sublayers?
                .filter { $0 is AVPlayerLayer }
                .forEach { $0.removeFromSuperlayer() }
            playerView.layer.addSublayer(layer)
        }
        initSlider()
    }
    
    private func initSlider() {
        if let videoPlayer = videoPlayer {
            slider.minimumValue = 0.0
            if let duration = videoPlayer.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                slider.maximumValue = Float(seconds)
                slider.isHidden = false
            }
        } else {
            slider.isHidden = true
        }
    }
    
    private func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        
        return (hours, minutes, seconds)
    }
    
    private func showAlert(with text: String) {
        let alertController = UIAlertController(title: "", message: text, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showLoader() {
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = .black
        overlay!.alpha = 0.8
        
        view.addSubview(overlay!)
    }
    
    private func removeLoader() {
       overlay?.removeFromSuperview()
    }
    
    // Mark: - IBAction
    @IBAction func sliderTouchUp(_ sender: Any) {
        videoPlayer?.pause()
        let value = slider.value
        videoPlayer?.currentItem?.seek(to: CMTime(seconds: Double(value), preferredTimescale: 60000), completionHandler: { [weak self] (success) in
            self?.videoPlayer?.play()
        })
    }
    
    @IBAction func playMovie(_ sender: Any) {
        guard let detail = movieDetails else { return }
        
        if playerButton.titleLabel?.text == "Lecture" {
            playerButton.setTitle("Pause", for: .normal)
            playMovie(with: detail.trailerURL)
        } else {
            playerButton.setTitle("Lecture", for: .normal)
            videoPlayer?.pause()
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
