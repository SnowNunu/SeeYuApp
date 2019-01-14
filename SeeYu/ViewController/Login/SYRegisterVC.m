//
//  SYRegisterVC.m
//  Seeyu
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYRegisterVC.h"

@interface SYRegisterVC ()

@end

@implementation SYRegisterVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _initParams];
}

#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    RAC(self.viewModel,job) = [RACSignal merge:@[RACObserve(self.registerView.jobTextField, text),self.registerView.jobTextField.rac_textSignal]];
    [[self.registerView.incomeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self pickerChoose:@"income"];
    }];
    [[self.registerView.heightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self pickerChoose:@"height"];
    }];
    [[self.registerView.maritalStatusBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self pickerChoose:@"maritalStatus"];
    }];
    [[self.registerView.strongTipsBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self chooseSpecialty:sender];
    }];
    [[self.registerView.technologyTipsBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self chooseSpecialty:sender];
    }];
    [[self.registerView.steadyTipsBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self chooseSpecialty:sender];
    }];
    [[self.registerView.softTipsBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self chooseSpecialty:sender];
    }];
    [[self.registerView.smartTipsBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self chooseSpecialty:sender];
    }];
    [[self.registerView.durableTipsBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self chooseSpecialty:sender];
    }];
    [[self.registerView.completeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        /// 除去全是空格的情况
        if ([NSString sy_isEmpty:self.viewModel.job]) {
            [MBProgressHUD sy_showTips:@"职业不能为空"];
            return;
        }
        [self.viewModel.registerCommand execute:nil];
    }];
    [RACObserve(self.viewModel, income) subscribeNext:^(id x) {
        @strongify(self);
        [self.registerView.incomeBtn setTitle:self.viewModel.income forState:UIControlStateNormal];
    }];
    [RACObserve(self.viewModel, height) subscribeNext:^(id x) {
        @strongify(self);
        [self.registerView.heightBtn setTitle:self.viewModel.height forState:UIControlStateNormal];
    }];
    [RACObserve(self.viewModel, maritalStatus) subscribeNext:^(id x) {
        @strongify(self);
        [self.registerView.maritalStatusBtn setTitle:self.viewModel.maritalStatus forState:UIControlStateNormal];
    }];
}

#pragma mark - 初始化参数
- (void)_initParams {
    self.viewModel.income = @"2000以下";
    self.viewModel.height = @"172cm";
    self.viewModel.maritalStatus = @"未婚";
    self.viewModel.specialtyArray = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0"]];
}

#pragma mark - 选择特长
- (void)chooseSpecialty:(UIButton*)sender {
    sender.selected = !sender.selected;
    sender.backgroundColor = sender.selected ? SYColorFromHexString(@"#9F69EB") : SYColorFromHexString(@"#FFFFFF");
    [self.viewModel.specialtyArray replaceObjectAtIndex:sender.tag - 700 withObject:sender.selected ? @"1" : @"0"];
}

#pragma mark - 职业等选择框
- (void)pickerChoose:(NSString*) string {
    NSArray *array = nil;
    NSString *title = nil;
    NSInteger row;
    if ([string isEqualToString:@"income"]) {
        array = @[@"2000以下",@"2000-5000",@"5000-10000",@"10000-20000",@"20000以上"];
        row = [array indexOfObject:self.viewModel.income];
        title = @"请选择收入";
    } else if ([string isEqualToString:@"height"]) {
        array = @[@"140cm",@"141cm",@"142cm",@"143cm",@"144cm",@"145cm",@"146cm",@"147cm",@"148cm",
                  @"149cm",@"150cm",@"151cm",@"152cm",@"153cm",@"154cm",@"155cm",@"156cm",@"157cm",
                  @"158cm",@"159cm",@"160cm",@"161cm",@"162cm",@"163cm",@"164cm",@"165cm",@"166cm",
                  @"167cm",@"168cm",@"169cm",@"170cm",@"171cm",@"172cm",@"173cm",@"174cm",@"175cm",
                  @"176cm",@"177cm",@"178cm",@"179cm",@"180cm",@"181cm",@"182cm",@"183cm",@"184cm",
                  @"185cm",@"186cm",@"187cm",@"188cm",@"189cm",@"190cm",@"191cm",@"192cm",@"193cm",
                  @"194cm",@"195cm",@"196cm",@"197cm",@"198cm",@"199cm",@"200cm"];
        row = [array indexOfObject:self.viewModel.height];
        title = @"请选择身高";
    } else {
        array = @[@"未婚",@"已婚",@"离异",@"保密"];
        row = [array indexOfObject:self.viewModel.maritalStatus];
        title = @"请选择婚姻状态";
    }
    @weakify(self)
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:array initialSelection:row doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self)
        if ([string isEqualToString:@"income"]) {
            self.viewModel.income = array[selectedIndex];
        } else if ([string isEqualToString:@"height"]) {
            self.viewModel.height = array[selectedIndex];
        } else {
            self.viewModel.maritalStatus = array[selectedIndex];
        }
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

#pragma mark - 设置子控件
- (void)_setupSubViews {
    SYRegisterView *registerView = [SYRegisterView registerView];
    registerView.sy_width = SY_SCREEN_WIDTH;
    registerView.sy_height = SY_SCREEN_HEIGHT - SY_APPLICATION_TOP_BAR_HEIGHT;
    registerView.sy_x = 0;
    registerView.sy_y = SY_APPLICATION_TOP_BAR_HEIGHT;
    _registerView = registerView;
    [self.view addSubview:registerView];
}

@end
