//
//  ViewableCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 11/5/12.
//
//

#import "ViewableCodeBlock.h"

@implementation ViewableCodeBlock
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;

-(NSString *) getDisplayName
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

-(ViewableCodeBlock *) getPrototype
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

-(NSArray *) getPropertyVariables
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

@end
