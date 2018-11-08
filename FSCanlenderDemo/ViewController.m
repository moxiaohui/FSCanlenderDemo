//
//  ViewController.m
//  FSCanlenderDemo
//
//  Created by 莫晓卉 on 2018/4/24.
//  Copyright © 2018年 莫晓卉. All rights reserved.
//

#import "ViewController.h"
#import "MOCanlenderView.h"
#import "Masonry.h"

@interface ViewController ()
@property (nonatomic, strong) MOCanlenderView *canlenderView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.canlenderView = [[MOCanlenderView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 350)];
  __weak typeof(self) weakSelf = self;
  self.canlenderView.changedDate = ^{
    NSLog(@"changedDate: %@", weakSelf.canlenderView.date);
  };
  [self.view addSubview:self.canlenderView];
}



@end
