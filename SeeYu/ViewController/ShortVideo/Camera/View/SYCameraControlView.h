//
//  SYCameraControlView.h
//  WeChat
//
//  Created by lx on 2018/8/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  照相机控制层

#import <UIKit/UIKit.h>
#import "SYVideoPreviewView.h"


/// 控制层的事件处理
typedef NS_ENUM(NSUInteger, SYCameraControlViewOperationType) {
    SYCameraControlViewOperationTypeSwap = 0,   /// 切换摄像头
    SYCameraControlViewOperationTypeClose,      /// 关闭界面
    SYCameraControlViewOperationTypeCancel,     /// 取消
    SYCameraControlViewOperationTypeEdit,       /// 编辑
    SYCameraControlViewOperationTypeDone,       /// 完成
};



/// 代理

@class SYCameraControlView;

@protocol SYCameraControlViewDelegate <NSObject>

@optional

/// 按钮的操作事件
- (void)cameraControlViewOperationAction:(SYCameraControlView *)controlView operationType:(SYCameraControlViewOperationType)operationType;

@end



@interface SYCameraControlView : UIView

/// previewView
@property (nonatomic , readonly , strong) SYVideoPreviewView *previewView;

/// delegate
@property (nonatomic , readwrite , weak) id <SYCameraControlViewDelegate> delegate;

@end
