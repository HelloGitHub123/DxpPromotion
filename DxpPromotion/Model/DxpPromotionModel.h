//
//  DxpPromotionModel.h
//  DxpPromotion
//
//  Created by 李标 on 2026/3/7.
//

#import <Foundation/Foundation.h>
#import "DxpPromotionBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@class DxpPromotionItem;
@class DxpPromotionItem;
@class RecommendedWordsItem;
@class Popup;
@class AppFrame;
@class AppFrameStyle;
@class Margin;
@class Background;
@class Backdrop;
@class Border;
@class WebFrame;
@class Title;
@class ContentStyle;
@class PopUpMessage;
@class Media;
@class MediaStyle;;
@class Padding;
@class Button;
@class PrimaryButton;
@class ButtonStyle;
@class FontStyle;
@class BorderStyle;
@class SecondaryButton;
@class Dismissal;
@class CloseButton;
@class CountDown;
@class DismissStyle;

@interface DxpPromotionModel : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, copy) NSArray <DxpPromotionItem *>*data;
@end



@interface DxpPromotionItem : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *subsId;
@property (nonatomic, copy) NSString *serviceNumber;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *adSlot;
@property (nonatomic, copy) NSString *batchCode;
@property (nonatomic, copy) NSString *contactId;
@property (nonatomic, copy) NSString *batchId;
@property (nonatomic, copy) NSString *campaignCode;
@property (nonatomic, copy) NSString *campaignName;
@property (nonatomic, copy) NSString *campaignDescription;
@property (nonatomic, copy) NSString *campaignPriority;
@property (nonatomic, copy) NSString *projectCode;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *modelCode;
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, strong) NSArray <RecommendedWordsItem *>*recommendedWordsList;
@end


@interface RecommendedWordsItem : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *recommendedWordsType;
@property (nonatomic, copy) NSString *recommendedTitle;
@property (nonatomic, copy) NSString *recommendedSubTitle;
@property (nonatomic, copy) NSString *recommendedWords;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *clickAction;
@property (nonatomic, copy) NSString *jumpLink;
@property (nonatomic, copy) NSString *linkType;
@property (nonatomic, copy) NSString *serverUrl;
@property (nonatomic, copy) NSString *showCloseButton;
@property (nonatomic, copy) NSString *creativeType;
@property (nonatomic, copy) NSString *creativeCode;
@property (nonatomic, copy) NSString *popupPageUrl;

@property (nonatomic, strong) Popup *popup;
@end


@interface Popup : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *popupType;
@property (nonatomic, strong) AppFrame *appFrame;
@property (nonatomic, strong) WebFrame *webFrame;
@property (nonatomic, strong) Title *title;
@property (nonatomic, strong) PopUpMessage *message;
@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) Button *button;
@property (nonatomic, strong) Dismissal *dismissal;
@end


@interface AppFrame : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *layout;
@property (nonatomic, strong) AppFrameStyle *style;
@end


@interface AppFrameStyle : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *layout;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *maxHeightPercent;
@property (nonatomic, strong) Margin *margin;
@property (nonatomic, strong) Background *background;
@property (nonatomic, strong) Backdrop *backdrop;
@property (nonatomic, strong) Border *border;
@end

@interface Margin : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *horizontal;
@property (nonatomic, copy) NSString *vertical;
@property (nonatomic, copy) NSString *minTopPercent;
@end

@interface Background : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *percent;
@property (nonatomic, copy) NSString *corner;
@property (nonatomic, copy) NSString *url;
@end

@interface Backdrop : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *percent;
@end

@interface Border : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *line;
@property (nonatomic, copy) NSString *percent;
@end

@interface WebFrame : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *layout;
@property (nonatomic, strong) AppFrameStyle *style;
@end

@interface Title : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) ContentStyle *style;
@end

@interface ContentStyle : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *bold;
@property (nonatomic, copy) NSString *italic;
@property (nonatomic, copy) NSString *underline;
@property (nonatomic, copy) NSString *position;
@end

@interface PopUpMessage : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) ContentStyle *style;
@end

@interface Media : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *mediaType;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *openType;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, strong) MediaStyle *style;
@end

@interface MediaStyle : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *position;
@property (nonatomic, strong) Padding *padding;
@end


@interface Padding : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *left;
@property (nonatomic, copy) NSString *right;
@property (nonatomic, copy) NSString *top;
@property (nonatomic, copy) NSString *bottom;
@end


@interface Button : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *layout;
@property (nonatomic, copy) NSString *minWidth;
@property (nonatomic, copy) NSString *arrangement;
@property (nonatomic, strong) PrimaryButton *primaryButton;
@property (nonatomic, strong) SecondaryButton *secondaryButton;
@end


@interface PrimaryButton : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *text;;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *openType;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, strong) ButtonStyle *style;
@end



@interface ButtonStyle : DxpPromotionBaseObject

@property (nonatomic, strong) FontStyle *fontStyle;
@property (nonatomic, copy) NSString *buttonStyle;
@property (nonatomic, strong) BorderStyle *borderStyle;
@property (nonatomic, copy) NSString *buttonCorner;
@property (nonatomic, copy) NSString *filledColor;
@end


@interface FontStyle : DxpPromotionBaseObject
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *bold;
@property (nonatomic, copy) NSString *italic;
@property (nonatomic, copy) NSString *underline;

@end

@interface BorderStyle : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *line;
@property (nonatomic, copy) NSString *width;
@end

@interface SecondaryButton : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *text;;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *openType;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, strong) ButtonStyle *style;
@end

@interface Dismissal : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *closeOnBackdrop;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, strong) CloseButton *closeButton;
@property (nonatomic, strong) CountDown *countDown;
@end


@interface CloseButton : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *enabled;
@property (nonatomic, strong) DismissStyle *dismissStyle;
@end

@interface CountDown : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *enabled;
@property (nonatomic, copy) NSString *seconds;
@property (nonatomic, strong) DismissStyle *dismissStyle;
@end

@interface DismissStyle : DxpPromotionBaseObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *size;
@end



NS_ASSUME_NONNULL_END
