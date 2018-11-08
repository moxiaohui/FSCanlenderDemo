//
//  MOCanlenderView.m
//  FSCanlenderDemo
//
//  Created by 莫晓卉 on 2018/4/24.
//  Copyright © 2018年 莫晓卉. All rights reserved.
//

#import "MOCanlenderView.h"
#import "FSCalendar.h"
#define kSelfWidth (self.frame.size.width)
#define kShadowHeight (2)
#define kHeaderHeight (50)
#define kSelfHeight (kHeaderHeight+288+kShadowHeight)
#define kCalendarHeight (288)

@interface MOCanlenderView ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) NSCalendar *gregorian;
@property (nonatomic, assign) BOOL calendarShow;
@end

@implementation MOCanlenderView {
  UIButton *_previousButton;
  UIButton *_nextButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupView];
    self.clipsToBounds = YES;
    [self hiddenCalendar];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
    [self.calendar reloadData];
  }
  return self;
}

- (void)setupView {
  self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSelfWidth, kHeaderHeight)];
  headerView.backgroundColor = [UIColor whiteColor];
  [self addSubview:headerView];
  
  _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _previousButton.frame = CGRectMake(12, kHeaderHeight/2-22, 44, 44);
  [_previousButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
  [_previousButton addTarget:self action:@selector(previousClicked) forControlEvents:UIControlEventTouchUpInside];
  [headerView addSubview:_previousButton];
  _previousButton.transform = CGAffineTransformMakeRotation(M_PI);
  
  _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _nextButton.frame = CGRectMake(kSelfWidth - 12 - 44, kHeaderHeight/2-22, 44, 44);
  [_nextButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
  [_nextButton addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
  [headerView addSubview:_nextButton];
  
  self.dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  self.dateBtn.frame = CGRectMake(12+44+8, 0, kSelfWidth - 2*(12+44+8), kHeaderHeight);
  [self.dateBtn setTitle:[self.dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
  [self.dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [headerView addSubview:self.dateBtn];
  UIImage *trilImg = [UIImage imageNamed:@"icon_tril"];
  [self.dateBtn setImage:trilImg forState:UIControlStateNormal];
  [self.dateBtn addTarget:self action:@selector(dateBtnClick) forControlEvents:UIControlEventTouchUpInside];
  [self setBtnImageRightAlignment];
  
  self.calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kSelfWidth, kCalendarHeight)];
  self.calendar.delegate = self;
  self.calendar.dataSource = self;
  self.calendar.headerHeight = 0;
  self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
  self.calendar.backgroundColor = [UIColor whiteColor];
  self.calendar.appearance.weekdayTextColor = [UIColor blackColor];
  self.calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
  [self addSubview:self.calendar];
  [self bringSubviewToFront:headerView];
  
  self.calendar.layer.shadowOffset = CGSizeMake(0, kShadowHeight);
  self.calendar.layer.shadowRadius = 3;
  self.calendar.layer.shadowOpacity = 0.1;
  self.calendar.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)setHiddenPreviousNextBtn:(BOOL)hiddenPreviousNextBtn {
  _hiddenPreviousNextBtn = hiddenPreviousNextBtn;
  [_previousButton setHidden:_hiddenPreviousNextBtn];
  [_nextButton setHidden:_hiddenPreviousNextBtn];
}

- (void)dateBtnClick {
  if (self.calendarShow) {
    [self hiddenCalendar];
  } else {
    [self showCanlendar];
  }
}

- (NSDate *)date {
  if (self.calendar.selectedDate) {
    return self.calendar.selectedDate;
  }
  return [NSDate date];
}

- (void)showCanlendar {
  [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kSelfHeight);
  } completion:^(BOOL finished) {
    [self changeDateBtnTitleWithShow:YES];
    self.calendar.layer.shadowRadius = .5;
    self.calendarShow = YES;
  }];
}

- (void)hiddenCalendar {
  [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kHeaderHeight);
  } completion:^(BOOL finished) {
    self.calendar.layer.shadowRadius = 0;
    [self changeDateBtnTitleWithShow:NO];
    self.calendarShow = NO;
  }];
}

- (void)changeDateBtnTitleWithShow:(BOOL)show {
  NSString *dateStr = @"";
  if (show) {
    self.dateFormatter.dateFormat = @"MM月";
    dateStr = [self.dateFormatter stringFromDate:self.calendar.currentPage];
    if (!_hiddenPreviousNextBtn) {
      [_nextButton setHidden:NO];
    }
  } else {
    self.dateFormatter.dateFormat = @"MM月dd日";
    dateStr = [self.dateFormatter stringFromDate:self.calendar.selectedDate];
    if ([self date:self.calendar.selectedDate equalToDate:[NSDate date]]) { // 隐藏next按钮
      [_nextButton setHidden:YES];
    } else {  // 显示next按钮
      if (!_hiddenPreviousNextBtn) {
        [_nextButton setHidden:NO];
      }
    }
  }
  [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
  [self setBtnImageRightAlignment];
}

- (void)previousClicked {
  if (self.calendarShow) { // 上个月
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
  } else {  // 前一天
    NSDate *preDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:self.calendar.selectedDate options:0];
    [self.calendar selectDate:preDate scrollToDate:YES];
    [self updateData];
  }
  [self changeDateBtnTitleWithShow:self.calendarShow];
}

- (void)nextClicked {
  if (self.calendarShow) { // 下个月
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
  } else {  // 后一天
    NSDate *nextDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:1 toDate:self.calendar.selectedDate options:0];
    if ([[NSDate date] compare:nextDate] >= 0) {  // 是否不超过今天
      [self.calendar selectDate:nextDate scrollToDate:YES];
      [self updateData];
    }
  }
  [self changeDateBtnTitleWithShow:self.calendarShow];
}

#pragma mark - 刷新数据
- (void)updateData {
  if (self.changedDate) {
    self.changedDate();
  }
}

#pragma mark - FSCalendarDelegate
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
  [self changeDateBtnTitleWithShow:self.calendarShow];
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
  if ([[NSDate date] compare:date] < 0) {
    return NO;  // can't select
  }
  return YES; // can select
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
  calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
  // Do other updates here
}

#pragma mark - 号码颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
  if ([[NSDate date] compare:date] < 0) {
    return [UIColor blackColor];   // can't select color
  }
  return [UIColor redColor];  // can select color
}

#pragma mark - 选中背景
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date {
  return [UIColor purpleColor];
}

#pragma mark - 默认背景
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
  return [UIColor whiteColor];
}

#pragma mark - 选中日期Action
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
  [self updateData];
  [self hiddenCalendar];
  [self.dateBtn setTitle:[self.dateFormatter stringFromDate:date] forState:UIControlStateNormal];
}

#pragma mark - 设置按钮image右对齐
- (void)setBtnImageRightAlignment {
  [self.dateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.dateBtn.imageView.image.size.width - 5, 0, self.dateBtn.imageView.image.size.width)];
  [self.dateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.dateBtn.titleLabel.frame.size.width + 5, 0, -self.dateBtn.titleLabel.frame.size.width)];
}

- (NSDateFormatter *)dateFormatter {
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"MM月dd日";
  }
  return _dateFormatter;
}

- (BOOL)date:(NSDate *)aDate equalToDate:(NSDate *)bDate {
  unsigned componentFlags =
  (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |
   NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |
   NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);
  
  NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
  
  NSDateComponents *components1 = [calendar components:componentFlags fromDate:aDate];
  NSDateComponents *components2 = [calendar components:componentFlags fromDate:bDate];
  return ((components1.year == components2.year) && (components1.month == components2.month) &&
          (components1.day == components2.day));
}

@end
