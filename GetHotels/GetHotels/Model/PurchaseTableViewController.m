//
//  PurchaseTableViewController.m
//  GetHotels
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "PurchaseTableViewController.h"
@interface PurchaseTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet NSArray *arr;

@end

@implementation PurchaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self naviConfig];
    [self uiLayout];
    [self dataInitialize];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipayResult" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title = @"入住酒店支付";
    //为导航条左上角创建一个按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"支付" style:UIBarButtonItemStylePlain target:self action:@selector(payAction)];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)uiLayout{
    _nameLabel.text = _hotel.name;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_hotel.hotelPrice];
    //NSLog(@"_hotel.hotelPrice=%@",_hotel.hotelPrice);
    
    self.tableView.tableFooterView = [UIView new];
    //将表格视图设置为编辑状态
    self.tableView.editing = YES;
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表格视图中的某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

//这个方法专门做数据的处理
- (void)dataInitialize{
    _arr = @[@"支付宝支付",@"微信支付",@"银联支付"];
}


- (void)payAction{
    switch (self.tableView.indexPathForSelectedRow.row) {
        case 0:{
            NSString *tradeNo = [GBAlipayManager generateTradeNO];
            [GBAlipayManager alipayWithProductName:_hotel.name amount:_hotel.hotelPrice tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@预定费",_hotel.name] itBPay:@"30"];
        }
            
            break;
        case 1:{
        }
            
            break;
        case 2:{
        }
            break;
            
        default:
            break;
    }
}

//当收到通知之后要做的事情
- (void)purchaseResultAction:(NSNotification *)note{
    //NSLog(@"侧1");
    NSString *result = note.object;
    //当合上的情况下打开，当打开的情况下合上
    if ([result isEqualToString:@"9000"]) {
        
        //成功
        UIAlertController *alertview = [UIAlertController alertControllerWithTitle:@"支付成功" message:@"恭喜您，您已成功完成预定" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertview addAction:okAction];
        [self presentViewController:alertview animated:YES completion:nil];
    } else {
        //失败
        [Utilities popUpAlertViewWithMsg:[result isEqualToString:@"4000"] ? @"未能支付成功，请确保账户余额充足" : @"您已取消支付" andTitle:@"支付失败" onView:self];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.f;
}


//设置组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"支付方式";
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //遍历表格视图中所有选中状态下的细胞
    for (NSIndexPath *eachIP in tableView.indexPathsForSelectedRows) {
        //当选中的细胞不是当前正在按得这个细胞的情况下
        if (eachIP != indexPath) {
            //将细胞从选中状态改为不选中状态
            [tableView deselectRowAtIndexPath:eachIP animated:YES];
        }
    }
    
}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
