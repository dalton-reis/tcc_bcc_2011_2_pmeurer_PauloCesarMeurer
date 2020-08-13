//
//  RAios.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/17/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACameraView.h"
#import "RAEngine.h"
#import "GLView.h"

@interface RAios : NSObject {
    UIView              *m_viewContainer;
    
    // Video
    RACameraView        *m_raCameraView;
    
    // Engine
    RAEngine            *m_raEngine;
    
    // OpenGL ES
    GLView              *m_raGLView;
    BOOL                m_bFpsHabilitado;
    BOOL                m_bTexturaHabilitado;
}

- (void)arInit:(UIView*)view;
- (void)arEnd;

// Vídeo
- (void)arVideoCapConfigFrameRate:(CMTime)frameRate;
- (void)arVideoCapConfigVideoQuality:(NSString*)captureSessionPreset;
- (void)arVideoCapStart;
- (void)arVideoCapStop;

// Engine
- (void)arMotionConfigAccelUpdateFrequency:(float)frequency;
- (void)arMotionConfigGravityFilterFactor:(float)filterFactor;
- (void)arMotionStart;
- (void)arMotionStop;

- (void)arLocationConfigFiltroDistanciaGPS:(float)filtroDistancia;
- (void)arLocationConfigFiltroBussola:(float)graus;
- (void)arLocationConfigDistanciaMaximaObjeto:(float)distancia;
- (void)arLocationStart;
- (void)arLocationStop;

- (void)arDrawConfigRaioDesenhoObjeto:(float)raio;
- (void)arDrawConfigDistanciaObjetoTela:(float)distancia;
- (void)arDrawConfigHabilitarFPS:(BOOL)habilitarFPS;
- (void)arDrawConfigHabilitarTexturas:(BOOL)habilitarTexturas;

- (void)arInsertObject:(PontoInteresse*)objeto;
- (void)arRemoveObject:(PontoInteresse*)objeto;
- (void)arRemoveAllObjects;

// OpenGL ES
- (void)arDrawStart;
- (void)arDrawStop;

@end
