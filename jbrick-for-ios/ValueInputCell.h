//
//  ValueInputCell.h
//  jbrick-for-ios
//
//  Created by Student on 10/19/12.
//
//

#import <UIKit/UIKit.h>

@protocol ValueInputCellDelegate
-(void) submitClicked;
@end

@interface ValueInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *Subview;
@property (nonatomic, assign) id<ValueInputCellDelegate> delegate;

-(void) setContent:(UIView *)content;

@end
