//
//  SYMomentListCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaSecurity/CocoaSecurity.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^openRechargeTipsBlock)(void);

@interface SYMomentListCell : UITableViewCell

@property (nonatomic, strong) openRechargeTipsBlock block;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) YYLabel *aliasLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) YYLabel *contentLabel;

@property (nonatomic, strong) UIView *photoContainerView;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, strong) UIImageView *videoContainerView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *lineView;

- (void)_setupPhotosViewByUrls:(NSString*)photosUrl;

- (void)emptyPhotosView;

- (void)_setupVideoShowViewBy:(NSString*)url;

- (void)emptyVideoView;

@end

NS_ASSUME_NONNULL_END
