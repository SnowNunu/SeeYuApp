//
//  YLShortVideoVC.h
//  NHZGame
//
//  Created by MH on 2017/6/27.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLShortVideoVC : UIViewController

@property (nonatomic, copy) void(^shortVideoBack)(NSURL *videoUrl);

@end
