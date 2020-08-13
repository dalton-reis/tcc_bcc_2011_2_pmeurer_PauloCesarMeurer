//
//  SetaDraw.cpp
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/12/11.
//  Copyright 2011 FURB. All rights reserved.
//

#include "SetaDraw.h"
#import "GLESComum.h"
#import "GLTextRenderer.h"

// Cria os vÈrtices que preenchem a seta.
const struct vertex verticesPreenchimento[]={
    {{0.00f, 0.00f, 0.00f},     {255, 255, 255, 255}},
    {{0.00f, 2.00f, 0.00f},     {255, 255, 255, 255}},
    {{-1.00f, +0.00f, 0.00f},   {255, 255, 255, 255}},
    
    {{0.00f, 0.00f, 0.00f},      {255, 255, 255, 255}},
    {{0.00f, 2.00f, 0.00f},      {255, 255, 255, 255}},
    {{1.00f, 0.00f, 0.00f},  {255, 255, 255, 255}},
    
    {{-0.5f, -2.00f, 0.00f},{255, 255, 255, 255}},
    {{0.5f, -2.00f, 0.00f}, {255, 255, 255, 255}},
    {{-0.5f, 0.00f, 0.00f},       {255, 255, 255, 255}},
    
    {{-0.5f, 0.00f, 0.00f},       {255, 255, 255, 255}},
    {{0.5f, -2.00f, 0.00f}, {255, 255, 255, 255}},
    {{0.5f, 0.00f, 0.00f},        {255, 255, 255, 255}},
};

static const Point3D vertices[] = {
    { -0.5,  0.0, 0.0},
    { -0.5,  -2.0, 0.0},
    { 0.5,  0.0, 0.0},
    { 0.5,  -2.0, 0.0},
    
};

static const GLfloat texCoordsB[] = {
    1.0, 0.0,
    0.0, 0.0,
    1.0, 1.0,
    0.0, 1.0,
};

static const GLfloat texCoordsA[] = {
    0.0, 1.0,
    1.0, 1.0,
    0.0, 0.0,
    1.0, 0.0,
};

@implementation SetaDraw

+ (void)renderSetaForAngle:(float)angulo{
    // desenha o preenchimento da seta
    glVertexPointer(3, GL_FLOAT, sizeof(struct vertex), &verticesPreenchimento[0].positon[0]);
    glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(struct vertex), &verticesPreenchimento[0].color[0]);
    int vertexCount = sizeof(verticesPreenchimento)/sizeof(struct vertex);
    glDrawArrays(GL_TRIANGLES, 0, vertexCount);
}

+ (void)renderSetaForAngle:(float)angulo forDistance:(float)distance{
    // desenha a seta
    [self renderSetaForAngle:angulo];
    
    // verifica o ânculo da seta para não mostrar o texto invertido
    GLvoid *textCoord = nil;
    if((angulo >= 270.0)||(angulo <=90.0))
        textCoord = (GLvoid*)texCoordsA;
    else
        textCoord = (GLvoid*)texCoordsB;

    // renderiza o texto
    NSString *text = [[NSString alloc] initWithFormat:@"%.2fm", distance];
    UIFont *font = [UIFont systemFontOfSize:20];
    [GLTextRenderer renderText:text forFont:font vertexCoord:(GLvoid*)&vertices textureCoord:textCoord redValue:0.0 greenValue:0.0 blueValue:0.0 alphaValue:1.0];
    
    // libera a memória alocada para text
    [text release];
}

@end