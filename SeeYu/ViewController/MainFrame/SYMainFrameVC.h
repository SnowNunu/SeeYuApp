//
//  SYMainFrameVC.h
//  SeeYu
//
//  Created by trc on 2019/01/24.
//  Copyright © 2019年 fljj. All rights reserved.
//  `首页`会话层页面

#import "SYVC.h"
#import "SYMainFrameVM.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import <CoreLocation/CoreLocation.h>

@interface SYMainFrameVC : SYVC <FSSegmentTitleViewDelegate,FSPageContentViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end
