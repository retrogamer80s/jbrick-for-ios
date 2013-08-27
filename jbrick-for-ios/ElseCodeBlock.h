//
//  ElseCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 4/23/13.
//
//

#import "CodeBlock.h"
#import "ViewableCodeBlock.h"
#import "CompositeCodeBlock.h"

@interface ElseCodeBlock :  CompositeCodeBlock <ViewableCodeBlock>{
    NSString *name;
}

@end
