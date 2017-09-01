//
//  GethotelModel.m
//  GetHotels
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "GethotelModel.h"

@implementation GethotelModel
-(id)initWithDetailDictionary:(NSDictionary *)dict{
    //    if ([dict[@"imgURL"] isKindOfClass:[NSNull class]]) {
    //        _imgUrl = @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A";
    //
    //    }else{
    //        _imgUrl = dict[@"imgURL"];
    //
    //    }
    self = [super init];
    if (self) {
        
        _name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"未知"];
        _content = [Utilities nullAndNilCheck:dict[@"content"] replaceBy:@"暂无内容"];
        _final_price = [Utilities nullAndNilCheck:dict[@"applicationFee"] replaceBy:@"0"];
        _hotelId = [[Utilities nullAndNilCheck:dict[@"business_id"] replaceBy:@"0"] integerValue];
        _hotelPrice= [Utilities nullAndNilCheck:dict[@"now_price"] replaceBy:@"0"];
        _starttime = [dict[@"startDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0: (NSTimeInterval)[dict[@"startDate"] integerValue];
        _endtime = [dict[@"endDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0: (NSTimeInterval)[dict[@"endDate"] integerValue];
        
        _hotelAddress =[Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"0"];
        _hotelimage =[Utilities nullAndNilCheck:dict[@"image"] replaceBy:@"0"];
        _latitude =[Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:@"0"];
        _longitude =[Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:@"0"];
        //_remark=[Utilities nullAndNilCheck:dict[@"remarks"]] replaceBy:@[@"remarks"]];
        self.remark = [dict[@"remaks"]isKindOfClass:[NSNull class]]?@[@"",@""]:dict[@"remarks"];
        self.faci = [dict[@"hotel_facilities"]isKindOfClass:[NSNull class]]?@[@"",@"",@"",@"",@"",@"",@"",@""]:dict[@"hotel_facilities"];
        self.type = [dict[@"hotel_types"]isKindOfClass:[NSNull class]]?@[@"",@"",@"",@"",]:dict[@"hotel_types"];
        _is_pet =[Utilities nullAndNilCheck:dict[@"is_pet"] replaceBy:@"0"];
        
    }
    return self;
}


@end
