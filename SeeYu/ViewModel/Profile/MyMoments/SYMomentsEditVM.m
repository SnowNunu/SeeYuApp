//
//  SYMomentsEditVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMomentsEditVM.h"

@implementation SYMomentsEditVM

- (void)initialize {
    [super initialize];
    @weakify(self)
    self.prefersNavigationBarHidden = YES;
    self.interactivePopDisabled = YES;
    self.title = @"动态编辑";
    self.releaseMomentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id x) {
        @strongify(self)
        [MBProgressHUD sy_showProgressHUD:@"动态上传中,请稍候"];
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        subscript[@"content"] = self.text;
        NSMutableArray<NSData *> *dataArray = [NSMutableArray new];
        NSMutableArray<NSString *> *namesArray = [NSMutableArray new];
        if ([self.type isEqualToString:@"video"]) {
            if (self.videoContentUrl != nil) {
                [dataArray addObject:[NSData dataWithContentsOfURL:self.videoContentUrl]];
            } else if (self.imagesArray.count > 0) {
                // 从相册选取的视频则去读取
                PHAsset *asset = self.assetArray.firstObject;
                [self getVideoFromPHAsset:asset Complete:^(NSData *data, NSString *fileName) {
                    [self.releaseVideoFromAlbumCommand execute:data];
                }];
                return [RACSignal empty];
            }
            [namesArray addObject:@"momentImage-mp4"];
        } else {
            if (self.imagesArray.count > 0) {
                for (UIImage *image in self.imagesArray) {
                    [dataArray addObject:UIImagePNGRepresentation(image)];
                    [namesArray addObject:@"momentImage-png"];
                }
            } else {
                [MBProgressHUD sy_showError:@"请先选择照片"];
            }
        }
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MOMENT_UPLOAD parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueUploadRequest:request resultClass:[SYObject class] fileDatas:[NSArray arrayWithArray:dataArray] namesArray:[NSArray arrayWithArray:namesArray] mimeType:nil] sy_parsedResults];
    }];
    [self.releaseMomentCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showTips:@"动态上传成功"];
        [self.services popViewModelAnimated:YES];
    }];
    [self.releaseMomentCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.releaseVideoFromAlbumCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSData *data) {
        @strongify(self)
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        subscript[@"content"] = self.text;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MOMENT_UPLOAD parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueUploadRequest:request resultClass:[SYObject class] fileDatas:@[data] namesArray:@[@"momentImage-mp4"] mimeType:nil] sy_parsedResults];
    }];
    [self.releaseVideoFromAlbumCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showTips:@"动态上传成功"];
        [self.services popViewModelAnimated:YES];
    }];
    [self.releaseVideoFromAlbumCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

- (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(void(^)(NSData *data,NSString *fileName))result {
    NSArray * assetResources = [PHAssetResource assetResourcesForAsset: asset];
    PHAssetResource *resource;
    for (PHAssetResource * assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo || assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString * fileName = @"tempAssetVideo.mp4";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHAssetResourceRequestOptions * options = [[PHAssetResourceRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        options.progressHandler = ^(double progress) {
            NSLog(@"%f",progress);
        };
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent: fileName];
        [[NSFileManager defaultManager] removeItemAtPath: PATH_MOVIE_FILE error: nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource: resource toFile: [NSURL fileURLWithPath: PATH_MOVIE_FILE] options: options completionHandler: ^(NSError * _Nullable error) {
            NSLog(@"%@",error);
            if (error) {
                [MBProgressHUD sy_hideHUD];
                [MBProgressHUD sy_showTips:@"iCloud视频下载失败"];
                result(nil, nil);
            } else {
                NSData *data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath: PATH_MOVIE_FILE]];
                result(data, fileName);
            }
        }];
    } else {
        result(nil, nil);
    }
}

@end
