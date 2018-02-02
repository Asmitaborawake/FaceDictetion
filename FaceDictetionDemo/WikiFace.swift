//
//  WikiFace.swift
//  FaceDictetionDemo
//
//  Created by Asmita on 02/02/18.
//  Copyright © 2018 Asmita. All rights reserved.
//

import UIKit
import ImageIO

class WikiFace: NSObject {
    
    enum WikiFaceError: Error{
        
        case CouldNotDownloadImage
    }
    
    class func faceForPerson (person:String, size:CGSize, completion:@escaping (_ image:UIImage?,_ imageFound:Bool?)->()) throws{
      let escapedString = person.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let pixelsofAPIRequest = Int(max(size.width , size.height)) * 2
        let url = NSURL(string: "https://en.wikipedia.org/w/api.php?action=query&titles=\(escapedString!)&prop=pageimages&format=json&pithumbsize=\(pixelsofAPIRequest)")
        
      
      let task:URLSessionTask = URLSession.shared.dataTask(with: url! as URL, completionHandler: {(data, response, error) -> Void in
        
        if error == nil {
            
            let wikidict = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
            print(wikidict)
            
         if let query = wikidict.object(forKey: "query") as? NSDictionary{
                if let pages = query.object(forKey: "pages") as? NSDictionary{
                    if let pageContent = pages.allValues.first as? NSDictionary{
                        if let thumbnil = pageContent.object(forKey: "thumbnail") as? NSDictionary {
                            if let thumbURL = thumbnil.object(forKey: "source") as? String{
                                let faceImage = UIImage(data: NSData(contentsOf: NSURL(string: thumbURL)! as URL)! as Data)
                                completion(faceImage,true )
                            }
                            else{
                                completion(nil,false)
                            }
                        }
                    }
                }
            }
        
          
          
        }
      })
        task.resume()
        
    }
    
    
    
    
    class func centerimageViewOnFace (imageview:UIImageView){
        
        
        
        
        
        let context = CIContext(options: nil)
        let options = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        
        let faceImage = imageview.image
        let ciImage = CIImage(cgImage: faceImage!.cgImage!)
        
        let fetuers = detector?.features(in: ciImage)
        
        if (fetuers?.count)! > 0 {
            
            var face:CIFaceFeature!
            
            for rect in fetuers!{
                face = rect as! CIFaceFeature
            }
            
            var faceRectwithExtenedBounds = face.bounds
            
            faceRectwithExtenedBounds.origin.x -= 20
            faceRectwithExtenedBounds.origin.y -= 30
            
            faceRectwithExtenedBounds.size.width += 40
            faceRectwithExtenedBounds.size.height += 60
            
            let x = faceRectwithExtenedBounds.origin.x / faceImage!.size.width
            let y = (faceImage!.size.height - faceRectwithExtenedBounds.origin.y - faceRectwithExtenedBounds.size.height) / faceImage!.size.height
            
            let widthface = faceRectwithExtenedBounds.size.width / faceImage!.size.width
            let heightface = faceRectwithExtenedBounds.size.height / faceImage!.size.height
            
            
            imageview.layer.contentsRect = CGRect(x: x, y: y, width: widthface, height: heightface)
            
            
            
        }
        
    }
  

}
