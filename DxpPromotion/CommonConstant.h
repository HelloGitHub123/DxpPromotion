//
//  CommonConstant.h
//  DxpPromotion
//
//  Created by 李标 on 2026/3/7.
//

#ifndef CommonConstant_h
#define CommonConstant_h

//判断是否为空
#define objectOrNull(obj)        ((obj) ? (obj) : [NSNull null])
#define objectOrEmptyStr(obj)    ((obj) ? (obj) : @"")
#define isNull(x)                (!x || [x isKindOfClass:[NSNull class]])
#define toInt(x)                 (isNull(x) ? 0 : [x intValue])
#define isEmptyString(x)         (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"null"] || [x isEqual:@"<null>"])
#define IsNilOrNull(_ref)        (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

#endif /* CommonConstant_h */
