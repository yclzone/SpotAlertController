//
//  KGAlertViewConfig.h
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGAlertViewConfig : NSObject

+ (instancetype)sharedConfig;

@property (nonatomic, readwrite, strong) UIFont *titleFont;
@property (nonatomic, readwrite, strong) UIColor *titleColor;

@property (nonatomic, readwrite, strong) UIFont *messageFount;
@property (nonatomic, readwrite, strong) UIColor *messageColor;

@end
