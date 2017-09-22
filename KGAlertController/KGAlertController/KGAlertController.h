//
//  KGAlertController.h
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGAlertAction.h"

typedef NS_ENUM(NSInteger, KGAlertControllerStyle) {
    KGAlertControllerStyleActionSheet = 0,
    KGAlertControllerStyleAlert
};

typedef void(^KGTextFieldConfigurationHandler)(UITextField *textField);

// UIAlertController

@interface KGAlertController : UIViewController

@property (nonatomic, readwrite, strong) UIImage *headerImage;
@property (nonatomic, readwrite, copy) NSAttributedString *attributedTitle;
@property (nonatomic, readwrite, copy) NSAttributedString *attributedMessage;
@property (nonatomic, readwrite, assign) KGAlertControllerStyle preferredStyle;
@property (nonatomic, readwrite, assign) BOOL dimBackground;
@property (nonatomic, readwrite, assign) BOOL showBackgroundImage;
@property (nonatomic, readwrite, assign) BOOL hiddenContentView;


+ (instancetype)alertControllerWithTitle:(NSAttributedString *)title
                                 message:(NSAttributedString *)message
                          preferredStyle:(KGAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithImage:(UIImage *)image
                                   title:(NSAttributedString *)title
                                 message:(NSAttributedString *)message
                          preferredStyle:(KGAlertControllerStyle)preferredStyle;


- (void)addAction:(KGAlertAction *)action;

- (void)addTextFieldWithConfigurationHandler:(KGTextFieldConfigurationHandler)configurationHandler;
- (UITextField *)textFieldAtIndex:(NSInteger)index;
- (void)show;
- (void)dismiss;
@end

