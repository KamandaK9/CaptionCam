//
//  DetailViewController.swift
//  CaptionCam
//
//  Created by Daniel Senga on 2022/04/29.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let imageToLoad = selectedImage {
            imageView.image = imageToLoad
        }
    }


}
