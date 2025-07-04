//
//  ATADFootView.m
//  AnyThingSDKDemo
//
//  Created by HyperBid Tech Support on 2021/12/6.
//

#import "ATADFootView.h"
#import "Masonry.h"

@interface ATADFootView()
@property (nonatomic, assign) BOOL isNeetRemove;
@property (nonatomic, assign) BOOL isNeetHidenAndMove;
@end

@implementation ATADFootView

- (instancetype)initWithRemoveBtn
{
    if (self = [super init]) {
        [self setupUIWithRemovebtn:YES hidenBtn:NO];
    }
    return self;
}

- (instancetype)initWithRemoveAndHidenBtn
{
    if (self = [super init]) {
        [self setupUIWithRemovebtn:YES hidenBtn:YES];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUIWithRemovebtn:NO hidenBtn:NO];
    }
    return self;
}

- (void)setupUIWithRemovebtn:(BOOL)haveRemove hidenBtn:(BOOL)haveHiden
{
    self.isNeetRemove = haveRemove;
    self.isNeetHidenAndMove = haveHiden;

    [self addSubview:self.loadBtn];
    [self addSubview:self.showBtn];
    [self addSubview:self.logBtn];
    if (haveRemove) {
        [self addSubview:self.removeBtn];
    }
    if (haveHiden) {
        [self addSubview:self.hidenBtn];
        [self addSubview:self.reShowBtn];
    }
}

- (void)layoutSubviews
{
    if (self.isNeetRemove) {
        // 需要remove按钮
        if (self.isNeetHidenAndMove) {
            // 需要hiden和Move按钮
            [self.loadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(kAdaptW(26,26));
                make.width.mas_equalTo((kScreenW - kAdaptW(26 * 3,26 * 3)) / 2);
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.mas_top).offset(kAdaptW(10,10));
            }];
            
            [self.showBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(kAdaptW(26,26));
                make.width.mas_equalTo((kScreenW - kAdaptW(26 * 3,26 * 3)) / 2);
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.loadBtn.mas_bottom).offset(kAdaptW(20,20));
            }];
            
            [self.logBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(kAdaptW(26,26));
                make.width.mas_equalTo((kScreenW - kAdaptW(26 * 3,26 * 3)) / 2);
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.showBtn.mas_bottom).offset(kAdaptW(20,20));
            }];
            
            [self.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.loadBtn.mas_right).offset(kAdaptW(26,26));
                make.right.equalTo(self.mas_right).offset(kAdaptW(-26,-26));
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.loadBtn.mas_top);
            }];
            self.hidenBtn.hidden = YES;
            [self.hidenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.showBtn.mas_right).offset(kAdaptW(26,26));
                make.right.equalTo(self.mas_right).offset(kAdaptW(-26,-26));
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.logBtn.mas_top);
            }];
            self.reShowBtn.hidden = YES;
            [self.reShowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.logBtn.mas_right).offset(kAdaptW(26,26));
                make.right.equalTo(self.mas_right).offset(kAdaptW(-26,-26));
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.showBtn.mas_top);
            }];
            
        } else {
            [self.loadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(kAdaptW(26,26));
                make.right.equalTo(self.mas_right).offset(kAdaptW(-26,-26));
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.mas_top).offset(kAdaptW(10,10));
            }];
            
            [self.showBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(kAdaptW(26,26));
                make.right.equalTo(self.mas_right).offset(kAdaptW(-26,-26));
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.loadBtn.mas_bottom).offset(kAdaptW(20,20));
            }];
            
            [self.logBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(kAdaptW(26,26));
                make.width.mas_equalTo((kScreenW - kAdaptW(26 * 3,26 * 3)) / 2);
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.showBtn.mas_bottom).offset(kAdaptW(20,20));
            }];
            
            [self.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.logBtn.mas_right).offset(kAdaptW(26,26));
                make.right.equalTo(self.mas_right).offset(kAdaptW(-26,-26));
                make.height.mas_equalTo(kAdaptW(90,90));
                make.top.equalTo(self.logBtn.mas_top);
            }];
        }
    } else {
        [self.loadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kAdaptW(26,26));
            make.right.equalTo(self.mas_right).offset(kAdaptW(-26,-26));
            make.height.mas_equalTo(kAdaptW(90,90));
            make.top.equalTo(self.mas_top).offset(kAdaptW(10,10));
        }];
        
        [self.showBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kAdaptW(26,26));
            make.right.equalTo(self.mas_right).offset(kAdaptW(-26,-26));
            make.height.mas_equalTo(kAdaptW(90,90));
            make.top.equalTo(self.loadBtn.mas_bottom).offset(kAdaptW(20,20));
        }];
        
        [self.logBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kAdaptW(26,26));
            make.right.equalTo(self.mas_right).offset(kAdaptW(-26,-26));
            make.height.mas_equalTo(kAdaptW(90,90));
            make.top.equalTo(self.showBtn.mas_bottom).offset(kAdaptW(20,20));
        }];
    }
}

#pragma mark - Action
- (void)clickLoadBtn
{
    if (self.clickLoadBlock) {
        self.clickLoadBlock();
    }
}

- (void)clickLogBtn
{
    if (self.clickLogBlock) {
        self.clickLogBlock();
    }
}
 
- (void)clickShowBtn
{
    if (self.clickShowBlock) {
        self.clickShowBlock();
    }
}

- (void)clickRemoveBtn
{
    if (self.clickRemoveBlock) {
        self.clickRemoveBlock();
    }
}

- (void)clickReShowBtn
{
    if (self.clickReShowBlock) {
        self.clickReShowBlock();
    }
}

- (void)clickHidenBtn
{
    if (self.clickHidenBlock) {
        self.clickHidenBlock();
    }
}
 
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - lazy
- (UIButton *)loadBtn
{
    if (!_loadBtn) {
        _loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadBtn setTitle:kLocalizeStr(@"LoadAd") forState:UIControlStateNormal];
        _loadBtn.layer.masksToBounds = YES;
        _loadBtn.layer.cornerRadius = 5; 
        _loadBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _loadBtn.layer.borderWidth = kAdaptW(3,3);
        [_loadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_loadBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_loadBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_loadBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_loadBtn addTarget:self action:@selector(clickLoadBtn) forControlEvents:UIControlEventTouchUpInside];
           
    }
    return _loadBtn;
}

- (UIButton *)showBtn
{
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setTitle:kLocalizeStr(@"ShowAd") forState:UIControlStateNormal];
        _showBtn.layer.masksToBounds = YES;
        _showBtn.layer.cornerRadius = 5; 
        _showBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _showBtn.layer.borderWidth = kAdaptW(3,3);
        [_showBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_showBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_showBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_showBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(clickShowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBtn;
}

- (UIButton *)logBtn
{
    if (!_logBtn) {
        _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logBtn setTitle:kLocalizeStr(@"ClearLog") forState:UIControlStateNormal];
        _logBtn.layer.masksToBounds = YES;
        _logBtn.layer.cornerRadius = 5; 
        _logBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _logBtn.layer.borderWidth = kAdaptW(3,3);
        [_logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_logBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_logBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_logBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_logBtn addTarget:self action:@selector(clickLogBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logBtn;
}

- (UIButton *)removeBtn
{
    if (!_removeBtn) {
        _removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeBtn setTitle:kLocalizeStr(@"RemoveAd") forState:UIControlStateNormal];
        _removeBtn.layer.masksToBounds = YES;
        _removeBtn.layer.cornerRadius = 5; 
        _removeBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _removeBtn.layer.borderWidth = kAdaptW(3,3);
        [_removeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_removeBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_removeBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_removeBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        [_removeBtn addTarget:self action:@selector(clickRemoveBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeBtn;
}

- (UIButton *)reShowBtn
{
    if (!_reShowBtn) {
        _reShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reShowBtn setTitle:kLocalizeStr(@"ReshowAd") forState:UIControlStateNormal];
        _reShowBtn.layer.masksToBounds = YES;
        _reShowBtn.layer.cornerRadius = 5; 
        _reShowBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _reShowBtn.layer.borderWidth = kAdaptW(3,3);
        [_reShowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_reShowBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_reShowBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_reShowBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        [_reShowBtn addTarget:self action:@selector(clickReShowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reShowBtn;
}

- (UIButton *)hidenBtn
{
    if (!_hidenBtn) {
        _hidenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hidenBtn setTitle:kLocalizeStr(@"HideAd") forState:UIControlStateNormal];
        _hidenBtn.layer.masksToBounds = YES;
        _hidenBtn.layer.cornerRadius = 5; 
        _hidenBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _hidenBtn.layer.borderWidth = kAdaptW(3,3);
        [_hidenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_hidenBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_hidenBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_hidenBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        [_hidenBtn addTarget:self action:@selector(clickHidenBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hidenBtn;
}
@end
