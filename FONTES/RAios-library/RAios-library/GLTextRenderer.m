//
//  GLTextRenderer.m
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 9/24/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import "GLTextRenderer.h"
#import "GLTextura.h"

@implementation GLTextRenderer

+ (void)renderText:(NSString*)text forFont:(UIFont*)font vertexCoord:(GLvoid *)vertices textureCoord:(GLvoid *)textCoords redValue:(float)red greenValue:(float)green blueValue:(float)blue alphaValue:(float)alpha{
    
    ///////////////////////////////////////////////////////////////////////////
    // cria a textura com o texto a ser exibido
    
    //stackoverflow.com/questions/6060578/iphone-opengles-2-0-text-texture-w-strange-border-not-stroke-issue
    /*CGSize size = [text sizeWithFont:font];
    
    NSInteger i;
    
    size_t width = size.width;
    if((width != 1) && (((int)width) & (((int)width) - 1))) {
        i = 1;
        while(i < width)
            i *= 2;
        width = i;
    }
    
    size_t height = size.height;
    if((height != 1) && (((int)height) & (((int)height) - 1))) {
        i = 1;
        while(i < height)
            i *= 2;
        height = i;
    }
    
    NSInteger BitsPerComponent = 8;
    
    int bpp = BitsPerComponent / 2;
    int byteCount = width * height * bpp;
    uint8_t *data = (uint8_t*) calloc(byteCount, 1);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 BitsPerComponent,
                                                 bpp * width,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextTranslateCTM(context, 0.0f, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    UIGraphicsPushContext(context);
    
    [text drawInRect:CGRectMake(0,
                               0,
                               size.width,
                               size.height)
           withFont:font
      lineBreakMode:UILineBreakModeWordWrap
          alignment:UITextAlignmentCenter];
    UIGraphicsPopContext();
    CGContextRelease(context);*/
    
    GLTextura *textura = [[GLTextura alloc]initWithTexto:text forFonte:font forRed:red forGreen:green forBlue:blue forAlpha:alpha];
    ///////////////////////////////////////////////////////////////////////////
    
    // renderiza a textura criada
    
    // habilita o array de coordenadas de textura
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
	// Cria um identificador para a textura
    GLuint		texture[1];
	glGenTextures(1, &texture[0]);
	glBindTexture(GL_TEXTURE_2D, texture[0]);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
    // isto é necessário para texturas que não são potência de dois
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
    // utiliza BRGA para gerar o quadro com a textura
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, [[NSData dataWithBytesNoCopy:data length:byteCount freeWhenDone:YES] bytes]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textura.largura, textura.altura, 0, GL_BGRA, GL_UNSIGNED_BYTE, textura.dadosTextura);
    
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    
    glTexCoordPointer(2, GL_FLOAT, 0, textCoords);
    
    // desenha os polígonos com a textura
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // desabilita a primitiva de array de coordenadas de textura
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisable(GL_TEXTURE_2D);
    
    // deleta a textura criada
    glDeleteTextures(1, &texture[0]);
    
    [textura release];
}

@end
