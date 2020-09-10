//
//  BaseNavigableCoordinator+UIImagePicker.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

// MARK: - UIImagePickerControllerDelegate
extension BaseNavigableCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    func goToPhotoPickerView(_ origin: PhotoPickerOrigin, sourceView: UIView) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheetController = UIAlertController(title: R.string.localizable.imagePickerTitle(), message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: R.string.localizable.imagePickerCamera(), style: .default) { [weak self] (_) in
            guard let self = self else { return }
            imagePickerController.sourceType = .camera
            self.navigationController.present(imagePickerController, animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: R.string.localizable.imagePickerLibrary(), style: .default) { [weak self] (_) in
            guard let self = self else { return }
            imagePickerController.sourceType = .photoLibrary
            self.navigationController.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)

        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoLibraryAction)
        actionSheetController.addAction(cancelAction)
        
        //Trating when alert is showing in the iPad
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
        }
        
        navigationController.present(actionSheetController, animated: true, completion: nil)
        
        self.photoPickerOrigin = origin
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [ UIImagePickerController.InfoKey: Any ]) {
        
        if let origin = photoPickerOrigin, let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            NotificationManager.shared.pickingImage(origin, image: image)
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

