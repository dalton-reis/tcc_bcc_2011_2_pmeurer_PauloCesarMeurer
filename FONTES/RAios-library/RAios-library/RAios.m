//
//  RAios.m
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/17/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import "RAios.h"


@implementation RAios

#pragma mark -
#pragma mark Inicialização

- (id)init{
    self = [super init];
    if(self){
        m_viewContainer =   nil;
        m_raEngine      =   nil;
        m_raGLView      =   nil;
        m_bFpsHabilitado = NO;
        m_bTexturaHabilitado = NO;
    }
    return self;
}

- (void)arInit:(UIView*)view{
    m_viewContainer = view;
    
    m_raCameraView  =   [[RACameraView alloc]init];
    m_raEngine      =   [[RAEngine alloc]init];
}

- (void)arEnd{
    [self arLocationStop];
    [self arMotionStop];
    [self arVideoCapStop];
    [self arDrawStop];
    
    [m_raEngine release];
    m_raEngine = nil;
    
    [m_raCameraView release];
    m_raCameraView = nil;
}

#pragma mark -
#pragma mark Gestão da câmera

- (void)arVideoCapConfigFrameRate:(CMTime)frameRate{
    // valida a configuração passada
    if(frameRate.value > CMTimeMake(1, 60).value)
        frameRate = CMTimeMake(1, 60);
        
    m_raCameraView->m_raCameraFrameRate = frameRate;
}

- (void)arVideoCapConfigVideoQuality:(NSString*)captureSessionPreset{
    // verifica se o captureSessionPreset é um parâmetro válido
    if([captureSessionPreset isEqualToString:AVCaptureSessionPresetMedium]  ||
       [captureSessionPreset isEqualToString:AVCaptureSessionPresetHigh]    ||
       [captureSessionPreset isEqualToString:AVCaptureSessionPresetLow])
    {
        m_raCameraView->m_raCameraQualidadeCaptura = captureSessionPreset;
    }
    else
        m_raCameraView->m_raCameraQualidadeCaptura = AVCaptureSessionPresetMedium;
        
}

- (void)arVideoCapStart{
    [m_raCameraView initCapture:m_viewContainer];
}

- (void)arVideoCapStop{
    [m_raCameraView stopCapture];
}

#pragma mark -
#pragma mark Gestão da engine

- (void)arMotionConfigAccelUpdateFrequency:(float)frequency{
    m_raEngine->m_accelUpdateFrequency = frequency;
}

- (void)arMotionConfigGravityFilterFactor:(float)filterFactor{
    m_raEngine->m_accelFilteringFactor = filterFactor;
}

- (void)arMotionStart{
    [m_raEngine inicializaMotionManager];
}

- (void)arMotionStop{
    [m_raEngine finalizaMotionManager];
}

- (void)arLocationConfigFiltroDistanciaGPS:(float)filtroDistancia{
    m_raEngine->m_GpsFiltroDistancia = filtroDistancia;
}

- (void)arLocationConfigFiltroBussola:(float)graus{
        m_raEngine->m_BussolaFiltroGraus = graus;
}

- (void)arLocationConfigDistanciaMaximaObjeto:(float)distancia{
    m_raEngine->m_geoAlcance = distancia;
}

- (void)arLocationStart{
    [m_raEngine inicializaLocationManager];
}

- (void)arLocationStop{
    [m_raEngine finalizaLocationManager];
}

- (void)arInsertObject:(PontoInteresse*)pontoInteresse{
    Objeto *obj = [[Objeto alloc]initWithLocation:pontoInteresse];
    [m_raEngine->m_arrayObjetos addObject:obj];
    [obj release];
}

- (void)arRemoveObject:(PontoInteresse*)pontoInteresse{
    [m_raEngine->m_arrayObjetos removeObject:pontoInteresse];
}

- (void)arRemoveAllObjects{
    [m_raEngine->m_arrayObjetos removeAllObjects];
}

#pragma mark -
#pragma mark Gestão de desenho

- (void)arDrawConfigRaioDesenhoObjeto:(float)raio{
    m_raEngine->m_glRaio = raio;
}

- (void)arDrawConfigDistanciaObjetoTela:(float)distancia{
    m_raEngine->m_distanciaObjetoCamera = distancia;
}

- (void)arDrawConfigHabilitarFPS:(BOOL)habilitarFPS{
    m_bFpsHabilitado = habilitarFPS;
}

- (void)arDrawConfigHabilitarTexturas:(BOOL)habilitarTexturas{
    m_bTexturaHabilitado = habilitarTexturas;
}

- (void)arDrawStart{
    m_raGLView = [[GLView alloc]initWithFrame:m_viewContainer.bounds resourceProvider:m_raEngine];
    [m_raGLView habilitarFPS:m_bFpsHabilitado];
    [m_raGLView habilitarTexturas:m_bTexturaHabilitado];
    
    // Adiciona o layer de GLView à view principal
    [m_viewContainer addSubview:m_raGLView];
    // libera a memória, pois addSubview retem o objeto
    [m_raGLView release];
}

- (void)arDrawStop{
    // remove a GLView da view em que ela está vinculada
    [m_raGLView removeFromSuperview];
    // encerra o loop de animação
    [m_raGLView stopDrawView];
}

#pragma mark -
#pragma mark Gerencia de memoria

- (void)dealloc{
    
    [self arEnd];
    
    [super dealloc];
}

@end
