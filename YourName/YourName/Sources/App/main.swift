//
//  main.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import UIKit

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc)),
    NSStringFromClass(UIApplication.self),
    NSStringFromClass(AppDelegate.self)
)
