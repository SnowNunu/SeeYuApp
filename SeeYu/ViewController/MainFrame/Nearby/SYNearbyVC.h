//
//  SYNearbyVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/24.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYNearbyVM.h"
#import "SYNearbyListCell.h"
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYNearbyVC : SYVC <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSString *city;

@end

NS_ASSUME_NONNULL_END
