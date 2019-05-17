//
//  SYNearbyListCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/16.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYNearbyListCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *defaultImageView;

@property (nonatomic, weak) UIImageView *headImageView;

@property (nonatomic, weak) UIImageView *vipImageView;

@property (nonatomic, weak) UILabel *distanceLabel;

@property (nonatomic, weak) UIView *infoBgView;

@property (nonatomic, weak) UILabel *aliasLabel;

@property (nonatomic, weak) UILabel *signatureLabel;

@end

NS_ASSUME_NONNULL_END
