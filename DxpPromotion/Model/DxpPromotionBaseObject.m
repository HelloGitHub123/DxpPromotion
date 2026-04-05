//
//  DxpPromotionBaseObject.m
//  DxpPromotionSDK
//
//  Created by 李标 on 2025/11/2.
//

#import "DxpPromotionBaseObject.h"

@implementation DxpPromotionBaseObject

- (instancetype)initWithJSON:(NSDictionary *)json {
	NSAssert(false, @"Over ride in subclasses");
	return nil;
}

- (NSString *)debugDescription {
	return [NSString stringWithFormat:@"<%@: %p\n%@\n>", NSStringFromClass([self class]), self, [self jsonRepresentation]];
}

- (NSDictionary *)jsonRepresentation {
	return nil;
}

- (NSString *)jsonString {
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self jsonRepresentation]
													   options:NSJSONWritingPrettyPrinted
														 error:&error];
	if (error) {
		return @"";
	} else {
		return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	}
}

- (id)checkForNull:(id)value {
	return value == [NSNull null] ? nil : value;
}


- (id)checkNumForNull:(id)value{
	
	if ([value isKindOfClass:[NSNull class]]){
		
		return 0;
	}
	return value;
}

- (id)copyWithZone:(NSZone *)zone {
	return [self copyWithZone:zone];
}

@end
