//
//  SYGiftPackageModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftPackageModel : SYObject

@property (nonatomic, assign) int day;

@property (nonatomic, assign) int isReceive;

@property (nonatomic, assign) int giftNum;

@property (nonatomic, assign) int giftType;

@end

NS_ASSUME_NONNULL_END
