//
//  JSMDatePick.h
//  JSMPickerView
//
//  Created by yuyi_liu on 2017/11/7.
//  Copyright © 2017年 yuyigufen. All rights reserved.
//

#import "JSMBasePickViewController.h"
@class JSMDatePick;

@protocol JSMDatePickerDelegate <NSObject>
- (void)datePicker:(JSMDatePick*)datePicker
          withYear:(NSString *)year
             month:(NSString *)month
               day:(NSString *)day;

@end
@interface JSMDatePick : JSMBasePickViewController
@property (nonatomic, weak) id<JSMDatePickerDelegate> delegate;
@end
