//
//  ViewController.swift
//  LoadingBar
//
//  Created by Saeid on 4/12/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDownloadDelegate {
    //Create instance of Progress
    @IBOutlet weak var pView: Progress!
    
    var isWaiting = false
    var isDownloading = false
    var downloadTask: NSURLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView(){
        //Show labels for download progress
        pView.showLabels = false
        
        //Show route path for a download progress
        pView.showRoutePath = false
        
        //waiting progress animation duration
        pView.animationTime = 3
        
        //Delay between animation for waiting bar
        pView.animationDelay = 1
        
        //path line width for progress/waiting bar
        pView.lineWidth = 6.0
        
        //this will rotate the progress bar if enabled. set it to false if you enable showLabels property
        pView.shouldRotate = true
        
        //active gradiant color for bar
        pView.shouldGradiant = true
        
        //route line color
        pView.routeColor = UIColor.grayColor()
        
        //main progress bar color. this only used for gradiant is not enabled
        pView.progressColor = UIColor.blueColor()
        
        //first gradiant color, this only works if gradiant is enabled
//        pView.grad1Color = UIColor.whiteColor()
        
        //second gradiant color, this only works if gradiant is enabled
//        pView.grad2Color = UIColor.blackColor()
        
        //font for % label
//        pView.percentFont = UIFont.systemFontOfSize(20)
        
        //font for details label
//        pView.detailsFont = UIFont.systemFontOfSize(15)
        
        //set custom path for the progress/waiting bar
//        pView.progressPath = createCustomPath()
        
        //call this at end of view modifications
        pView.setupView()
    }
    
    func createCustomPath() -> UIBezierPath{
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(205.5, 0.5))
        bezierPath.addCurveToPoint(CGPointMake(193.5, 8.5), controlPoint1: CGPointMake(197.75, 0.5), controlPoint2: CGPointMake(193.5, 8.5))
        bezierPath.addCurveToPoint(CGPointMake(184.16, 24.72), controlPoint1: CGPointMake(193.5, 8.5), controlPoint2: CGPointMake(171.5, 10.5))
        bezierPath.addCurveToPoint(CGPointMake(174.5, 41.5), controlPoint1: CGPointMake(196.83, 38.93), controlPoint2: CGPointMake(174.5, 41.5))
        bezierPath.addCurveToPoint(CGPointMake(150.5, 25.5), controlPoint1: CGPointMake(174.5, 41.5), controlPoint2: CGPointMake(165.5, 9.5))
        bezierPath.addCurveToPoint(CGPointMake(135.5, 41.5), controlPoint1: CGPointMake(135.5, 41.5), controlPoint2: CGPointMake(149.5, 41.5))
        bezierPath.addCurveToPoint(CGPointMake(109.5, 41.5), controlPoint1: CGPointMake(121.5, 41.5), controlPoint2: CGPointMake(125.5, 75.5))
        bezierPath.addCurveToPoint(CGPointMake(92.5, 8.5), controlPoint1: CGPointMake(93.5, 7.5), controlPoint2: CGPointMake(92.5, 8.5))
        bezierPath.addCurveToPoint(CGPointMake(64.5, 31.5), controlPoint1: CGPointMake(92.5, 8.5), controlPoint2: CGPointMake(64.5, -6.5))
        bezierPath.addCurveToPoint(CGPointMake(26.5, 41.5), controlPoint1: CGPointMake(64.5, 69.5), controlPoint2: CGPointMake(26.5, 41.5))
        bezierPath.addCurveToPoint(CGPointMake(14.5, 82.5), controlPoint1: CGPointMake(26.5, 41.5), controlPoint2: CGPointMake(-4.5, 69.5))
        bezierPath.addCurveToPoint(CGPointMake(51.5, 68.5), controlPoint1: CGPointMake(33.5, 95.5), controlPoint2: CGPointMake(51.5, 68.5))
        bezierPath.addCurveToPoint(CGPointMake(92.5, 68.5), controlPoint1: CGPointMake(51.5, 68.5), controlPoint2: CGPointMake(92.5, 48.5))
        bezierPath.addCurveToPoint(CGPointMake(114.5, 91.5), controlPoint1: CGPointMake(92.5, 88.5), controlPoint2: CGPointMake(93.5, 100.5))
        bezierPath.addCurveToPoint(CGPointMake(141.5, 75.5), controlPoint1: CGPointMake(135.5, 82.5), controlPoint2: CGPointMake(141.5, 75.5))
        bezierPath.addCurveToPoint(CGPointMake(141.5, 58.5), controlPoint1: CGPointMake(141.5, 75.5), controlPoint2: CGPointMake(123.5, 58.5))
        bezierPath.addCurveToPoint(CGPointMake(174.5, 107.5), controlPoint1: CGPointMake(159.5, 58.5), controlPoint2: CGPointMake(174.5, 107.5))
        bezierPath.addCurveToPoint(CGPointMake(224.5, 82.5), controlPoint1: CGPointMake(174.5, 107.5), controlPoint2: CGPointMake(244.5, 115.5))
        bezierPath.addCurveToPoint(CGPointMake(174.5, 68.5), controlPoint1: CGPointMake(204.5, 49.5), controlPoint2: CGPointMake(174.5, 68.5))
        bezierPath.addCurveToPoint(CGPointMake(212.5, 41.5), controlPoint1: CGPointMake(174.5, 68.5), controlPoint2: CGPointMake(194.5, 24.5))
        bezierPath.addCurveToPoint(CGPointMake(224.5, 8.5), controlPoint1: CGPointMake(230.5, 58.5), controlPoint2: CGPointMake(224.5, 8.5))
        bezierPath.addCurveToPoint(CGPointMake(205.5, 0.5), controlPoint1: CGPointMake(224.5, 8.5), controlPoint2: CGPointMake(213.25, 0.5))
        bezierPath.closePath()
        
        return bezierPath
    }
    
    //MARK: - Create Waiting bar
    @IBAction func startWaiting(){
        if !isWaiting{
            //starts waiting bar
            
            isWaiting = !isWaiting
            pView.startProgress()
        }else{
            //stop waiting bar
            
            isWaiting = !isWaiting
            pView.endProgress()
        }
    }
    
    //MARK: - Create Download Actions
    @IBAction func startProgress(sender: UIButton){
        if isDownloading{
            self.isDownloading = !isDownloading
            downloadTask?.cancel()
        }else{
            self.isDownloading = !isDownloading
            createDlTask()
        }
    }
    
    /*!
     Create a download task and add to NSOperationQueue
     */
    func createDlTask() {
        let downloadRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.solarspace.co.uk/Multimedia/ISS/ISSNicebackdropBIG.jpg")!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        downloadTask = session.downloadTaskWithRequest(downloadRequest)
        downloadTask!.resume()
    }
    
    
    //MARK: - NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        pView.updateAnimation(CGFloat(progress))
        pView.updatePercent(progress * 100)
        pView.updateDetails(totalBytesWritten, total: totalBytesExpectedToWrite)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        // Show Download Complete
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let _ = error {
            // Show Error
        } else {
            // Show Success
        }
    }
    
    
}

