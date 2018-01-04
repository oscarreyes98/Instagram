//
//  CaptureViewController.swift
//  Instagram
//
//  Created by Oscar Reyes on 1/3/18.
//  Copyright © 2018 Oscar Reyes. All rights reserved.
//

import UIKit
import Parse

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureImageView.layer.borderWidth = 2
        pictureImageView.layer.borderColor = UIColor.black.cgColor
        
        imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPhoto(tapGestureRecognizer:)))
        self.pictureImageView.addGestureRecognizer(tapGestureRecognizer)
        self.pictureImageView.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureImageView.image = pickedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectPhoto(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        if self.pictureImageView.image == nil {
            print("No photo was selected, could not submit")
            return
        }
        
        let imageToPost = resize(image: self.pictureImageView.image!, newSize: CGSize(width: 200, height: 200))
        let captionToPost = self.captionTextField.text
        
        Post.postUserImage(image: imageToPost, withCaption: captionToPost) { (success: Bool, error: Error?) in
            if success {
                print("Submitted photo")
                self.tabBarController?.selectedIndex = 0
                self.pictureImageView.image = nil
                self.captionTextField.text = ""
                
            }
            else {
                print(error?.localizedDescription ?? "Error submitting photo")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
