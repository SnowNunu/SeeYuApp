//
//  SYMyMomentsListCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/1.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBImageCliped.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMyMomentsListCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *yearLabel;

@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UILabel *monthLabel;

@property (nonatomic, strong) UILabel *aliasLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *photoContainerView;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, strong) UIImageView *videoContainerView;

@property (nonatomic, strong) UIView *bottomView;

- (void)_setupPhotosViewByUrls:(NSString*)photosUrl;

- (void)emptyPhotosView;

- (void)_setupVideoShowViewBy:(NSString*)url;

- (void)emptyVideoView;

@end

NS_ASSUME_NONNULL_END
