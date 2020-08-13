//
//  Teste.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/16/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RAios.h"

@interface FerramentasView : UIView {
    
    /*stuff needed to animate the shrinking/disapearing of the images from the screen*/
    CADisplayLink   *displayLink;
    RAios           *m_RAios;
}

- (void)drawQuartz:(CADisplayLink *)sender;
- (id)initWithFrame:(CGRect)frame toolkit:(RAios*)toolkit;

@end
