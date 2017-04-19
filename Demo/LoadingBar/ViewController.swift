//
//  ViewController.swift
//  LoadingBar
//
//  Created by Saeid on 4/12/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    //Create instance of Progress
    @IBOutlet weak var pView: GDProgress!
    
    var isWaiting = false
    var isDownloading = false
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView(){
        //Show labels for download progress
        pView.showLabels = true
        
        //Show route path for a download progress
        pView.showRoutePath = true
        
        //waiting progress animation duration
        pView.animationTime = 3
        
        //Delay between animation for waiting bar
        pView.animationDelay = 1
        
        //path line width for progress/waiting bar
        pView.lineWidth = 6.0
        
        //this will rotate the progress bar if enabled. set it to false if you enable showLabels property
        pView.shouldRotate = false
        
        //active gradiant color for bar
        pView.shouldGradiant = false
        
        //route line color
        pView.routeColor = UIColor.gray
        
        //main progress bar color. this only used for gradiant is not enabled
        pView.progressColor = UIColor.blue
        
        //first gradiant color, this only works if gradiant is enabled
//        pView.grad1Color = UIColor.white
        
        //second gradiant color, this only works if gradiant is enabled
//        pView.grad2Color = UIColor.black
        
        //font for % label
        pView.percentFont = UIFont.systemFont(ofSize: 20)
        
        //font for details label
//        pView.detailsFont = UIFont.systemFont(ofSize: 15)
        
        //set custom path for the progress/waiting bar
        pView.progressPath = createCustomPath()
        
        //call this at end of view modifications
        pView.setupView()
    }
    
    func createCustomPath() -> UIBezierPath{
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 205.5, y: 0.5))
        bezierPath.addCurve(to: CGPoint(x: 193.5, y: 8.5), controlPoint1: CGPoint(x: 197.75, y: 0.5), controlPoint2: CGPoint(x: 193.5, y: 8.5))
        bezierPath.addCurve(to: CGPoint(x: 184.16, y: 24.72), controlPoint1: CGPoint(x: 193.5, y: 8.5), controlPoint2: CGPoint(x: 171.5, y: 10.5))
        bezierPath.addCurve(to: CGPoint(x: 174.5, y: 41.5), controlPoint1: CGPoint(x: 196.83, y: 38.93), controlPoint2: CGPoint(x: 174.5, y: 41.5))
        bezierPath.addCurve(to: CGPoint(x: 150.5, y: 25.5), controlPoint1: CGPoint(x: 174.5, y: 41.5), controlPoint2: CGPoint(x: 165.5, y: 9.5))
        bezierPath.addCurve(to: CGPoint(x: 135.5, y: 41.5), controlPoint1: CGPoint(x: 135.5, y: 41.5), controlPoint2: CGPoint(x: 149.5, y: 41.5))
        bezierPath.addCurve(to: CGPoint(x: 109.5, y: 41.5), controlPoint1: CGPoint(x: 121.5, y: 41.5), controlPoint2: CGPoint(x: 125.5, y: 75.5))
        bezierPath.addCurve(to: CGPoint(x: 92.5, y: 8.5), controlPoint1: CGPoint(x: 93.5, y: 7.5), controlPoint2: CGPoint(x: 92.5, y: 8.5))
        bezierPath.addCurve(to: CGPoint(x: 64.5, y: 31.5), controlPoint1: CGPoint(x: 92.5, y: 8.5), controlPoint2: CGPoint(x: 64.5, y: -6.5))
        bezierPath.addCurve(to: CGPoint(x: 26.5, y: 41.5), controlPoint1: CGPoint(x: 64.5, y: 69.5), controlPoint2: CGPoint(x: 26.5, y: 41.5))
        bezierPath.addCurve(to: CGPoint(x: 14.5, y: 82.5), controlPoint1: CGPoint(x: 26.5, y: 41.5), controlPoint2: CGPoint(x: -4.5, y: 69.5))
        bezierPath.addCurve(to: CGPoint(x: 51.5, y: 68.5), controlPoint1: CGPoint(x: 33.5, y: 95.5), controlPoint2: CGPoint(x: 51.5, y: 68.5))
        bezierPath.addCurve(to: CGPoint(x: 92.5, y: 68.5), controlPoint1: CGPoint(x: 51.5, y: 68.5), controlPoint2: CGPoint(x: 92.5, y: 48.5))
        bezierPath.addCurve(to: CGPoint(x: 114.5, y: 91.5), controlPoint1: CGPoint(x: 92.5, y: 88.5), controlPoint2: CGPoint(x: 93.5, y: 100.5))
        bezierPath.addCurve(to: CGPoint(x: 141.5, y: 75.5), controlPoint1: CGPoint(x: 135.5, y: 82.5), controlPoint2: CGPoint(x: 141.5, y: 75.5))
        bezierPath.addCurve(to: CGPoint(x: 141.5, y: 58.5), controlPoint1: CGPoint(x: 141.5, y: 75.5), controlPoint2: CGPoint(x: 123.5, y: 58.5))
        bezierPath.addCurve(to: CGPoint(x: 174.5, y: 107.5), controlPoint1: CGPoint(x: 159.5, y: 58.5), controlPoint2: CGPoint(x: 174.5, y: 107.5))
        bezierPath.addCurve(to: CGPoint(x: 224.5, y: 82.5), controlPoint1: CGPoint(x: 174.5, y: 107.5), controlPoint2: CGPoint(x: 244.5, y: 115.5))
        bezierPath.addCurve(to: CGPoint(x: 174.5, y: 68.5), controlPoint1: CGPoint(x: 204.5, y: 49.5), controlPoint2: CGPoint(x: 174.5, y: 68.5))
        bezierPath.addCurve(to: CGPoint(x: 212.5, y: 41.5), controlPoint1: CGPoint(x: 174.5, y: 68.5), controlPoint2: CGPoint(x: 194.5, y: 24.5))
        bezierPath.addCurve(to: CGPoint(x: 224.5, y: 8.5), controlPoint1: CGPoint(x: 230.5, y: 58.5), controlPoint2: CGPoint(x: 224.5, y: 8.5))
        bezierPath.addCurve(to: CGPoint(x: 205.5, y: 0.5), controlPoint1: CGPoint(x: 224.5, y: 8.5), controlPoint2: CGPoint(x: 213.25, y: 0.5))
        bezierPath.close()
        
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
    @IBAction func startProgress(_ sender: UIButton){
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
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        downloadTask = session.downloadTask(with: URL(string: "http://www.solarspace.co.uk/Multimedia/ISS/ISSNicebackdropBIG.jpg")!)
        downloadTask!.resume()
    }
    
    
    //MARK: - NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        pView.updateAnimation(CGFloat(progress))
        pView.updatePercent(progress * 100)
        pView.updateDetails(totalBytesWritten, totalBytesExpectedToWrite)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Show Download Complete
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let _ = error {
            // Show Error
        } else {
            // Show Success
        }
    }
    
    
}

