//
//  KGAlertAction.m
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import "KGAlertAction.h"

@implementation KGAlertAction
+ (instancetype)actionWithTitle:(NSString *)title style:(KGAlertActionStyle)style handler:(KGAlertActionHandler)handler {
    KGAlertAction *action = [KGAlertAction new];
    action.title = title;
    action.actionStyle = style;
    action.actionHandler = handler;
    return action;
}
@end
