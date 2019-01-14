//
//  UISearchBar+SYExtension.m
//  WeChat
//
//  Created by senba on 2017/9/28.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "UISearchBar+SYExtension.h"

@implementation UISearchBar (SYExtension)

+ (void)load{
    // 修改按钮标题文字属性( 颜色, 大小, 字体)
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName: SY_MAIN_TINTCOLOR, NSFontAttributeName: [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    // 将searchBar的cancel按钮改成中文的
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
}

- (void)sy_configureSearchBar{
    self.searchBarStyle = UISearchBarStyleProminent;
    self.barStyle = UIBarStyleDefault;
    
    self.barTintColor = SY_MAIN_BACKGROUNDCOLOR;
    self.tintColor = SY_MAIN_TINTCOLOR;
    
    /// 去掉SearchBar的上下的黑色细线
    UIImageView *view = [[[self.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = SYColorFromHexString(@"#DFDFDD").CGColor;
    view.layer.borderWidth = 1;
    
    self.backgroundImage = SYImageNamed(@"widget_searchbar_cell_bg_5x44");
    [self setSearchFieldBackgroundImage:SYImageNamed(@"widget_searchbar_textfield_17x28") forState:UIControlStateNormal];
    [self setImage:SYImageNamed(@"SearchContactsBarIcon_20x20") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    self.searchTextPositionAdjustment = UIOffsetMake(5, 0);
    self.placeholder = @"搜索";
}
@end
