//
//  XCTestLayout.m
//  TangramDemo
//
//  Created by 王英辉 on 2019/3/14.
//  Copyright © 2019 tmall. All rights reserved.
//

#import "XCTestLayout.h"
#import "NSArray+TMSafeUtils.h"
#import "TangramItemModelProtocol.h"
#import "UIView+VirtualView.h"

@implementation XCTestLayout

- (TangramLayoutType *)layoutType {
    return @"container-test";
}

- (void)setItemModels:(NSArray *)itemModels
{
    _itemModels = itemModels;
}

- (void)calculateLayout {
 
    CGFloat itemW = 50;
    CGFloat itemH = 50;
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    for (NSObject<TangramItemModelProtocol> *item in self.itemModels) {
        [item setItemFrame: CGRectMake(itemX, itemY, itemW, itemH)];
        itemX += itemW;
        if(itemX/itemW > 5) {
            itemX = 0;
            itemY += 50;
        }
    }
    self.vv_height = itemY + itemH;
}

- (void)heightChangedWithElement:(UIView *)element model:(NSObject<TangramItemModelProtocol> *)model {

}

- (NSString *)position {
    return @"";
}

// Margin
- (CGFloat)marginTop {
    return 0;
}

- (CGFloat)marginRight {
    return 0;
}

- (CGFloat)marginBottom {
    return 0;
}

- (CGFloat)marginLeft {
    return 0;
}

@end
