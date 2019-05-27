//
//  SYMyMomentsListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/1.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMyMomentsListCell.h"
#import <YBImageBrowser/YBImageBrowser.h>

@implementation SYMyMomentsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = SYColorFromHexString(@"#F5DFFF");
    bgView.layer.cornerRadius = 9.f;
    bgView.layer.masksToBounds = YES;
    _bgView = bgView;
    [self.contentView addSubview:bgView];
    
    UILabel *yearLabel = [UILabel new];
    yearLabel.textAlignment = NSTextAlignmentLeft;
    yearLabel.textColor = SYColor(193, 99, 237);
    yearLabel.font = SYFont(14, YES);
    _yearLabel = yearLabel;
    [self.contentView addSubview:yearLabel];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.textColor = SYColor(193, 99, 237);
    aliasLabel.font = SYFont(13, YES);
    _aliasLabel = aliasLabel;
    [self.contentView addSubview:aliasLabel];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = SYColor(193, 99, 237);
    timeLabel.font = SYFont(9, YES);
    _timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    UILabel *dayLabel = [UILabel new];
    dayLabel.textAlignment = NSTextAlignmentLeft;
    dayLabel.textColor = SYColor(193, 99, 237);
    dayLabel.font = SYFont(13, YES);
    _dayLabel = dayLabel;
    [self.contentView addSubview:dayLabel];

    UILabel *monthLabel = [UILabel new];
    monthLabel.textAlignment = NSTextAlignmentLeft;
    monthLabel.textColor = SYColor(193, 99, 237);
    monthLabel.font = SYFont(10, YES);
    _monthLabel = monthLabel;
    [self.contentView addSubview:monthLabel];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = SYColor(193, 99, 237);
    contentLabel.font = SYFont(10,YES);
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    _contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];

    UIView *photoContainerView = [UIView new];
    photoContainerView.backgroundColor = [UIColor clearColor];
    _photoContainerView = photoContainerView;
    [self.contentView addSubview:photoContainerView];
    
    UIImageView *videoContainerView = [UIImageView new];
    videoContainerView.backgroundColor = [UIColor blackColor];
    videoContainerView.userInteractionEnabled = YES;
    videoContainerView.contentMode = UIViewContentModeScaleAspectFill;
    videoContainerView.clipsToBounds = YES;
    [videoContainerView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _videoContainerView = videoContainerView;
    [self.contentView addSubview:videoContainerView];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor clearColor];
    _bottomView = bottomView;
    [self.contentView addSubview:bottomView];
}

- (void)_makeSubViewsConstraints {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(2);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-2);
    }];
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.left.equalTo(self.bgView).offset(10);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yearLabel.mas_right).offset(10);
        make.centerY.height.equalTo(self.yearLabel);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.top.equalTo(self.aliasLabel);
        make.height.offset(11);
    }];
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(12);
        make.top.equalTo(self.yearLabel.mas_bottom).offset(5);
        make.left.equalTo(self.yearLabel).offset(5);
    }];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(10);
        make.left.equalTo(self.dayLabel.mas_right);
        make.bottom.equalTo(self.dayLabel);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-55);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.photoContainerView.mas_top).offset(-4);
        make.left.equalTo(self.aliasLabel);
    }];
    [_photoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.contentLabel);
        make.bottom.equalTo(self.videoContainerView.mas_top);
        make.height.offset(0);
    }];
    [_videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
        make.width.offset(140);
        make.left.equalTo(self.photoContainerView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.photoContainerView);
        make.height.offset(14);
    }];
}

// 根据传入的url分割
- (void)_setupPhotosViewByUrls:(NSString*)photosUrl {
    [self emptyPhotosView];
    NSArray *photosArray = [photosUrl componentsSeparatedByString:@","];
    self.photos = [NSMutableArray arrayWithArray:photosArray];
    CGFloat width = (SY_SCREEN_WIDTH - 117 - 10) / 3;
    [_photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.contentLabel);
        make.bottom.equalTo(self.videoContainerView.mas_top);
        make.height.offset((photosArray.count - 1) / 3 * (width + 5) + width);
    }];
    for (int i = 0; i < photosArray.count; i++) {
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [photoView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        photoView.backgroundColor = [UIColor blueColor];
        photoView.tag = i;
        photoView.userInteractionEnabled = YES;
        [photoView yy_setImageWithURL:[NSURL URLWithString:photosArray[i]] placeholder:SYImageNamed(@"errorPic") options:SYWebImageOptionAutomatic completion:NULL];
        [self.photoContainerView addSubview:photoView];
        
        // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(_tapPhoto:)];
        [photoView addGestureRecognizer:recognizer];
        recognizer.view.tag = i;
        
        [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(width);
            if (photosArray.count == 4) {
                make.left.equalTo(self.photoContainerView).offset(i % 2 * (width + 5));
                make.top.equalTo(self.photoContainerView).offset(i / 2 * (width + 5));
            } else {
                make.left.equalTo(self.photoContainerView).offset(i % 3 * (width + 5));
                make.top.equalTo(self.photoContainerView).offset(i / 3 * (width + 5));
            }
        }];
    }
}

- (void)emptyPhotosView {
    [self.photoContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
}

- (void)_setupVideoShowViewBy:(NSString*)url {
    [self emptyVideoView];
    UIImageView *playImageView = [UIImageView new];
    playImageView.image = SYImageNamed(@"play");
    [self.videoContainerView addSubview:playImageView];
    [self.videoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(140);
        make.height.offset(140);
    }];
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.videoContainerView).offset(6);
        make.width.offset(19);
        make.height.offset(19);
    }];
    self.videoUrl = [NSURL URLWithString:url];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [recognizer addTarget:self action:@selector(_tapVideo:)];
    [self.videoContainerView addGestureRecognizer:recognizer];
    if ([self getCacheImageByUrl:url] != nil) {
        self.videoContainerView.image = [self getCacheImageByUrl:url];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [[UIImage alloc] getVideoPreviewImage:[NSURL URLWithString:url]];
            YYCache *cache = [YYCache cacheWithName:@"seeyu"];
            NSString *key = [NSString stringWithFormat:@"moments_image_%@",[CocoaSecurity md5:url].hexLower];
            [cache setObject:image forKey:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.videoContainerView.image = image;
            });
        });
    }
}

- (void)emptyVideoView {
    [self.videoContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.videoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
}

- (void)_tapPhoto:(UITapGestureRecognizer *)sender {
    /// 图片浏览
    NSMutableArray *item = [NSMutableArray new];
    for (int i = 0 ; i < self.photos.count; i++) {
        YBImageBrowseCellData *data = [YBImageBrowseCellData new];
        data.url = self.photos[i];
        data.sourceObject = [self viewWithTag:i];
        data.allowSaveToPhotoAlbum = NO;
        [item addObject:data];
    }
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = item;
    browser.currentIndex = sender.view.tag;
    [browser show];
}

- (void)_tapVideo:(UITapGestureRecognizer *)sender {
    YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
    data.url = self.videoUrl;
    data.sourceObject = self.videoContainerView;
    data.autoPlayCount = 1;
    data.allowSaveToPhotoAlbum = NO;
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = @[data];
    browser.currentIndex = 0;
    [browser show];
}

- (UIImage *)getCacheImageByUrl:(NSString *)url {
    YYCache *cache = [YYCache cacheWithName:@"seeyu"];
    NSString *key = [NSString stringWithFormat:@"moments_image_%@",[CocoaSecurity md5:url].hexLower];
    if ([cache containsObjectForKey:key]) {
        // 有缓存数据优先读取缓存数据
        id value = [cache objectForKey:key];
        UIImage *image = (UIImage *) value;
        return image;
    } else {
        return nil;
    }
}

//- (void)setDayAndMonthLabel:(NSString *)timeLabel {
//    if (![timeLabel isEqualToString:@""] && timeLabel != nil) {
//        self.dayLabel.text = [timeLabel substringWithRange:NSMakeRange(8, 2)];
//        self.monthLabel.text = [NSString stringWithFormat:@"%@月",[timeLabel substringWithRange:NSMakeRange(5, 2)]];
//    };
//}
//
//- (void)setPhotosShowView:(NSString *)photosString {
//    NSArray *photosArray = [photosString componentsSeparatedByString:@","];
//    _photosImageArrays = [NSMutableArray arrayWithArray:photosArray];
//    if (photosArray.count >= 4) {
//        // 显示前4张图片
//        for (int i = 0 ; i < 4; i++) {
//            UIImageView *cellImageView = [UIImageView new];
//            cellImageView.contentMode = UIViewContentModeScaleAspectFill;
//            cellImageView.clipsToBounds = YES;
//            [cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//            cellImageView.tag = i;
//            [cellImageView yy_setImageWithURL:[NSURL URLWithString:photosArray[i]] placeholder:[UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(34, 34)] options:SYWebImageOptionAutomatic completion:NULL];
//            [self.photosBgView addSubview:cellImageView];
//
//            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
//            [recognizer addTarget:self action:@selector(_tapPhoto:)];
//            [self.photosBgView addGestureRecognizer:recognizer];
//            recognizer.view.tag = i;
//
//            [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.offset(34);
//                make.left.equalTo(self.photosBgView).offset(4 + i % 2 * 38);
//                make.top.equalTo(self.photosBgView).offset(4 + i / 2 * 38);
//            }];
//        }
//    } else if (photosArray.count == 3) {
//        for (int i = 0 ; i < 3; i++) {
//            UIImageView *cellImageView = [UIImageView new];
//            cellImageView.contentMode = UIViewContentModeScaleAspectFill;
//            cellImageView.clipsToBounds = YES;
//            [cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//            cellImageView.tag = i;
//            [cellImageView yy_setImageWithURL:[NSURL URLWithString:photosArray[i]] placeholder:[UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(34, 34)] options:SYWebImageOptionAutomatic completion:NULL];
//            [self.photosBgView addSubview:cellImageView];
//
//            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
//            [recognizer addTarget:self action:@selector(_tapPhoto:)];
//            [self.photosBgView addGestureRecognizer:recognizer];
//            recognizer.view.tag = i;
//
//            [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.offset(34);
//                if (i == 0) {
//                    make.centerX.equalTo(self.photosBgView);
//                    make.top.equalTo(self.photosBgView).offset(4);
//                } else {
//                    make.left.equalTo(self.photosBgView).offset(4 + (i - 1) * 38);
//                    make.bottom.equalTo(self.photosBgView).offset(-4);
//                }
//            }];
//        }
//    } else if (photosArray.count == 2) {
//        for (int i = 0 ; i < 2; i++) {
//            UIImageView *cellImageView = [UIImageView new];
//            cellImageView.contentMode = UIViewContentModeScaleAspectFill;
//            cellImageView.clipsToBounds = YES;
//            [cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//            cellImageView.tag = i;
//            [cellImageView yy_setImageWithURL:[NSURL URLWithString:photosArray[i]] placeholder:[UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(34, 72)] options:SYWebImageOptionAutomatic completion:NULL];
//            [self.photosBgView addSubview:cellImageView];
//
//            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
//            [recognizer addTarget:self action:@selector(_tapPhoto:)];
//            [self.photosBgView addGestureRecognizer:recognizer];
//            recognizer.view.tag = i;
//
//            [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self.photosBgView);
//                make.width.offset(34);
//                make.height.equalTo(self.photosBgView).offset(0.1);
//                make.left.equalTo(self.photosBgView).offset(4 + i * 38);
//            }];
//        }
//    } else if (photosArray.count == 1) {
//        UIImageView *cellImageView = [UIImageView new];
//        cellImageView.contentMode = UIViewContentModeScaleAspectFill;
//        cellImageView.clipsToBounds = YES;
//        [cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        cellImageView.tag = 0;
//        [cellImageView yy_setImageWithURL:[NSURL URLWithString:photosArray[0]] placeholder:[UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(72, 72)] options:SYWebImageOptionAutomatic completion:NULL];
//        [self.photosBgView addSubview:cellImageView];
//
//        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
//        [recognizer addTarget:self action:@selector(_tapPhoto:)];
//        [self.photosBgView addGestureRecognizer:recognizer];
//        recognizer.view.tag = 0;
//
//        [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.photosBgView);
//            make.width.height.offset(72);
//        }];
//    }
//}

//- (void)setVideoShowView:(NSString *)videoString {
//    UIImageView *videoBgView = [UIImageView new];
//    videoBgView.contentMode = UIViewContentModeScaleAspectFill;
//    videoBgView.clipsToBounds = YES;
//    [videoBgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    videoBgView.image = [UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(72, 72)];
//    [self.photosBgView addSubview:videoBgView];
//
//    UIImageView *playImageView = [UIImageView new];
//    playImageView.image = SYImageNamed(@"icon_video");
//    [self.photosBgView addSubview:playImageView];
//    self.videoUrl = [NSURL URLWithString:videoString];
//
//    [videoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(72);
//        make.center.equalTo(self.photosBgView);
//    }];
//    [playImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(20);
//        make.height.offset(13);
//        make.left.equalTo(self.photosBgView).offset(6);
//        make.bottom.equalTo(self.photosBgView).offset(-6);
//    }];
//
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
//    [recognizer addTarget:self action:@selector(_tapVideo:)];
//    [self.photosBgView addGestureRecognizer:recognizer];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        UIImage *image = [UIImage sy_thumbnailImageForVideo:[NSURL URLWithString:videoString] atTime:1];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            videoBgView.image = image;
//        });
//    });
//}
//
//- (void)_tapPhoto:(UITapGestureRecognizer *)sender {
//    /// 图片浏览
//    NSMutableArray *item = [NSMutableArray new];
//    for (int i = 0 ; i < self.photosImageArrays.count; i++) {
//        YBImageBrowseCellData *data = [YBImageBrowseCellData new];
//        data.url = self.photosImageArrays[i];
//        data.sourceObject = [self viewWithTag:i];
//        data.allowSaveToPhotoAlbum = NO;
//        [item addObject:data];
//    }
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataSourceArray = item;
//    browser.currentIndex = sender.view.tag;
//    [browser show];
//}
//
//- (void)_tapVideo:(UITapGestureRecognizer *)sender {
//    YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
//    data.url = self.videoUrl;
//    data.sourceObject = self.photosBgView;
//    data.autoPlayCount = 1;
//    data.allowSaveToPhotoAlbum = NO;
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataSourceArray = @[data];
//    browser.currentIndex = 0;
//    [browser show];
//}

@end
