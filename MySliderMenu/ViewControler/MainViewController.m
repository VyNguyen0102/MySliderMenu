//
//  MainViewController.m
//  MySliderMenu
//
//  Created by VyNV on 10/7/15.
//  Copyright (c) 2015 VyNV. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "ViewController.h"
#import "SliderMenuViewController.h"

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
#define TOUCH_X_AREA 60

@interface MainViewController ()<CenterViewControllerDelegate, UIGestureRecognizerDelegate
>

@property (nonatomic, strong) ViewController *centerViewController;
@property (nonatomic, strong) SliderMenuViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic, assign) CGPoint touchPoint;
@end

@implementation MainViewController 

- (void)viewDidLoad {
	[self setupView];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView {
	self.centerViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
	self.centerViewController.delegate = self;
	[self.view addSubview:self.centerViewController.view];
	[self addChildViewController:_centerViewController];
	[_centerViewController didMoveToParentViewController:self];
	
	[self setupGestures];
}
-(UIView *)getLeftView {
	// init view if it doesn't already exist
	if (_leftPanelViewController == nil)
	{
		// this is where you define the view for the left panel
		self.leftPanelViewController = [[SliderMenuViewController alloc] initWithNibName:@"SliderMenuViewController" bundle:nil];
		
		[self.view addSubview:self.leftPanelViewController.view];
		
		[self addChildViewController:_leftPanelViewController];
		[_leftPanelViewController didMoveToParentViewController:self];
		
		_leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	}
	
	self.showingLeftPanel = YES;
	
	// setup view shadows
	[self showCenterViewWithShadow:YES withOffset:-2];
	
	UIView *view = self.leftPanelViewController.view;
	return view;
}

-(void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
	if (value) {
		[_centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
		[_centerViewController.view.layer setShadowOpacity:0.8];
		[_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
		
	} else {
		[_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
	}
}
-(void)movePanelToRight {
	UIView *childView = [self getLeftView];
	[self.view sendSubviewToBack:childView];
	
	[UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		_centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
	}
					 completion:^(BOOL finished) {
						 if (finished) {
							 // do some thing with this
						 }
					 }];
}
-(void)movePanelToOriginalPosition {
	[UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		_centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	}
					 completion:^(BOOL finished) {
						 if (finished) {
							 [self resetMainView];
						 }
					 }];
}
-(void)resetMainView {
	// remove left and right views, and reset variables, if needed
	if (_leftPanelViewController != nil) {
		[self.leftPanelViewController.view removeFromSuperview];
		self.leftPanelViewController = nil;
		self.showingLeftPanel = NO;
	}	[self showCenterViewWithShadow:NO withOffset:0];
}

-(void)setupGestures {
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	
	[_centerViewController.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender {
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
	
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
	CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];

	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		UIView *childView = nil;
		if(velocity.x > 0) {
			if (!_showingLeftPanel) {
				childView = [self getLeftView];
			}
		}
		// make sure the view we're working with is front and center
		[self.view sendSubviewToBack:childView];
		[[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
		_touchPoint = [sender locationInView:_centerViewController.view];
	}
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
		// are we more than halfway, if so, show the panel when done dragging by setting this value to YES (1)
		_showPanel = [sender view].center.x - _centerViewController.view.frame.size.width/2	 > _centerViewController.view.frame.size.width/2;
		
		// allow dragging only in x coordinates by only updating the x coordinate with translation position
		if ((translatedPoint.x >0 || _showingLeftPanel) && _touchPoint.x < TOUCH_X_AREA){
			[sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
			[(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
		}
	}
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		if (!_showPanel) {
			[self movePanelToOriginalPosition];
		} else {
			[self movePanelToRight];
		}
	}
}

@end
