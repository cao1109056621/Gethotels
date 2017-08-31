//
//  locationViewController.m
//  HotelReservation
//
//  Created by admin1 on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "locationViewController.h"

#import <CoreLocation/CoreLocation.h>
@interface locationTableViewController ()<CLLocationManagerDelegate>{
    
    BOOL firstVisit;
}
- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (strong, nonatomic) IBOutlet UITableView *citytableview;

@property (strong,nonatomic) NSDictionary *cities;
@property (strong,nonatomic) NSArray *keys;
@property (strong,nonatomic) CLLocationManager *locMgr;
@property (strong,nonatomic) CLLocation *location;
@end
@implementation locationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self uilayout];
    [self dataInitalize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//每次将要离开这个页面的时候
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locMgr stopUpdatingLocation];
}

- (void)naviConfig{
    //设置导航条标题文字
    //self.navigationItem.title = @"发布活动";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(beckAction)];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)dataInitalize{
    firstVisit = YES;
    //创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //获取要读取的文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Cities" ofType:@"plist"];
    //判断路径文件下是否存在
    if ([fileMgr fileExistsAtPath:filePath]) {
        //将文件内容读取为对应的格式
        NSDictionary *fileContent = [NSDictionary dictionaryWithContentsOfFile:filePath];
        //判断读取到的内容是否存在（判断文件是否损坏）
        if (fileContent) {
            //NSLog(@"fileContent = %@", fileContent);
            _cities = fileContent;
            //提取字典中所有的健
            NSArray *rawKeys = [fileContent allKeys];
            //根据拼音首字母进行能够识别多音字的升序排序
            _keys = [rawKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        }
    }
}
- (void)uilayout{
    if (![[[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"]isKindOfClass:[NSNull class]]) {
        if ([[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"] != nil) {
            //已经获得了定位，将定位到的城市显示在按钮上
            [_cityBtn setTitle:[[StorageMgr singletonStorageMgr]objectForKey:@"LocCity"] forState:UIControlStateNormal];
            _cityBtn.enabled = YES;
            return;
        }
    }
    //当还没有获取定位的情况下，去执行定位功能
    
    [self locationStart];
}

- (void)locationStart{
    //这个专门处理跟定位有关系的基本设置
    _locMgr = [CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //识别定位到的设备位移多少距离进行一次是别
    _locMgr.distanceFilter = kCLDistanceFilterNone;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
    //打开定位服务的开关（开始定位）----只要开了就要关
    [_locMgr startUpdatingLocation];
}

//用Model的方式返回上一页
-(void)beckAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //获取当前正在渲染的组的名称
    NSString *key = _keys[section];
    //根据组的名称作为健来查询到对应的值（这个值就是这一组城市数组）
    NSArray *sectionCities = _cities[key];
    //返回这一组城市的个数来作为行数
    return sectionCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    NSString *key = _keys[indexPath.section];
    NSArray *sectionCities = _cities[key];
    NSDictionary *city = sectionCities[indexPath.row];
    cell.textLabel.text = city[@"name"];
    
    return cell;
}


//设置组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _keys[section];
    
}


//设置section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = _keys[indexPath.section];
    NSArray *sectionCities = _cities[key];
    NSDictionary *city = sectionCities[indexPath.row];
    
    [[NSNotificationCenter defaultCenter]performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"ResetHome" object:city[@"name"]] waitUntilDone:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置右侧快捷键拦
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _keys;
}

- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
    //A
    //[noteCenter postNotificationName:@"ResetHome" object:nil];
    //B
    NSNotification *note = [NSNotification notificationWithName:@"ResetHome" object:[[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"]];
    //[noteCenter postNotification:note];
    //结合线程的通知（表示先让通知接受这完成它手打通知后要做的事以后在执行别的任务）
    [noteCenter performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
    //回到上一个页面
    [self dismissViewControllerAnimated:YES completion:nil];
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;{
    if (error) {
        switch (error.code) {
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
                break;
                
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
                break;
                
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw", nil) andTitle:nil onView:self];
                break;
                
            default:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError", nil) andTitle:nil onView:self];
                break;
        }
    }
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    //NSLog(@"纬度：%f",newLocation.coordinate.latitude);
    //NSLog(@"经度：%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿到城市
    if (firstVisit) {
        firstVisit = !firstVisit;
        //根据定位拿到城市
        [self getRegeoViaCoordinate];
    }
}

- (void)getRegeoViaCoordinate{
    //dispatch表示从now开始过3个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    //用dispatch设置好的策略去做这些事情
    dispatch_after(duration, dispatch_get_main_queue(), ^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                //NSLog(@"locDict = %@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"LocCity"];
                //将定位到的城市保存到单例化全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"LocCity" andValue:cityStr];
                //修改城市按钮标题
                [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
                _cityBtn.enabled = YES;
                
            }
        }];
        //关闭开关
        [_locMgr stopUpdatingLocation];
    });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
