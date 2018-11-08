//
//  MOCanlenderView.h
//  FSCanlenderDemo
//
//  Created by 莫晓卉 on 2018/4/24.
//  Copyright © 2018年 莫晓卉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOCanlenderView : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) void(^changedDate)(void);
@property (nonatomic, assign) BOOL hiddenPreviousNextBtn;  // 隐藏 左右按钮

- (void)showCanlendar;
- (void)hiddenCalendar;

@end
