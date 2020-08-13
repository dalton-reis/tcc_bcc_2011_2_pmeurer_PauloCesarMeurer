//
//  Teste.m
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/16/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import "FerramentasView.h"

@implementation FerramentasView

- (id)initWithFrame:(CGRect)frame toolkit:(RAios*)toolkit;
{
    self = [super initWithFrame:frame];
    if (self) {
        /*stuff needed to animate the shrinking/disapearing of the images from the screen* /
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawQuartz:)];
        //[displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        //displayLink.frameInterval = 1; */
        m_RAios = toolkit;
        [self setNeedsDisplayInRect:frame];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if( CGRectContainsPoint(CGRectMake(5, 435, 40, 40), point)){
        /*NSString *msg = [[NSString alloc]initWithFormat:@"Configurações"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Furb RA" message:msg delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        [msg release];*/
        
        return YES;
    }
    
    return NO;
}

/*stuff needed to animate the shrinking/disapearing of the images from the screen*/
/*This method contiguously gets called by some other object that we have not created but we have linked to */
- (void)updateNodeTouchedFade:(CADisplayLink *)sender{

    
 //implicit call to drawRect method
}

- (void)drawQuartz:(CADisplayLink *)sender{
        [self setNeedsDisplayInRect:self.bounds];
}

/*stuff needed to place and remove images from the screen*/
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    //CGContextSetStrokeColorWithColor(context, currentColor.CGColor);
    
    //CGContextSetFillColorWithColor(context, currentColor.CGColor);
    
    CGRect currentRect = CGRectMake(5,
                                    435,
                                    40,
                                    40);
    UIImage *image = [UIImage imageNamed:@"exit.png"];
    UIImage *rotateImage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
    [rotateImage  drawInRect:currentRect];
}

/*This method gets called when the app initially loads and when the user touches the location on the screen where an image is located in order to update the
 screen/view*/
- (void)drawNodes{

    [self setNeedsDisplay];//implicit call to drawRect method
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    UITouch*	touch = [[event touchesForView:self] anyObject];
	CGPoint ponto = [touch locationInView:self];
    
    if( CGRectContainsPoint(CGRectMake(5, 435, 40, 40), ponto)){
         
        [m_RAios arEnd];
        
        id superView = [self superview];
        id viewController = [superView nextResponder];
        [viewController viewWillAppear:NO];
        
         [self removeFromSuperview];
    }
}

@end
