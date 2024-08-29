//
//  ViewController.swift
//  TikTokDemo
//
//  Created by Anjali Pawar on 11/07/24.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlet
    
   
    @IBOutlet weak var collView: UICollectionView!
    
    var videoData = [Category]()
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collView?.delegate = self
        collView?.dataSource = self
        collView?.reloadData()
        
        // Fetch JSON Data
        fetchJSON { result in
            self.videoData = result
            print(self.videoData)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collView?.isPagingEnabled = true
        collView?.setCollectionViewLayout(layout, animated: true)
    }
}

// MARK: - Private Helper Methods
extension ViewController {
    
    func fetchJSON(handler: @escaping (_ result: [Category]) -> Void) {
        guard let fileLocation = Bundle.main.url(forResource: "simple", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(json)
            
            let decoder = JSONDecoder()
            let videoJSON = try decoder.decode(VideoJSON.self, from: data)
            // Handler call here
            handler(videoJSON.categories)
            
        } catch {
            print("Parsing Error")
        }
    }
    
    @objc func btnLikeTapped(sender: UIButton){
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                sender.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            } completion: { finished in
                UIView.animate(withDuration: 0.3){
                    sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }

        }else{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                sender.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            } completion: { finished in
                UIView.animate(withDuration: 0.3){
                    sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        }
    }
}

//MARK: Collectionview Methods
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoData[section].videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        let videoData = videoData[indexPath.section].videos[indexPath.row]
        
        //Data Assigning
        cell.videos = videoData.sources
        cell.btnLike.addTarget(self, action: #selector(btnLikeTapped), for: .touchUpInside)
        cell.btnLike.tag = indexPath.row
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collView.frame.width, height: collView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? VideoCollectionViewCell{
            cell.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? VideoCollectionViewCell{
            cell.pause()
        }
    }
    
}
