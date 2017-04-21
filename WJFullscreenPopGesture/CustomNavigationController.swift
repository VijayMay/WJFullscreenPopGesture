//
//  CustomNavigationController.swift
//  WJFullscreenPopGesture
//
//  Created by mwj on 17/4/20.
//  Copyright © 2017年 MWJ. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         
         分析：一般用手势触发某个行为需要哪些条件 ？
         
         1、需要创建一个我们需要的手势实例；
         2、添加到一个View上（需要一个view）；
         3、需要一个Target；
         4、需要一个Action。
         
         let tapG = UITapGestureRecognizer()
         view.addGestureRecognizer(tapG)
         tapG.addTarget(<#T##target: Any##Any#>, action: <#T##Selector#>)
         
         我们需要改成全屏触发，其实Target和Action 是不需要改的，那我们就先拿到 Target和Action。
         再拿到手势和添加手势的View，尝试的去改手势和添加手势的View 。
         
         总结： 从iOS 7.0 系统就帮我添加了手势返回，但是只支持左边缘触发，现在我们需要改成全屏触发，只要把系统的手势更换为UIPanGestureRecognizer.
         
         */
        

        // 获取系统的Pop手势
        guard let systemGes = interactivePopGestureRecognizer else { return }
        
        print(systemGes)
        // 获取系统手势添加的view
        guard let gesView = systemGes.view else { return }
        
        // 获取Target和Action，但是系统并没有暴露相关属性
        //利用 class_copyIvarList 查看所有的属性 (发现_targets 是一个数组)
        print("------------------------属性---------------------------------")
        var ivarCount : UInt32 = 0
        let ivars = class_copyIvarList(UIGestureRecognizer.self, &ivarCount)!
        for i in 0..<ivarCount {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            print(String(cString: name!))
        }
        print("------------------------方法---------------------------------")
        //利用 class_copyMethodList 查看所有的方法（并没有找到我们想要的方法）
        var methodCount : UInt32 = 0
        let methods = class_copyMethodList(UIGestureRecognizer.self, &methodCount)!
        
        for i in 0 ..< methodCount {
            let method = methods[Int(i)]
            let name = method_getName(method)
            print("\(name)")
        }
        //从Targets 取出 Target
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        guard let target = targetObjc.value(forKey: "target") else { return }
        //方法名称获取 Action
        let action = Selector(("handleNavigationTransition:"))
        

        let panGes = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)
        

    }
    

}
