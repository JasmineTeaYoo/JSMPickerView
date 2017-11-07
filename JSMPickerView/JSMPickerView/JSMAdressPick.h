//
//  JSMAdressPick.h
//  JSMPickerView
//
//  Created by yuyi_liu on 2017/11/7.
//  Copyright © 2017年 yuyigufen. All rights reserved.
//

#import "JSMBasePickViewController.h"
@class JSMAdressPick;

@protocol JSMAddressPickerDelegate <NSObject>
-(void)addressPicker:(JSMAdressPick*)addressPicker
    selectedProvince:(NSString*)province
                city:(NSString*)city
                area:(NSString*)area;

@end
@interface JSMAdressPick : JSMBasePickViewController
@property (nonatomic, weak) id<JSMAddressPickerDelegate> delegate;
@end
