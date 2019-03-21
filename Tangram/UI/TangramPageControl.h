//
//  TangramPageControl.h
//  Tangram
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TangramPageControlStyleDefault,
    TangramPageControlStyleImage
} TangramPageControlStyle;


@interface TangramPageControl : UIControl

@property (nonatomic) TangramPageControlStyle style;

@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL hidesForSinglePage; // hide the the indicator if there is only one page. default is NO

@property (nonatomic, retain) UIColor * maskColor;
@property (nonatomic) CGFloat maskAlpha; // worked when the maskColor is not set to clear. assign to 0.0 ～ 1.0

@property (nonatomic) CGFloat pageWidth;
@property (nonatomic) CGFloat pageHeight;
@property (nonatomic) CGFloat pageSpacing;

// for TangramPageControlStyleImage
@property (nonatomic, strong) UIImage * normalImage;
@property (nonatomic, strong) UIImage * selectedImage;
// for TangramPageControlStyleDefault
@property (nonatomic, strong) UIColor   *normalFillColor;
@property (nonatomic, strong) UIColor   *selectedFillColor;


- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@end
