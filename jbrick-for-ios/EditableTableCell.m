//
//  EditableTableCell.m
//  jbrick-for-ios
//
//  Created by Student on 4/2/13.
//
//

#import "EditableTableCell.h"

@implementation EditableTableCell

@synthesize TextField = textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    [super awakeFromNib];
}


@end
