//
//  HotelModel.h
//  hotel
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelModel : NSObject
@property (strong,nonatomic) NSString *imgurl;
@property (nonatomic) NSInteger  hotelId;
@property (strong,nonatomic) NSString *hotelname;
@property (strong,nonatomic) NSString *hotelAddress;

@property (strong,nonatomic) NSString *businessId;
@property (strong,nonatomic) NSString *nickname;
@property (strong,nonatomic) NSString *memberId;
@property (strong,nonatomic) NSString *phone;
@property (strong,nonatomic) NSString *avatarUrl;

@property (strong,nonatomic) NSString *htadd;
@property (strong,nonatomic) NSString *htname;
@property (nonatomic) NSInteger htprice;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
