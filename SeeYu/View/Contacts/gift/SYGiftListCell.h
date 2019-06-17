//
//  SYGiftListCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/6/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftListCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *giftBtn;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
