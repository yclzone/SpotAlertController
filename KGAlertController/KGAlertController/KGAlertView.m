//
//  KGAlertView.m
//  KGAlertController
//
//  Created by gogovan on 22/09/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import "KGAlertView.h"
#import "KGAlertAction.h"
#import <Masonry.h>



@interface KGAlertView ()
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *titleBanner;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *fieldsHolderView;
@property (nonatomic, strong) UIView *actionsHolderView;



@end

@implementation KGAlertView

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)setupViews {

    self.layer.cornerRadius = 6;
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleBanner = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.headerImage];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:imageView];
        imageView;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor darkTextColor];
        label.attributedText = self.attributedTitle;
        [self addSubview:label];
        label;
    });
    
    self.messageLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor grayColor];
        label.attributedText = self.attributedMessage;
        [self addSubview:label];
        label;
    });
    
    self.fieldsHolderView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        view;
    });
    
    self.actionsHolderView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        view;
    });
}

- (void)setupLayout {
    // 背景图片
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    // 标题图片
    [self.titleBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBanner.mas_bottom).offset(MARGIN);
        make.leading.equalTo(self).offset(TEXT_MARGIN);
        make.trailing.equalTo(self).offset(-TEXT_MARGIN);
    }];
    
    if (!self.attributedTitle.string.length) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleBanner.mas_bottom).offset(0);
        }];
    }
    
    // 消息内容
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.leading.equalTo(self).offset(TEXT_MARGIN);
        make.trailing.equalTo(self).offset(-TEXT_MARGIN);
    }];
    
    if (!self.attributedMessage.string.length) {
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        }];
    }
    
    // 文本框
    [self.fieldsHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self validView].mas_bottom).offset(MARGIN);
        make.leading.equalTo(self).offset(MARGIN);
        make.trailing.equalTo(self).offset(-MARGIN);
        //        make.bottom.equalTo(self).offset(-MARGIN);
    }];
    
    __block UITextField *previousField = nil;
    [self.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull textField, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.fieldsHolderView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.fieldsHolderView);
            make.trailing.equalTo(self.fieldsHolderView);
            make.height.mas_equalTo(ACTION_FIELD_HEIGHT);
            
            if (!previousField) {
                // 第一个按钮
                make.top.equalTo(self.fieldsHolderView.mas_top);
            } else {
                // 中间的按钮
                make.top.equalTo(previousField.mas_bottom).offset(ACTION_BUTTON_SPACE);
            }
        }];
        
        previousField = textField;
    }];
    
    // 最后一个按钮
    [previousField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fieldsHolderView);
    }];
    
    
    // 按钮
    [self.actionsHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fieldsHolderView.mas_bottom).offset(MARGIN);
        make.leading.equalTo(self).offset(MARGIN);
        make.trailing.equalTo(self).offset(-MARGIN);
        make.bottom.equalTo(self).offset(-MARGIN);
    }];
    
    __block UIButton *previousButton = nil;
    [self.actions enumerateObjectsUsingBlock:^(KGAlertAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(actionButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = idx;
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitle:action.title forState:UIControlStateNormal];
            button.layer.cornerRadius = 3;
            
            switch (action.actionStyle) {
                case KGAlertActionStyleDefault: {
                    button.backgroundColor = [UIColor colorWithRed:81/255.0 green:127/255.0 blue:247/255.0 alpha:1];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    break;
                }
                case KGAlertActionStyleCancel: {
                    button.backgroundColor = [UIColor whiteColor];
                    button.layer.borderWidth = 0.5;
                    button.layer.borderColor = [UIColor colorWithRed:154/255.0 green:161/255.0 blue:175/255.0 alpha:1].CGColor;
                    [button setTitleColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1] forState:UIControlStateNormal];
                    break;
                }
                case KGAlertActionStyleDestructive: {
                    button.backgroundColor = [UIColor colorWithRed:81/255.0 green:127/255.0 blue:247/255.0 alpha:1];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    break;
                }
                    
                default:
                    break;
            }
            
            [self.actionsHolderView addSubview:button];
            button;
        });
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.actionsHolderView);
            make.trailing.equalTo(self.actionsHolderView);
            make.height.mas_equalTo(ACTION_BUTTON_HEIGHT);
            
            if (!previousButton) {
                // 第一个按钮
                make.top.equalTo(self.actionsHolderView.mas_top);
            } else {
                // 中间的按钮
                make.top.equalTo(previousButton.mas_bottom).offset(ACTION_BUTTON_SPACE);
            }
        }];
        
        previousButton = button;
    }];
    
    // 最后一个按钮
    [previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.actionsHolderView);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CONTENTVIEW_WIDTH);
    }];
}

- (void)actionButtonDidClicked:(UIButton *)button {
    KGAlertAction *action = self.actions[button.tag];
    if (action.actionHandler) {
        action.actionHandler(action);
    }
    
    if (self.handler) {
        self.handler();
    }
}

- (UIView *)validView {
    UIView *validView = nil;
    if (self.attributedTitle.string.length) {
        validView = self.titleLabel;
    }
    
    if (self.attributedMessage.string.length) {
        validView = self.messageLabel;
    }
    
    if (!validView) {
        validView = self.titleBanner;
    }
    return validView;
}


- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    self.titleLabel.attributedText = _attributedTitle;
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage {
    _attributedMessage = attributedMessage;
    self.messageLabel.attributedText = _attributedMessage;
}

- (void)setHeaderImage:(UIImage *)headerImage {
    _headerImage = headerImage;
    self.titleBanner.image = _headerImage;
}

@end
