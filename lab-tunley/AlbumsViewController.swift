//
//  AlbumsViewController.swift
//  lab-tunley
//
//  Created by me on 9/13/23.
//

import UIKit
import Nuke

class AlbumsViewController: UIViewController, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let album = albums[indexPath.item]
        Nuke.loadImage(with: album.artworkUrl100, into: cell.albumImageView)
        
        return cell
    }
    
    
    var albums: [Album] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self;
        
        let url = URL(string: "https://itunes.apple.com/search?term=blackpink&attribute=artistTerm&entity=album&media=music")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
            }

            guard let data = data else {
                print("❌ Data is nil")
                return
            }

            do {
                let decoder = JSONDecoder();
                let response = try decoder.decode(AlbumSearchResponse.self, from: data)
                let albums = response.results
                DispatchQueue.main.async {
                    self?.albums = albums
                    self?.collectionView.reloadData()
                }
            } catch {
                print("❌ Error parsing JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
       
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let numberOfColumns: CGFloat = 3
        let width = floor((collectionView.bounds.width - (layout.minimumInteritemSpacing * (numberOfColumns - 1))) / numberOfColumns)
        layout.itemSize = CGSize(width: width, height: width)
    }
}
