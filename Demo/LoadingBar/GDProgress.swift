//
//  Progress.swift
//  LoadingBar
//
//  Created by Saeid on 4/12/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

class GDProgress: UIView {
    private var progressShape: CAShapeLayer = CAShapeLayer()
    private var routeShape: CAShapeLayer? = nil
    private var progressLabel: UILabel? = nil
    private var detailsLabel: UILabel? = nil
    
    var progressPath: UIBezierPath!
    var animationTime: CGFloat = 3.0
    var animationDelay: CGFloat = 1
    var showLabels: Bool = true
    var showRoutePath: Bool = false
    var lineWidth: CGFloat = 10.0
    var shouldRotate: Bool = true
    var shouldGradiant: Bool = true
    var routeColor: UIColor = UIColor.grayColor()
    var progressColor: UIColor = UIColor.blueColor()
    var grad1Color: UIColor = UIColor.whiteColor()
    var grad2Color: UIColor = UIColor.blackColor()
    var percentFont: UIFont = UIFont.systemFontOfSize(20)
    var detailsFont: UIFont = UIFont.systemFontOfSize(15)

    
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
        self.backgroundColor = UIColor.clearColor()
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
        let circleRaduis = (min(self.bounds.width, self.bounds.height) / 2 - progressShape.lineWidth) / 2
        let circleCenter = CGPointMake(bounds.midX , bounds.midY)
        let startAngle = CGFloat(M_PI_2)
        let endAngle = startAngle + CGFloat(M_PI * 2)
        
        let progressBezier = UIBezierPath(arcCenter: circleCenter, radius: circleRaduis, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
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
        progressShape.backgroundColor = UIColor.clearColor().CGColor
        progressShape.fillColor = nil
        progressShape.strokeColor = progressColor.CGColor
        progressShape.lineWidth = self.lineWidth
        progressShape.strokeStart = 0.0
        progressShape.strokeEnd = 0.0
        progressShape.lineJoin = "round"

        if shouldGradiant{
            let gradiantLayer = createGradiantLayer(grad1Color, g2: grad2Color)
            gradiantLayer.mask = progressShape
            layer.addSublayer(gradiantLayer)
        }else{
            let maskLayer = CAShapeLayer()
            maskLayer.strokeColor = progressColor.CGColor
            maskLayer.lineWidth = self.lineWidth
            maskLayer.strokeStart = 0.0
            maskLayer.strokeEnd = 1.0
            maskLayer.lineJoin = "round"
            maskLayer.path = progressShape.path

            maskLayer.mask = progressShape
            layer.addSublayer(maskLayer)
        }
    }
    
    func createRouteLayer(){
        routeShape = CAShapeLayer()
        routeShape!.path = progressShape.path
        routeShape!.strokeColor = routeColor.CGColor
        routeShape!.fillColor = nil
        routeShape!.strokeStart = 0.0
        routeShape!.strokeEnd = 1.0
        routeShape!.lineWidth = 1.0
        routeShape!.lineJoin = "round"
        routeShape!.lineDashPattern = [2, 4]
        layer.insertSublayer(routeShape!, below: progressShape)
    }
    
    private func createGradiantLayer(g1: UIColor, g2: UIColor) -> CAGradientLayer{
        let gLayer = CAGradientLayer()
        gLayer.frame = self.bounds
        gLayer.locations = [0.0, 1.0]
        
        let top = grad1Color.CGColor
        let bot = grad2Color.CGColor
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
        startAnimation.duration = CFTimeInterval(self.animationTime)
        
        startAnimation.setValue("animation", forKey: "strokeEnd")
        startAnimation.delegate = self
        startAnimation.fillMode = kCAFillModeForwards
        
        let endAnimation = CABasicAnimation(keyPath: "strokeStart")
        endAnimation.beginTime = CFTimeInterval(animationDelay)
        endAnimation.fromValue = 0.0
        endAnimation.toValue = 1.0
        endAnimation.duration = CFTimeInterval(self.animationTime - animationDelay)
        
        endAnimation.setValue("animation", forKey: "strokeStart")
        endAnimation.delegate = self
        endAnimation.fillMode = kCAFillModeForwards
        
        // if it's a circular path, it can have a rotation animation
        //shouldRotate var indicate if progressbar should rotate
        if shouldRotate{
            rotate()
        }
        
        let groupAnim = CAAnimationGroup()
        groupAnim.animations = [startAnimation, endAnimation]
        groupAnim.duration = CFTimeInterval(self.animationTime)
        groupAnim.repeatCount = HUGE
        groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        progressShape.addAnimation(groupAnim, forKey: "gruoupAnim")
    }
    
    func endProgress(){
        progressShape.strokeEnd = 0.0
        progressShape.removeAllAnimations()
    }
    
    func rotate(){
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = M_PI * 2// rotate 360 degrees
        rotateAnimation.duration = CFTimeInterval(self.animationTime * 1.2)
        rotateAnimation.repeatCount = HUGE
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    func updatePercent(value: Float){
        guard let pLabel = self.progressLabel else{
            return
        }
        pLabel.text = String(format: "%.0f %@", value, "%")
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
        progressLabel!.font = percentFont
        progressLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        detailsLabel = UILabel()
        detailsLabel!.text = "0.0 MB / 0.0 MB"
        detailsLabel!.textAlignment = .Center
        detailsLabel!.textColor = UIColor.blackColor()
        detailsLabel!.font = detailsFont
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
