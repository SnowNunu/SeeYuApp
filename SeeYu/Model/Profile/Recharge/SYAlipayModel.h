//
//  SYAlipayModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAlipayModel : SYObject

@property (nonatomic, strong) NSString *requestType;

@property (nonatomic, strong) NSString *fromAppUrlScheme;

@property (nonatomic, strong) NSString *dataString;

@end

NS_ASSUME_NONNULL_END
