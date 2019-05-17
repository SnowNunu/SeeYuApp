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

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UIView *infoBgView;

@property (nonatomic, strong) UILabel *aliasLabel;

@property (nonatomic, strong) UILabel *signatureLabel;

@end

NS_ASSUME_NONNULL_END
