//
//  KGAlertController.m
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GoGoVan. All rights reserved.
//

#import "KGAlertController.h"
#import <Masonry/Masonry.h>
#import "KGAlertView.h"

@interface KGAlertController ()

@property (nonatomic, readwrite, strong) UIWindow *previousWindow;
@property (nonatomic, readwrite, strong) UIWindow *alertWindow;

@property (nonatomic, assign) BOOL useIndependentWindow;

@property (nonatomic, strong) KGAlertView *contentView;

@property (nonatomic, strong) UIImageView *bgImageView;

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
    if (_dimBackground) {
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    } else {
        self.view.backgroundColor = [UIColor clearColor];
    }

    [self configAlertView];
    
    self.contentView.headerImage = self.headerImage;
    self.contentView.attributedTitle = self.attributedTitle;
    self.contentView.attributedMessage = self.attributedMessage;
    self.contentView.actions = self.actions;
    self.contentView.textFields = self.textFields;
    [self.contentView setupLayout];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Public Methods

+ (instancetype)alertControllerWithTitle:(NSAttributedString *)title
                                 message:(NSAttributedString *)message
                          preferredStyle:(KGAlertControllerStyle)preferredStyle {
    KGAlertController *ac = [KGAlertController new];
    ac.attributedTitle= title;
    ac.attributedMessage = message;
    ac.preferredStyle = preferredStyle;
    ac.dimBackground = YES;
    return ac;
}

+ (instancetype)alertControllerWithImage:(UIImage *)image
                                   title:(NSAttributedString *)title
                                 message:(NSAttributedString *)message
                          preferredStyle:(KGAlertControllerStyle)preferredStyle {
    KGAlertController *ac = [KGAlertController new];
    ac.headerImage = image;
    ac.attributedTitle= title;
    ac.attributedMessage = message;
    ac.preferredStyle = preferredStyle;
    ac.dimBackground = YES;
//    [ac configAlertView];
    return ac;
}

- (void)show {
    
    [self showAnimaged:YES];
}

- (void)showAnimaged:(BOOL)animated {
    self.previousWindow = [UIApplication sharedApplication].keyWindow;
    [self.alertWindow makeKeyAndVisible];
    
    if (animated) {
        CGAffineTransform old = self.contentView.transform;
        
        CGAffineTransform from = CGAffineTransformScale(self.contentView.transform, 0, 0);
        self.contentView.transform = from;
        CGAffineTransform to = CGAffineTransformScale(old, 1.05, 1.05);
        CGAffineTransform end = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.15 animations:^{
            self.contentView.transform = to;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                self.contentView.transform = end;
            }];
            
        }];
    }
}

- (void)dismissAnimated:(BOOL)animated {
    void (^completion)(void) = ^{
        [self.previousWindow makeKeyAndVisible];
        self.alertWindow = nil;
    };
    if (animated) {
        CGAffineTransform old = self.contentView.transform;
        CGAffineTransform to = CGAffineTransformScale(old, 0.9, 0.9);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = to;
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            completion();
        }];
    } else {
        completion();
    }
}

- (void)dismiss {
    [self dismissAnimated:YES];
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

- (UITextField *)textFieldAtIndex:(NSInteger)index {
    if (self.textFields.count > index) {
        return self.textFields[index];
    }
    
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private Methods

- (void)configAlertView {
    switch (self.preferredStyle) {
        case KGAlertControllerStyleAlert: {
            self.contentView = [KGAlertView new];
            break;
        }
        case KGAlertControllerStyleActionSheet: {
            //
            break;
        }
    }
    __weak typeof(self) weakSelf = self;
    self.contentView.handler = ^{
        [weakSelf dismiss];
    };
    self.contentView.userInteractionEnabled = YES;
    [self.view addSubview:self.contentView];
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

