//
//  DxpPromotionAlertView.h
//  DxpPromotion
//
//  Created by 李标 on 2026/3/7.
//
//  营销推广弹框视图，支持 WebView/图片内容、主次按钮、关闭按钮
//  样式与布局由 promotionInfo.mktCreativeInfo.popup 配置
//

#import <UIKit/UIKit.h>
#import "DxpPromotionInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// 关闭按钮点击回调
/// @param action promotionInfo.mktCreativeInfo.popup.dismissal.action
typedef void(^DxpPromotionAlertCloseBlock)(NSString * _Nullable action);

/// 主/次按钮点击回调
/// @param action 按钮的 action
/// @param openType 打开方式（如：内嵌页、外部浏览器等）
/// @param link 跳转链接
typedef void(^DxpPromotionAlertButtonBlock)(NSString * _Nullable action, NSString * _Nullable openType, NSString * _Nullable link);

@interface DxpPromotionAlertView : UIView

/// 营销推广数据，包含弹框样式、内容、按钮等配置
@property (nonatomic, strong) DxpPromotionInfo *promotionInfo;

/// 关闭按钮（×）点击回调
@property (nonatomic, copy, nullable) DxpPromotionAlertCloseBlock closeBlock;

/// 主按钮点击回调
@property (nonatomic, copy, nullable) DxpPromotionAlertButtonBlock primaryButtonBlock;

/// 次按钮点击回调
@property (nonatomic, copy, nullable) DxpPromotionAlertButtonBlock secondaryButtonBlock;

/// 展示弹框，若未添加到父视图则自动添加到 keyWindow
- (void)show;

/// 关闭并移除弹框
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
