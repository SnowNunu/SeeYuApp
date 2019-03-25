//
//  SYForumResultModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYForumResultModel : SYObject

@property (nonatomic, strong) NSString *commentForumid;

@property (nonatomic, strong) NSString *commentUserid;

@property (nonatomic, strong) NSString *commentContent;

@property (nonatomic, strong) NSString *commentDate;

@property (nonatomic, strong) NSString *commentStatus;

@property (nonatomic, strong) NSString *commentLiked;

@end

NS_ASSUME_NONNULL_END
