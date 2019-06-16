//
//  SYMomentListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMomentListCell.h"
#import <YBImageBrowser/YBImageBrowser.h>

@implementation SYMomentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    UIImageView *headImageView = [UIImageView new];
    headImageView.masksToBounds = YES;
    headImageView.layer.cornerRadius = 22.5f;
    _headImageView = headImageView;
    [self.contentView addSubview:headImageView];
    
    YYLabel *aliasLabel = [YYLabel new];
    aliasLabel.numberOfLines = 0;   // 开启多行显示
    aliasLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 90;
    aliasLabel.font = SYFont(12, YES);
    aliasLabel.textColor = SYColor(143, 135, 220);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    _aliasLabel = aliasLabel;
    [self.contentView addSubview:aliasLabel];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.textColor = SYColor(100, 100, 100);
    timeLabel.font = SYFont(8, YES);
    timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    YYLabel *contentLabel = [YYLabel new];
    contentLabel.numberOfLines = 0;   // 开启多行显示
    contentLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 90;
    contentLabel.font = SYFont(10, YES);
    contentLabel.textColor = SYColor(100, 100, 100);
    contentLabel.textAlignment = NSTextAlignmentLeft;
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
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = SYColor(242, 242, 242);
    _lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)_makeSubViewsConstraints {
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.left.top.equalTo(self.contentView).offset(12);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView).offset(1);
        make.right.equalTo(self.contentView).offset(-50);
        make.height.offset(15);
        make.left.equalTo(self.headImageView.mas_right).offset(12);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.offset(15);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.photoContainerView.mas_top).offset(-4);
        make.left.right.equalTo(self.aliasLabel);
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
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel);
        make.right.equalTo(self.timeLabel);
        make.bottom.equalTo(self.bottomView);
        make.height.offset(1);
    }];
}

// 根据传入的url分割
- (void)_setupPhotosViewByUrls:(NSString*)photosUrl {
    [self emptyPhotosView];
    NSArray *photosArray = [photosUrl componentsSeparatedByString:@","];
    self.photos = [NSMutableArray arrayWithArray:photosArray];
    CGFloat width = (SY_SCREEN_WIDTH - 90 - 10) / 3;
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
        make.width.offset(100);
        make.height.offset(180);
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
    if ([self judgeOpenRechargeTipsView]) {
        if (self.block) {
            self.block();
        }
    } else {
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
}

- (void)_tapVideo:(UITapGestureRecognizer *)sender {
    if ([self judgeOpenRechargeTipsView]) {
        if (self.block) {
            self.block();
        }
    } else {
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

- (BOOL)judgeOpenRechargeTipsView {
    return NO;
//    SYUser *user = SYSharedAppDelegate.services.client.currentUser;
//    if (user.userVipStatus == 1) {
//        if (user.userVipExpiresAt != nil) {
//            if ([NSDate sy_overdue:user.userVipExpiresAt]) {
//                // 已过期
//                return YES;
//            } else {
//                // 未过期
//                return NO;
//            }
//        } else {
//            return YES;
//        }
//    } else {
//        // 未开通会员
//        return YES;
//    }
}

@end
