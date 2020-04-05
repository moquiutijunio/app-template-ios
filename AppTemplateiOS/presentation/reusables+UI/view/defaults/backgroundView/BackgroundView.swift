//
//  BackgroundView.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 30/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography
import Kingfisher

enum BackgroundViewType {
    
    case normal
    case header
    case half
    case full
}

final class BackgroundView: UIView {
    
    private let imageView = UIImageView()
    
    private let gradientColors = [
        UIColor.clear,
        UIColor.background
    ]
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
        return blurEffectView
    }()
    
    private var hasBlur = false
    private var gradientLayer: CAGradientLayer?
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let gradientLayer = gradientLayer else { return }
        self.imageView.setNeedsLayout()
        self.imageView.layoutIfNeeded()
        
        if hasBlur {
            gradientLayer.frame = blurEffectView.bounds
        } else {
            gradientLayer.frame = imageView.bounds
        }
    }
    
    private func setupViews() {
        
        self.addSubview(imageView)
        self.backgroundColor = .background
        self.imageView.clipsToBounds = true
    }
    
    private func setupImageView(type: BackgroundViewType) {
        
        constrain(self, imageView) { (container, image) in
            image.top == container.top
            image.right == container.right
            
            switch type {
            case .normal:
                image.left >= container.left + 50
                image.height <= container.height / 2
                
            case .half:
                image.left == container.left
                image.height == container.width
                
            case .header:
                image.left == container.left
                image.height == 350
                
            case .full:
                image.left == container.left
                image.bottom >= container.bottom
            }
        }
    }
    
    private func setupBlurAndGradientIfNeeded(blur: Bool, gradient: Bool) {
        
        self.hasBlur = blur
        guard imageView.image != nil else { return }
        
        self.imageView.setNeedsLayout()
        self.imageView.layoutIfNeeded()
        
        if blur {
            self.blurEffectView.frame = self.imageView.bounds
        }
        
        if self.gradientLayer == nil {
            if gradient && blur {
                gradientLayer = blurEffectView.contentView.addGradient(colors: gradientColors, locations: [0, 0.8])
            } else if gradient {
                gradientLayer = imageView.addGradient(colors: gradientColors, locations: [0.74, 1])
            }
        }
        
        self.layoutSubviews()
    }
    
    private func setContentModeBy(type: BackgroundViewType) {
        
        switch type {
        default:
            self.imageView.contentMode = .scaleAspectFill
        }
    }
}

extension BackgroundView {
    
    var imageFrame: CGRect {
        return imageView.bounds
    }
    
    func setImage(_ image: UIImage,
                  blurEffect: Bool,
                  gradient: Bool,
                  type: BackgroundViewType) {
        
        setupImageView(type: type)
        setContentModeBy(type: type)
        self.imageView.image = image
        self.setupBlurAndGradientIfNeeded(blur: blurEffect, gradient: gradient)
    }
    
    func setImage(url: URL?,
                  blurEffect: Bool,
                  gradient: Bool,
                  type: BackgroundViewType,
                  completion: (() -> Void)?) {
        
        setupImageView(type: type)
        setContentModeBy(type: type)
        
        self.imageView.kf.setImage(with: url) { [weak self] (result) in
            guard let self = self else { return }
            
            self.setupBlurAndGradientIfNeeded(blur: blurEffect, gradient: gradient)
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    func setImageAlpha(_ alpha: CGFloat) {
        self.imageView.alpha = alpha
    }
}
