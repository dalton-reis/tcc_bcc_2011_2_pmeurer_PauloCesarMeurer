//
//  GLTextRenderer.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 9/24/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLESComum.h"


@interface GLTextRenderer : NSObject {
    
}

+ (void)renderText:(NSString*)text forFont:(UIFont*)font vertexCoord:(GLvoid *)vertices textureCoord:(GLvoid *)textCoords redValue:(float)red greenValue:(float)green blueValue:(float)blue alphaValue:(float)alpha;

@end
