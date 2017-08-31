//
//  cityModel.m
//  HotelReservation
//
//  Created by admin1 on 2017/8/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "cityModel.h"

@implementation cityModel
-(id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _hotelId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"1"];
        
        
    }
    return self;
}

@end
