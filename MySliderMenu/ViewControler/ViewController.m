//
//  ViewController.m
//  MySliderMenu
//
//  Created by VyNV on 10/7/15.
//  Copyright (c) 2015 VyNV. All rights reserved.
//

#import "ViewController.h"
#define CENTER_TAG 1
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (IBAction)ShowMenu:(id)sender {
	[_delegate movePanelToRight];
	NSLog(@"ShowMenu");
}

@end
