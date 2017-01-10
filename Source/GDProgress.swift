//
//  Progress.swift
//  LoadingBar
//
//  Created by Saeid on 4/12/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

class GDProgress: UIView, CAAnimationDelegate {
    fileprivate var progressShape: CAShapeLayer = CAShapeLayer()
    fileprivate var routeShape: CAShapeLayer? = nil
    fileprivate var progressLabel: UILabel? = nil
    fileprivate var detailsLabel: UILabel? = nil
    
    var progressPath: UIBezierPath!
    var animationTime: CGFloat = 3.0
    var animationDelay: CGFloat = 1
    var showLabels: Bool = true
    var showRoutePath: Bool = false
    var lineWidth: CGFloat = 10.0
    var shouldRotate: Bool = true
    var shouldGradiant: Bool = true
    var routeColor: UIColor = UIColor.gray
    var progressColor: UIColor = UIColor.blue
    var grad1Color: UIColor = UIColor.white
    var grad2Color: UIColor = UIColor.black
    var percentFont: UIFont = UIFont.systemFont(ofSize: 20)
    var detailsFont: UIFont = UIFont.systemFont(ofSize: 15)

    
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
        self.backgroundColor = UIColor.clear
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
        let circleCenter = CGPoint(x: bounds.midX , y: bounds.midY)
        let startAngle = CGFloat(M_PI_2)
        let endAngle = startAngle + CGFloat(M_PI * 2)
        
        let progressBezier = UIBezierPath(arcCenter: circleCenter, radius: circleRaduis, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        return progressBezier
    }
    
    //MARK: - Layers
    //Create custom shape layers
    fileprivate func createMainLayer(){
        if let _ = self.progressPath{
            progressShape.path = progressPath?.cgPath
        }else{
            progressShape.path = createMainPath().cgPath
        }
        progressShape.backgroundColor = UIColor.clear.cgColor
        progressShape.fillColor = nil
        progressShape.strokeColor = progressColor.cgColor
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
            maskLayer.strokeColor = progressColor.cgColor
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
        routeShape!.strokeColor = routeColor.cgColor
        routeShape!.fillColor = nil
        routeShape!.strokeStart = 0.0
        routeShape!.strokeEnd = 1.0
        routeShape!.lineWidth = 1.0
        routeShape!.lineJoin = "round"
        routeShape!.lineDashPattern = [2, 4]
        layer.insertSublayer(routeShape!, below: progressShape)
    }
    
    fileprivate func createGradiantLayer(_ g1: UIColor, g2: UIColor) -> CAGradientLayer{
        let gLayer = CAGradientLayer()
        gLayer.frame = self.bounds
        gLayer.locations = [0.0, 1.0]
        
        let top = grad1Color.cgColor
        let bot = grad2Color.cgColor
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
        
        progressShape.add(groupAnim, forKey: "gruoupAnim")
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
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func updatePercent(_ value: Float){
        guard let pLabel = self.progressLabel else{
            return
        }
        pLabel.text = String(format: "%.0f %@", value, "%")
    }
    
    func updateAnimation(_ currentVal: CGFloat){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressShape.strokeEnd
        animation.toValue = currentVal
        animation.duration = 0.2
        animation.fillMode = kCAFillModeForwards
        
        progressShape.strokeEnd = currentVal
        progressShape.add(animation, forKey: nil)
    }
    
    func updatePercente(_ percent: Float){
        guard let pLabel = self.progressLabel else{
            return
        }
        pLabel.text = "\(percent) %"
    }
    
    func updateDetails(_ downloded: Int64, total: Int64){
        guard let dLabel = self.detailsLabel else{
            return
        }
        let downlodedMB = convertToMB(downloded)
        let totalMB = convertToMB(total)
        
        dLabel.text = String(format: "%0.2f MB / %0.2f MB", downlodedMB, totalMB)
    }
    
    func convertToMB(_ totalBytes: Int64) -> Float{
        return (Float(totalBytes) / 1024) / 1024
    }
    
    //MARK: - Labels
    //Create indicator labels for loading progress bar
    fileprivate func createLabels(){
        progressLabel = UILabel()
        progressLabel!.text = "0 %"
        progressLabel!.textAlignment = .center
        progressLabel!.textColor = UIColor.black
        progressLabel!.font = percentFont
        progressLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        detailsLabel = UILabel()
        detailsLabel!.text = "0.0 MB / 0.0 MB"
        detailsLabel!.textAlignment = .center
        detailsLabel!.textColor = UIColor.black
        detailsLabel!.font = detailsFont
        detailsLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(detailsLabel!)
        self.addSubview(progressLabel!)
        
        setupConstains()
    }
    
    fileprivate func setupConstains(){
        let wConstraintP = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: progressLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let hConstraintP = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: progressLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let yAlignmentConstraint = NSLayoutConstraint(item: progressLabel!, attribute: .centerX, relatedBy: .equal, toItem: detailsLabel!, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let topConstraintD = NSLayoutConstraint(item: progressLabel!, attribute: .bottom, relatedBy: .equal, toItem: detailsLabel!, attribute: .top, multiplier: 1.0, constant: 1.0)
        
        self.addConstraints([wConstraintP, hConstraintP, yAlignmentConstraint, topConstraintD])
    }
    
    
    
    
    
    
    
}
