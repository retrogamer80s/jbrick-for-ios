//
//  ValueInputCell.m
//  jbrick-for-ios
//
//  Created by Student on 10/19/12.
//
//

#import "ValueInputCell.h"

@implementation ValueInputCell
@synthesize Subview;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)ValueSelected:(id)sender {
    if(delegate)
        [delegate submitClicked:indexPath];
}

- (void)setContent:(UIView *)content indexPath:(NSIndexPath *)index
{
    indexPath = index;
    
    for(UIView *view in Subview.subviews)
        [view removeFromSuperview];
    content.frame = CGRectMake(0, 0, 260, content.frame.size.height);
    [Subview addSubview:content];
}

@end
