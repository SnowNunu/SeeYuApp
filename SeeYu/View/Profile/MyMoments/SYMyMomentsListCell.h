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

@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, strong) NSMutableArray *photosImageArrays;

@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UILabel *monthLabel;

@property (nonatomic, strong) UIView *photosBgView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *photosNumberLabel;

- (void)setDayAndMonthLabel:(NSString *)timeLabel;

- (void)setPhotosShowView:(NSString *)photosString;

- (void)setVideoShowView:(NSString *)videoString;

@end

NS_ASSUME_NONNULL_END
