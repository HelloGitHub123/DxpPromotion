//
//  DxpPromotionViewModel.m
//  DxpPromotion
//
//  Created by 李标 on 2026/3/7.
//

#import "DxpPromotionViewModel.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import <YYModel/YYModel.h>

@implementation DxpPromotionViewModel

#define stringFormat(s, ...)     [NSString stringWithFormat:(s),##__VA_ARGS__]

- (void)queryPromotionsBySubsId:(NSString *)subsId channel:(NSString *)channel adSlot:(NSString *)adSlot serviceNumber:(NSString *)serviceNumber {
	
	NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
	[parmas setValue:subsId forKey:@"subsId"];
	[parmas setValue:channel forKey:@"channel"];
	[parmas setValue:adSlot forKey:@"adSlot"];
	[parmas setValue:serviceNumber forKey:@"serviceNumber"];
	
	NSString *url = @"/dxp/promotion-management/v2/promotions";
	
	__weak __typeof(&*self)weakSelf = self;
	[[DCNetAPIClient sharedClient] POST:url paramaters:parmas CompleteBlock:^(id res, NSError *error) {
		if (!error) {
			NSDictionary *dict = (NSDictionary *)res;
			NSString *resultCode = [dict objectForKey:@"resultCode"];
			if ([resultCode isEqualToString:@"200"]) {
				weakSelf.promotionModel = [DxpPromotionModel yy_modelWithDictionary:dict];
				
				if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
					[weakSelf.delegate requestSuccess:weakSelf method:queryPromotionList];
				}
			} else {
				weakSelf.errorMsg = [dict objectForKey:@"resultMsg"];
				if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
					[weakSelf.delegate requestFailure:weakSelf method:queryPromotionList];
				}
			}
		} else {
			weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
			weakSelf.resultCode = [res objectForKey:@"resultCode"];
			if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
				[weakSelf.delegate requestFailure:weakSelf method:queryPromotionList];
			}
		}
	}];
}
@end
