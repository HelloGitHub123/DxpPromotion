//
//  DxpPromotionBaseObject.h
//  DxpPromotionSDK
//
//  Created by 李标 on 2025/11/2.
//

#import <Foundation/Foundation.h>
#import "HJPromotionRequestProtocolForVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DxpPromotionBaseObject : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, strong) NSString *errorCode;

//将后台字典数据转化为对象
- (instancetype)initWithJSON:(NSDictionary *)json;
//拼装字典数据
- (NSDictionary *)jsonRepresentation;
//将字典数据转化为字符串
- (NSString *)jsonString;

- (id)checkForNull:(id)value;

- (id)checkNumForNull:(id)value;
@end

NS_ASSUME_NONNULL_END
