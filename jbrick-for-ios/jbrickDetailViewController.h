//
//  jbrickDetailViewController.h
//  jbrick-for-ios
//
//  Created by Student on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramPane.h"
#import "PropertyPanelUIView.h"

@interface jbrickDetailViewController : UIViewController <UISplitViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet PropertyPanelUIView *propertyPane;
@property (weak, nonatomic) IBOutlet ProgramPane *programPane;

-(void) placeBlock:(UIView *)block;

@end
