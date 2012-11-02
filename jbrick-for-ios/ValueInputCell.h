//
//  ValueInputCell.h
//  jbrick-for-ios
//
//  Created by Student on 10/19/12.
//
//

#import <UIKit/UIKit.h>

@protocol ValueInputCellDelegate
-(void) submitClicked:(NSIndexPath *)index;
@end

@interface ValueInputCell : UITableViewCell
{
    NSIndexPath *indexPath;
}
@property (weak, nonatomic) IBOutlet UIView *Subview;
@property (nonatomic, assign) id<ValueInputCellDelegate> delegate;

-(void) setContent:(UIView *)content indexPath:(NSIndexPath *)index;

@end
