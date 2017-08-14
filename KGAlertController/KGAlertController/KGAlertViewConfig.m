//
//  KGAlertViewConfig.m
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import "KGAlertViewConfig.h"

@implementation KGAlertViewConfig
+ (instancetype)sharedConfig {
    static KGAlertViewConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}
@end
