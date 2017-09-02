//
//  reserViewController.m
//  GetHotels
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "reserViewController.h"
#import "SDCycleScrollView.h"
#import "PurchaseTableViewController.h"
#import "GethotelModel.h"
@interface reserViewController ()<SDCycleScrollViewDelegate>{
    NSInteger flag;
    
}
@property (weak, nonatomic) IBOutlet UIView *bannerView;
//@property (strong, nonatomic) NSArray *reserArr;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event;



@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
- (IBAction)startDateAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
- (IBAction)endDateAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *laiview;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
- (IBAction)mapAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *hotelprice;
@property (weak, nonatomic) IBOutlet UILabel *hoteladd;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *room;
@property (weak, nonatomic) IBOutlet UILabel *Withearly;
@property (weak, nonatomic) IBOutlet UILabel *Bigbed;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *leaveLbl;
@property (weak, nonatomic) IBOutlet UILabel *liveLbl;
@property (weak, nonatomic) IBOutlet UILabel *petLbl;
@property (weak, nonatomic) IBOutlet UILabel *hotelname;
@property (weak, nonatomic) IBOutlet UILabel *stopcarLbl;
@property (weak, nonatomic) IBOutlet UILabel *washLbl;
@property (weak, nonatomic) IBOutlet UILabel *wifiLbl;
@property (weak, nonatomic) IBOutlet UILabel *pickLbl;
@property (weak, nonatomic) IBOutlet UILabel *luggLbl;
@property (weak, nonatomic) IBOutlet UILabel *finessLbl;
@property (weak, nonatomic) IBOutlet UILabel *dinnerLbl;
@property (weak, nonatomic) IBOutlet UILabel *wakeLbl;


@end

@implementation reserViewController
{
    NSArray *_imagesURLStrings;
    SDCycleScrollView *_customCellScrollViewDemo;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self custom];
    [self readyForEncoding];
    [self naviConfig];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title = @"入住酒店支付";
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(beckAction)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)custom{
    
    UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    demoContainerView.contentSize = CGSizeMake(self.view.frame.size.width, self.bannerView.frame.size.height );
    [self.bannerView addSubview:demoContainerView];
    
    NSArray *imageNames = @[@"reser1",@"reser2",@"reser3",@"reser4"];
    
    // 网络加载 --- 创建带标题的图片轮播器
  
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -64, UI_SCREEN_W, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [demoContainerView addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imageNames;
    });
    
}
- (void)readyForEncoding{
    // 创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    //开始请求
    //num=20;
    NSDictionary* para = @{@"id":@20};
    [RequestAPI requestURL:@"/hotel/findHotelById" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [_aiv stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1){
            NSDictionary *result = responseObject[@"content"];
            //NSArray *arry = result[@"hotel_types"];
            _hotel = [[GethotelModel alloc]initWithDetailDictionary:result];
            [self uilayout];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        NSLog(@"statusCode = %ld",(long)statusCode);
    }];
    
    
    
}
-(void)uilayout{
    //酒店描述
    _hotelprice.text = [NSString stringWithFormat:@"¥%@",_hotel.hotelPrice];
    _hoteladd.text = [NSString stringWithFormat:@"%@",_hotel.hotelAddress];
    _hotelname.text = [NSString stringWithFormat:@"%@",_hotel.name];
    
    _stopcarLbl.text =_hotel.faci[0];
    _washLbl.text =_hotel.faci[1];
    _wifiLbl.text =_hotel.faci[2];
    _pickLbl.text =_hotel.faci[3];
    /*_luggLbl.text =_hotel.faci[4];
     _finessLbl.text =_hotel.faci[5];
     _dinnerLbl.text =_hotel.faci[6];
     _wakeLbl.text =_hotel.faci[7];*/
    NSArray *array = _hotel.faci;
    for (int i = 0 ; i < array.count; i++) {
        if(i == 0){ _stopcarLbl.text = array[0];}
        if(i == 1){ _washLbl.text = array[1];}
        if(i == 2){ _wifiLbl.text = array[2];}
        if(i == 3){ _pickLbl.text = array[3];}
        if(i == 4){ _luggLbl.text = array[4];}
        if(i == 5){ _finessLbl.text = array[5];}
        if(i == 6){ _dinnerLbl.text = array[6];}
        if(i == 7){ _wakeLbl.text = array[7];}

    }

    //房间设施
    _size.text = _hotel.type[3];
    _Bigbed.text = _hotel.type[2];
    _Withearly.text = _hotel.type[1];
    _room.text = _hotel.type[0];
    //酒店政策
    _leaveLbl.text = _hotel.remark[1];
    _liveLbl.text = _hotel.remark[0];
    //是否能携带宠物
    if ([_hotel.is_pet isEqualToString:@"0"]) {
        _petLbl.text = @"不可携带宠物！";
        return;
    }
    if ([_hotel.is_pet isEqualToString:@"1"]) {
        _petLbl.text = @"可携带宠物！";
        return;
    }
    
    _ImageView.image = [UIImage imageNamed:@"reser5"];
    NSString *startTimeStr = [Utilities dateStrFromCstampTime:_hotel.starttime withDateFormat:@"MM-dd"];
    [_startDateBtn setTitle:startTimeStr forState:UIControlStateNormal];
    NSString *endTimeStr = [Utilities dateStrFromCstampTime:_hotel.endtime withDateFormat:@"MM-dd"];
    [_endDateBtn setTitle:endTimeStr forState:UIControlStateNormal];
    
    
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
}
- (void)setDefaultDateForButton{
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //定义日期格式
    formatter.dateFormat = @"MM月dd日";
    //当前时间
    NSDate *date = [NSDate date];
    //明天的日期
    NSDate *dateTom = [NSDate dateTomorrow];
    
    //将时间转换为字符串
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dateTomStr = [formatter stringFromDate:dateTom];
    //将处理好的时间字符串设置给两个button
    [_startDateBtn setTitle:dateStr forState:UIControlStateNormal];
    [_endDateBtn setTitle:dateTomStr forState:UIControlStateNormal];
}
/*
 //网络请求
 - (void)request{
 
 //获取token请求接口
 NSString *token = [[StorageMgr singletonStorageMgr] objectForKey:@"token"];
 NSArray *headers = @[[Utilities makeHeaderForToken:token]];
 
 //开始日期
 NSTimeInterval startTime = [Utilities cTimestampFromString:_startDateBtn.titleLabel.text format:@"yyyy-MM-dd"];
 //结束日期
 NSTimeInterval endTime = [Utilities cTimestampFromString:_endDateBtn.titleLabel.text format:@"yyyy-MM-dd"];
 
 if (startTime >= endTime) {
 [_avi stopAnimating];
 UIRefreshControl *ref = [_historyTableView viewWithTag:10005];
 [ref endRefreshing];
 [Utilities popUpAlertViewWithMsg:@"请正确设置开始日期和结束日期" andTitle:@"提示" onView:self onCompletion:^{
 }];
 }else{
 NSDictionary *para = @{@"pageNum":@(pageNum),@"pageSize":@(pageSize),@"startTime":@(startTime),@"endTime":@(endTime)};
 
 [RequestAPI requestURL:@"/api/callHistory" withParameters:para andHeader:headers byMethod:kGet andSerializer:kForm success:^(id responseObject) {
 [_avi stopAnimating];
 UIRefreshControl *ref = [_historyTableView viewWithTag:10005];
 [ref endRefreshing];
 NSLog(@"history: %@", responseObject);
 if ([responseObject[@"flag"] isEqualToString:@"success"]) {
 NSDictionary *result = responseObject[@"result"];
 NSArray *list = result[@"list"];
 
 isLastPage = [result[@"isLastPage"] boolValue];
 
 if (pageNum == 1) {
 [_historyArr removeAllObjects];
 }
 
 for (NSDictionary *dict in list) {
 HistoryModel *history = [[HistoryModel alloc] initWithDict:dict];
 [_historyArr addObject:history];
 }
 
 if (_historyArr.count == 0) {
 _imageView.hidden = NO;
 }else{
 _imageView.hidden = YES;
 }
 
 [_historyTableView reloadData];
 }else{
 [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
 }];
 }
 
 } failure:^(NSInteger statusCode, NSError *error) {
 [_avi stopAnimating];
 UIRefreshControl *ref = [_historyTableView viewWithTag:10005];
 [ref endRefreshing];
 [Utilities forceLogoutCheck:statusCode fromViewController:self];
 }];
 }
 }
 
 
 */
-(void)beckAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startDateAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    _toolBar.hidden = NO;
    _datePickerView.hidden = NO;
    _laiview.hidden = NO;
}
- (IBAction)endDateAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _toolBar.hidden = NO;
    _datePickerView.hidden = NO;
    _laiview.hidden = NO;
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _datePickerView.hidden = YES;
    _laiview.hidden = YES;
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //拿到当前datepicker选择的时间
    NSDate *date = _datePickerView.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"MM月dd日";
    //将日期转换为字符串（通过日期格式器中的stringFromDate方法）
    NSString *theDate = [formatter stringFromDate:date];
    
    if (flag == 0) {
        [_startDateBtn setTitle:theDate forState:UIControlStateNormal];
    }else{
        [_endDateBtn setTitle:theDate forState:UIControlStateNormal];
    }
    
    _toolBar.hidden = YES;
    _datePickerView.hidden = YES;
    _laiview.hidden = YES;
}
- (IBAction)mapAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //if ([Utilities loginCheck])
    PurchaseTableViewController *purchaseVC = [Utilities getStoryboardInstance:@"Second" byIdentity:@"purchase"];
    purchaseVC.hotel = _hotel;
    [self.navigationController pushViewController:purchaseVC animated:YES];
    
    /*else{
     //获取要跳转过去的那个页面
     UINavigationController *signNavi = [Utilities getStoryboardInstance:@"" byIdentity:@""];
     //执行跳转
     [self presentViewController:signNavi animated:YES completion:nil];
     }*/
    
}
@end
