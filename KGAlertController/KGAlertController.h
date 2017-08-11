//
//  KGAlertController.h
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GOGO VAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGAlertAction.h"

@interface KGAlertController : UIViewController
- (void)showTitle:(NSString *)title message:(NSString *)message;

- (void)show;
- (void)addAction:(KGAlertAction *)action;
@end
