//
//  ViewController.swift
//  LoadingBar
//
//  Created by Saeid on 4/12/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var pView: Progress!
    
    var isDownloading = false
    var downloadTask: NSURLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pView.setupView()
        pView.startProgress()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Actions
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

