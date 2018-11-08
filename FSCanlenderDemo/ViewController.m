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
  
  UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 50)];
  dateLb.textAlignment = NSTextAlignmentCenter;
  dateLb.textColor = [UIColor blackColor];
  [self.view addSubview:dateLb];
  
  self.canlenderView = [[MOCanlenderView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 350)];
  __weak typeof(self) weakSelf = self;
  self.canlenderView.changedDate = ^{
    dateLb.text = weakSelf.canlenderView.date.description;
  };
  [self.view addSubview:self.canlenderView];
}



@end
