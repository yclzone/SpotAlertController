//
//  KGAlertAction.h
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KGAlertActionStyle) {
    KGAlertActionStyleDefault = 0,
    KGAlertActionStyleCancel,
    KGAlertActionStyleDestructive
};

@class KGAlertAction;

//UIAlertAction

typedef void(^KGAlertActionHandler)(KGAlertAction *action);

@interface KGAlertAction : NSObject

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, assign) KGAlertActionStyle actionStyle;
@property (nonatomic, readwrite, copy) KGAlertActionHandler actionHandler;

+ (instancetype)actionWithTitle:(NSString *)title handler:(KGAlertActionHandler)handler;

@end
