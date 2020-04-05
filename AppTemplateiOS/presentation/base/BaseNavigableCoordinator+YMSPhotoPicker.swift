//
//  BaseNavigableCoordinator+YMSPhotoPicker.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation
import YangMingShan

enum PhotoPickerType {
    
    case createAccount
}

// MARK: - YMSPhotoPickerViewControllerDelegate
extension BaseNavigableCoordinator: YMSPhotoPickerViewControllerDelegate {
        
    func goToPhotoPickerView(_ type: PhotoPickerType) {
        let pickerViewController = YMSPhotoPickerViewController()
        
        pickerViewController.numberOfPhotoToSelect = 1
        pickerViewController.theme.titleLabelTextColor = .primaryColor
        pickerViewController.theme.tintColor = .primaryColor
        pickerViewController.theme.orderLabelTextColor = .customWhite()
        pickerViewController.theme.cameraIconColor = .customWhite()
        pickerViewController.theme.navigationBarBackgroundColor = .customWhite()
        pickerViewController.theme.orderTintColor = .primaryColor
        pickerViewController.theme.cameraVeilColor = .primaryColor
        
        if #available(iOS 13.0, *) {
            pickerViewController.isModalInPresentation = true
        }
        
        self.photoPickerType = type
        navigationController.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    
    @objc func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPicking image: UIImage!) {
        
        if let type = photoPickerType {
            NotificationManager.shared.pickingImage(type, image: image)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func photoPickerViewControllerDidReceivePhotoAlbumAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        
        if let vc = navigationController.viewControllers.last as? BaseViewController {
            vc.showToast(text: R.string.localizable.messagePhotoAccessDenied())
        }
    }
    
    @objc func photoPickerViewControllerDidReceiveCameraAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        
        if let vc = navigationController.viewControllers.last as? BaseViewController {
            vc.showToast(text: R.string.localizable.messageCameraAccessDenied())
        }
    }
}
