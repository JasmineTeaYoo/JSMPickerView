//
//  ViewController.m
//  JSMPickerView
//
//  Created by yuyi_liu on 2017/11/7.
//  Copyright © 2017年 yuyigufen. All rights reserved.
//

#import "ViewController.h"
#import "JSMDatePick.h"
#import "JSMAdressPick.h"

@interface ViewController ()<JSMDatePickerDelegate,JSMAddressPickerDelegate>
{
    
    UIButton *btnDate;
    UIButton *btnAdress;
    NSInteger index;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    btnDate =[UIButton buttonWithType:UIButtonTypeCustom];
    btnDate.frame =CGRectMake(100, 100, 150, 30);
    btnDate.backgroundColor =[UIColor grayColor];
    btnDate.tag =100;
    [btnDate setTitle:@"日期" forState:UIControlStateNormal];
    [btnDate addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDate];
    
    
    
    
    btnAdress =[UIButton buttonWithType:UIButtonTypeCustom];
    btnAdress.frame =CGRectMake(50, 150, 300, 30);
    btnAdress.backgroundColor =[UIColor grayColor];
    [btnAdress setTitle:@"地址" forState:UIControlStateNormal];
    btnAdress.tag =101;
    [btnAdress addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAdress];

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)btn:(UIButton *)button{
    index =button.tag;
    if(button.tag ==100){
        
        JSMDatePick *vc = [[JSMDatePick alloc] init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    if(button.tag ==101){
        
        JSMAdressPick *vc = [[JSMAdressPick alloc] init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
        
    }

    
}


#pragma mark - HSDatePickerVCDelegate
- (void)datePicker:(JSMDatePick*)datePicker
          withYear:(NSString *)year
             month:(NSString *)month
               day:(NSString *)day
{
    
    NSString *str =[NSString stringWithFormat:@"%@年-%@月-%@日",year,month,day];
    [btnDate setTitle:str forState:UIControlStateNormal];
    NSLog(@"选择了   %@--%@--%@",year,month,day);
}

#pragma mark - HSAddressPickerVCDelegate
-(void)addressPicker:(JSMAdressPick*)addressPicker
    selectedProvince:(NSString*)province
                city:(NSString*)city
                area:(NSString*)area
{
    
    NSString *str =[NSString stringWithFormat:@"%@-%@-%@",province,city,city];
    [btnAdress setTitle:str forState:UIControlStateNormal];
    NSLog(@"选择了   %@--%@--%@",province,city,area);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
