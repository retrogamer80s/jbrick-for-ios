//
//  MethodTabelCell.m
//  jbrick-for-ios
//
//  Created by Student on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MethodTabelCell.h"

@implementation MethodTabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.DescriptionLabel.hidden = true;
        self.ParametesLabel.hidden = true;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (bool) Expanded {
    return expanded;
}
- (void) setExpanded:(bool)Expanded
{
    if(expanded != Expanded){
        expanded = Expanded;
        if(expanded){
            self.ParametesLabel.hidden = false;
            self.DescriptionLabel.hidden = false;
            [self setTextHeights];
        } else {
            self.ParametesLabel.hidden = true;
            self.DescriptionLabel.hidden = true;
        }
        
    }
}

- (float) Height {
    if(expanded){
        return self.ParametesLabel.frame.origin.y + self.ParametesLabel.frame.size.height + 20;
    } else {
        return self.customLabel.frame.origin.y + self.customLabel.frame.size.height + 15;
    }
}

- (void) setTextHeights{
    CGRect frame = self.DescriptionLabel.frame;
    CGSize maximumSize = CGSizeMake(frame.size.width, 10000);
    CGSize labelHeighSize = [self.DescriptionLabel.text sizeWithFont: self.DescriptionLabel.font
                                                   constrainedToSize:maximumSize
                                                   lineBreakMode:UILineBreakModeWordWrap];
    self.DescriptionLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, labelHeighSize.height);
    
    float paramY = frame.origin.y + labelHeighSize.height + 20;
    frame = self.ParametesLabel.frame;
    maximumSize = CGSizeMake(frame.size.width, 10000);
    labelHeighSize = [self.ParametesLabel.text sizeWithFont: self.ParametesLabel.font
                                                   constrainedToSize:maximumSize
                                                   lineBreakMode:UILineBreakModeWordWrap];
    self.ParametesLabel.frame = CGRectMake(frame.origin.x, paramY, frame.size.width, labelHeighSize.height);
}


@end
