//
//  DataLoader.swift
//  NewsFeed
//
//  Created by Ravindra Sonkar on 29/09/19.
//  Copyright © 2019 Ravindra Sonkar. All rights reserved.
//

import UIKit

class DataLoader: UIView {
    
    public class var singleton: DataLoader {
        struct Static {
            static let instance = DataLoader()
        }
        return Static.instance
    }
    
    @IBInspectable
    public var color: UIColor = .red {
        didSet {
            indicator.strokeColor = color.cgColor
        }
    }
    
    @IBInspectable
    public var lineWidth: CGFloat = 3.0 {
        didSet {
            indicator.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    internal let indicator = CAShapeLayer()
    internal let animator = LoaderAnimator()
    
    internal var isAnimating = false
    
    convenience init() {
        self.init(frame: .zero)
        self.setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    internal func setup() {
        indicator.strokeColor = UIColor.red.cgColor
        indicator.fillColor = nil
        indicator.lineWidth = lineWidth
        indicator.strokeStart = 0.0
        indicator.strokeEnd = 0.0
        layer.addSublayer(indicator)
    }
}

extension DataLoader {
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        indicator.frame = bounds
        
        let diameter = bounds.size.min - indicator.lineWidth
        let path = UIBezierPath(center: bounds.center, radius: diameter / 2)
        indicator.path = path.cgPath
    }
}

extension DataLoader {
    public func startAnimating(_ view : UIView) {
        let window = UIWindow(windowScene: UIApplication.shared.connectedScenes.first as! UIWindowScene)
        window.addSubview(DataLoader.singleton)
        DataLoader.singleton.translatesAutoresizingMaskIntoConstraints = false
        DataLoader.singleton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        DataLoader.singleton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        guard !isAnimating else { return }
        view.isUserInteractionEnabled = false
        animator.addAnimation(to: indicator)
        isAnimating = true
    }
    
    public func stopAnimating() {
        guard isAnimating else { return }
        DataLoader.singleton.superview?.isUserInteractionEnabled = true
        animator.removeAnimation(from: indicator)
        isAnimating = false
        DataLoader.singleton.removeFromSuperview()
    }
}

final class LoaderAnimator {
    enum Animation: String {
        var key: String {
            return rawValue
        }
        
        case spring = "material.indicator.spring"
        case rotation = "material.indicator.rotation"
    }
    
    public func addAnimation(to layer: CALayer) {
        layer.add(rotationAnimation(), forKey: Animation.rotation.key)
        layer.add(springAnimation(), forKey: Animation.spring.key)
    }
    
    public func removeAnimation(from layer: CALayer) {
        layer.removeAnimation(forKey: Animation.rotation.key)
        layer.removeAnimation(forKey: Animation.spring.key)
    }
}

extension LoaderAnimator {
    internal func rotationAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .rotationZ)
        animation.duration = 2
        animation.fromValue = 0
        animation.toValue = (2.0 * .pi)
        animation.repeatCount = .infinity
        
        return animation
    }
    
    internal func springAnimation() -> CAAnimationGroup {
        let animation = CAAnimationGroup()
        animation.duration = 1.5
        animation.animations = [
            strokeStartAnimation(),
            strokeEndAnimation(),
            strokeCatchAnimation(),
            strokeFreezeAnimation()
        ]
        animation.repeatCount = .infinity
        
        return animation
    }
    
    internal func strokeStartAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .strokeStart)
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 0.15
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        return animation
    }
    
    internal func strokeEndAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .strokeEnd)
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        return animation
    }
    
    internal func strokeCatchAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .strokeStart)
        animation.beginTime = 1
        animation.duration = 0.5
        animation.fromValue = 0.15
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        return animation
    }
    
    internal func strokeFreezeAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .strokeEnd)
        animation.beginTime = 1
        animation.duration = 0.5
        animation.fromValue = 1
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        return animation
    }
}

extension CAPropertyAnimation {
    enum Key: String {
        var path: String {
            return rawValue
        }
        
        case strokeStart = "strokeStart"
        case strokeEnd = "strokeEnd"
        case strokeColor = "strokeColor"
        case rotationZ = "transform.rotation.z"
        case scale = "transform.scale"
    }
    
    convenience init(key: Key) {
        self.init(keyPath: key.path)
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension CGSize {
    var min: CGFloat {
        return CGFloat.minimum(width, height)
    }
}

extension UIBezierPath {
    convenience init(center: CGPoint, radius: CGFloat) {
        self.init(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
    }
}

