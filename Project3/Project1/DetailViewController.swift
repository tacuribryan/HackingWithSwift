//
//  DetailViewController.swift
//  Project1
//
//  Created by Bryan Tacuri on 6/12/19.
//  Copyright © 2019 Bryan Tacuri. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String? 
    var selectedPicture = 0
    var TotalPictureNumb = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "This is image \(selectedPicture) out of \(TotalPictureNumb)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        // Do any additional setup after loading the view.
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    //This function creates the Share button on the right side of the navagation bar
    @objc func shareTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)
        else{
            print ("No image found")
            return 
        }
        // If there is an image loaded, then the name is available too
        let vc = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])
        // This line is necessary for iPad -> Shows the controller bellow the right bar button
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
