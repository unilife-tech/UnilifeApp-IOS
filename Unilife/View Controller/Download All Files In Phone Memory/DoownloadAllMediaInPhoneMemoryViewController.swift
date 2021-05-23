//
//  DoownloadAllMediaInPhoneMemoryViewController.swift
//  Unilife
//
//  Created by Apple on 25/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class DoownloadAllMediaInPhoneMemoryViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var downloadMediaTable_View: UITableView!
    
    var downloadTaskList = [DownloadTaskInfo]()
    
    var urlSession: URLSession!
    
    // MARK: - Variable
    
    var urlList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadMediaTable_View.delegate = self
        
        self.downloadMediaTable_View.dataSource = self

    }
    
    
    // MARK: - Button Action
    
    @IBAction func tapClose_btn(_ sender: Any) {
        
    self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Table View Delegate And DataSource

extension DoownloadAllMediaInPhoneMemoryViewController: UITableViewDataSource, UITableViewDelegate, URLSessionDelegate, URLSessionDownloadDelegate{
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return urlList.count 
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:DownloadTaskCellTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "DownloadTaskCellTableViewCell") as? DownloadTaskCellTableViewCell;
        if(cell == nil) {
            cell = DownloadTaskCellTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DownloadTaskCellTableViewCell");
        }
        
        cell!.layoutMargins = UIEdgeInsets.zero;
        cell!.preservesSuperviewLayoutMargins = false;
        
        let downloadTaskInfo = DownloadTaskInfo();
        downloadTaskInfo.name = String(urlList[indexPath.row]);
        downloadTaskInfo.url = String(urlList[indexPath.row]);
        
      downloadTaskList.append(downloadTaskInfo);
        
        cell?.name.text = downloadTaskInfo.name;
        cell?.progressBar.progress = downloadTaskInfo.progress;
        cell?.progressLabel.text = String(Int(downloadTaskInfo.progress)) + "%";
        
        cell?.startBtn.addTarget(self, action: #selector(startDownloadSingleFile(_:)), for: .touchUpInside)
        
        return cell!;
    }
    
    
    // MARK: - Download Functions
    
    @objc func startDownloadSingleFile(_ sender: AnyObject) {
        print(sender.superview!!.superview);
        
        let view = sender.superview!!.superview
        if((sender.superview!!.superview!) is  DownloadTaskCellTableViewCell) {
            let taskCell = sender.superview!!.superview! as! DownloadTaskCellTableViewCell;
            let cellIndexPath = self.downloadMediaTable_View.indexPath(for: taskCell);
            let downloadInfo = downloadTaskList[(cellIndexPath!.row)];

            if(downloadInfo.isDownload) {
                //pause it
                downloadInfo.downloadTask!.cancel(byProducingResumeData: { (resumeData) -> Void in
                    downloadInfo.downloadedData = NSData.init(data: resumeData!);
//                    self.writeCacheFile(downloadInfo.downloadedData, fileName: String(downloadInfo.url!.hash));
                })

                downloadInfo.isDownload = false;
                (sender as! UIButton).setTitle("Resume", for: .normal)
            } else {
                //start it or resume it
//                downloadInfo.downloadedData = self.readCacheFile(String(downloadInfo.url!.hash));
                if(downloadInfo.downloadedData != nil) {
//                    downloadInfo.downloadTask = urlSession?.downloadTaskWithResumeData(downloadInfo.downloadedData!);
                } else {
                    let url:NSURL = NSURL.init(string: downloadInfo.url!)!;
                    
//                    downloadInfo.downloadTask = self.urlSession!.downloadTaskWithURL(url);
                }

                downloadInfo.downloadTaskId = downloadInfo.downloadTask?.taskIdentifier;
                downloadInfo.downloadTask!.resume();
                (sender as! UIButton).setTitle("Pause", for: .normal);
                downloadInfo.isDownload = true;
                downloadInfo.downloadedData = nil;
            }
        }
    }
    
    
    
}
