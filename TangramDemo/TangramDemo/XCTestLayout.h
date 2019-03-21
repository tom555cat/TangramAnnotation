//
//  XCTestLayout.h
//  TangramDemo
//
//  Created by 王英辉 on 2019/3/14.
//  Copyright © 2019 tmall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TangramLayoutProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCTestLayout : UIView<TangramLayoutProtocol>

@property (nonatomic, strong) NSArray *itemModels;
@property (nonatomic, weak) TangramBus *tangramBus;
@property (nonatomic, strong) NSString *identifier;

@end

NS_ASSUME_NONNULL_END
