//
//  KGAlertAction.h
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GOGO VAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KGAlertAction;

typedef void(^KGAlertActionHandler)(KGAlertAction *action);

@interface KGAlertAction : NSObject

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) KGAlertActionHandler actionHandler;

+ (instancetype)actionWithTitle:(NSString *)title handler:(KGAlertActionHandler)handler;

@end
