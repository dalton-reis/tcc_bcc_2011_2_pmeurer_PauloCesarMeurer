//
//  SetaDraw.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/12/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SetaDraw : NSObject {
}

+ (void)renderSetaForAngle:(float)angulo forDistance:(float)distance;
+ (void)renderSetaForAngle:(float)angulo;

@end