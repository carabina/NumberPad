//
//  VisualizeCollectionViewController.swift
//  NumberPad
//
//  Created by Bridger Maxwell on 1/15/15.
//  Copyright (c) 2015 Bridger Maxwell. All rights reserved.
//

import UIKit
import DigitRecognizerSDK

let reuseIdentifier = "ImageCell"

class ImageCell: UICollectionViewCell {
    let imageView: UIImageView = UIImageView()
    let indexLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageCellSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        imageCellSetup()
    }
    
    func imageCellSetup() {
        imageView.frame = self.contentView.bounds
        self.contentView.addSubview(imageView)
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        indexLabel.text = "Mj"
        indexLabel.sizeToFit()
        indexLabel.frame = CGRectMake(0, self.contentView.bounds.height  - indexLabel.frame.size.height, self.contentView.bounds.width, indexLabel.frame.height)
        self.contentView.addSubview(indexLabel)
        indexLabel.textColor = UIColor.grayColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        indexLabel.text = ""
    }
    
}


class VisualizeCollectionViewController: UICollectionViewController {
    
    var digitClassifier: DTWDigitClassifier!
    var digitLabels: [DTWDigitClassifier.DigitLabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.digitClassifier = AppDelegate.sharedAppDelegate().digitClassifier
        self.digitLabels = Array(digitClassifier.normalizedPrototypeLibrary.keys)
        
        self.collectionView!.registerClass(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    let prototypeSize = CGSizeMake(140, 140)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.digitLabels = Array(digitClassifier.normalizedPrototypeLibrary.keys)
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = prototypeSize
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
        
        self.collectionView!.reloadData()
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return digitClassifier.normalizedPrototypeLibrary.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let label = self.digitLabels[section]
        return digitClassifier.normalizedPrototypeLibrary[label]?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell
        
        let label = self.digitLabels[indexPath.section]
        if let prototype = digitClassifier.normalizedPrototypeLibrary[label]?[indexPath.row] {
            let image = visualizeNormalizedStrokes(prototype, imageSize: self.prototypeSize)
            cell.imageView.image = image
            cell.imageView.layer.borderWidth = 1
            
            cell.indexLabel.text = "\(indexPath.row)"
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
