//
//  Tools.swift
//  ScreenVideoDemo
//
//  Created by Janise on 2019/1/11.
//  Copyright © 2019年 Janise. All rights reserved.
//

import Foundation
/// 将秒数计算展示为时分秒
///
/// - Parameter seconds: 总秒数
/// - Returns: 时分秒文字展示
func timeString(_ seconds: Int) -> String {
    //小时显示
    let hour = seconds/3600
    //分钟显示
    let minute = seconds%3600/60
    //秒数显示
    let second = seconds%60
    return String(format: "%02d", hour)+":"+String(format: "%02d", minute)+":"+String(format: "%02d", second)
}
