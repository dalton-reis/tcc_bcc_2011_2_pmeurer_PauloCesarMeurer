//
//  GLESComum.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/24/11.
//  Copyright 2011 FURB. All rights reserved.
//

#pragma mark -
#pragma mark Imports

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>         //para utilizar o GL_RENDERBUFFER
#import <OpenGLES/EAGL.h>

#pragma mark -
#pragma mark Estruturas de Dados

// Define uma estrutura que representa um ponto 3D
typedef struct SPoint3D
{
	GLfloat x;
	GLfloat y;
	GLfloat z;
} Point3D;

// POD (plain old data) que representa a estrutura de cada vértice do triângulo
struct vertex{
    float positon[3];   // Localização do vértice
    Byte color[4];     // Cor do vértice RGBA
};

#pragma mark -
#pragma mark Funções

#define POW2(x) ((x)*(x))
#define degreesToRadian(x) (M_PI * x / 180.0)