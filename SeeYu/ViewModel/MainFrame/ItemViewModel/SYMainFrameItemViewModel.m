//
//  SYMainFrameItemViewModel.m
//  WeChat
//
//  Created by senba on 2017/10/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYMainFrameItemViewModel.h"

@interface SYMainFrameItemViewModel ()
/// LiveRoom
@property (nonatomic, readwrite, strong) SYLiveRoom *liveRoom;
/// cellHeight
@property (nonatomic, readwrite, assign) CGFloat cellHeight;
/// girlStar
@property (nonatomic, readwrite, copy) NSString *girlStar;
/// 观众人数
@property (nonatomic, readwrite, copy) NSAttributedString *allNumAttr;
@end


@implementation SYMainFrameItemViewModel

- (instancetype)initWithLiveRoom:(SYLiveRoom *)liveRoom{
    if (self = [super init]) {
        self.liveRoom = liveRoom;
        
        self.girlStar = [NSString stringWithFormat:@"girl_star%zd_40x19",liveRoom.starlevel];
        
        NSMutableAttributedString *allNumAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@人在看",liveRoom.allnum]];
        allNumAttr.yy_font = SYRegularFont_17;
        allNumAttr.yy_color = SYColorFromHexString(@"#999999");
        allNumAttr.yy_alignment = NSTextAlignmentRight;
        [allNumAttr yy_setColor:SYColorFromHexString(@"#F14F94") range:NSMakeRange(0, liveRoom.allnum.length)];
        self.allNumAttr = allNumAttr.copy;
        
        self.cellHeight = 50 + SY_SCREEN_WIDTH + 7;
    }
    return self;
}
@end
