//
//  DxpPromotionModel.m
//  DxpPromotion
//
//  Created by 李标 on 2026/3/7.
//

#import "DxpPromotionModel.h"

@implementation DxpPromotionModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
	return @{
		@"data" : [DxpPromotionItem class]
	};
}
@end


@implementation DxpPromotionItem;

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
	return @{
		@"recommendedWordsList" : [RecommendedWordsItem class]
	};
}

@end


@implementation RecommendedWordsItem
@end

@implementation Popup
@end

@implementation AppFrame
@end

@implementation AppFrameStyle
@end

@implementation Margin
@end

@implementation Background
@end

@implementation Backdrop
@end

@implementation Border
@end

@implementation WebFrame
@end

@implementation Title
@end

@implementation ContentStyle
@end

@implementation Message
@end

@implementation Media
@end

@implementation MediaStyle
@end

@implementation Padding
@end

@implementation Button
@end

@implementation PrimaryButton
@end

@implementation ButtonStyle
@end

@implementation FontStyle
@end

@implementation BorderStyle
@end

@implementation SecondaryButton
@end

@implementation Dismissal
@end

@implementation CloseButton
@end

@implementation CountDown
@end

@implementation DismissStyle
@end
