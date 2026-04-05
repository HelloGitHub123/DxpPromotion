//
//  DxpPromotionConfigManager.h
//  DxpPromotion
//
//  Created by 李标 on 2026/3/7.
//

#import <Foundation/Foundation.h>
//#import "DxpPromotionModel.h"
#import "DxpPromotionInfo.h"
#import "DxpPromotionAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RequestPromotionDataCompletionBlock)(BOOL success, NSArray<DxpPromotionInfo *> *promotionList, NSString *errorMessage, NSString *errorCode);

@interface DxpPromotionConfigManager : NSObject

+ (instancetype)shareInstance;

// 配置参数
- (void)configureParamsWithUrl:(NSString *)dxpUrl token:(NSString *)token subsId:(NSString *)subsId serviceNumber:(NSString *)serviceNumber excludePageNames:(NSArray *)excludePageNames;

- (NSString *)dxpUrl;
- (NSString *)token;
- (NSString *)subsId;
- (NSString *)serviceNumber;
- (NSArray *)excludePageNames;


// 请求数据
- (void)requestPromotionData:(RequestPromotionDataCompletionBlock)completion;

// 显示弹框（无回调）
- (void)showPromotion:(NSString *)pageURL;

// 显示弹框，3个回调由外界传入并透传
- (void)showPromotion:(NSString *)pageURL
          closeBlock:(nullable DxpPromotionAlertCloseBlock)closeBlock
   primaryButtonBlock:(nullable DxpPromotionAlertButtonBlock)primaryButtonBlock
  secondaryButtonBlock:(nullable DxpPromotionAlertButtonBlock)secondaryButtonBlock;

@end

NS_ASSUME_NONNULL_END
