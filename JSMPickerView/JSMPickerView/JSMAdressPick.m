//
//  JSMAdressPick.m
//  JSMPickerView
//
//  Created by yuyi_liu on 2017/11/7.
//  Copyright © 2017年 yuyigufen. All rights reserved.
//

#import "JSMAdressPick.h"

@interface JSMAdressPick ()
// 数据源数组
@property(nonatomic,strong)NSMutableArray *allProvinces;// 所有省信息
@property(nonatomic,strong)NSMutableArray *allCities;// 一个省的所有城市信息
@property(nonatomic,strong)NSMutableArray *currentCityArray;// 当前省的 所有城市名称
@property(nonatomic,strong)NSMutableArray *currentAreaArray;// 当前市的 所有区名称
// 记录当前行
@property(nonatomic,assign) NSInteger provinceIndex;
@property(nonatomic,assign) NSInteger cityIndex;
// 记录当前省市区
@property(nonatomic,copy) NSString *currentProvince;
@property(nonatomic,copy) NSString *currentCity;
@property(nonatomic,copy) NSString *currentArea;
@end

@implementation JSMAdressPick
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerTitle = @"请选择地区";
    [self allProvinces];// 初始化所有省数据
    [self currentCityArray]; //初始化当前市数据
    [self currentAreaArray];// 初始化当前区数组
    
    self.JSMPickerdataArr = @[_allProvinces,_currentCityArray,_currentAreaArray];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
        return [self.allProvinces[row] objectForKey:@"divisionName"];
        break;
        case 1:
        return self.currentCityArray[row];
        break;
        case 2:
        return self.currentAreaArray[row];
        break;
        default:
        break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        // 重置当前城市数组
        self.provinceIndex = row;
        [self resetCityArray];
        // 刷新城市列表,并滚动至第一行
        [self scrollToTopRowAtComponent:1];
        // 记录当前城市
        _currentCity = _currentCityArray[0];
        // 根据当前城市重置区数组
        self.cityIndex = [_currentCityArray indexOfObject:_currentCity];
        [self resetAreaArray];
        // 刷新区列表,并滚动至第一行
        [self scrollToTopRowAtComponent:2];
        // 记录当前
        _currentProvince = [_allProvinces[row] objectForKey:@"divisionName"];
        // 记录当前区
        if (_currentAreaArray.count) {
            _currentArea = _currentAreaArray[0];
        }
        else{
            _currentArea = @"";
        }
    }
    else if(component == 1){
        // 记录当前城市
        _currentCity = _currentCityArray[row];
        // 根据当前城市重置区数组
        self.cityIndex = row;
        [self resetAreaArray];
        // 刷新区列表,并滚动至第一行
        [self scrollToTopRowAtComponent:2];
        if (_currentAreaArray.count) {
            _currentArea = _currentAreaArray[0];
        }
        else{
            _currentArea = @"";
        }
    }
    else{
        // 重置当前区
        if (_currentAreaArray.count) {
            _currentArea = _currentAreaArray[row];
        }
        else{
            _currentArea = @"";
        }
    }
}

#pragma mark - privateMethods
-(void)cancleBtnClick{
    [super cancleBtnClick];
}

-(void)ensureBtnClick{
    [super ensureBtnClick];
    if ([self.delegate respondsToSelector:@selector(addressPicker:selectedProvince:city:area:)]) {
        [self.delegate addressPicker:self selectedProvince:_currentProvince city:_currentCity area:_currentArea];
    }
}

/** 获取plist文件路径 */
-(NSString*)addressFilePath{
    return [[NSBundle mainBundle] pathForResource:@"Address.plist" ofType:nil];
}

/** 获取当前省 的市数组 */
-(void)resetCityArray{
    [self.currentCityArray removeAllObjects];
    // 当前省信息字典
    NSDictionary *currentPorvinceDict = self.allProvinces[_provinceIndex];
    // 当前省编码
    NSString *cityPostcode = [currentPorvinceDict objectForKey:@"divisionCode"];
    // 根据省编码 获取 市信息数组
    NSArray *cityArr = [[NSDictionary dictionaryWithContentsOfFile:[self addressFilePath]] objectForKey:cityPostcode];
    self.allCities = [NSMutableArray arrayWithArray:cityArr];
    // 重置城市数组
    for (NSDictionary *dict in cityArr) {
        [_currentCityArray addObject:[dict objectForKey:@"divisionName"]];
    }
}

/** 根据当前城市编号 获取区数组 */
-(void)resetAreaArray{
    [self.currentAreaArray removeAllObjects];
    NSString *currentCityPostcode = [_allCities[_cityIndex] objectForKey:@"divisionCode"];
    // 根据市编码 获取 区信息数组
    NSArray *areaArr = [[NSDictionary dictionaryWithContentsOfFile:[self addressFilePath]] objectForKey:currentCityPostcode];
    // 重置区数组
    for (NSDictionary *dict in areaArr) {
        [_currentAreaArray addObject:[dict objectForKey:@"divisionName"]];
    }
}

/** 刷新区列表,并滚动至第一行 */
-(void)scrollToTopRowAtComponent:(NSInteger)component{
    [self.pickView reloadComponent:component];
    [self.pickView selectRow:0 inComponent:component animated:YES];
}

#pragma mark - lazy
/** 所有省字典数据 */
-(NSMutableArray*)allProvinces{
    if (!_allProvinces) {
        _allProvinces = [[NSDictionary dictionaryWithContentsOfFile:[self addressFilePath]] objectForKey:@"provinces"];
        _currentProvince = [_allProvinces[0] objectForKey:@"divisionName"];// 初始化当前省
    }
    return _allProvinces;
}

/** 市名称 数组 */
-(NSMutableArray*)currentCityArray{
    if (!_currentCityArray) {
        _currentCityArray = [[NSMutableArray alloc] init];
        // 重置城市数组
        [self resetCityArray];
        _currentCity = _currentCityArray[0];
    }
    return _currentCityArray;
}

/** 区名称 数组 */
-(NSMutableArray*)currentAreaArray{
    if (!_currentAreaArray) {
        _currentAreaArray = [[NSMutableArray alloc] init];
        // 重置区数组
        [self resetAreaArray];
        _currentArea = _currentAreaArray[0];
    }
    return _currentAreaArray;
}

@end
