//
//  ViewController.swift
//  Project1
//
//  Created by Bryan Tacuri on 6/12/19.
//  Copyright © 2019 Bryan Tacuri. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        for item in items {
            if item.hasPrefix("nssl"){
                //this is a picture to load
                pictures.append(item)
                
            }
        }
        

        pictures.sort()
        print(pictures)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.TotalPictureNumb = pictures.count
            vc.selectedPicture = indexPath.row + 1
            
            navigationController?.pushViewController(vc, animated: true)

        }
    }
    @objc func shareTapped(){

        // If there is an image loaded, then the name is available too
        let vc = UIActivityViewController(activityItems: pictures, applicationActivities: nil)
        
        // This line is necessary for iPad -> Shows the controller bellow the right bar button
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}


