//
//  CodeBlockVisitor.h
//  jbrick-for-ios
//
//  Created by Student on 10/31/12.
//
//

#import <Foundation/Foundation.h>

@protocol CodeBlockVisitor <NSObject>
-(void) visitMethodCallCodeBlock:(NSObject *)block;
-(void) visitMethodDeclorationBlock:(NSObject *)block;
-(void) visitValueCodeBlock:(NSObject *)block;
-(void) visitVariableCodeBlock:(NSObject *)block;
-(void) visitVariableDeclorationBlock:(NSObject *)block;
-(void) visitVariableAssignmentBlock:(NSObject *)block;
-(void) visitVariableMathBlock:(NSObject *)block;
@end
