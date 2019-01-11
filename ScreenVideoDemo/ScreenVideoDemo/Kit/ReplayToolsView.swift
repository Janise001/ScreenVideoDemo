//
//  ReplayToolsView.swift
//  ScreenVideoDemo
//
//  Created by Janise on 2019/1/11.
//  Copyright © 2019年 Janise. All rights reserved.
//

import UIKit

class ReplayToolsView: UIView {
    /// 关闭闭包
    var closeBlock: (()->())?
    /// 开始录制闭包
    var actionBlock: (()->())?
    /// 关闭按钮
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "replay_close_icon"), for: .normal)
        return button
    }()
    /// 时间展示label
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textAlignment = .center
        label.textColor = Color.white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    /// 录屏 开始/关闭 按钮
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "replay_start_icon"), for: .normal)
        button.setBackgroundImage(UIImage(named: "replay_notStart_icon"), for: .selected)
        return button
    }()
    /// 秒数
    var seconds: Int = 0 {
        didSet {
            timeLabel.text = timeString(seconds)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.black
        self.alpha = 0.5
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.closeButton.addTarget(self, action: #selector(closeTool), for: .touchUpInside)
        self.actionButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        self.configLayout()
    }
    /// 配置控件
    func configLayout() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.addArrangedSubview(self.closeButton)
            view.addArrangedSubview(self.timeLabel)
            view.addArrangedSubview(self.actionButton)
            view.axis = .horizontal
            view.alignment = .center
            view.distribution = .equalCentering
            view.spacing = 10
            return view
        }()
        self.addSubview(stackView)
        stackView.frame = CGRect(x: 15.0, y: 0.0, width: self.bounds.width-30, height: self.bounds.height)
    }
    
    /// 关闭视图
    @objc func closeTool() {
        self.closeBlock?()
    }
    /// 开始录屏
    @objc func start() {
        self.actionBlock?()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

