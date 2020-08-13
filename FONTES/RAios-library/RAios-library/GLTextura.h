//
//  GLTextura.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 10/14/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GLTextura : NSObject {
    size_t altura;
    size_t largura;
    
    uint8_t *dadosTextura;
}

- (id)initWithTexto:(NSString*)texto forFonte:(UIFont*)fonte forRed:(float)red forGreen:(float)green forBlue:(float)blue forAlpha:(float)alpha;

@property (readwrite, assign) size_t altura;
@property (readwrite, assign) size_t largura;
@property (readwrite, assign) uint8_t* dadosTextura;

@end
