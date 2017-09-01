//
//  HotelViewController.m
//  HotelReservation
//
//  Created by admin1 on 2017/8/19.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelViewController.h"
#import "HotelTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import <CoreLocation/CoreLocation.h>
#import "HotelModel.h"
@interface HotelViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate>{
    NSInteger flag;
    NSInteger ar;
    NSString *brr;
    NSInteger arryer;
    NSInteger page;
    NSInteger perPage;
    BOOL firstVisit;
    BOOL isLoading;
    NSTimeInterval followUpTime;
    

}
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (strong ,nonatomic) NSMutableArray *arr;
@property (strong ,nonatomic) NSArray *arry;
@property (weak, nonatomic) IBOutlet UITextField *idSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *gethotelView;

@property (strong,nonatomic) CLLocationManager *locMgr;
@property (strong,nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@property (weak, nonatomic) IBOutlet UIView *screenView;
@property (weak, nonatomic) IBOutlet UIButton *screenBtn;
- (IBAction)screenBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *sequenBtn;
- (IBAction)sequenBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *sequenView;
@property (weak, nonatomic) IBOutlet UIButton *allbtn;
- (IBAction)allbtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *fourbtn;
- (IBAction)fourbtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *fivebtn;
- (IBAction)fivebtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *nobtn;
- (IBAction)nobtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *threehundrebtn;
- (IBAction)threehundredbtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *fivehundred;
- (IBAction)fivehundred:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *tenhundred;
- (IBAction)tenhundred:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *livedate;
@property (weak, nonatomic) IBOutlet UIButton *leavedate;
@property (weak, nonatomic) IBOutlet UIButton *tenuphundred;
- (IBAction)tenhundredbtn:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)livedateBtn:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)leavedateBtn:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)confirmBtn:(UIBarButtonItem *)sender;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarView;
- (IBAction)BossBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *paixu;
- (IBAction)paixu:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *lowtohight;
- (IBAction)lowtohight:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)hightTolow:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *highttolow;
@property (weak, nonatomic) IBOutlet UIButton *neartofar;
- (IBAction)neartofar:(UIButton *)sender forEvent:(UIEvent *)event;





@end

@implementation HotelViewController
//第一次将要开始渲染这个页面的时候
-(void)awakeFromNib{
    [super awakeFromNib];
}
- (void)viewDidLoad {

    [super viewDidLoad];
    [self locaionConfig];
    [self dataInitialize];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
    _idSearchBar.returnKeyType = UIReturnKeySearch;//变为发送按钮
    _idSearchBar.delegate = self;//设置代理
    perPage=10;
    page=1;
   
    _arry = @[@"img_01",@"img_02",@"img_03",@"img_04"];
    self.bannerView.imageURLStringsGroup = _arry;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.delegate = self;
    self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//每次将要来到这个页面的时候
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationStart];
}
//每次将要离开这个页面的时候
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locMgr stopUpdatingLocation];
}
#pragma mark - table view
//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arr.count;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotelcell" forIndexPath:indexPath];
    NSDictionary *dict = _arr[indexPath.row];
    NSURL *url = dict[@"hotel_img"];
    [cell.imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.nameLabel.text = dict[@"hotel_name"];
    cell.placeLabel.text = dict[@"hotel_address"];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥ %@ 元", dict[@"now_price"]];
    return cell;
}

//设置细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_idSearchBar resignFirstResponder];
}


//在代理方法中实现你想要的点击操作就可以了
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self networkRequest];
    [_idSearchBar resignFirstResponder];
    _idSearchBar.text = @"";
    return YES;
}

//设置每一组中每一行的细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断当前tableView是否为_activityTableView（这个条件判断常用在一个页面中有多个taleView的时候）
    if ([tableView isEqual:_gethotelView]) {
        //取消选中
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
//当某一个页面跳转行为将要发生的时候
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"firstTOsecond"]) {
      /*  //当从列表页到详情页的这个跳转要发生的时候
        //1、获取要传递到下一页去的数据
        NSIndexPath *indexPath = [_gethotelView indexPathForSelectedRow];
        HotelModel *activity = _arr[indexPath.row];
        //2、获取下一页这个实例
        DetailViewController *detailVC = segue.destinationViewController;
        //3、把数据给下一页预备好的接受容器
        detailVC.activity = activity;
       */
    }
}

//每次离开了这个页面的时候
-( void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //获得当前页面的导航控制器所谓系的关于导航关系的数组，判断该数组中是否包含自己来得知当前操作是离开本页面还是退出本页面
    if(![self.navigationController.viewControllers containsObject:self]){
        //在这里先释放所有监听（包括：Action事件；Protocol协议；Gesture手势；Notification通知......）
    }
}
//这个专门处理跟定位有关系的基本设置
- (void)locaionConfig{
    _locMgr = [CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //识别定位到的设备位移多少距离进行一次是别
    _locMgr.distanceFilter = kCLDistanceFilterNone;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
}
//这个方法处理开始定位
- (void)locationStart{
    //判断用户有没有选择过是否使用定位
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //询问用户是否愿意使用定位
#ifdef __IPHONE_8_0
        //if ([_locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //使用“使用中打开定位”这个策略去运行定位功能
        [_locMgr requestWhenInUseAuthorization];
        //}
#endif
    }
    //打开定位服务的开关（开始定位）----只要开了就要关
    [_locMgr startUpdatingLocation];
}
//这个方法专门做数据的处理
- (void)dataInitialize{
    BOOL appInit = NO;
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //说明是第一次打开app
        appInit = YES;
    } else {
        if ([Utilities getUserDefaults:@"UserCity"] == nil) {
            //说明是第一次打开app
            appInit = YES;
        }
        if (appInit) {
            //第一次来到app将默认城市与记忆城市同步
            NSString *userCity = _cityButton.titleLabel.text;
            [Utilities setUserDefaults:@"UserCity" content:userCity];
        } else {
            //不是第一次来到app则将记忆城市与按钮上的城市名反向同步
            NSString *userCity = [Utilities getUserDefaults:@"UserCity"];
            [_cityButton setTitle:userCity forState:UIControlStateNormal];
        }
    }
    firstVisit = YES;
    isLoading = NO;
    _arr = [NSMutableArray new];
    // 创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
   
    
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
        [_aiv stopAnimating];
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
                if (![cityStr isEqualToString:_cityButton.titleLabel.text]) {
                    //当定位到的城市和当前选择的城市不一样的时候去弹窗询问用户是否要切换城市
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的的城市为%@,请问您是否要切换",cityStr] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * yesAction = [UIAlertAction actionWithTitle: @"确认"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_cityButton setTitle:cityStr forState:UIControlStateNormal];
                        //修改用户选择城市记忆体
                        [Utilities removeUserDefaults:@"UserCity"];
                        
                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
                        //重新执行网络请求
                        //[self networkRequest];
                    }];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                    [alertView addAction:yesAction];
                    [alertView addAction:noAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                }
                
            }
        }];
        //关闭开关
        [_locMgr stopUpdatingLocation];
    });
}
- (void)checkCityState:(NSNotification *)note{
    NSString *cityStr = note.object;
    if (![cityStr isEqualToString:_cityButton.titleLabel.text]) {
        //修改城市按钮标题
        [_cityButton setTitle:cityStr forState:UIControlStateNormal];
        //修改用户选择城市记忆体
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        
    }
}

//智能排序
- (IBAction)screenBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    self.sequenView.hidden = YES;
        if (self.screenView.hidden == NO) {
            [_screenBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            self.screenView.hidden = YES;
        }else{
            self.screenView.hidden = NO;
            [_screenBtn setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
        }
}
//筛选
- (IBAction)sequenBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    self.screenView.hidden = YES;
    if (self.sequenView.hidden == NO) {
        [_sequenBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
        self.sequenView.hidden = YES;
    }else{
        self.sequenView.hidden = NO;
        [_sequenBtn setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
    }
}
//全部
- (IBAction)allbtn:(UIButton *)sender forEvent:(UIEvent *)event {
    _fourbtn.selected = NO;
    _fivebtn.selected = NO;
    if (_allbtn.selected == NO) {
        _allbtn.selected = YES;
    }
    
}
//四星
- (IBAction)fourbtn:(UIButton *)sender forEvent:(UIEvent *)event {
     _allbtn.selected = NO;
    _fivebtn.selected = NO;
    if (_fourbtn.selected == NO) {
        _fourbtn.selected = YES;
    }
    
}
//五星
- (IBAction)fivebtn:(UIButton *)sender forEvent:(UIEvent *)event {
    _fourbtn.selected = NO;
     _allbtn.selected = NO;
    if (_fivebtn.selected == NO) {
        _fivebtn.selected = YES;
    }
   
}
//不限
- (IBAction)nobtn:(UIButton *)sender forEvent:(UIEvent *)event {
     _threehundrebtn.selected = NO;
    _fivehundred.selected = NO;
    _tenhundred.selected = NO;
    _tenuphundred.selected = NO;
    if (_nobtn.selected == NO) {
        _nobtn.selected = YES;
    }
  
}
//300以下
- (IBAction)threehundredbtn:(UIButton *)sender forEvent:(UIEvent *)event {
    _nobtn.selected = NO;
    _fivehundred.selected = NO;
    _tenhundred.selected = NO;
    _tenuphundred.selected = NO;
    if (_threehundrebtn.selected == NO) {
        _threehundrebtn.selected = YES;
    }
   
}
//300-500
- (IBAction)fivehundred:(UIButton *)sender forEvent:(UIEvent *)event {
    _nobtn.selected = NO;
    _tenhundred.selected = NO;
     _threehundrebtn.selected = NO;
    _tenuphundred.selected = NO;
    if (_fivehundred.selected == NO) {
        _fivehundred.selected = YES;
    }
   
}
//500-1000
- (IBAction)tenhundred:(UIButton *)sender forEvent:(UIEvent *)event {
    _nobtn.selected = NO;
    _fivehundred.selected = NO;
     _threehundrebtn.selected = NO;
    _tenuphundred.selected = NO;
    if (_tenhundred.selected == NO) {
        _tenhundred.selected = YES;
    }
 
}
//1000以上
- (IBAction)tenhundredbtn:(UIButton *)sender forEvent:(UIEvent *)event {
    _nobtn.selected = NO;
    _fivehundred.selected = NO;
     _threehundrebtn.selected = NO;
    _tenhundred.selected = NO;
    if (_tenuphundred.selected == NO) {
        _tenuphundred.selected = YES;
    }
    
}
//入住时间
- (IBAction)livedateBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    _datePicker.hidden = NO;
    _dateView.hidden = NO;
    _toolbarView.hidden = NO;
}

- (IBAction)leavedateBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _datePicker.hidden = NO;
    _dateView.hidden = NO;
     _toolbarView.hidden = NO;
}
//确认按钮
- (IBAction)confirmBtn:(UIBarButtonItem *)sender {
    NSDate *date = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd ";
    matter.dateFormat = @"yyyy-MM-dd ";
    NSString *thDate = [formatter stringFromDate:date];
    NSString *theDate = [matter stringFromDate:date];
    
    followUpTime = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd HH:mm"];
    
    if (flag == 0) {
        [_livedate setTitle:thDate forState:UIControlStateNormal];
    }else{
        [_leavedate setTitle:theDate forState:UIControlStateNormal];
    }

    _toolbarView.hidden = YES;
    _datePicker.hidden = YES;
    _dateView.hidden = YES;
}
//取消按钮
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _datePicker.hidden = YES;
    _toolbarView.hidden = YES;
    _dateView.hidden = YES;
}
- (IBAction)BossBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_allbtn.selected == YES) {
        ar = 1;
    }else if (_fourbtn.selected == YES){
        ar = 2;
    }else if (_fivebtn.selected == YES){
        ar = 3;
    }
    if (_paixu.selected == YES) {
        brr = @"1";
    }else if (_lowtohight.selected == YES){
        brr = @"2";
    }else if (_highttolow.selected == YES){
        brr = @"3";
    }else if (_neartofar.selected == YES){
        brr = @"4";
    }
    if (_nobtn.selected == YES) {
        arryer = 1;
    }else if (_threehundrebtn.selected == YES){
        arryer = 2;
    }else if (_fivehundred.selected == YES){
        arryer = 3;
    }else if (_tenhundred.selected == YES){
        arryer = 4;
    }else if (_tenuphundred.selected == YES){
        arryer = 5;
    }
    //开始日期
    NSTimeInterval startTime = [Utilities cTimestampFromString:_livedate.titleLabel.text format:@"yyyy-MM-dd"];
    //结束日期
    NSTimeInterval endTime = [Utilities cTimestampFromString:_leavedate.titleLabel.text format:@"yyyy-MM-dd"];
    
    if (startTime >= endTime) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请正确设置开始日期和结束日期" andTitle:@"提示" onView:self];
    }else{
        NSDictionary *para = @{@"pageNum":@(page),@"pageSize":@(perPage),@"inTime":@(startTime),@"outTime":@(endTime),@"sortingId":brr,@"startId":@(ar),@"priceId":@(arryer)};
        NSLog(@"page = %ld  perPage = %ld  startTime = %f  endTime = %f  ar = %ld  brr = %@ priceId = %ld",(long)page,(long)perPage,startTime,endTime,(long)ar,brr,(long)arryer);
        
        NSString *urlstring=@"https://gethotels.fisheep.com.cn/hotel/findHotelByCity_edu";
        AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
        manger.responseSerializer=[AFHTTPResponseSerializer serializer];
        [manger GET:urlstring parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"dict = %@",dict);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
        
        
           }
}
- (void)networkRequest{
    NSString *urlstring=@"https://gethotels.fisheep.com.cn/findHotelById";
    NSDictionary *param=@{@"id": _idSearchBar.text};
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manger GET:urlstring parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *result = dict[@"content"];
        //NSLog(@"%@",result);
        [_arr addObject:result];
        //NSLog(@"_arr = %@",_arr);
        //刷新表格
        [_gethotelView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}

- (IBAction)paixu:(UIButton *)sender forEvent:(UIEvent *)event {
    _lowtohight.selected = NO;
    _highttolow.selected = NO;
    _neartofar.selected = NO;
    if (_paixu.selected == NO) {
        _paixu.selected = YES;
    }
}
- (IBAction)lowtohight:(UIButton *)sender forEvent:(UIEvent *)event {
    _paixu.selected = NO;
    _highttolow.selected = NO;
    _neartofar.selected = NO;
    if (_lowtohight.selected == NO) {
        _lowtohight.selected = YES;
    }
}

- (IBAction)hightTolow:(UIButton *)sender forEvent:(UIEvent *)event {
    _paixu.selected = NO;
    _lowtohight.selected = NO;
    _neartofar.selected = NO;
    if (_highttolow.selected == NO) {
        _highttolow.selected = YES;
    }
}
- (IBAction)neartofar:(UIButton *)sender forEvent:(UIEvent *)event {
    _paixu.selected = NO;
    _lowtohight.selected = NO;
    _highttolow.selected = NO;
    if (_neartofar.selected == NO) {
        _neartofar.selected = YES;
    }
}
@end
