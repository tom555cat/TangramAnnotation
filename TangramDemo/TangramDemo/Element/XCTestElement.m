//
//  XCTestElement.m
//  TangramDemo
//
//  Created by 王英辉 on 2019/3/14.
//  Copyright © 2019 tmall. All rights reserved.
//

#import "XCTestElement.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TangramEvent.h"
#import "UIView+Tangram.h"

@interface XCTestElement()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation XCTestElement

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addTarget:self action:@selector(clickedOnElement) forControlEvents:UIControlEventTouchUpInside];
        self.clipsToBounds = YES;
        CGFloat r = (random()%256)/256.0;
        CGFloat g = (random()%256)/256.0;
        CGFloat b = (random()%256)/256.0;
        self.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    }
    return self;
}


//- (UIImageView *)imageView
//{
//    if (_imageView == nil) {
//        _imageView = [[UIImageView alloc] init];
//        _imageView.userInteractionEnabled = NO;
//        _imageView.contentMode = UIViewContentModeScaleToFill;
//        _imageView.clipsToBounds = YES;
//        [self addSubview:_imageView];
//        self.backgroundColor = [UIColor grayColor];
//    }
//    return _imageView;
//}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor redColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(void)setImgUrl:(NSString *)imgUrl
{
    if (imgUrl.length > 0) {
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.size.width > 0 && frame.size.height > 0) {
        [self mui_afterGetView];
    }
}

- (void)mui_afterGetView
{
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.titleLabel.text = [NSString stringWithFormat:@"%ld",[self.number longValue]];
    [self.titleLabel sizeToFit];
}

- (void)clickedOnElement
{
//    TangramEvent *event = [[TangramEvent alloc]initWithTopic:@"jumpAction" withTangramView:self.inTangramView posterIdentifier:@"singleImage" andPoster:self];
//    [event setParam:self.action forKey:@"action"];
//    [self.tangramBus postEvent:event];
}


+ (CGFloat)heightByModel:(TangramDefaultItemModel *)itemModel;
{
    return 100.f;
}
@end
