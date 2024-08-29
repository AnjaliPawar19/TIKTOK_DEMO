//
//  VideoCollectionViewCell.swift
//  TikTokDemo
//
//  Created by Anjali Pawar on 11/07/24.
//

import UIKit
import GSPlayer

class VideoCollectionViewCell: UICollectionViewCell {
    
    var videos: String!
    
    //MARK: Outlet
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnMusicDisc: UIButton!
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var imgPlay: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
    }
    
    func play() {
        imgPlay.isHidden = true
        playerView.play(for: URL(string: videos)!)
        playerView.isHidden = false
        btnMusicDisc.startRotating()
    }
    
    func pause() {
        playerView.pause(reason: .hidden)
        btnMusicDisc.stopRotating()
    }
    
    private func viewSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        playerView.isUserInteractionEnabled = true
        playerView.addGestureRecognizer(tap)
    }
    
    @objc private func viewTapped() {
        if playerView.state == .playing {
            imgPlay.isHidden = false
            playerView.pause(reason: .userInteraction)
            btnMusicDisc.stopRotating()
        } else {
            imgPlay.isHidden = true
            playerView.resume()
            btnMusicDisc.startRotating()
        }
    }
}

extension UIView {
    
    func startRotating(duration: Double = 3) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = .infinity
            animate.fromValue = 0.0
            animate.toValue = Double.pi * 2.0
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
