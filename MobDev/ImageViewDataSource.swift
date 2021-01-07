//
//  ImageViewDataSource.swift
//  MobDev
//
//  Created by POG on 07.01.2021.
//

import UIKit


class ImagesViewDataSource: NSObject, UICollectionViewDataSource {

    var Images: [(UIImage?, String?)] = []

    func activateImage(in cell: ImageCell, at index: Int) {
        cell.ActivityIndicator.stopAnimating()
        cell.ImageView.image = Images[index].0
        cell.ImageView.isHidden = false
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! ImageCell

        if Images[indexPath.row].0 == nil {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: URL(string: self.Images[indexPath.row].1!)!) {
                    self.Images[indexPath.row].0 = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.activateImage(in: cell, at: indexPath.row)
                    }
                }
            }
        } else {
            activateImage(in: cell, at: indexPath.row)
        }

        return cell
    }

}
