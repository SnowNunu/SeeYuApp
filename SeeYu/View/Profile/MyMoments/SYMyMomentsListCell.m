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
        _photosImageArrays = [NSMutableArray new];
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    UILabel *dayLabel = [UILabel new];
    dayLabel.textAlignment = NSTextAlignmentLeft;
    dayLabel.textColor = SYColor(51, 51, 51);
    dayLabel.font = [UIFont boldSystemFontOfSize:30];
    _dayLabel = dayLabel;
    [self addSubview:dayLabel];
    
    UILabel *monthLabel = [UILabel new];
    monthLabel.textAlignment = NSTextAlignmentLeft;
    monthLabel.textColor = SYColor(51, 51, 51);
    monthLabel.font = [UIFont boldSystemFontOfSize:15];
    _monthLabel = monthLabel;
    [self addSubview:monthLabel];
    
    UIView *photosBgView = [UIView new];
    photosBgView.backgroundColor = [UIColor whiteColor];
    _photosBgView = photosBgView;
    [self addSubview:photosBgView];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = SYColor(51, 51, 51);
    contentLabel.font = SYRegularFont(15);
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    contentLabel.numberOfLines = 3;
    _contentLabel = contentLabel;
    [self addSubview:contentLabel];
    
    UILabel *photosNumberLabel = [UILabel new];
    photosNumberLabel.textAlignment = NSTextAlignmentLeft;
    photosNumberLabel.textColor = SYColor(159, 105, 235);
    photosNumberLabel.font = SYRegularFont(15);
    _photosNumberLabel = photosNumberLabel;
    [self addSubview:photosNumberLabel];
}

- (void)_makeSubViewsConstraints {
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photosBgView);
        make.left.equalTo(self).offset(15);
        make.height.offset(22);
        make.width.offset(38);
    }];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.dayLabel);
        make.left.equalTo(self.dayLabel.mas_right).offset(5);
        make.height.offset(15);
        make.width.offset(35);
    }];
    [_photosBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.offset(80);
        make.left.equalTo(self.monthLabel.mas_right).offset(10);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photosBgView.mas_right).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.photosBgView);
    }];
    [_photosNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.bottom.equalTo(self.photosBgView);
        make.height.offset(15);
    }];
}

- (void)setDayAndMonthLabel:(NSString *)timeLabel {
    if (![timeLabel isEqualToString:@""] && timeLabel != nil) {
        self.dayLabel.text = [timeLabel substringWithRange:NSMakeRange(8, 2)];
        self.monthLabel.text = [NSString stringWithFormat:@"%@月",[timeLabel substringWithRange:NSMakeRange(5, 2)]];
    };
}

- (void)setPhotosShowView:(NSString *)photosString {
    NSArray *photosArray = [photosString componentsSeparatedByString:@","];
    _photosImageArrays = [NSMutableArray arrayWithArray:photosArray];
    if (photosArray.count >= 4) {
        // 显示前4张图片
        for (int i = 0 ; i < 4; i++) {
            UIImageView *cellImageView = [UIImageView new];
            cellImageView.contentMode = UIViewContentModeScaleAspectFill;
            cellImageView.clipsToBounds = YES;
            [cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            cellImageView.tag = i;
            [cellImageView yy_setImageWithURL:[NSURL URLWithString:photosArray[i]] placeholder:[UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(34, 34)] options:SYWebImageOptionAutomatic completion:NULL];
            [self.photosBgView addSubview:cellImageView];

            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
            [recognizer addTarget:self action:@selector(_tapPhoto:)];
            [self.photosBgView addGestureRecognizer:recognizer];
            recognizer.view.tag = i;

            [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.offset(34);
                make.left.equalTo(self.photosBgView).offset(4 + i % 2 * 38);
                make.top.equalTo(self.photosBgView).offset(4 + i / 2 * 38);
            }];
        }
    } else if (photosArray.count == 3) {
        for (int i = 0 ; i < 3; i++) {
            UIImageView *cellImageView = [UIImageView new];
            cellImageView.contentMode = UIViewContentModeScaleAspectFill;
            cellImageView.clipsToBounds = YES;
            [cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            cellImageView.tag = i;
            [cellImageView yy_setImageWithURL:[NSURL URLWithString:photosArray[i]] placeholder:[UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(34, 34)] options:SYWebImageOptionAutomatic completion:NULL];
            [self.photosBgView addSubview:cellImageView];
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
            [recognizer addTarget:self action:@selector(_tapPhoto:)];
            [self.photosBgView addGestureRecognizer:recognizer];
            recognizer.view.tag = i;
            
            [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.offset(34);
                if (i == 0) {
                    make.centerX.equalTo(self.photosBgView);
                    make.top.equalTo(self.photosBgView).offset(4);
                } else {
                    make.left.equalTo(self.photosBgView).offset(4 + (i - 1) * 38);
                    make.bottom.equalTo(self.photosBgView).offset(-4);
                }
            }];
        }
    } else if (photosArray.count == 2) {
        for (int i = 0 ; i < 2; i++) {
            UIImageView *cellImageView = [UIImageView new];
            cellImageView.contentMode = UIViewContentModeScaleAspectFill;
            cellImageView.clipsToBounds = YES;
            [cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            cellImageView.tag = i;
            [cellImageView yy_setImageWithURL:[NSURL URLWithString:photosArray[i]] placeholder:[UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(34, 72)] options:SYWebImageOptionAutomatic completion:NULL];
            [self.photosBgView addSubview:cellImageView];
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
            [recognizer addTarget:self action:@selector(_tapPhoto:)];
            [self.photosBgView addGestureRecognizer:recognizer];
            recognizer.view.tag = i;
            
            [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.photosBgView);
                make.width.offset(34);
                make.height.equalTo(self.photosBgView).offset(0.1);
                make.left.equalTo(self.photosBgView).offset(4 + i * 38);
            }];
        }
    } else if (photosArray.count == 1) {
        UIImageView *cellImageView = [UIImageView new];
        cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        cellImageView.clipsToBounds = YES;
        [cellImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        cellImageView.tag = 0;
        [cellImageView yy_setImageWithURL:[NSURL URLWithString:photosArray[0]] placeholder:[UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(72, 72)] options:SYWebImageOptionAutomatic completion:NULL];
        [self.photosBgView addSubview:cellImageView];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(_tapPhoto:)];
        [self.photosBgView addGestureRecognizer:recognizer];
        recognizer.view.tag = 0;
        
        [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.photosBgView);
            make.width.height.offset(72);
        }];
    }
}

- (void)setVideoShowView:(NSString *)videoString {
    UIImageView *videoBgView = [UIImageView new];
    videoBgView.contentMode = UIViewContentModeScaleAspectFill;
    videoBgView.clipsToBounds = YES;
    [videoBgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    videoBgView.image = [UIImage hyb_imageWithColor:SYColorFromHexString(@"#D7D7D7") toSize:CGSizeMake(72, 72)];
    [self.photosBgView addSubview:videoBgView];
    
    UIImageView *playImageView = [UIImageView new];
    playImageView.image = SYImageNamed(@"icon_video");
    [self.photosBgView addSubview:playImageView];
    self.videoUrl = [NSURL URLWithString:videoString];
    
    [videoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(72);
        make.center.equalTo(self.photosBgView);
    }];
    [playImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.height.offset(13);
        make.left.equalTo(self.photosBgView).offset(6);
        make.bottom.equalTo(self.photosBgView).offset(-6);
    }];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [recognizer addTarget:self action:@selector(_tapVideo:)];
    [self.photosBgView addGestureRecognizer:recognizer];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [UIImage sy_thumbnailImageForVideo:[NSURL URLWithString:videoString] atTime:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            videoBgView.image = image;
        });
    });
}

- (void)_tapPhoto:(UITapGestureRecognizer *)sender {
    /// 图片浏览
    NSMutableArray *item = [NSMutableArray new];
    for (int i = 0 ; i < self.photosImageArrays.count; i++) {
        YBImageBrowseCellData *data = [YBImageBrowseCellData new];
        data.url = self.photosImageArrays[i];
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
    data.sourceObject = self.photosBgView;
    data.autoPlayCount = 1;
    data.allowSaveToPhotoAlbum = NO;
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = @[data];
    browser.currentIndex = 0;
    [browser show];
}

@end
