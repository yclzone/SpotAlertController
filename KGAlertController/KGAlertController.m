//
//  KGAlertController.m
//  KGAlertController
//
//  Created by gogovan on 11/08/2017.
//  Copyright © 2017 GOGO VAN. All rights reserved.
//

#import "KGAlertController.h"
#import <Masonry/Masonry.h>

static CGFloat const MARGIN = 30;

@interface KGAlertController ()

@property (nonatomic, readwrite, strong) UIWindow *previousWindow;
@property (nonatomic, readwrite, strong) UIWindow *alertWindow;

@property (nonatomic, assign) BOOL useIndependentWindow;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *titleBanner;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *actionsHolderView;

@property (nonatomic, copy) NSString *alertTitel;
@property (nonatomic, copy) NSString *alertMessage;

@property (nonatomic, strong) NSMutableArray<KGAlertAction *> *actions;
@end

@implementation KGAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
    self.contentView = ({
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 6;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view;
    });
    
    self.titleBanner = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sheet_call"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    self.actionsHolderView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:view];
        view;
    });

    
    [self.titleBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
    }];

    [self.actionsHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBanner.mas_bottom).offset(MARGIN);
        make.leading.equalTo(self.contentView).offset(MARGIN);
        make.trailing.equalTo(self.contentView).offset(-MARGIN);
        make.bottom.equalTo(self.contentView).offset(-MARGIN);
    }];

    __block UIButton *previousButton = nil;
    [self.actions enumerateObjectsUsingBlock:^(KGAlertAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor groupTableViewBackgroundColor];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:action.title forState:UIControlStateNormal];
            button.layer.cornerRadius = 3;
            [button addTarget:self action:@selector(actionButtonDidClicked:)
             forControlEvents:UIControlEventTouchUpInside];
            button.tag = idx;
            [self.actionsHolderView addSubview:button];
            button;
        });
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.actionsHolderView);
            make.trailing.equalTo(self.actionsHolderView);
            
            if (!previousButton) {
                // 第一个按钮
                make.top.equalTo(self.actionsHolderView.mas_top);
            } else {
                // 中间的按钮
                make.top.equalTo(previousButton.mas_bottom).offset(10);
            }
        }];
        
        previousButton = button;
    }];
    
    // 最后一个按钮
    [previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.actionsHolderView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(285);
        make.center.equalTo(self.view);
    }];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)showTitle:(NSString *)title message:(NSString *)message {
    
    self.alertTitel = title;
    self.alertMessage = message;
    
    [self.alertWindow makeKeyAndVisible];
}

- (void)show {
    [self.alertWindow makeKeyAndVisible];
}

- (void)addAction:(KGAlertAction *)action {
    if (!action) {
        return;
    }
    
    [self.actions addObject:action];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.alertWindow = nil;
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

#pragma mark - Action
- (void)actionButtonDidClicked:(UIButton *)button {
    KGAlertAction *action = self.actions[button.tag];
    if (action.actionHandler) {
        action.actionHandler(action);
    }
}


#pragma mark - Getter && Setter
- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [NSMutableArray array];
    }
    return _actions;
}

@end
