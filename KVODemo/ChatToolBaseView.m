//
//  ChatToolBaseView.m
//  KVODemo
//
//  Created by 郭凯 on 2016/11/29.
//  Copyright © 2016年 guokai. All rights reserved.
//

#import "ChatToolBaseView.h"
#import "Define.h"

@implementation ChatToolBaseView

//- (BOOL)hiden {
//    return self.hiden;
//}

- (void)setHiden:(BOOL)hiden {
    if (hiden) {
        [self hidenView];
    }else {
        [self showView];
    }
}

- (void)hidenView {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width, self.bounds.size.height);
    }];
}

- (void)showView {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, kScreenSize.height - self.bounds.size.height, kScreenSize.width, self.bounds.size.height);
    }];
}

@end
