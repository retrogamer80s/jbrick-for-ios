//
//  CompositeCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 2/6/13.
//
//

#import "CompositeCodeBlock.h"

@implementation CompositeCodeBlock
-(id) init
{
    self = [super init];
    innerCodeBlocks = [NSMutableArray array];
    return self;
}

-(bool)canAddCodeBlock:(CodeBlock *)codeBlock{ return true; }

-(bool)addCodeBlock:(CodeBlock *)codeBlock
{
    if(![self canAddCodeBlock:codeBlock])
        return false;
    [innerCodeBlocks addObject:codeBlock];
    codeBlock.Parent = self;
    return true;
}

-(bool)addCodeBlock:(CodeBlock *)codeBlock indexBlock:(CodeBlock *)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    if(![self canAddCodeBlock:codeBlock])
        return false;
    NSInteger insertIndex = [innerCodeBlocks indexOfObject:indexBlock];
    if(insertIndex == NSNotFound)
        return false;
    
    if(afterIndexBlock)
        [innerCodeBlocks insertObject:codeBlock atIndex:insertIndex+1];
    else
        [innerCodeBlocks insertObject:codeBlock atIndex:insertIndex];     codeBlock.Parent = self;
    
    return true;
}

-(void)removeCodeBlock:(CodeBlock *)codeBlock
{
    [innerCodeBlocks removeObject:codeBlock];
}

-(bool) parameterIsInScope:(CodeBlock *)parameter beforeIndex:(CodeBlock *)index
{
    int paramIndex = [innerCodeBlocks indexOfObject:parameter];
    int indexIndex = [innerCodeBlocks indexOfObject:index];
    
    if(paramIndex != NSNotFound && indexIndex != NSNotFound)
        return paramIndex < indexIndex;
    else
        return [super parameterIsInScope:parameter beforeIndex:index];
}

- (void) addAvailableParameters:(Primative)type parameterList:(NSMutableArray *)paramList beforeIndex:(CodeBlock *)index
{
    for(CodeBlock * codeBlock in innerCodeBlocks)
    {
        if(codeBlock == index)
            break;
        CodeBlock * paramRef = [codeBlock getParameterReferenceBlock:type];
        if(paramRef)
            [paramList addObject:paramRef];
    }
    
    if(self.Parent)
        [self.Parent addAvailableParameters:type parameterList:paramList beforeIndex:self];
}
- (void)childWasDeleted:(CodeBlock *)child{
    [innerCodeBlocks removeObject:child];
}

// Encoding/Decoding Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:innerCodeBlocks forKey:@"innerCodeBlocks"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    innerCodeBlocks = [coder decodeObjectForKey:@"innerCodeBlocks"];
    
    return self;
}


@end
