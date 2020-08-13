//
//  GLTextura.m
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 10/14/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import "GLTextura.h"


@implementation GLTextura
@synthesize altura;
@synthesize largura;
@synthesize dadosTextura;

- (id)initWithTexto:(NSString*)texto forFonte:(UIFont*)fonte forRed:(float)red forGreen:(float)green forBlue:(float)blue forAlpha:(float)alpha{
    
    if((self = [super init])) {
        CGSize size = [texto sizeWithFont:fonte];
        
        NSInteger i;
        
        largura = size.width;
        if((largura != 1) && (((int)largura) & (((int)largura) - 1))) {
            i = 1;
            while(i < largura)
                i *= 2;
            largura = i;
        }
        
        altura = size.height;
        if((altura != 1) && (((int)altura) & (((int)altura) - 1))) {
            i = 1;
            while(i < altura)
                i *= 2;
            altura = i;
        }
        
        NSInteger BitsPerComponent = 8;
        
        int bpp = BitsPerComponent / 2;
        int byteCount = largura * altura * bpp;
        uint8_t *data = (uint8_t*) calloc(byteCount, 1);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
        CGContextRef context = CGBitmapContextCreate(data,
                                                     largura,
                                                     altura,
                                                     BitsPerComponent,
                                                     bpp * largura,
                                                     colorSpace,
                                                     bitmapInfo);
        CGColorSpaceRelease(colorSpace);
        CGContextSetRGBFillColor(context, red, green, blue, alpha);
        CGContextTranslateCTM(context, 0.0f, altura);
        CGContextScaleCTM(context, 1.0f, -1.0f);
        UIGraphicsPushContext(context);
        
        [texto drawInRect:CGRectMake(0,
                                    0,
                                    size.width,
                                    size.height)
            withFont:fonte
            lineBreakMode:UILineBreakModeWordWrap
            alignment:UITextAlignmentCenter];
        
        UIGraphicsPopContext();
        CGContextRelease(context);
        
        dadosTextura = (uint8_t *)[[NSData dataWithBytesNoCopy:data length:byteCount freeWhenDone:YES] bytes];
    }
    
    return self;
}


@end
