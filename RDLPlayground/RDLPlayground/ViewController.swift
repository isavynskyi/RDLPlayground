//
//  ViewController.swift
//  RDLPlayground
//
//  Created by Ihor Savynskyi on 28.03.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var counter = 0
    
    var lastIP: IndexPath {
        IndexPath(item: counter - 1, section: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    @IBAction func addEntrry(_ sender: Any) {
        counter += 1
        let ip = lastIP
        
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [ip])
        } completion: { _ in
            self.collectionView.scrollToItem(at: ip,
                                        at: .right,
                                        animated: true)
        }
    }
    
}

private extension ViewController {
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        counter
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellReuseIdentified", for: indexPath)
        
        return cell
    }
    
    
}
