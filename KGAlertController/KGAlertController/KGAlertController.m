//
//  KGAlertController.m
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import "KGAlertController.h"
#import <Masonry/Masonry.h>

static CGFloat const MARGIN = 30;
static CGFloat const ACTION_FIELD_HEIGHT = 40;
static CGFloat const ACTION_BUTTON_HEIGHT = 45;
static CGFloat const ACTION_BUTTON_SPACE = 10;
static CGFloat const CONTENTVIEW_WIDTH = 285;

@interface KGAlertController ()

@property (nonatomic, readwrite, strong) UIWindow *previousWindow;
@property (nonatomic, readwrite, strong) UIWindow *alertWindow;

@property (nonatomic, assign) BOOL useIndependentWindow;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *titleBanner;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *fieldsHolderView;
@property (nonatomic, strong) UIView *actionsHolderView;


@property (nonatomic, strong) NSMutableArray<KGAlertAction *> *actions;
@property (nonatomic, strong) NSMutableArray<UITextField *> *textFields;
@end

@implementation KGAlertController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    NSLog(@"%s", __FUNCTION__);
//}

#pragma mark - Public Methods

+ (instancetype)alertControllerWithTitle:(NSAttributedString *)title
                                 message:(NSAttributedString *)message
                          preferredStyle:(KGAlertControllerStyle)preferredStyle {
    KGAlertController *ac = [KGAlertController new];
    ac.attributedTitle= title;
    ac.attributedMessage = message;
    ac.preferredStyle = preferredStyle;
    return ac;
}

+ (instancetype)alertControllerWithImage:(UIImage *)image
                                   title:(NSAttributedString *)title
                                 message:(NSAttributedString *)message
                          preferredStyle:(KGAlertControllerStyle)preferredStyle{
    KGAlertController *ac = [KGAlertController new];
    ac.headerImage = image;
    ac.attributedTitle= title;
    ac.attributedMessage = message;
    ac.preferredStyle = preferredStyle;
    return ac;
}

- (void)show {
    self.previousWindow = [UIApplication sharedApplication].keyWindow;
    [self.alertWindow makeKeyAndVisible];
}

- (void)dismiss {
    [self.previousWindow makeKeyAndVisible];
    self.alertWindow = nil;
}

- (void)addAction:(KGAlertAction *)action {
    if (!action) {
        return;
    }
    
    [self.actions addObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(KGTextFieldConfigurationHandler)configurationHandler {
    
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 4;
    [self.textFields addObject:textField];
    if (configurationHandler) {
        configurationHandler(textField);
    }
}

#pragma mark - Event Response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismiss];
}

- (void)actionButtonDidClicked:(UIButton *)button {
    KGAlertAction *action = self.actions[button.tag];
    if (action.actionHandler) {
        action.actionHandler(action);
    }
    
    [self dismiss];
}

#pragma mark - Private Methods

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

- (void)setupViews {
    self.contentView = ({
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 6;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view;
    });
    
    self.titleBanner = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.headerImage];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor darkTextColor];
        label.attributedText = self.attributedTitle;
        [self.contentView addSubview:label];
        label;
    });
    
    self.messageLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor grayColor];
        label.attributedText = self.attributedMessage;
        [self.contentView addSubview:label];
        label;
    });
    
    self.fieldsHolderView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        view;
    });
    
    self.actionsHolderView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        view;
    });
}

- (void)setupLayout {
    
    
    // 标题图片
    [self.titleBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBanner.mas_bottom).offset(MARGIN);
        make.leading.equalTo(self.contentView).offset(MARGIN);
        make.trailing.equalTo(self.contentView).offset(-MARGIN);
    }];
    
    if (!self.attributedTitle.string.length) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleBanner.mas_bottom).offset(0);
        }];
    }
    
    // 消息内容
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.leading.equalTo(self.contentView).offset(MARGIN);
        make.trailing.equalTo(self.contentView).offset(-MARGIN);
    }];
    
    if (!self.attributedMessage.string.length) {
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        }];
    }
    
    // 文本框
    [self.fieldsHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self validView].mas_bottom).offset(MARGIN);
        make.leading.equalTo(self.contentView).offset(MARGIN);
        make.trailing.equalTo(self.contentView).offset(-MARGIN);
//        make.bottom.equalTo(self.contentView).offset(-MARGIN);
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
        make.leading.equalTo(self.contentView).offset(MARGIN);
        make.trailing.equalTo(self.contentView).offset(-MARGIN);
        make.bottom.equalTo(self.contentView).offset(-MARGIN);
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
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CONTENTVIEW_WIDTH);
        make.center.equalTo(self.view);
    }];
}

#pragma mark - Getter && Setter
- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [NSMutableArray array];
    }
    return _actions;
}

- (NSMutableArray<UITextField *> *)textFields {
    if (!_textFields) {
        _textFields = [NSMutableArray array];
    }
    return _textFields;
}

- (UIWindow *)alertWindow {
    if (!_alertWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = UIWindowLevelAlert;
        window.backgroundColor = [UIColor clearColor];
        window.rootViewController = self;
        _alertWindow = window;
    }
    return _alertWindow;
}

@end
