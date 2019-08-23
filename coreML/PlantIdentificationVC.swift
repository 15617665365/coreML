//
//  PlantIdentificationVC.swift
//  coreML
//
//  Created by wangfeng on 2019/8/23.
//  Copyright © 2019 wangfeng. All rights reserved.
//

import UIKit
import CoreML
import Vision

class PlantIdentificationVC: UIViewController {

    @IBOutlet weak var startBut: UIButton!
    @IBOutlet weak var selectImageV: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func OnSelectClick(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
        
    }
    
}

extension PlantIdentificationVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
           
            selectImageV.image = image
            guard let ciImage = CIImage(image: image) else {
                fatalError()
            }
            
            guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
                fatalError();
            }
        
            let request = VNCoreMLRequest(model: model){ (request, error) in
                let res = request.results as! [VNClassificationObservation]
                
                self.startBut.setTitle(res.first?.identifier, for: .normal)
            }
            request.imageCropAndScaleOption = .centerCrop
 
//            do {
//                try VNImageRequestHandler(cgImage: ciImage as! CGImage ).perform([request])
//            } catch  {
//                print(error.localizedDescription)
//            }Ò
            do{
                           try VNImageRequestHandler(ciImage: ciImage).perform([request])
                       }catch{
                           print("执行图像识别请求失败，原因是：\(error.localizedDescription)")
                       }
            
          
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
