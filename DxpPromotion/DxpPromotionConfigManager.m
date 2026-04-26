//
//  DxpPromotionConfigManager.m
//  DxpPromotion
//
//  Created by 李标 on 2026/3/7.
//

#import "DxpPromotionConfigManager.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import "CommonConstant.h"
#import <YYModel/YYModel.h>
#import "DxpPromotionInfo.h"
#import "DxpPromotionAlertView.h"

static DxpPromotionConfigManager *manager = nil;

@interface DxpPromotionConfigManager ()

@property (nonatomic, copy) NSString *dxpUrl; // DXP 服务器地址
@property (nonatomic, copy) NSString *token;  // 用于 API 请求头
@property (nonatomic, copy) NSString *subsId; // 订户 ID
@property (nonatomic, copy) NSString *serviceNumber; // 服务号码
@property (nonatomic, strong) NSArray *excludePageNames; // 排除的页面名称

@property (nonatomic, strong) DxpPromotionModel *promotionModel; // 全量数据
@property (nonatomic, strong) NSMutableArray *promotionPageUrlArr; // 保存数据中所有页面的路由
@property (nonatomic, strong) NSMutableArray <DxpPromotionInfo *>*promotionInfoList; // 弹框集合
@end


@implementation DxpPromotionConfigManager

+ (instancetype)shareInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[DxpPromotionConfigManager alloc] init];
	});
	return manager;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		self.promotionInfoList = [[NSMutableArray alloc] init];
		self.promotionPageUrlArr = [[NSMutableArray alloc] init];
	}
	return self;
}

#pragma mark -- 配置
- (void)configureParamsWithUrl:(NSString *)dxpUrl token:(NSString *)token subsId:(NSString *)subsId serviceNumber:(NSString *)serviceNumber excludePageNames:(NSArray *)excludePageNames {
	
	self.dxpUrl = dxpUrl;
	self.token = token;
	self.subsId = subsId;
	self.serviceNumber = serviceNumber;
	self.excludePageNames = excludePageNames;
	
	[DCNetAPIClient sharedClient].baseUrl = dxpUrl;
	[DCNetAPIClient sharedClient].token = token;
	_subsId = subsId;
	_serviceNumber = serviceNumber;
	_excludePageNames = excludePageNames;
}

- (NSString *)dxpUrl {
	return _dxpUrl;
}

- (NSString *)token {
	return _token;
}

- (NSString *)subsId {
	return _subsId;
}

- (NSString *)serviceNumber {
	return _serviceNumber;
}

- (NSArray *)excludePageNames {
	return _excludePageNames;
}

#pragma mark -- 请求数据
- (void)requestPromotionData:(RequestPromotionDataCompletionBlock)completion {

	if (isEmptyString(self.dxpUrl)) {
		return;
	}
	
//	NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
//	[parmas setValue:self.subsId forKey:@"subsId"];
//	[parmas setValue:@"APP" forKey:@"channel"];
//	[parmas setValue:@"APP_POPUP" forKey:@"adSlot"];
//	[parmas setValue:self.serviceNumber forKey:@"serviceNumber"];
	
	NSString *path = @"/dxp/promotion-management/v1/promotions";
	NSString *url = [NSString stringWithFormat:@"%@?subsId=%@&channel=APP&adSlot=APP_POPUP",path,self.subsId];
	
	__weak __typeof(&*self)weakSelf = self;
	
//	url = @"http://10.10.178.35:11204/mockApi/jGeabfh610ca319b3f3afb04a2f4990247b9e7c78154002/dxp/promotion-management/v1/promotions?responseId=7081";
	
	[[DCNetAPIClient sharedClient] GET:url paramaters:@{} CompleteBlock:^(id res, NSError *error) {
		NSDictionary *dict = (NSDictionary *)res;
		if (!error) {
			NSString *resultCode = [dict valueForKey:@"resultCode"];
			if ([resultCode isEqualToString:@"0"]) {
				DxpPromotionModel *promotionModel = [DxpPromotionModel yy_modelWithDictionary:dict];
				// 原始数据
				weakSelf.promotionModel = promotionModel;
				// 解析数据
				[weakSelf parserPromotionData:completion];
//				dispatch_async(dispatch_get_main_queue(), ^{
//					completion(YES, promotionModel, @"", @"200");
//				});
			} else {
				NSString *errorMsg = [dict valueForKey:@"resultMsg"];
				dispatch_async(dispatch_get_main_queue(), ^{
					completion(NO, @[],errorMsg, resultCode);
				});
			}
		} else {
			NSString *errorMsg = [dict valueForKey:@"resultMsg"];
			NSString *resultCode = [dict valueForKey:@"resultCode"];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(NO, @[] ,errorMsg, resultCode);
			});
		}
	}];
}

#pragma mark -- 解析数据
- (void)parserPromotionData:(RequestPromotionDataCompletionBlock)completion {
	if (IsArrEmpty(self.promotionModel.data)) {
		return;
	}
	// 根据页面，剔除数据
	//	NSMutableArray *
	for (DxpPromotionItem *mktContactDto in self.promotionModel.data) {
		if (!IsArrEmpty(mktContactDto.recommendedWordsList)) {
			RecommendedWordsItem *recommendedWordsItem =[mktContactDto.recommendedWordsList objectAtIndex:0];
			NSString *pageUrl = recommendedWordsItem.popupPageUrl; // 弹框页面的路由
			if (!IsArrEmpty(self.excludePageNames)) {
				if ([self.excludePageNames containsObject:pageUrl]) {
					//剔除数据、把不需要显示的数据剔除
					continue;
				}
			}
			// 保存页面路由
//			[self.promotionPageUrlArr addObject:pageUrl];
			// 构建数据
			DxpPromotionInfo *promotionInfo = [[DxpPromotionInfo alloc] init];
			promotionInfo.batchId = mktContactDto.batchId;
			promotionInfo.transactionSn = mktContactDto.contactId;
			promotionInfo.campaignCode = mktContactDto.campaignCode;
			promotionInfo.mktCreativeInfo = [mktContactDto.recommendedWordsList objectAtIndex:0];
			promotionInfo.popupPageURL = pageUrl;
			
			// 判断是否是web
			if ([recommendedWordsItem.creativeType isEqualToString:@"2"]) {
				// web
				NSString *serverUrl = recommendedWordsItem.serverUrl;
				NSString *creativeCode = recommendedWordsItem.creativeCode;
				NSString *url = [NSString stringWithFormat:@"%@?code=%@&source=APP",serverUrl,creativeCode];
				
				promotionInfo.webURL = url;
				promotionInfo.creativeType = @"2";
			}
			[self.promotionInfoList addObject:promotionInfo];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(YES, self.promotionInfoList, @"", @"200");
			});
		}
	}
}

- (void)showPromotion:(NSString *)pageURL {
	[self showPromotion:pageURL showBlock:nil closeBlock:nil primaryButtonBlock:nil secondaryButtonBlock:nil];
}

- (void)showPromotion:(NSString *)pageURL
			showBlock:(nullable DxpPromotionAlertShowBlock)showBlock
		   closeBlock:(nullable DxpPromotionAlertCloseBlock)closeBlock
   primaryButtonBlock:(nullable DxpPromotionAlertButtonBlock)primaryButtonBlock
 secondaryButtonBlock:(nullable DxpPromotionAlertButtonBlock)secondaryButtonBlock {
	if (isEmptyString(pageURL)) {
		return;
	}
	DxpPromotionInfo *promotionInfo = [self.promotionInfoList objectAtIndex:0];
	
	DxpPromotionAlertView *alertView = [[DxpPromotionAlertView alloc] initWithFrame:CGRectZero];
	alertView.promotionInfo = promotionInfo;
	alertView.showBlock = showBlock;
	alertView.closeBlock = closeBlock;
	alertView.primaryButtonBlock = primaryButtonBlock;
	alertView.secondaryButtonBlock = secondaryButtonBlock;
	[alertView show];
	
	[self.promotionPageUrlArr removeObject:pageURL];
}


@end
