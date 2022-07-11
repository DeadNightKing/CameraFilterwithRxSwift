//
//  ViewController.swift
//  CameraFilter
//
//  Created by Flow_RyanChou on 2022/7/5.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photoCVC = navC.viewControllers.first as? PhotosCollectionViewController
        else{
            fatalError("Segue destination is not found")
        }
        
        photoCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
        
    }
    
    @IBAction func applyFilterButtonPressed(){
        
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FiltersService().applyFilter(to: sourceImage)
            .subscribe { filterImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filterImage
                }
            } onError: { filterError in
                print(filterError)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)

        
//        FiltersService().applyFilter(to: sourceImage) { filteredImage in
//            DispatchQueue.main.async {
//                self.photoImageView.image = filteredImage
//            }
//        }
        
    }
    
    private func updateUI(with image: UIImage){
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }


}

