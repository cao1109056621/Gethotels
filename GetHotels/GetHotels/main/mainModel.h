//
//  hotelModel.h
//  hotel
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mainModel : NSObject
@property (strong,nonatomic) NSString *name;   //酒店名称
@property (strong,nonatomic) NSString *content;//活动内容
@property (strong,nonatomic) NSString *openid;
@property (strong,nonatomic) NSString *final_price;//实付金额
@property (nonatomic) NSTimeInterval *final_in_time_str;
@property (nonatomic) NSTimeInterval *final_out_time_str;
@property (strong,nonatomic) NSString *code;

@property (nonatomic) NSInteger hotelId;

@property (strong,nonatomic) NSString * hotelPrice;//酒店价格
@property (nonatomic) NSTimeInterval starttime;
@property (nonatomic) NSTimeInterval endtime;
@property (strong,nonatomic) NSString * hotelAddress;
@property (strong,nonatomic) NSString *hotelimage;

@property (nonatomic) CGFloat *latitude;
@property (nonatomic) CGFloat *longitude;
@property (strong,nonatomic) NSArray * remark;
@property (strong,nonatomic) NSString * is_pet;
@property (strong,nonatomic) NSArray * faci;
@property (strong,nonatomic) NSArray * type;


-(id)initWithDetailDictionary:(NSDictionary *)dict;
@end
