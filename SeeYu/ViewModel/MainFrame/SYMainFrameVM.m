//
//  SYMainFrameVM.m
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYMainFrameVM.h"

@interface SYMainFrameVM ()

@end


@implementation SYMainFrameVM

- (void)initialize {
    [super initialize];
    
    self.rankingVM = [[SYRankingVM alloc]initWithServices:self.services params:nil];
    
    self.nearbyVM = [[SYNearbyVM alloc]initWithServices:self.services params:nil];
    
    self.anchorsOrderVM = [[SYAnchorsOrderVM alloc] initWithServices:self.services params:nil];
}
@end
