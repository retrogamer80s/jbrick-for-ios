//
//  PropertyPanelUIView.h
//  jbrick-for-ios
//
//  Created by Student on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyPanelUIView : UIView
{
    UIView *contents;
}

-(void) setPanelContents:(UIView *)newContent;
-(void)closePanel:(void (^)(BOOL finished))completion;
-(void)openPanel:(void (^)(BOOL finished))completion;
-(BOOL)isOpen;
@end
