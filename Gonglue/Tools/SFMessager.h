//
//  SFMessager.h
//  Gonglue
//
//  Created by jiajun on 1/13/13.
//  Copyright (c) 2013 Gonglue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFMessager : NSObject

+ (void)addMessage:(NSString *)message forKey:(NSString *)key;
+ (NSString *)messageForKey:(NSString *)key;

@end
