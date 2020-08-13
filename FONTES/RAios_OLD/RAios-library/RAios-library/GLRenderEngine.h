/*!
 *  GLRenderEngine.h
 *  FURB RA
 *
 *  Created by Paulo Cesar Meurer on 8/10/11.
 *
 *  Classe criada para efetuar as operações gráficas
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GLESComum.h"

@interface GLRenderEngine : NSObject {
    GLfloat m_modelview[16];    // ModelView matrix inicial
    GLfloat m_projection[16];   // Projection matrix inicial
    GLint   m_viewport[4];      // ViewPort matrix inicial
    
    GLuint m_frameBuffer;
    GLuint m_renderBuffer;
    
    int m_zFar;
    int m_zNear;
    
    CGRect m_frame;
    
    // texturas
    BOOL                m_bHabilitarTexturas;
}

- (id)initForContext:(EAGLContext*)context fromDrawable:(CAEAGLLayer*)eaglLayer;
- (BOOL)initializeEngine:(CGRect)frame;

- (void)renderObjects:(NSMutableArray*)objects toRoll:(float)roll toAzimuth:(float)azimuth orientacaoDispositivo:(UIDeviceOrientation)orientacao desenharFPS:(bool)desenharPFS fps:(int)fps;

- (void)habilitarTexturas:(BOOL)habilitarTexturas;
- (void)drawFPS:(int)fps;

- (bool)checkCollision:(NSMutableArray*)objects touchX:(float)x touchY:(float)y orientacaoDispositivo:(UIDeviceOrientation)orientacao;

- (void)switchBackToFrustum;
- (void)switchToOrtho;

@end
