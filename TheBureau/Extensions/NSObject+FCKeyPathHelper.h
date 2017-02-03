//
//  NSObject+KeyPathHelper.h
//  SkrillPayments
//
//  Created by Ashish Awaghad on 7/1/15.
//  Copyright (c) 2015 Mubaloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FCKeyPathHelper)

- (id)valueForKeyPathFC:(NSString *)keyPath;

@end
