//
//  KGAlertView.h
//  KGAlertController
//
//  Created by gogovan on 22/09/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KGAlertAction;

static CGFloat const MARGIN = 30;
static CGFloat const TEXT_MARGIN = 10;
static CGFloat const ACTION_FIELD_HEIGHT = 40;
static CGFloat const ACTION_BUTTON_HEIGHT = 45;
static CGFloat const ACTION_BUTTON_SPACE = 10;
static CGFloat const CONTENTVIEW_WIDTH = 285;

typedef void(^KGAlertViewHandler)(void);

@interface KGAlertView : UIView
@property (nonatomic, readwrite, strong) UIImage *headerImage;
@property (nonatomic, readwrite, copy) NSAttributedString *attributedTitle;
@property (nonatomic, readwrite, copy) NSAttributedString *attributedMessage;

@property (nonatomic, strong) NSMutableArray<KGAlertAction *> *actions;
@property (nonatomic, strong) NSMutableArray<UITextField *> *textFields;

@property (nonatomic, readwrite, copy) KGAlertViewHandler handler;


- (void)setupLayout;
@end
