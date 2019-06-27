//
//  SYAppUpdateModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/6/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAppUpdateModel : SYObject

@property (nonatomic, strong) NSString *downloadLink;

@property (nonatomic, assign) float version;

@end

NS_ASSUME_NONNULL_END
