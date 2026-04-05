//
//  DxpPromotionInfo.h
//  DxpPromotion
//
//  Created by 李标 on 2026/3/8.
//

#import <Foundation/Foundation.h>
#import "DxpPromotionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DxpPromotionInfo : NSObject

@property (nonatomic, copy) NSString *transactionSn;
@property (nonatomic, copy) NSString *batchId;
@property (nonatomic, copy) NSString *campaignCode;
@property (nonatomic, strong) RecommendedWordsItem *mktCreativeInfo;
@property (nonatomic, copy) NSString *popupPageURL; // 页面的标识符、路由名称
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *creativeType; // 2:webview 其他显示图片
@end

NS_ASSUME_NONNULL_END
