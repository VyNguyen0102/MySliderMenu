//
//  ViewController.h
//  MySliderMenu
//
//  Created by VyNV on 10/7/15.
//  Copyright (c) 2015 VyNV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelToRight;
@required
- (void)movePanelToOriginalPosition;
@end

@interface ViewController : UIViewController
@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;
@end

