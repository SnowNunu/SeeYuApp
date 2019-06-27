//
//  SYGoodsModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/10.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGoodsModel : SYObject

@property (nonatomic, strong) NSString *goodsId;

@property (nonatomic, strong) NSString *goodsName;

@property (nonatomic, strong) NSString *goodsMoney;

@property (nonatomic, strong) NSString *productId;

@end

NS_ASSUME_NONNULL_END
