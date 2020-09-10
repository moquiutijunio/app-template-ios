//
//  NotificationManager.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 25/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import RxSwift

final class NotificationManager {
    static let shared = NotificationManager()

    // MARK: - Update Profile
    private let newImagePickingSubject = PublishSubject<(PhotoPickerOrigin, UIImage)>()
    lazy var newImagePicking: Observable<(PhotoPickerOrigin, UIImage)> = {
        return newImagePickingSubject
    }()
    
    func pickingImage(_ type: PhotoPickerOrigin, image: UIImage) {
        newImagePickingSubject.onNext((type, image))
    }
}
