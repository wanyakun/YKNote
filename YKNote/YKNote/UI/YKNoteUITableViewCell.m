//
//  YKNoteUITableViewCell.m
//  YKNote
//
//  Created by wanyakun on 2017/2/25.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import "YKNoteUITableViewCell.h"

@interface YKNoteUITableViewCell ()

@property (nonatomic, strong) CALayer *textLayer;
@property (nonatomic, strong) CALayer *imageLayer;

@end

@implementation YKNoteUITableViewCell

- (instancetype)init {
    if (self = [super init]) {
        self.textLayer.frame = CGRectMake(10, 10, 150, 44);
        [self.layer addSublayer:self.textLayer];
        
        self.imageLayer.frame = CGRectMake(10, 60, 200, 200);
        [self.layer addSublayer:self.imageLayer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - private method
- (void)setTextContext:(NSString *)text {
    self.textLayer.contents = text;
}

- (void)setImageContext:(UIImage *)image {
    self.imageLayer.contents = image;
}

#pragma mark - getter
- (CALayer *)textLayer {
    if (_textLayer == nil) {
        _textLayer = [[CALayer alloc] init];
        _textLayer.delegate = self;
    }
    return _textLayer;
}

- (CALayer *)imageLayer {
    if (_imageLayer == nil) {
        _imageLayer = [[CALayer alloc] init];
    }
    return _imageLayer;
}

@end
