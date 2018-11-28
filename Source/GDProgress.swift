//
//  Progress.swift
//  LoadingBar
//
//  Created by Saeid on 4/12/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

class GDProgress: UIView{
    fileprivate var progressShape: CAShapeLayer = CAShapeLayer()
    fileprivate var routeShape: CAShapeLayer? = nil
    
    var progressPath: UIBezierPath?
    var animationTime: CGFloat = 3.0
    var animationDelay: CGFloat = 1
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

        backgroundColor = UIColor.clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
    }
    
    func setup(showLabels: Bool = false, showRoutePath: Bool = false){
        if showLabels{
            createLabels()
        }
        if showRoutePath{
            createRouteLayer()
        }
        createMainLayer()
    }

    //MARK: - Pathes
    //Create custom path for loading
    private var mainPath: UIBezierPath{
        let circleRaduis = (min(bounds.width, bounds.height) / 2 - progressShape.lineWidth) / 2
        let circleCenter = CGPoint(x: bounds.midX , y: bounds.midY)
        let startAngle = CGFloat(Double.pi)
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        
        let progressPath = UIBezierPath(arcCenter: circleCenter, radius: circleRaduis, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        return progressPath
    }
    
    //MARK: - Layers
    //Create custom shape layers
    fileprivate func createMainLayer(){
        if let _ = self.progressPath{
            progressShape.path = progressPath?.cgPath
        }else{
            progressShape.path = mainPath.cgPath
        }
        progressShape.backgroundColor = UIColor.clear.cgColor
        progressShape.fillColor = nil
        progressShape.strokeColor = progressColor.cgColor
        progressShape.lineWidth = lineWidth
        progressShape.strokeStart = 0.0
        progressShape.strokeEnd = 0.0
        progressShape.lineJoin = CAShapeLayerLineJoin(rawValue: "round")

        if shouldGradiant{
            let gradiantLayer = createGradiantLayer(grad1Color, grad2Color)
            gradiantLayer.mask = progressShape
            layer.addSublayer(gradiantLayer)
        }else{
            let maskLayer = CAShapeLayer()
            maskLayer.strokeColor = progressColor.cgColor
            maskLayer.lineWidth = lineWidth
            maskLayer.strokeStart = 0.0
            maskLayer.strokeEnd = 1.0
            maskLayer.lineJoin = CAShapeLayerLineJoin(rawValue: "round")
            maskLayer.path = progressShape.path

            maskLayer.mask = progressShape
            layer.addSublayer(maskLayer)
        }
    }
    
    fileprivate func createRouteLayer(){
        routeShape = CAShapeLayer()
        routeShape!.path = progressShape.path
        routeShape!.strokeColor = routeColor.cgColor
        routeShape!.fillColor = nil
        routeShape!.strokeStart = 0.0
        routeShape!.strokeEnd = 1.0
        routeShape!.lineWidth = 1.0
        routeShape!.lineJoin = CAShapeLayerLineJoin(rawValue: "round")
        routeShape!.lineDashPattern = [2, 4]
        layer.insertSublayer(routeShape!, below: progressShape)
    }
    
    fileprivate func createGradiantLayer(_ g1: UIColor, _ g2: UIColor) -> CAGradientLayer{
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
     If it should be a simple loading indicator, this should be uncommented.
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
        startAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        let endAnimation = CABasicAnimation(keyPath: "strokeStart")
        endAnimation.beginTime = CFTimeInterval(animationDelay)
        endAnimation.fromValue = 0.0
        endAnimation.toValue = 1.0
        endAnimation.duration = CFTimeInterval(self.animationTime - animationDelay)
        
        endAnimation.setValue("animation", forKey: "strokeStart")
        endAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        // if it's a circular path, it can have a rotation animation
        //shouldRotate var indicate if progressbar should rotate
        if shouldRotate{
            rotate()
        }
        
        let groupAnim = CAAnimationGroup()
        groupAnim.animations = [startAnimation, endAnimation]
        groupAnim.duration = CFTimeInterval(self.animationTime)
        groupAnim.repeatCount = HUGE
        groupAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        progressShape.add(groupAnim, forKey: "gruoupAnim")
    }
    
    func endProgress(){
        progressShape.strokeEnd = 0.0
        progressShape.removeAllAnimations()
    }
    
    func rotate(){
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi * 2 // rotate 360 degrees
        rotateAnimation.duration = CFTimeInterval(self.animationTime * 1.2)
        rotateAnimation.repeatCount = HUGE
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func updatePercentWithFormat(_ value: Float){
        progressLabel.text = String(format: "%.0f %@", value, "%")
    }
    
    func updateAnimation(_ currentVal: CGFloat){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressShape.strokeEnd
        animation.toValue = currentVal
        animation.duration = 0.2
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        progressShape.strokeEnd = currentVal
        progressShape.add(animation, forKey: nil)
    }
    
    func updatePercent(_ value: Float){
        progressLabel.text = "\(value) %"
    }
    
    func updateDetails(_ downloded: Int64, _ total: Int64){
        let downlodedMB = convertToMB(downloded)
        let totalMB = convertToMB(total)
        
        detailsLabel.text = String(format: "%0.2f MB / %0.2f MB", downlodedMB, totalMB)
    }
    
    func convertToMB(_ totalBytes: Int64) -> Float{
        return (Float(totalBytes) / 1024) / 1024
    }
    
    //MARK: - Labels
    //Create indicator labels for loading progress bar
    lazy var progressLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0 %"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.black
        lbl.font = self.percentFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.sizeToFit()
        
        return lbl
    }()

    lazy var detailsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0.0 MB / 0.0 MB"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.black
        lbl.font = self.detailsFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.sizeToFit()
        
        return lbl
    }()
    
    fileprivate func createLabels(){
        addSubview(detailsLabel)
        addSubview(progressLabel)
        setupConstains()
    }
    
    fileprivate func setupConstains(){
        detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        detailsLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        progressLabel.centerXAnchor.constraint(equalTo: detailsLabel.centerXAnchor, constant: 0.0).isActive = true
        progressLabel.bottomAnchor.constraint(equalTo: detailsLabel.topAnchor, constant: -5).isActive = true
    }
}
