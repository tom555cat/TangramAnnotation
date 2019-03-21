//
//  XCOnePlusFourLayout.h
//  TangramDemo
//
//  Created by 王英辉 on 2019/3/14.
//  Copyright © 2019 tmall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TangramLayoutProtocol.h"
#import "TangramView.h"
#import "TangramFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCOnePlusFourLayout : TangramFlowLayout

// The ratio of the upper and lower lines.
// Only read first two element. Two elements added up should be 100
// The type of element in `rows` can be NSString or NSNumber
@property (nonatomic, strong) NSArray *rows;

@end

NS_ASSUME_NONNULL_END
