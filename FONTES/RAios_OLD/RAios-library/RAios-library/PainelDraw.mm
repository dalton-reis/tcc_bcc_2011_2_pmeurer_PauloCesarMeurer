//
//  RAPainelDraw.m
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/15/11.
//  Copyright 2011 FURB. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PainelDraw.h"
#import "GLESComum.h"
#import "GLTextRenderer.h"

const struct vertex VerticesPainel[]={
    {{-3.0f, 3.0f, 0.0f },  {127, 127, 127, 127}},
    {{3.0f,  -3.0f, 0.0f}, {127, 127, 127, 127}},
    {{3.0f,  3.0f, 0.0f },  {127, 127, 127, 127}}, 
    
    {{-3.0f, 3.0f, 0.0f },  {127, 127, 127, 127}},
    {{3.0f,  -3.0f, 0.0f}, {127, 127, 127, 127}},
    {{-3.0f, -3.0f, 0.0f}, {127, 127, 127, 127}},
};


static const Point3D vertices[] = {
    { -3.0,  3.0, 0.0},
    { -3.0,  -3.0, 0.0},
    { 3.0,  3.0, 0.0},
    { 3.0,  -3.0, 0.0},
    
};

static const GLfloat texCoords[] = {
    0.0, 1.0,
    1.0, 1.0,
    0.0, 0.0,
    1.0, 0.0,
};


@implementation PainelDraw

+ (void)renderPainel{
    glVertexPointer(3, GL_FLOAT, sizeof(struct vertex), &VerticesPainel[0].positon[0]);
    glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(struct vertex), &VerticesPainel[0].color[0]);
    int vertexCount = sizeof(VerticesPainel)/sizeof(struct vertex);
    glDrawArrays(GL_TRIANGLES, 0, vertexCount);
}

+ (void)renderPainelWithString:(NSString*)str{
    
    // renderiza o painel
    [self renderPainel];
    
    // rotaciona o espaço 3D para exibir o texto corretamente
    glRotatef(90.0, 0.0f, 0.0f, 1.0f);
    
    // renderiza o texto    
    UIFont *font = [UIFont systemFontOfSize:20];
    [GLTextRenderer renderText:str forFont:font vertexCoord:(GLvoid*)&vertices textureCoord:(GLvoid*)texCoords redValue:0.0 greenValue:0.0 blueValue:0.0 alphaValue:1.0];
}

@end
