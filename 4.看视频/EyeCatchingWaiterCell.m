//
//  EyeCatchingWaiterCell.m
//  4.看视频
//
//  Created by apple on 2020/7/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EyeCatchingWaiterCell.h"

#import <Masonry.h>

@interface EyeCatchingWaiterCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation EyeCatchingWaiterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
        UIView * line = [UIView new];
        [self addSubview:line];
        line.backgroundColor = [UIColor greenColor];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@(2));
        }];
    }
    return self;
}

- (void)initSubviews{
    [self.contentView addSubview:self.coverImageView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.coverImageView.frame = self.contentView.bounds;
}
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
    }
    return _coverImageView;
}

@end
