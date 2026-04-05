//
//  DxpPromotionViewModel.h
//  DxpPromotion
//
//  Created by 李标 on 2026/3/7.
//

#import <Foundation/Foundation.h>
#import "DxpPromotionBaseObject.h"
#import "HJPromotionRequestProtocolForVM.h"
#import "DxpPromotionModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * _Nonnull queryPromotionList = @"queryPromotionList";

@interface DxpPromotionViewModel : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, weak) id<HJVMRequestDelegate> delegate;

@property (nonatomic, strong) DxpPromotionModel *promotionModel;

- (void)queryPromotionsBySubsId:(NSString *)subsId channel:(NSString *)channel adSlot:(NSString *)adSlot serviceNumber:(NSString *)serviceNumber;

@end

NS_ASSUME_NONNULL_END
