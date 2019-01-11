//
//  ViewController.swift
//  ScreenVideoDemo
//
//  Created by Janise on 2019/1/11.
//  Copyright © 2019年 Janise. All rights reserved.
//

import UIKit
import MobileCoreServices
import ReplayKit
class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RPPreviewViewControllerDelegate {
    
    /// 展示录屏控件按钮
    @IBOutlet weak var showViewBtn: UIButton!
    /// 计时器
    var time: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 点击展示录屏控件
    ///
    /// - Parameter sender: 按钮
    @IBAction func showActionView(_ sender: UIButton) {
        if !self.showViewBtn.isSelected {
            let replayVideoView = ReplayToolsView(frame: CGRect(x: 20, y: self.view.bounds.height-100, width: self.view.bounds.width-40, height: 50))
            //使用block代替在view中编写关闭方法，添加对“app录屏”按钮的选中状态设置
            replayVideoView.closeBlock = { () in
                //此处设置结束录制后将replayVideoView移除，也可以隐藏isHidden，在此处和startRecordingScreen方法中将view改成隐藏，replayVideoView需要改为全局变量使用
                replayVideoView.removeFromSuperview()
                self.showViewBtn.isSelected = !self.showViewBtn.isSelected
            }
            replayVideoView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragFunction)))
            replayVideoView.actionBlock = {
                self.startRecordingScreen(replayVideoView)
                replayVideoView.closeButton.isHidden = replayVideoView.actionButton.isSelected
            }
            let window = UIApplication.shared.keyWindow
            window!.addSubview(replayVideoView)
            self.showViewBtn.isSelected = !self.showViewBtn.isSelected
        }
    }
    // Janise: 设置拖动手势（可用于拖动控件后设置控件依赖位置，此处只设置可在y轴方向上移动，如需要在x方向上移动，可对x位置修改）
    @objc func dragFunction(_ pan: UIPanGestureRecognizer) {
        let point = pan.translation(in: view)
        if let v = pan.view {
            //设置移至顶部和底部时不可移动，64为个人主观设置值，可根据个人需要更改
            if (v.frame.origin.y > 64 && point.y < 0)
                || (v.frame.origin.y + v.frame.height < (UIApplication.shared.keyWindow?.frame.height)! && point.y > 0) {
                v.center.y = v.center.y + point.y
            }
            pan.setTranslation(.zero, in: view)
        }
    }
    // Janise:  开始录制屏幕（考虑问题，可否像android那样在录屏时不将ReplayVideoToolView视图作为屏幕的一部分录制，我暂时还没找到方法）
    
    /// 开始录屏(遗留问题：初次录屏时会询问用户是否同意使用录屏功能，但是时间在用户点击录屏按钮时已开始计时，与用户同意使用录屏功能时间点有时间差，这部分需要解决)
    ///
    /// - Parameter toolView: 自制黑色半透明录屏视图（用于图标的展示修改和时间的变化）
    @objc func startRecordingScreen(_ toolView: ReplayToolsView) {
        // 检测设备是否支持录屏功能
        if RPScreenRecorder.shared().isAvailable && systemVersionAvaliable()  {
            //录屏按钮是否选中
            if toolView.actionButton.isSelected {
                //停止计时
                self.time?.invalidate()
                self.time = nil
                toolView.seconds = 0
                //选中状态下停止录制
                RPScreenRecorder.shared().stopRecording { (previewCon, error) in
                    if let errors = error {
                        print(errors)
                    }
                    if let controller = previewCon {
                        controller.previewControllerDelegate = self
                        UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
                    }
                }
                
                toolView.actionButton.isSelected = false
                toolView.removeFromSuperview()
                self.showViewBtn.isSelected = !self.showViewBtn.isSelected
                return
            }else {
                //开始计时
                self.time = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                    toolView.seconds += 1
                })
                //未选中状态下开始录屏
                RPScreenRecorder.shared().startRecording { (err) in
                    if let error = err {
                        print(error)
                    }
                }
                toolView.actionButton.isSelected = true
            }
        }else {
            //            //正式编写时需将两种提示分开展示，权限与版本两个不可合二为一
            //            let alert = UIAlertController(title: "提示", message: "请先授予app录屏权限，系统版本低于9.0不支持录屏功能，请升级版本后使用该功能", preferredStyle: .alert)
            //            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// 视频播放失败
    ///
    /// - Parameter previewController: 视频预览播放器
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        //关闭视频预览
        previewController.dismiss(animated: true, completion: nil)
    }
    
    /// 判断版本是否在9.0版本及以上版本
    ///
    /// - Returns: 布尔值
    func systemVersionAvaliable() -> Bool {
        if #available(iOS 9.0, *) {
            return true
        }
        return false
    }
}

