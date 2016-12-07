//
//  ViewController.swift
//  Detector
//
//  Created by Gregg Mojica on 8/21/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import CoreImage


class ViewController: UIViewController {
    @IBOutlet weak var personPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personPic.image = UIImage(named: "face-1")
        detect()
    }
    
    func detect(){
        
        //Create personciImage to extract the UIImage from storyboard and converts it to a CIIMage
        guard let personciImage = CIImage(image: personPic.image!) else {
            return
        }
        
        // The options(CIDetectorAccuracyHigh, CIDetectorAccuracyLow) indicate high or low processing power
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        
        // define CIDetector to detect face
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        
        // Call featuresInImage methods of faceDetector. 
        // FaceDetector finds faces in the given image. 
        // At the end, it returns us an array of faces
        let faces = faceDetector?.features(in: personciImage)
        
        //For converting the Core Image Coordinates to UIView Coordinates
        let ciImageSize = personciImage.extent.size
        /* Obsolete in Swift 3
        var transform = CGAffineTransformMakeScale(1,-1)
        transform = CGAffineTransformTranslate(transform, 0, -ciImageSize.height)
        */
        var transform = CGAffineTransform(scaleX: 1,y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        
        // Loop through the array, and cast the face to "CIFaceFeature"
        for face in faces as! [CIFaceFeature] {
            print("found bounds are \(face.bounds)")
            
            // Create a UIView called "faceBox" and 從 faces.first 中回傳 frame 的資料設定給 faceBox 的frame dimensions
            // Replace :
            // let faceBox = UIView(frame: face.bounds)
            // by
            /* -------------Apply the transform to convert the coordinates -------------*/
            // var faceViewBounds = CGRectApplyAffineTransform(face.bounds, transform) //obsolete
            var faceViewBounds = face.bounds.applying(transform)
            
            // Calculate the actual position and size of the rectangle in the image view
            let viewSize = personPic.bounds.size
            let scale = min(viewSize.width / ciImageSize.width, viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            // faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, CGAffineTransformMakeScale(scale, scale))   //Obsolete
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            let faceBox = UIView(frame: faceViewBounds)
            /* ----------------- end of transformation of Affine -----------------------*/
            
            // 設定 faceBox's border 寬度 = 3
            faceBox.layer.borderWidth = 3
            
            // 設定 faceBox's border 顏色 = red
            //obsolete: 
            // faceBox.layer.borderColor = UIColor.redColor().CGColor
            faceBox.layer.borderColor = UIColor.red.cgColor
            
            //清除背景顏色，表示這個 view 不會有背景
            //obsolete:
            //faceBox.backgroundColor = UIColor.clearColor()
            faceBox.backgroundColor = UIColor.clear
            
            // 把這個 view 加到 personPic imageview
            personPic.addSubview(faceBox)
            
            // 以下的 API 表示不止可以偵測臉，detector 還可以偵測左右眼
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition{
                print("Right eye bounds are \(face.rightEyePosition)")
            }
            
            
        }
        
    }
    
}
