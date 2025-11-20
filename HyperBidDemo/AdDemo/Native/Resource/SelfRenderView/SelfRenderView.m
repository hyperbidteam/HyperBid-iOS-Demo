//
//  SelfRenderView.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/11.
//

#import "SelfRenderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
 
@interface SelfRenderView()

@property(nonatomic, strong)  ATNativeAdOffer * nativeAdOffer;
@property (nonatomic, strong) MCAdInfo        * adInfo;

@end

@implementation SelfRenderView

- (void)dealloc {
    ATDemoLog(@"🔥---SelfRenderView--dealloc");
}

- (void)destory {
    // Destroy offer in time
    _nativeAdOffer = nil;
}
 
- (instancetype)initWithAdInfo:(MCAdInfo *)adInfo {
    if (self = [super init]) {
        _adInfo = adInfo;
        self.backgroundColor = randomColor;
        // Initialize components
        [self addView];
        // Layout all components
        [self makeConstraintsForSubviews];
        // Assign values based on material object MCAdInfo
        [self setupUI];
    }
    return self;
}

- (void)addView {
    self.advertiserLabel = [[UILabel alloc]init];
    self.advertiserLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.advertiserLabel.textColor = [UIColor blackColor];
    self.advertiserLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.advertiserLabel];
        
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    self.textLabel.textColor = [UIColor blackColor];
    [self addSubview:self.textLabel];
    
    self.ctaLabel = [[UILabel alloc]init];
    self.ctaLabel.font = [UIFont systemFontOfSize:15.0f];
    self.ctaLabel.textColor = [UIColor whiteColor];
    self.ctaLabel.backgroundColor = [UIColor blueColor];
    self.ctaLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.ctaLabel];

    self.ratingLabel = [[UILabel alloc]init];
    self.ratingLabel.font = [UIFont systemFontOfSize:15.0f];
    self.ratingLabel.textColor = [UIColor yellowColor];
    [self addSubview:self.ratingLabel];
 
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.layer.cornerRadius = 4.0f;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.mainImageView];
    
    self.logoImageView = [[UIImageView alloc]init];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.tag = 110220;
    [self addSubview:self.logoImageView];
    
    UIImage *closeImg = [UIImage imageNamed:@"icon_webview_close" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AnyThinkSDK" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
    self.dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dislikeButton.backgroundColor = randomColor;
    [self.dislikeButton setImage:closeImg forState:0];
    [self addSubview:self.dislikeButton];
    
    // MediaView does not need initialization, but must be judged and assigned like this
    if (self.adInfo.nativeAd.mediaView) {
        self.mediaView = self.adInfo.nativeAd.mediaView;
        [self addSubview:self.mediaView];
    }
    
    // Enable interaction based on actual situation
    [self addUserInteraction];
}

- (void)addUserInteraction {
    self.ctaLabel.userInteractionEnabled = YES;
    self.advertiserLabel.userInteractionEnabled = YES;
    self.titleLabel.userInteractionEnabled = YES;
    self.textLabel.userInteractionEnabled = YES;
    self.ratingLabel.userInteractionEnabled = YES;
    self.iconImageView.userInteractionEnabled = YES;
    self.mainImageView.userInteractionEnabled = YES;
    self.logoImageView.userInteractionEnabled = YES;
}

- (void)setupUI {
    if (self.adInfo.nativeAd.icon) {
        self.iconImageView.image = self.adInfo.nativeAd.icon;
    } else {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.adInfo.nativeAd.iconUrl]];
        ATDemoLog(@"🔥AnyThinkDemo::iconUrl:%@",self.adInfo.nativeAd.iconUrl);
    }

    if (self.adInfo.nativeAd.mainImage) {
        self.mainImageView.image = self.adInfo.nativeAd.mainImage;
    } else {
        [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.adInfo.nativeAd.imageUrl]];
        ATDemoLog(@"🔥AnyThinkDemo::imageUrl:%@",self.adInfo.nativeAd.imageUrl);
    }
    
    if (self.adInfo.nativeAd.logoUrl.length) {
        ATDemoLog(@"🔥----logoUrl:%@",self.adInfo.nativeAd.logoUrl);
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.adInfo.nativeAd.logoUrl]];
    } else if (self.adInfo.nativeAd.logo) {
        ATDemoLog(@"🔥----logo:%@",self.adInfo.nativeAd.logo);
        self.logoImageView.image = self.adInfo.nativeAd.logo;
    }
        
    self.advertiserLabel.text = self.adInfo.nativeAd.advertiser;
    self.titleLabel.text = self.adInfo.nativeAd.title;
    self.textLabel.text = self.adInfo.nativeAd.body;
    self.ctaLabel.text = self.adInfo.nativeAd.callToAction;
    self.ratingLabel.text = [NSString stringWithFormat:@"Rating:%@", self.adInfo.nativeAd.starRating.stringValue ? self.adInfo.nativeAd.starRating.stringValue : @""];
     
    ATDemoLog(@"🔥AnythinkDemo::native文本内容title:%@ ; text:%@ ; cta:%@ ",self.adInfo.nativeAd.title,self.adInfo.nativeAd.body,self.adInfo.nativeAd.callToAction);
}

- (void)makeConstraintsForSubviews {
    self.backgroundColor = randomColor;
    self.titleLabel.backgroundColor = randomColor;
    self.textLabel.backgroundColor = randomColor;
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@25);
        make.bottom.equalTo(self).equalTo(@-5);
        make.left.equalTo(self).equalTo(@5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-50);
        make.height.equalTo(@20);
        make.top.equalTo(self).offset(20);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-50);
        make.height.equalTo(@20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.ctaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).equalTo(@5);
        make.width.equalTo(@100);
        make.height.mas_equalTo(self.ctaLabel.font.lineHeight);
        make.left.equalTo(self.textLabel.mas_left);
    }];
    
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ctaLabel.mas_right).offset(20);
        make.height.mas_equalTo(self.ratingLabel.font.lineHeight);
        make.top.equalTo(self.ctaLabel.mas_top).offset(0);
        make.width.equalTo(@80);
    }];
 
    [self.advertiserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.right.equalTo(self).equalTo(@-5);
        make.left.equalTo(self.ctaLabel.mas_right).offset(50);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.height.width.equalTo(@75);
        make.top.equalTo(self).offset(20);
    }];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
        make.bottom.equalTo(self).offset(-5);
    }];
 
    [self.dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@30);
        make.top.equalTo(self).equalTo(@5);
        make.right.equalTo(self.mas_right).equalTo(@-15);
    }];
    
    // Set constraints for mediaView
    if (self.adInfo.nativeAd.mediaView) { 
        [self.mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
            make.bottom.equalTo(self).offset(-5);
        }];
    }
}
 

@end
