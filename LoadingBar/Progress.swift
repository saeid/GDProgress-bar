//
//  Progress.swift
//  LoadingBar
//
//  Created by Saeid on 4/12/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

class Progress: UIView {
    private var progressShape: CAShapeLayer = CAShapeLayer()
    private var routeShape: CAShapeLayer? = nil
    private var progressLabel: UILabel? = nil
    private var detailsLabel: UILabel? = nil
    
    var progressPath: UIBezierPath!
    var animationTime: CFTimeInterval = 5.0
    var animationDelay: CFTimeInterval = 1
    var showLabels: Bool = true
    var showRoutePath: Bool = true
    var lineWidth: CGFloat = 5.0

    
    //MARK: - init
    //override init of uiview class
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //create uiview components
    func setupView(){
        createMainLayer()
        if showLabels{
            createLabels()
        }
        if showRoutePath{
            createRouteLayer()
        }
    }
    
    //MARK: - Pathes
    //Create custom path for loading
    func createMainPath() -> UIBezierPath{
        let progressBezier = UIBezierPath()
        progressBezier.moveToPoint(CGPointMake(CGRectGetWidth(frame) / 2 - 100, CGRectGetHeight(frame) / 2 - 100))
        progressBezier.addLineToPoint(CGPointMake(CGRectGetWidth(frame) / 2 + 100, CGRectGetHeight(frame) / 2 - 100))
        progressBezier.addLineToPoint(CGPointMake(CGRectGetWidth(frame) / 2 + 100, CGRectGetHeight(frame) / 2 + 100))
        progressBezier.addLineToPoint(CGPointMake(CGRectGetWidth(frame) / 2 - 100, CGRectGetHeight(frame) / 2 + 100))
        
        progressBezier.closePath()
        
        return progressBezier
    }
    
    //MARK: - Layers
    //Create custom shape layers
    private func createMainLayer(){
        if let _ = self.progressPath{
            progressShape.path = progressPath?.CGPath
        }else{
            progressShape.path = createMainPath().CGPath
        }
        let gradiantLayer = createGradiantLayer()
        progressShape.backgroundColor = UIColor.clearColor().CGColor
        progressShape.fillColor = nil
        progressShape.strokeColor = UIColor.blackColor().CGColor
        progressShape.lineWidth = self.lineWidth
        progressShape.strokeStart = 0.0
        progressShape.strokeEnd = 0.0
        progressShape.lineJoin = "round"
        
        gradiantLayer.mask = progressShape
        
        layer.addSublayer(gradiantLayer)
    }
    
    func createRouteLayer(){
        routeShape = CAShapeLayer()
        routeShape!.path = progressShape.path
        routeShape!.strokeColor = UIColor.grayColor().CGColor
        routeShape!.fillColor = nil
        routeShape!.strokeStart = 0.0
        routeShape!.strokeEnd = 1.0
        routeShape!.lineWidth = 1.0
        routeShape!.lineJoin = "round"
        routeShape!.lineDashPattern = [2, 4]
        layer.insertSublayer(routeShape!, below: progressShape)
    }
    
    private func createGradiantLayer() -> CAGradientLayer{
        let gLayer = CAGradientLayer()
        gLayer.frame = self.bounds
        gLayer.locations = [0.0, 1.0]
        
        let top = UIColor.blackColor().colorWithAlphaComponent(0.7).CGColor
        let bot = UIColor.redColor().CGColor
        
        gLayer.colors = [top, bot]
        
        return gLayer
    }
    
    //MARK: - Loading Actions
    /*!
     if it should be a simple loading indicator, this should be uncommented.
     these will start and stop loading bar on user call
     
     it will create an endless load animation for custom CAShapeLayer
     
     uncomment startProgress() & endProgress() for this purpose
     */
    func startProgress(){
        let startAnimation = CABasicAnimation(keyPath: "strokeEnd")
        startAnimation.fromValue = 0.0
        startAnimation.toValue = 1.0
        startAnimation.duration = self.animationTime
        
        startAnimation.setValue("animation", forKey: "strokeEnd")
        startAnimation.delegate = self
        startAnimation.fillMode = kCAFillModeForwards
        
        let endAnimation = CABasicAnimation(keyPath: "strokeStart")
        endAnimation.beginTime = animationDelay
        endAnimation.fromValue = 0.0
        endAnimation.toValue = 1.0
        endAnimation.duration = self.animationTime - animationDelay
        
        endAnimation.setValue("animation", forKey: "strokeStart")
        endAnimation.delegate = self
        endAnimation.fillMode = kCAFillModeForwards
        
        // if it's a circular path, it can have a rotation animation
        //uncomment below lines + group animation line
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = M_PI * 2 // rotate 360 degrees
        rotateAnimation.duration = 2
        rotateAnimation.cumulative = true
        
        let groupAnim = CAAnimationGroup()
        //                groupAnim.animations = [startAnimation, endAnimation, rotateAnimation]
        groupAnim.animations = [startAnimation, endAnimation]
        groupAnim.duration = self.animationTime
        groupAnim.repeatCount = HUGE
        groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        progressShape.addAnimation(groupAnim, forKey: "gruoupAnim")
    }
    
    func endProgress(){
        progressShape.strokeEnd = 0.0
        progressShape.removeAllAnimations()
    }
    
    func updatePercent(value: Float){
        self.progressLabel!.text = String(format: "%.0f %@", value, "%")
    }
    
    func updateAnimation(currentVal: CGFloat){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressShape.strokeEnd
        animation.toValue = currentVal
        animation.duration = 0.2
        animation.fillMode = kCAFillModeForwards
        
        progressShape.strokeEnd = currentVal
        progressShape.addAnimation(animation, forKey: nil)
    }
    
    func updatePercente(percent: Float){
        guard let pLabel = self.progressLabel else{
            return
        }
        pLabel.text = "\(percent) %"
    }
    
    func updateDetails(downloded: Int64, total: Int64){
        guard let dLabel = self.detailsLabel else{
            return
        }
        let downlodedMB = convertToMB(downloded)
        let totalMB = convertToMB(total)
        
        dLabel.text = String(format: "%0.2f MB / %0.2f MB", downlodedMB, totalMB)
    }
    
    func convertToMB(totalBytes: Int64) -> Float{
        return (Float(totalBytes) / 1024) / 1024
    }
    
    //MARK: - Labels
    //Create indicator labels for loading progress bar
    private func createLabels(){
        progressLabel = UILabel()
        progressLabel!.text = "0 %"
        progressLabel!.textAlignment = .Center
        progressLabel!.textColor = UIColor.blackColor()
        progressLabel!.font = UIFont.systemFontOfSize(30)
        progressLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        detailsLabel = UILabel()
        detailsLabel!.text = "0.0 MB / 0.0 MB"
        detailsLabel!.textAlignment = .Center
        detailsLabel!.textColor = UIColor.blackColor()
        detailsLabel!.font = UIFont.systemFontOfSize(15)
        detailsLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(detailsLabel!)
        self.addSubview(progressLabel!)
        
        setupConstains()
    }
    
    
    private func setupConstains(){
        let wConstraintP = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let hConstraintP = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        let yAlignmentConstraint = NSLayoutConstraint(item: progressLabel!, attribute: .CenterX, relatedBy: .Equal, toItem: detailsLabel!, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let topConstraintD = NSLayoutConstraint(item: progressLabel!, attribute: .Bottom, relatedBy: .Equal, toItem: detailsLabel!, attribute: .Top, multiplier: 1.0, constant: 1.0)
        
        self.addConstraints([wConstraintP, hConstraintP, yAlignmentConstraint, topConstraintD])
    }
    
    
    
    
    
    
    
}
