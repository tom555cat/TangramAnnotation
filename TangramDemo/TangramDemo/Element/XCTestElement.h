//
//  XCTestElement.h
//  TangramDemo
//
//  Created by 王英辉 on 2019/3/14.
//  Copyright © 2019 tmall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TangramElementHeightProtocol.h"
#import "TMLazyScrollView.h"
#import "TangramDefaultItemModel.h"
#import "TangramEasyElementProtocol.h"
#import <TMLazyItemViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCTestElement : UIControl<TangramElementHeightProtocol,TMLazyItemViewProtocol,TangramEasyElementProtocol>

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSNumber *number;

@property (nonatomic, weak) TangramDefaultItemModel *tangramItemModel;

@property (nonatomic, weak) UIView<TangramLayoutProtocol> *atLayout;

@property (nonatomic, weak) TangramBus *tangramBus;

@property (nonatomic, strong) NSString *action;

@end

NS_ASSUME_NONNULL_END
