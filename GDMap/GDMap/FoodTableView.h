//
//  FoodTableView.h
//  GDMap
//
//  Created by sw on 17/5/21.
//  Copyright © 2017年 sw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoodTableView;

@protocol FoodTableViewDelegate <NSObject>

- (void)didTouchTableView:(FoodTableView *)tableView withLocation:(CGPoint)location;

@end

@interface FoodTableView : UITableView

@property(nonatomic,weak) id<FoodTableViewDelegate> touchDelegate;

@end
