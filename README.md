# AMKits

[![Platform](https://img.shields.io/cocoapods/p/AMKits.svg?style=flat)](http://cocoapods.org/pods/AMKits)
[![Language](https://img.shields.io/badge/Language-%20Objective%20C%20-blue.svg)]()
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Version](https://img.shields.io/cocoapods/v/AMKits.svg?style=flat)](http://cocoapods.org/pods/AMKits)
[![License](https://img.shields.io/cocoapods/l/AMKits.svg?style=flat)](http://cocoapods.org/pods/AMKits)
[![Weibo](https://img.shields.io/badge/Sina微博-@Developer_Andy-orange.svg?style=flat)](http://weibo.com/u/5271489088)
[![GitHub stars](https://img.shields.io/github/stars/AndyM129/AMKits.svg)](https://github.com/AndyM129/AMKits/stargazers)
[![Download](https://img.shields.io/cocoapods/dt/AMKits.svg)](https://github.com/AndyM129/AMKits/archive/master.zip)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Requirements

- iOS8 +



## Installation

AMKits is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```Linux
pod "AMKits"
```



## Update History

### 2017-07-19

#### 1. 搭建项目框架

#### 2. 发布`0.1.0`版本

##### 1) 添加 NSObject+AMKDeallocBlock.h

可随意给对象添加随意多个在执行`dealloc`时执行的block，可用来释放对象、移除通知

##### 2) 添加 NSObject+AMKLocaleDescription.h

重写相关方法，使得`NSArray`、`NSDictionar`y、`NSSet`等集合类的实例在控制台输出时，能够正常的打印中文，而不是Unicode码

##### 3) 添加 UIViewController+AMKLifeCircleBlock.h

为外部提供的`viewDidLoad`、`viewWillAppear:`、`viewDidAppear:`、`viewWillDisappear:`、`viewDidDisappear:`等生命周期的回调

##### 4) 添加 UIViewController+AMKViewControllerSwitch.h

添加`UIViewController`切换相关扩展

##### 5) 添加 UIView+AMKExtendTouchRect.h

支持对`UIView`手势交互范围的调整



## Author

如果你有好的 idea 或 疑问，请随时提 issue 或 request。

如果你在开发过程中遇到什么问题，或对iOS开发有着自己独到的见解，再或是你与我一样同为菜鸟，都可以关注或私信我的微博 [`@Developer_Andy`](http://weibo.com/u/5271489088)、[`简书`](http://www.jianshu.com/users/28d89b68984b/latest_articles)

“Stay hungry. Stay foolish.”

与君共勉~



## One More Thing

如果你想了解开源框架的创建方法，具体可以参看我的简书[《创建自己的开源框架到CocoaPods》](http://www.jianshu.com/p/f39a22252e5f)



## License

AMKits is available under the MIT license. See the LICENSE file for more info.
