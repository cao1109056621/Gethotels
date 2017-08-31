//
//  HotelTableViewCell.h
//  HotelReservation
//
//  Created by admin1 on 2017/8/19.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
