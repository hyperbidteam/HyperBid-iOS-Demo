//
//  CustomTableViewCell.h
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2024/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subTitleLbl;  

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subTitle;

@end

NS_ASSUME_NONNULL_END


