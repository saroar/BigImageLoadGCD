//
//  ViewController.swift
//  BigImageLoadGCD
//
//  Created by Alif on 18/11/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import UIKit

enum BigImages: String {
    case whale = "https://lh3.googleusercontent.com/16zRJrj3ae3G4kCDO9CeTHj_dyhCvQsUDU0VF0nZqHPGueg9A9ykdXTc6ds0TkgoE1eaNW-SLKlVrwDDZPE=s0#w=4800&h=3567"
    case shark = "https://lh3.googleusercontent.com/BCoVLCGTcWErtKbD9Nx7vNKlQ0R3RDsBpOa8iA70mGW2XcC76jKS09pDX_Rad6rjyXQCxngEYi3Sy3uJgd99=s0#w=4713&h=3846"
    case seaLion = "https://lh3.googleusercontent.com/ibcT9pm_NEdh9jDiKnq0NGuV2yrl5UkVxu-7LbhMjnzhD84mC6hfaNlb-Ht0phXKH4TtLxi12zheyNEezA=s0#w=4626&h=3701"
}

class ViewController: UIViewController {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    
    @IBAction func synchronousDownload(_ sender: Any) {
        
        // hide current image + start animation
        photoView.image = nil
        activityView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) { () -> Void in
            guard let url = URL(string: BigImages.seaLion.rawValue),
                let imgData = try? Data(contentsOf: url),
                let image = UIImage(data: imgData) else {
                    return
            }
            
            self.photoView.image = image
            self.activityView.stopAnimating()
        }
        
    }
    
    
    @IBAction func simpleAsynchronousDownload(_ sender: Any) {
        
        // hide current image + start animation
        photoView.image = nil
        activityView.startAnimating()
        
        guard let url = URL(string: BigImages.shark.rawValue) else { return }
        
        // create a queue
        let downloadQueue = DispatchQueue(label: "download", attributes: [])
        
        // add a closure that encapsulates the blocking operation
        // run it asynchronously: some time in the near future
        downloadQueue.async { () -> Void in
            guard let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) else { return }
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.photoView.image = image
                self.activityView.stopAnimating()
            })
        }
    }
    
    @IBAction func asynchronousDownload(_ sender: Any) {
        // hide current image + start animation
        photoView.image = nil
        activityView.startAnimating()
        
        downloadBigImage { (image) -> Void in
            
            // Display it + Stop animating
            self.photoView.image = image
            self.activityView.stopAnimating()
        }
    }
    
    // This method downloads and image in the background once it's
    // finished, it runs the closure it receives as a parameter.
    // This closure is called a completion handler
    // Go download the image, and once you're done, do _this_ (the completion handler)
    func downloadBigImage(comletionHandler handler: @escaping (_ image: UIImage) -> Void ) {
        DispatchQueue.global(qos: .userInitiated).async {() -> Void in
            guard let url = URL(string: BigImages.whale.rawValue),
                let imgData = try? Data(contentsOf: url),
                let image = UIImage(data: imgData) else {
                    return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                handler(image)
            })
        }
    }
}

