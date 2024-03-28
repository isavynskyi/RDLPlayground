//
//  ViewController.swift
//  RDLPlayground
//
//  Created by Ihor Savynskyi on 28.03.2024.
//

import UIKit

public protocol CollectionInteractable {
    func addNewItem()
    func deleteItem(at index: Int)
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var counter = 0
    private lazy var gestureRecognizer = UIPanGestureRecognizer()
    private var currentlyDraggedCell: UICollectionViewCell?
    
    var lastIP: IndexPath {
        IndexPath(item: counter - 1, section: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    
    }

    @IBAction func addEntry(_ sender: Any) {
        addNewItem()
    }
    
    private func deleteCell(_ cell: UICollectionViewCell) {
        guard let ip = collectionView.indexPath(for: cell) else { return }
        deleteItem(at: ip)
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        counter -= 1
        
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [indexPath])
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
        
        gestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
        collectionView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
            
        case .began:
            let touchLocation = sender.location(in: collectionView)
            if let ip = collectionView.indexPathForItem(at: touchLocation),
               let cell = collectionView.cellForItem(at: ip) {
                currentlyDraggedCell = cell
            } else {
                currentlyDraggedCell = nil
            }
        case .changed:
            guard let currentlyDraggedCell else { return }
            let yTranslation = sender.translation(in: collectionView).y
            currentlyDraggedCell.transform = CGAffineTransform(translationX: 0, y: yTranslation)
        case .ended, .cancelled, .failed:
            guard let currentlyDraggedCell else { return }
            let yTranslation = sender.translation(in: collectionView).y
            
            let threashold = 50 + (collectionView.frame.height - currentlyDraggedCell.frame.height)/2
            if abs(yTranslation) > threashold {
                deleteCell(currentlyDraggedCell)
            } else {
                currentlyDraggedCell.transform = .identity
            }
            self.currentlyDraggedCell = nil
        case .possible:
            break // reset
        @unknown default:
            break // reset
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteItem(at: indexPath)
    }
}

extension ViewController: CollectionInteractable {
    func addNewItem() {
        DispatchQueue.main.async {
            self.counter += 1
            let ip = self.lastIP
            
            self.collectionView.performBatchUpdates {
                self.collectionView.insertItems(at: [ip])
            } completion: { _ in
                self.collectionView.scrollToItem(at: ip,
                                            at: .right,
                                            animated: true)
            }
        }
    }
    
    func deleteItem(at index: Int) {
        DispatchQueue.main.async {
            guard index <= self.counter else { return }
            let ip = IndexPath(item: index, section: 0)
            self.deleteItem(at: ip)
        }
    }
}
