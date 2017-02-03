//
//  NSObject+KeyPathHelper.m
//  SkrillPayments
//
//  Created by Ashish Awaghad on 7/1/15.
//  Copyright (c) 2015 Mubaloo. All rights reserved.
//

#import "NSObject+FCKeyPathHelper.h"

@implementation NSObject (FCKeyPathHelper)

- (id)valueForKeyPathFC:(NSString *)keyPath
{
    @try {
        id obj = [self valueForKeyPath:keyPath];
        
        if (!obj || obj == [NSNull null]) {
            return nil;
        }
        
        return obj;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return nil;
}

@end
