//
//  CodeBlockVisitor.h
//  jbrick-for-ios
//
//  Created by Student on 10/31/12.
//
//

#import <Foundation/Foundation.h>

/**
 * This class is an implimentation of the Visitor pattern it is here
 * for extensability purposes of the codeBlock's
 */
@protocol CodeBlockVisitor <NSObject>
-(void) visitMethodCallCodeBlock:(NSObject *)block;
-(void) visitMethodDeclorationBlock:(NSObject *)block;
-(void) visitValueCodeBlock:(NSObject *)block;
-(void) visitVariableCodeBlock:(NSObject *)block;
-(void) visitVariableDeclorationBlock:(NSObject *)block;
-(void) visitVariableAssignmentBlock:(NSObject *)block;
-(void) visitVariableMathBlock:(NSObject *)block;
-(void) visitWhileLoopCodeBlock:(NSObject *)block;
-(void) visitLogicalOperatorCodeBlock:(NSObject *)block;
-(void) visitElseCodeBlock:(NSObject *)block;
@end
