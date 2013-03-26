//
//  SaveFileList.h
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import <Foundation/Foundation.h>

@interface SaveFileList : NSObject <UITableViewDataSource>{
    NSMutableArray *saveFiles;
}

-(id)init;

@end
