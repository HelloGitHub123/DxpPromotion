//
//  DxpPromotionAlertView.m
//  DxpPromotion
//
//  Created by 李标 on 2026/3/7.
//

#import "DxpPromotionAlertView.h"
#import <UIKit/UIKit.h>
@import Masonry;
#import <WebKit/WebKit.h>
#import <SDWebImage/SDWebImage.h>
#import "DxpPromotionModel.h"

#pragma mark - 常量

/// 弹框左右边距默认值（取自 margin.horizontal）
static CGFloat const kDefaultHorizontalMargin = 16.0f;
/// 背景遮罩透明度默认值（取自 backdrop.percent/100）
static CGFloat const kDefaultBackdropAlpha = 0.6f;
/// 关闭按钮距离弹框底部的间距
static CGFloat const kCloseButtonTopOffset = 30.0f;
/// 主/次按钮高度
static CGFloat const kButtonHeight = 44.0f;
/// 主/次按钮之间的间距
static CGFloat const kButtonSpacing = 12.0f;
/// 按钮容器内边距
static CGFloat const kButtonContainerPadding = 16.0f;

#pragma mark - 私有属性

@interface DxpPromotionAlertView ()

@property (nonatomic, strong) UIView *backdropView;           ///< 背景遮罩，支持点击关闭
@property (nonatomic, strong) UIView *dialogContainerView;     ///< 弹框容器
@property (nonatomic, strong) WKWebView *webView;              ///< WebView（creativeType=2 时展示）
@property (nonatomic, strong) UIImageView *imageView;         ///< 图片视图（creativeType≠2 时展示）
@property (nonatomic, strong) UIButton *closeButton;           ///< 关闭按钮，位于弹框下方
@property (nonatomic, strong) UIView *buttonContainerView;    ///< 主/次按钮容器
@property (nonatomic, strong) UIButton *primaryButton;         ///< 主按钮
@property (nonatomic, strong) UIButton *secondaryButton;      ///< 次按钮

@end

@implementation DxpPromotionAlertView

#pragma mark - 生命周期

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - 懒加载

- (UIView *)backdropView {
    if (!_backdropView) {
        _backdropView = [[UIView alloc] init];
        _backdropView.backgroundColor = [UIColor blackColor];
        _backdropView.alpha = kDefaultBackdropAlpha;
        [self addSubview:_backdropView];
        UITapGestureRecognizer *backdropTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backdropTapped)];
        [_backdropView addGestureRecognizer:backdropTap];
    }
    return _backdropView;
}

- (UIView *)dialogContainerView {
    if (!_dialogContainerView) {
        _dialogContainerView = [[UIView alloc] init];
        _dialogContainerView.backgroundColor = [UIColor whiteColor];
        _dialogContainerView.layer.cornerRadius = 0;
        _dialogContainerView.clipsToBounds = YES;
        [self addSubview:_dialogContainerView];
    }
    return _dialogContainerView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[[WKWebViewConfiguration alloc] init]];
        _webView.hidden = YES;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.dialogContainerView addSubview:_webView];
    }
    return _webView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.hidden = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
        [self.dialogContainerView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"×" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightLight];
        _closeButton.hidden = YES;
        [_closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return _closeButton;
}

- (UIView *)buttonContainerView {
    if (!_buttonContainerView) {
        _buttonContainerView = [[UIView alloc] init];
        _buttonContainerView.backgroundColor = [UIColor clearColor];
        [self.dialogContainerView addSubview:_buttonContainerView];
    }
    return _buttonContainerView;
}

- (UIButton *)primaryButton {
    if (!_primaryButton) {
        _primaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_primaryButton addTarget:self action:@selector(primaryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainerView addSubview:_primaryButton];
    }
    return _primaryButton;
}

- (UIButton *)secondaryButton {
    if (!_secondaryButton) {
        _secondaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secondaryButton addTarget:self action:@selector(secondaryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainerView addSubview:_secondaryButton];
    }
    return _secondaryButton;
}

#pragma mark - 布局 (Masonry)

- (void)updateConstraints {
    [super updateConstraints];
    
    if (!_promotionInfo || !_promotionInfo.mktCreativeInfo.popup.appFrame) {
        return;
    }
    
    // 弹框左右边距，取自 appFrame.style.margin.horizontal，默认 16
    CGFloat horizontalMargin = [self horizontalMargin];
    
    [self.backdropView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 弹框最大高度，取自 appFrame.style.maxHeightPercent
    CGFloat maxHeight = [UIScreen mainScreen].bounds.size.height * 0.8;
    AppFrameStyle *style = _promotionInfo.mktCreativeInfo.popup.appFrame.style;
    if (style && style.maxHeightPercent.length > 0) {
        CGFloat percent = [style.maxHeightPercent floatValue] / 100.0f;
        maxHeight = [UIScreen mainScreen].bounds.size.height * percent;
    }
    
    CGFloat defaultHeight = MIN(400, maxHeight);
    
    [self.dialogContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(horizontalMargin);
        make.right.mas_equalTo(-horizontalMargin);
        make.height.mas_equalTo(defaultHeight);
    }];
    
    // 按钮区域高度：inline 单行 / 双行堆叠 / 无按钮
    BOOL hasButtons = [self hasButtons];
    Button *buttonConfig = hasButtons ? _promotionInfo.mktCreativeInfo.popup.button : nil;
    BOOL isInline = buttonConfig && [[buttonConfig.arrangement lowercaseString] isEqualToString:@"inline"];
    BOOL hasBoth = buttonConfig && buttonConfig.primaryButton && buttonConfig.secondaryButton && buttonConfig.primaryButton.text.length > 0 && buttonConfig.secondaryButton.text.length > 0;
    CGFloat buttonContainerHeight;
    if (hasButtons) {
        if (isInline && hasBoth) {
            buttonContainerHeight = kButtonHeight + 2 * kButtonContainerPadding;
        } else if (hasBoth) {
            buttonContainerHeight = 2 * kButtonHeight + kButtonSpacing + 2 * kButtonContainerPadding;
        } else {
            buttonContainerHeight = kButtonHeight + 2 * kButtonContainerPadding;
        }
    } else {
        buttonContainerHeight = 0;
    }
    
    [self.buttonContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(buttonContainerHeight);
    }];
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.buttonContainerView.mas_top);
    }];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.buttonContainerView.mas_top);
    }];
    
    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.dialogContainerView.mas_bottom).offset(kCloseButtonTopOffset);
        make.width.height.mas_equalTo(44);
    }];
    
    if (hasButtons) {
        [self updateButtonConstraints];
    }
}

/// 根据 button.layout 和 button.arrangement 更新按钮约束
/// layout: autoRight 居右 | autoMiddle 居中 | autoLeft 居左 | fullWidth 全宽
/// arrangement: inline 一行 | 其他 上下两行
- (void)updateButtonConstraints {
    Button *buttonConfig = _promotionInfo.mktCreativeInfo.popup.button;
    if (!buttonConfig) return;
    
    NSString *layout = [buttonConfig.layout lowercaseString];
    BOOL isInline = [[buttonConfig.arrangement lowercaseString] isEqualToString:@"inline"];
    BOOL hasPrimary = buttonConfig.primaryButton && buttonConfig.primaryButton.text.length > 0;
    BOOL hasSecondary = buttonConfig.secondaryButton && buttonConfig.secondaryButton.text.length > 0;
    BOOL fullWidth = [layout isEqualToString:@"fullwidth"];
    
    CGFloat padding = kButtonContainerPadding;
    
    if (isInline && hasPrimary && hasSecondary) {
        if (fullWidth) {
            [self.primaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(padding);
                make.bottom.mas_equalTo(-padding);
                make.left.mas_equalTo(padding);
                make.height.mas_equalTo(kButtonHeight);
            }];
            [self.secondaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self.primaryButton);
                make.left.mas_equalTo(self.primaryButton.mas_right).offset(kButtonSpacing);
                make.right.mas_equalTo(-padding);
                make.width.mas_equalTo(self.primaryButton);
            }];
        } else {
            if ([layout isEqualToString:@"autoright"]) {
                [self.secondaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(padding);
                    make.right.mas_equalTo(-padding);
                    make.bottom.mas_equalTo(-padding);
                    make.height.mas_equalTo(kButtonHeight);
                }];
                [self.primaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(self.secondaryButton);
                    make.right.mas_equalTo(self.secondaryButton.mas_left).offset(-kButtonSpacing);
                }];
            } else if ([layout isEqualToString:@"automiddle"]) {
                [self.primaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.buttonContainerView.mas_centerX).offset(-kButtonSpacing/2);
                    make.centerY.mas_equalTo(0);
                    make.top.mas_equalTo(padding);
                    make.bottom.mas_equalTo(-padding);
                    make.height.mas_equalTo(kButtonHeight);
                }];
                [self.secondaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.buttonContainerView.mas_centerX).offset(kButtonSpacing/2);
                    make.centerY.mas_equalTo(0);
                    make.top.bottom.mas_equalTo(self.primaryButton);
                    make.height.mas_equalTo(kButtonHeight);
                }];
            } else {
                [self.primaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(padding);
                    make.left.mas_equalTo(padding);
                    make.bottom.mas_equalTo(-padding);
                    make.height.mas_equalTo(kButtonHeight);
                }];
                [self.secondaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(self.primaryButton);
                    make.left.mas_equalTo(self.primaryButton.mas_right).offset(kButtonSpacing);
                }];
            }
        }
    } else if (hasPrimary && hasSecondary) {
        [self.primaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(padding);
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(-padding);
            make.height.mas_equalTo(kButtonHeight);
        }];
        [self.secondaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.primaryButton.mas_bottom).offset(kButtonSpacing);
            make.bottom.mas_equalTo(-padding);
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(-padding);
            make.height.mas_equalTo(kButtonHeight);
        }];
    } else if (hasPrimary) {
        if (fullWidth) {
            [self.primaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(padding, padding, padding, padding));
                make.height.mas_equalTo(kButtonHeight);
            }];
        } else if ([layout isEqualToString:@"autoright"]) {
            [self.primaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(padding);
                make.right.mas_equalTo(-padding);
                make.bottom.mas_equalTo(-padding);
                make.height.mas_equalTo(kButtonHeight);
            }];
        } else if ([layout isEqualToString:@"automiddle"]) {
            [self.primaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(padding);
                make.bottom.mas_equalTo(-padding);
                make.height.mas_equalTo(kButtonHeight);
            }];
        } else {
            [self.primaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(padding);
                make.left.mas_equalTo(padding);
                make.bottom.mas_equalTo(-padding);
                make.height.mas_equalTo(kButtonHeight);
            }];
        }
    } else if (hasSecondary) {
        if (fullWidth) {
            [self.secondaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(padding, padding, padding, padding));
                make.height.mas_equalTo(kButtonHeight);
            }];
        } else if ([layout isEqualToString:@"autoright"]) {
            [self.secondaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(padding);
                make.right.mas_equalTo(-padding);
                make.bottom.mas_equalTo(-padding);
                make.height.mas_equalTo(kButtonHeight);
            }];
        } else if ([layout isEqualToString:@"automiddle"]) {
            [self.secondaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(padding);
                make.bottom.mas_equalTo(-padding);
                make.height.mas_equalTo(kButtonHeight);
            }];
        } else {
            [self.secondaryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(padding);
                make.left.mas_equalTo(padding);
                make.bottom.mas_equalTo(-padding);
                make.height.mas_equalTo(kButtonHeight);
            }];
        }
    }
}

#pragma mark - 公开方法

- (void)show {
    if (!_promotionInfo || !_promotionInfo.mktCreativeInfo) {
        return;
    }
    
    [self applyStyle];
    [self setupContent];
    [self setupButtons];
    [self setupCloseButton];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    if (!self.superview) {
        UIWindow *keyWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in scene.windows) {
                        if (window.isKeyWindow) {
                            keyWindow = window;
                            break;
                        }
                    }
                    if (keyWindow) break;
                }
            }
        }
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }
        if (keyWindow) {
            self.frame = keyWindow.bounds;
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [keyWindow addSubview:self];
        }
    }
    
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 私有方法

/// 弹框左右边距，取自 margin.horizontal，默认 16
- (CGFloat)horizontalMargin {
    Margin *margin = _promotionInfo.mktCreativeInfo.popup.appFrame.style.margin;
    if (margin && margin.horizontal.length > 0) {
        return [margin.horizontal floatValue];
    }
    return kDefaultHorizontalMargin;
}

/// 应用弹框样式：背景遮罩颜色/透明度、弹框背景色/圆角
- (void)applyStyle {
    AppFrame *appFrame = _promotionInfo.mktCreativeInfo.popup.appFrame;
    if (!appFrame || !appFrame.style) return;
    
    AppFrameStyle *style = appFrame.style;
    
    // 背景遮罩：backdrop.color、backdrop.percent
    Backdrop *backdrop = style.backdrop;
    if (backdrop) {
        if (backdrop.color.length > 0) {
            self.backdropView.backgroundColor = [self colorFromHexString:backdrop.color];
        }
        if (backdrop.percent.length > 0) {
            self.backdropView.alpha = [backdrop.percent floatValue] / 100.0f;
        } else {
            self.backdropView.alpha = kDefaultBackdropAlpha;
        }
    } else {
        self.backdropView.backgroundColor = [UIColor blackColor];
        self.backdropView.alpha = kDefaultBackdropAlpha;
    }
    
    // 弹框背景：background.color、background.corner
    Background *background = style.background;
    if (background) {
        if (background.color.length > 0) {
            self.dialogContainerView.backgroundColor = [self colorFromHexString:background.color];
        } else {
            self.dialogContainerView.backgroundColor = [UIColor whiteColor];
        }
        if (background.corner.length > 0) {
            self.dialogContainerView.layer.cornerRadius = [background.corner floatValue];
        }
    } else {
        self.dialogContainerView.backgroundColor = [UIColor whiteColor];
    }
}

/// 设置内容区域：creativeType=2 用 WebView，否则用图片
- (void)setupContent {
    BOOL isWebView = [_promotionInfo.creativeType isEqualToString:@"2"];
    
    if (isWebView) {
        self.webView.hidden = NO;
        self.imageView.hidden = YES;
        
        NSString *serverUrl = _promotionInfo.mktCreativeInfo.serverUrl ?: _promotionInfo.webURL ?: @"";
        NSString *creativeCode = _promotionInfo.mktCreativeInfo.creativeCode ?: @"";
        NSString *separator = [serverUrl containsString:@"?"] ? @"&" : @"?";
        NSString *urlString = [NSString stringWithFormat:@"%@%@code=%@&source=APP", serverUrl, separator, creativeCode];
        NSURL *url = [NSURL URLWithString:urlString];
        if (url) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    } else {
        self.webView.hidden = YES;
        self.imageView.hidden = NO;
        
        NSString *thumbnail = _promotionInfo.mktCreativeInfo.thumbnail;
        if (thumbnail.length > 0) {
            NSURL *imageUrl = [NSURL URLWithString:thumbnail];
            if (imageUrl) {
                [self.imageView sd_setImageWithURL:imageUrl placeholderImage:nil];
            }
        }
    }
}

/// 是否存在主/次按钮
- (BOOL)hasButtons {
    Button *buttonConfig = _promotionInfo.mktCreativeInfo.popup.button;
    if (!buttonConfig) return NO;
    BOOL hasPrimary = buttonConfig.primaryButton && buttonConfig.primaryButton.text.length > 0;
    BOOL hasSecondary = buttonConfig.secondaryButton && buttonConfig.secondaryButton.text.length > 0;
    return hasPrimary || hasSecondary;
}

/// 配置主/次按钮：文案、样式（ButtonStyle）
- (void)setupButtons {
    Button *buttonConfig = _promotionInfo.mktCreativeInfo.popup.button;
    if (!buttonConfig) {
        self.buttonContainerView.hidden = YES;
        return;
    }
    
    BOOL hasPrimary = buttonConfig.primaryButton && buttonConfig.primaryButton.text.length > 0;
    BOOL hasSecondary = buttonConfig.secondaryButton && buttonConfig.secondaryButton.text.length > 0;
    
    if (!hasPrimary && !hasSecondary) {
        self.buttonContainerView.hidden = YES;
        return;
    }
    
    self.buttonContainerView.hidden = NO;
    
    if (hasPrimary) {
        PrimaryButton *pb = buttonConfig.primaryButton;
        [self.primaryButton setTitle:pb.text forState:UIControlStateNormal];
        [self applyButtonStyle:pb.style toButton:self.primaryButton];
        self.primaryButton.hidden = NO;
    } else {
        self.primaryButton.hidden = YES;
    }
    
    if (hasSecondary) {
        SecondaryButton *sb = buttonConfig.secondaryButton;
        [self.secondaryButton setTitle:sb.text forState:UIControlStateNormal];
        [self applyButtonStyle:sb.style toButton:self.secondaryButton];
        self.secondaryButton.hidden = NO;
    } else {
        self.secondaryButton.hidden = YES;
    }
}

/// 应用按钮样式：filledColor、buttonCorner、borderStyle、fontStyle
- (void)applyButtonStyle:(ButtonStyle *)style toButton:(UIButton *)button {
    if (!style) return;
    
    if (style.filledColor.length > 0) {
        button.backgroundColor = [self colorFromHexString:style.filledColor];
    } else {
        button.backgroundColor = [UIColor clearColor];
    }
    
    if (style.buttonCorner.length > 0) {
        button.layer.cornerRadius = [style.buttonCorner floatValue];
        button.clipsToBounds = YES;
    }
    
    if (style.borderStyle) {
        if (style.borderStyle.color.length > 0) {
            button.layer.borderColor = [self colorFromHexString:style.borderStyle.color].CGColor;
        }
        if (style.borderStyle.width.length > 0) {
            button.layer.borderWidth = [style.borderStyle.width floatValue];
        }
    }
    
    if (style.fontStyle) {
        CGFloat fontSize = 16;
        if (style.fontStyle.size.length > 0) {
            fontSize = [style.fontStyle.size floatValue];
        }
        UIFontWeight weight = UIFontWeightRegular;
        if (style.fontStyle.bold.length > 0 && ([style.fontStyle.bold boolValue] || [style.fontStyle.bold isEqualToString:@"true"])) {
            weight = UIFontWeightBold;
        }
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:weight];
        if (style.fontStyle.color.length > 0) {
            [button setTitleColor:[self colorFromHexString:style.fontStyle.color] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

- (void)primaryButtonTapped {
    Button *btn = _promotionInfo.mktCreativeInfo.popup.button;
    PrimaryButton *pb = btn.primaryButton;
    if (_primaryButtonBlock && pb) {
        _primaryButtonBlock(pb.action, pb.openType, pb.link);
    }
}

- (void)secondaryButtonTapped {
    Button *btn = _promotionInfo.mktCreativeInfo.popup.button;
    SecondaryButton *sb = btn.secondaryButton;
    if (_secondaryButtonBlock && sb) {
        _secondaryButtonBlock(sb.action, sb.openType, sb.link);
    }
}

/// 配置关闭按钮：是否显示（closeButton.enabled）、样式（dismissStyle）
- (void)setupCloseButton {
    BOOL showClose = NO;
    Popup *popup = _promotionInfo.mktCreativeInfo.popup;
    Dismissal *dismissal = popup ? popup.dismissal : nil;
    CloseButton *closeButton = dismissal ? dismissal.closeButton : nil;
    if (closeButton && closeButton.enabled.length > 0) {
        showClose = [closeButton.enabled boolValue] || [closeButton.enabled isEqualToString:@"true"];
    }
    
    if (showClose && closeButton.dismissStyle) {
        if (closeButton.dismissStyle.color.length > 0) {
            [self.closeButton setTitleColor:[self colorFromHexString:closeButton.dismissStyle.color] forState:UIControlStateNormal];
        }
        if (closeButton.dismissStyle.size.length > 0) {
            self.closeButton.titleLabel.font = [UIFont systemFontOfSize:[closeButton.dismissStyle.size floatValue] weight:UIFontWeightLight];
        }
    }
    
    self.closeButton.hidden = !showClose;
}

/// 点击背景遮罩，若 closeOnBackdrop=true 则关闭
- (void)backdropTapped {
    Popup *popup = _promotionInfo.mktCreativeInfo.popup;
    if (!popup) return;
    
    Dismissal *dismissal = popup.dismissal;
    BOOL closeOnBackdrop = NO;
    if (dismissal && dismissal.closeOnBackdrop.length > 0) {
        closeOnBackdrop = [dismissal.closeOnBackdrop boolValue] || [dismissal.closeOnBackdrop isEqualToString:@"true"];
    }
    
    if (closeOnBackdrop) {
        [self dismissWithAction:dismissal.action];
    }
}

- (void)closeButtonTapped {
    NSString *action = nil;
    if (_promotionInfo.mktCreativeInfo.popup.dismissal) {
        action = _promotionInfo.mktCreativeInfo.popup.dismissal.action;
    }
    [self dismissWithAction:action];
}

/// 关闭弹框并回调 closeBlock
- (void)dismissWithAction:(NSString *)action {
    if (_closeBlock) {
        _closeBlock(action);
    }
    [self dismiss];
}

/// 将十六进制颜色字符串转为 UIColor，支持 #RGB、#RRGGBB、#RRGGBBAA
- (UIColor *)colorFromHexString:(NSString *)hexString {
    if (!hexString || hexString.length == 0) {
        return [UIColor blackColor];
    }
    
    NSString *clean = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([clean hasPrefix:@"#"]) {
        clean = [clean substringFromIndex:1];
    }
    
    unsigned int r = 0, g = 0, b = 0, a = 255;
    
    if (clean.length == 6) {
        sscanf([clean UTF8String], "%02x%02x%02x", &r, &g, &b);
    } else if (clean.length == 8) {
        sscanf([clean UTF8String], "%02x%02x%02x%02x", &r, &g, &b, &a);
    } else if (clean.length == 3) {
        unsigned int rr, gg, bb;
        sscanf([clean UTF8String], "%1x%1x%1x", &rr, &gg, &bb);
        r = rr * 17; g = gg * 17; b = bb * 17;
    }
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}

@end
