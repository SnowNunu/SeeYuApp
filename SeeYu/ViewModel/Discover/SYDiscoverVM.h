//
//  SYDiscoverVM.h
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYMomentVM.h"
#import "SYWebVM.h"

@interface SYDiscoverVM : SYVM

@property (nonatomic, strong) SYMomentVM *momentVM;

@property (nonatomic, strong) SYWebVM *webVM;

@end
