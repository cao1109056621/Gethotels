//
//  cityModel.h
//  HotelReservation
//
//  Created by admin1 on 2017/8/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cityModel : NSObject
@property (strong,nonatomic) NSString *hotelId;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
