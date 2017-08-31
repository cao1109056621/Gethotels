//
//  HotelModel.m
//  hotel
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelModel.h"

@implementation HotelModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
         //_hotelId =[dict[@"business_id"]isKindOfClass:[NSNull class]] ? 0 :[dict[@"business_id"] integerValue];
        _imgurl = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
        _nickname= [Utilities nullAndNilCheck:dict[@"nick_name"] replaceBy:@"未知"];
        _hotelAddress = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"未知"];
        //_businessId= [Utilities nullAndNilCheck:dict[@"_business_id"] replaceBy:@"未知"];
        _hotelname = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"未命名"];
    }
    return self;

}

@end
