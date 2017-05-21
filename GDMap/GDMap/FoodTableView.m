//
//  FoodTableView.m
//  GDMap
//
//  Created by sw on 17/5/21.
//  Copyright © 2017年 sw. All rights reserved.
//

#import "FoodTableView.h"

@implementation FoodTableView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    if (self.touchDelegate && [self.touchDelegate respondsToSelector:@selector(didTouchTableView:withLocation:)]) {
        [self.touchDelegate didTouchTableView:self withLocation:location];
    }
}
@end

