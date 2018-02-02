//
//  ViewController.swift
//  FaceDictetionDemo
//
//  Created by Asmita on 02/02/18.
//  Copyright © 2018 Asmita. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate{

    
     var appDelegate = AppDelegate()
    
    @IBOutlet var textfield: UITextField!
    
    @IBOutlet var wikiFaceImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.delegate = self
        
        
       
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
    textField.resignFirstResponder()
        
        if let textFieldContent = textField.text{
            do{
                try WikiFace.faceForPerson(person: textFieldContent, size: CGSize(width:200, height:300), completion: {  (image:UIImage?,imageFound:Bool?) -> () in
                    if imageFound! == true{
                        DispatchQueue.main.async {
                            self.wikiFaceImg.image = image
                            
                            WikiFace.centerimageViewOnFace(imageview: self.wikiFaceImg)
                        }
                    }
                    
                    })
            }catch WikiFace.WikiFaceError.CouldNotDownloadImage{
                print("error")
                appDelegate.showAlertMessage(alertTitile: "Error", alertMessage: "CouldNotDownloadImage")
            }
            catch {
                print("error")
            }
        }

        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

