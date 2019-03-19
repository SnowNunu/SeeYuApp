//
//  SYAnchorsModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsModel : SYObject

/* 用户id */
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, assign) int anchorStarLevel;

@property (nonatomic, strong) NSString *userSignature;

@property (nonatomic, strong) NSString *userSpecialty;

@property (nonatomic, strong) NSString *anchorChatCost;

@property (nonatomic, strong) NSString *showPhoto;

@property (nonatomic, strong) NSString *showVideo;

@property (nonatomic, assign) int userOnline;

@end

NS_ASSUME_NONNULL_END
