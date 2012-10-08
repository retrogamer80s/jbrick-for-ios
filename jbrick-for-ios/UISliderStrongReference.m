//
//  UISliderStrongReference.m
//  jbrick-for-ios
//
//  Created by Student on 10/2/12.
//
//

#import "UISliderStrongReference.h"

@implementation UISliderStrongReference
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.minimumValue = 0;
    self.maximumValue = 100;
    self.value = 75;
    
    return self;
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [super addTarget:target action:action forControlEvents:controlEvents];
    rememberedTarget = target;
}
@end
