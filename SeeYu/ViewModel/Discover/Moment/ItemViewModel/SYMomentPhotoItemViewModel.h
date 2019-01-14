//
//  SYMomentPhotoItemViewModel.h
//  SYDevelopExample
//
//  Created by senba on 2017/7/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYMomentCommentItemViewModel.h"

@interface SYMomentPhotoItemViewModel : NSObject

/// picture
@property (nonatomic, readwrite, strong) SYPicture *picture;


/// init
- (instancetype)initWithPicture:(SYPicture *)picture;

@end
