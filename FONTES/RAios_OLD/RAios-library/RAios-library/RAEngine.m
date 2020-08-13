//
//  RAEngine.m
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/17/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import "RAEngine.h"

@implementation RAEngine

#pragma mark - Inicialização

- (id)init{
    self = [super init];
    if(self){
        
        // inicializa o array de objetos
        m_arrayObjetos = [[NSMutableArray alloc]init];
        
        // inicializa as configurações do acelerômetro
        m_motionManager = nil;
        m_roll = 0.0;
        m_accelUpdateFrequency = 50.0;//Hz
        m_accelFilteringFactor = 0.1;
        
        // inicializa as configurações do GPS
        m_GpsFiltroDistancia = 0.0;
        m_BussolaFiltroGraus = 0.0;
        m_geoAlcance = 20000.0;
        
        // configuração de desenho
        m_glRaio = 1.5;
        m_distanciaObjetoCamera = 14.0f;//16.0f;
    }
    return self;
}

#pragma mark - Gerencia de memória

- (void)dealloc
{
    // libera a memória alocada para o location manager
    [self finalizaLocationManager];
    
    // libera a memória alocada para o motion manager
    [self finalizaMotionManager];
    
    // libera a memória alocada para os pontos de interesse
    [m_arrayObjetos release];
    
    [super dealloc];
}

#pragma mark - Eventos do acelerometro

- (void)inicializaMotionManager{
    // documentação do acelerômetro
    //	
    
    // uso do Block_copy
    //www.techques.com/question/1-4281956/iPhone-Motion---EXC-BAD-ACCESS
    
    m_accelZ = 0.00;
    
    m_motionManager = [[CMMotionManager alloc]init];
    m_motionQueue = [[NSOperationQueue alloc]init];
    
    if( m_motionManager.accelerometerAvailable ){
        // frequencia de atualização do acelerômetro
        m_motionManager.accelerometerUpdateInterval = 1.0/m_accelUpdateFrequency;
        
        // inicializa a leitura dos valores do acelerômetro
        [m_motionManager startAccelerometerUpdatesToQueue:m_motionQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) 
         {
             if( error){
                 // Caso ocorra erro encerra as atualizações do acelerêmetrp
                 [m_motionManager stopAccelerometerUpdates];
                 
                 NSLog(@"O acelerômetro encontrou um erro: %@", error);
             }
             else{
                 m_deviceOrientation = [[UIDevice currentDevice]orientation];
                 
                 // Isolating the Gravity Component from Acceleration Data
                 // Use a basic low-pass filter to keep only the gravity component of each axis.
                 m_accelZ = (accelerometerData.acceleration.z * m_accelFilteringFactor) + (m_accelZ * (1.0 - m_accelFilteringFactor));
                 
                 // obtem a orientação real no x.
                 float newAcelerometroZ = (90.0/2.3) * m_accelZ + 90.0;
                 
                 if (newAcelerometroZ != m_roll) {
                     m_roll = newAcelerometroZ;
                 }
             }
         }];
    }
    else{
        NSLog(@"Acelerômetro não disponível");
    }
}

- (void)finalizaMotionManager{
    
    // Encerra o monitoramento de movimento
    [m_motionManager stopAccelerometerUpdates];
    
    // Cancela todas as operações pendentes na fila
    [m_motionQueue cancelAllOperations];
    
    // Espera o encerramento das operações em andamento
    [m_motionQueue waitUntilAllOperationsAreFinished];
    
    // Libera a memória alocada para m_motionQueue
    [m_motionQueue release];
    m_motionQueue = nil;
    
    // Libera a memória alocada para m_motionManager
    [m_motionManager release];
    m_motionManager = nil;
    
    m_roll = 0.0;
}

#pragma mark - Eventos de Bussola e GPS

- (void)inicializaLocationManager{
    // inicializa a instância do location manager
    m_locationManager = [[CLLocationManager alloc]init];
    m_locationManager.delegate = self;
    
    // ajusta a precisão desejada
    m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //distancia em metros de deslocamento lateral para atualizar a localização.
    m_locationManager.distanceFilter = m_GpsFiltroDistancia;
    
    // inicia a atualização da localização
    [m_locationManager startUpdatingLocation];
    
    // verifica se o recurso da bússola está disponível
    if ([CLLocationManager headingAvailable]) {
        
        // mundança angular mínima para gerar novos eventos da bússola 
        m_locationManager.headingFilter = m_BussolaFiltroGraus;
        
        // inicia a atualização da bússola
        [m_locationManager startUpdatingHeading];
    }
    else{
        NSLog(@"Bússola não disponível");
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    // A atualização do azimuth somente ocorre quando há mudança angular de 1 grau,
    // por causa de locationManager.headingFilter = 1;
    
    // Verifica se o heading é válido. Valor negativo significa erro
    if( [newHeading headingAccuracy] < 0.00 ){
        NSLog(@"Leitura da bussola invalida!");
        return;
    }
    
    // obtém o norte verdadeiro
    m_azimuth = [newHeading trueHeading];
}


// Atualiza a situação dos pontos de interesse em relação à coordenada da câmera
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    // realinha os pontos de interesse com a nova localização
    [self atualizaPontosInteresse:newLocation];
}

- (void)atualizaPontosInteresse:(CLLocation *)localizacaoDispositivo{
    float glDiametroCamera = m_glRaio * 2;
    
    float radarGeoAlcance = 500;
    float radarTelaRaio   = 75;
    
    CLLocation *poiLocation;
    for(Objeto *obj in m_arrayObjetos){
        
        // Cria um objeto de CLLocation com as coordenadas do ponto de interesse
        poiLocation = [[CLLocation alloc]initWithLatitude:obj->m_pontoInteresse.geoLat longitude:obj->m_pontoInteresse.geoLon];
        
        // Verifica se está numa distância aceitável
        
        // obtem a distância
        CLLocationDistance distance = [localizacaoDispositivo distanceFromLocation:poiLocation];
        obj->m_geoDistancia = distance;
        
        // libera a memória alocada para poiLocation
        [poiLocation release];
        
        // Guarda se o POI está muito longe e portanto, fora da tela do dispositivo.
        obj->m_foraTela = abs(obj->m_geoDistancia) > m_geoAlcance;
        
        if(obj->m_foraTela)
            continue;
        
        // obtem o ângulo entre o dispositivo e o POI
        double deltaLat = obj->m_pontoInteresse.geoLat - localizacaoDispositivo.coordinate.latitude;
        double deltaLon = obj->m_pontoInteresse.geoLon - localizacaoDispositivo.coordinate.longitude;
        
        double rAngulo = atan(deltaLon / deltaLat);
        if (deltaLat < 0) { // 2 ou 3 quadrante ajusta.
            rAngulo -= M_PI;
        }
        
        // Guarda seno e conseno do ângulo.
        double anguloSin = sin(rAngulo);
        double anguloCos = cos(rAngulo);
        
        // Cálculos do radar.
        {
            // Verifica se está muito distante a ponto de não pintar no radar.
            bool foraRadar = abs(obj->m_geoDistancia) >= radarGeoAlcance;
            
            // Guarda a posição do ponto em miniatura dentro do radar.
            if (foraRadar) {
                obj->m_foraRadar = true;
                obj->m_glRadarX = NAN;
                obj->m_glRadarY = NAN;
            }
            else {
                obj->m_foraRadar = false;
                double telaDistancia = obj->m_geoDistancia / radarGeoAlcance * radarTelaRaio;
                obj->m_glRadarX = (float) (telaDistancia * anguloSin);
                obj->m_glRadarY = (float) (telaDistancia * anguloCos);
            }
        }
        
        // Guarda o ângulo pois vai usar na seta e no objeto.
        obj->m_glAngulo = rAngulo * 180 / M_PI;//(float) toDegrees(rAngulo);
        
        // Guarda a posição da seta no gl.
        obj->m_glSetaX = (float) (glDiametroCamera * anguloSin); // Usa o dobro pois o ponto da seta È o seu centro,
        obj->m_glSetaY = (float) (glDiametroCamera * anguloCos); // assim fica com um círculo no centro.
        obj->m_glSetaZ = -8.0f;
        
        // Guarda a posção do painel no gl.
        obj->m_glObjetoX = (float) (m_distanciaObjetoCamera * anguloSin);
        obj->m_glObjetoY = (float) (m_distanciaObjetoCamera * anguloCos);
        obj->m_glObjetoZ = -3.0f;
    }
}

- (void)finalizaLocationManager{
    // Encerra o polling de eventos da bússola
    [m_locationManager stopUpdatingHeading];
    
    // Encerra o polling de eventos de localização
    [m_locationManager stopUpdatingLocation];
    
    // Libera a memória alocada para o location manager
    [m_locationManager release];
    m_locationManager = nil;
}


@end
