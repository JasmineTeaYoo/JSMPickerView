//
//  JSMBasePickViewController.h
//  JSMPickerView
//
//  Created by yuyi_liu on 2017/11/7.
//  Copyright © 2017年 yuyigufen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSMBasePickViewController : UIViewController
// 设置中间title
@property(nonatomic,copy) NSString *pickerTitle;
// pickerview
@property (strong, nonatomic) UIPickerView *pickView;
// 数据源
@property(nonatomic,strong) NSArray<NSMutableArray*> *JSMPickerdataArr;
// 取消
-(void)cancleBtnClick;
// 确认
-(void)ensureBtnClick;
@end
