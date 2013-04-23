//
//  CBVisitorUIBlockBuilder.m
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import "CBVisitorUIBlockBuilder.h"
#import "CodeBlock.h"
#import "ViewableCodeBlock.h"

@implementation CBVisitorUIBlockBuilder

-(void) visitCodeBlock:(CodeBlock *)block
{

}

-(void) visitMethodCallCodeBlock:(NSObject *)block{}
-(void) visitMethodDeclorationBlock:(NSObject *)block{}
-(void) visitValueCodeBlock:(NSObject *)block{}
-(void) visitVariableCodeBlock:(NSObject *)block{}
-(void) visitVariableDeclorationBlock:(NSObject *)block{}
-(void) visitVariableAssignmentBlock:(NSObject *)block{}
-(void) visitVariableMathBlock:(NSObject *)block{}
-(void) visitWhileLoopCodeBlock:(NSObject *)block{}
-(void) visitLogicalOperatorCodeBlock:(NSObject *)block{}
-(void) visitElseCodeBlock:(NSObject *)block{}
@end
