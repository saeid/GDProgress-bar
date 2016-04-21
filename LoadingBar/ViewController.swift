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
        pView.lineWidth = 10.0
        
        //this will rotate the progress bar if enabled. it works for Waiting bar to create
        //smooth animating bar
        pView.shouldRotate = true
        
        //active gradiant color for bar
        pView.shouldGradiant = true
        
        //route line color
        pView.routeColor = UIColor.grayColor()
        
        //main progress bar color. this only used for gradiant is not enabled
        pView.progressColor = UIColor.blueColor()
        
        //first gradiant color, this only works if gradiant is enabled
        pView.grad1Color = UIColor.whiteColor()
        
        //second gradiant color, this only works if gradiant is enabled
        pView.grad2Color = UIColor.blackColor()
        
        //font for % label
        pView.percentFont = UIFont.systemFontOfSize(20)
        
        //font for details label
        pView.detailsFont = UIFont.systemFontOfSize(15)
        
        //call this at end of view modifications
        pView.setupView()
        
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

