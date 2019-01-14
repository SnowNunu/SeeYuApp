//
//  SYBootRegisterVC.m
//  Seeyu
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYBootRegisterVC.h"

@interface SYBootRegisterVC ()


@end

@implementation SYBootRegisterVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置子控件
    [self _setupSubViews];
}

#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    [[self.bootRegisterView.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        /// 除去全是空格的情况
        if ([NSString sy_isEmpty:self.viewModel.alias]) {
            [MBProgressHUD sy_showTips:@"昵称不能为空"];
            return;
        }
        [self.viewModel.nextCommand execute:nil];
    }];
    [[self.bootRegisterView.maleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self _setMaleGender:YES];
    }];
    [[self.bootRegisterView.femaleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self _setMaleGender:NO];
    }];
    [[self.bootRegisterView.ageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self pickerChoose];
    }];
    RAC(self.viewModel,alias) = [RACSignal merge:@[RACObserve(self.bootRegisterView.aliasTextField, text),self.bootRegisterView.aliasTextField.rac_textSignal]];
    [RACObserve(self.viewModel, age) subscribeNext:^(id x) {
        @strongify(self);
        [self.bootRegisterView.ageBtn setTitle:self.viewModel.age forState:UIControlStateNormal];
    }];
}

#pragma mark - 设置子控件
- (void)_setupSubViews {
    SYBootRegisterView *view = [SYBootRegisterView bootRegisterView];
    view.sy_width = SY_SCREEN_WIDTH;
    view.sy_height = SY_SCREEN_HEIGHT - SY_APPLICATION_TOP_BAR_HEIGHT;
    view.sy_x = 0;
    view.sy_y = SY_APPLICATION_TOP_BAR_HEIGHT;
    _bootRegisterView = view;
    [self.view addSubview:_bootRegisterView];
    self.viewModel.age = @"25岁";
    self.viewModel.gender = @"男";
}

#pragma mark - 设置性别
- (void)_setMaleGender:(BOOL) gender {
    _bootRegisterView.maleBtn.selected = gender;
    _bootRegisterView.femaleBtn.selected = !gender;
    _bootRegisterView.maleLabel.textColor = gender ? SYColor(196, 145, 253) : SYColor(153, 153, 153);
    _bootRegisterView.femaleLabel.textColor = !gender ? SYColor(196, 145, 253) : SYColor(153, 153, 153);
    self.viewModel.gender = _bootRegisterView.maleBtn.selected ? @"男" : @"女";
}

#pragma mark - 年龄选择框
- (void)pickerChoose {
    NSArray *array = @[@"18岁",@"19岁",@"20岁",@"21岁",@"22岁",@"23岁",@"24岁",@"25岁",@"26岁",
                       @"27岁",@"28岁",@"29岁",@"30岁",@"31岁",@"32岁",@"33岁",@"34岁",@"35岁",
                       @"36岁",@"37岁",@"38岁",@"39岁",@"40岁",@"41岁",@"42岁",@"43岁",@"44岁",
                       @"45岁",@"46岁",@"47岁",@"48岁",@"49岁",@"50岁",@"51岁",@"52岁",@"53岁",
                       @"54岁",@"55岁",@"56岁",@"57岁",@"58岁",@"59岁",@"60岁",@"61岁",@"62岁",
                       @"63岁",@"64岁",@"65岁",@"66岁",@"67岁",@"68岁",@"69岁",@"70岁"];
    NSInteger row = [array indexOfObject:self.viewModel.age];
    @weakify(self)
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:@"请选择年龄" rows:array initialSelection:row doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self)
        self.viewModel.age = array[selectedIndex];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"取消了选择");
    } origin:self.view];
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(0, 0, 32, 32)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    UIButton *confirmlButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmlButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmlButton setFrame:CGRectMake(0, 0, 32, 32)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:confirmlButton]];
    [picker showActionSheetPicker];
}

@end
