//
//  SYGiftListModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/6/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftListModel : SYObject

@property (nonatomic, strong) NSString *giftName;

@property (nonatomic, assign) int giftPrice;

@property (nonatomic, strong) NSString *giftImg;

@property (nonatomic, assign) int giftId;

@end

NS_ASSUME_NONNULL_END
