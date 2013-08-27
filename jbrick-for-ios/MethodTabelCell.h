//
//  MethodTabelCell.h
//  jbrick-for-ios
//
//  Created by Student on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MethodTabelCell : UITableViewCell {
    bool expanded;
}
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ParametesLabel;
@property (nonatomic) IBOutlet UILabel* customLabel;
@property bool Expanded;
@property (readonly) float Height;

@end
