//
//  RAEngine.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/17/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "Objeto.h"
#import "PontoInteresse.h"

@interface RAEngine : NSObject <CLLocationManagerDelegate>{
    
    CLLocationManager *m_locationManager; // GPS e Bussola
    
    CMMotionManager  *m_motionManager; // acelerômetro
    NSOperationQueue *m_motionQueue;
    double m_accelZ; // aceleração medida no eixo z
    
@public
    NSMutableArray *m_arrayObjetos; // array de objetos a ser desenhado
    
    float m_accelUpdateFrequency; // taxa de atualização do acelerômetro
    float m_accelFilteringFactor; // filtro de gravidade do acelerômetro
    
	float m_azimuth;    // Rotacao da bussola em graus.
	float m_roll;       // Rotação sobre o eixo z
    
    float m_GpsFiltroDistancia; // distancia minima a ser percorrida lateralmente para atualizar a coordenada geografica
    float m_BussolaFiltroGraus; // // mundança angular mínima para gerar novos eventos da bússola 
    float m_geoAlcance; // alcance da tela em metros. Só estarão visíveis objetos dentro desta margem 
    float m_glRaio;     // raio em que os objetos serão dispostos na tela
    
    float m_distanciaObjetoCamera; // distância da câmera em que o objeto vai ser desenhado
    
    UIDeviceOrientation m_deviceOrientation; // Orientação atual do dispositivo
}

// GPS e Bussula
- (void)inicializaLocationManager;
- (void)finalizaLocationManager;

// Acelerometro
- (void)inicializaMotionManager;
- (void)finalizaMotionManager;

// Engine
- (void)atualizaPontosInteresse:(CLLocation *)localizacaoDispositivo;

@end
