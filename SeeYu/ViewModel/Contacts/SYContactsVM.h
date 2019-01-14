//
//  SYContactsVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYTableViewModel.h"

@interface SYContactsVM : SYTableViewModel
/// addFriendsCommand
@property (nonatomic, readonly, strong) RACCommand *addFriendsCommand;
@end
