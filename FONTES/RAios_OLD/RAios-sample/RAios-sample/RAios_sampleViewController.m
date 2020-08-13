//
//  RAios_sampleViewController.m
//  RAios-sample
//
//  Created by Paulo Cesar Meurer on 11/7/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import "RAios_sampleViewController.h"
#import "ConfigViewController.h"
#import "PontoInteresseSemText.h"

@implementation RAios_sampleViewController

- (void)dealloc
{
    // finaliza a realidade aumentada
    [m_RAios arEnd];
    [m_RAios release];
    
    // libera a tela de ferramentas
    [m_ferramentasView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    m_RAios = nil;
    m_ferramentasView = nil;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.exclusiveTouch = NO;
    
    // Inicializa a engine
    m_RAios = [[RAios alloc]init];
    
    // Guarda as dimensões da tela
    m_fViewHeight = CGRectGetHeight(self.view.bounds);
    m_fViewWidth = CGRectGetWidth(self.view.bounds);
    
    // Rotaciona a view para landscapeRight
    m_originalTransform = self.view.transform;
}
- (IBAction)onButtonRealidadeAumentada:(id)sender{
    
    // Rotaciona a view para portrait
    self.view.frame = CGRectMake(0, 0, m_fViewHeight, m_fViewWidth);
    self.view.center = CGPointMake(m_fViewWidth/2.0, m_fViewHeight/2.0); 
    m_originalTransform = self.view.transform;
    CGAffineTransform  transform = CGAffineTransformRotate(m_originalTransform, -(M_PI / 2.0));
    self.view.transform = transform;
    m_originalTransform = transform;
    
    // Inicializa a biblioteca
    [m_RAios arInit:self.view];
    
    // configura a captura de vídeo
    [m_RAios arVideoCapConfigFrameRate:CMTimeMake(1,30)];
    [m_RAios arVideoCapConfigVideoQuality:AVCaptureSessionPresetMedium];
    
    // inicia a captura de vídeo
    [m_RAios arVideoCapStart];
    
    // configura o acelerômetro
    [m_RAios arMotionConfigAccelUpdateFrequency:50.0];
    [m_RAios arMotionConfigGravityFilterFactor:0.1];
    
    // configura o GPS e a Bussola
    int distAtuGPS = [[NSUserDefaults standardUserDefaults] integerForKey:@"atuGPS"];
    int distMaxObjetos = [[NSUserDefaults standardUserDefaults] integerForKey:@"distPOI"];    
    [m_RAios arLocationConfigFiltroBussola:0.0];
    [m_RAios arLocationConfigDistanciaMaximaObjeto:distMaxObjetos];
    [m_RAios arLocationConfigFiltroDistanciaGPS:distAtuGPS];
    
    // configura os parametros para desenho
    [m_RAios arDrawConfigRaioDesenhoObjeto:1.5];
    [m_RAios arDrawConfigDistanciaObjetoTela:14.0];
    [m_RAios arDrawConfigHabilitarFPS:[[NSUserDefaults standardUserDefaults]boolForKey:@"fps"]];
    [m_RAios arDrawConfigHabilitarTexturas:[[NSUserDefaults standardUserDefaults]boolForKey:@"textura"]];
    
    // inicia a captura de movimento
    [m_RAios arMotionStart];
    
    // inicia a captura das coordenadas GPS
    [m_RAios arLocationStart];
    
    int iNumObjetos = [[NSUserDefaults standardUserDefaults]integerForKey:@"numObjetos"];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"textura"]){            
        PontoInteresse *eisenbahn; 
        for(int i=0; i<iNumObjetos; i++){
            eisenbahn = [[PontoInteresse alloc]initWithDescricao:@"ObjSimulado" latitude:-26.893395 longitude:-49.126386];
            [m_RAios arInsertObject:eisenbahn];
            [eisenbahn release];
        }
        
        PontoInteresse *shopping;
        
        for(int i=0; i<1; i++){
            shopping = [[PontoInteresse alloc]initWithDescricao:@"Shopping" latitude:-26.919700 longitude:-49.069400];
            [m_RAios arInsertObject:shopping];
            [shopping release];
        }
    }
    else{
        PontoInteresseSemText *eisenbahn; 
        for(int i=0; i<iNumObjetos; i++){
            eisenbahn = [[PontoInteresseSemText alloc]initWithDescricao:@"ObjSimulado" latitude:-26.893395 longitude:-49.126386];
            [m_RAios arInsertObject:eisenbahn];
            [eisenbahn release];
        }
        
        PontoInteresseSemText *shopping;
        
        for(int i=0; i<1; i++){
            shopping = [[PontoInteresseSemText alloc]initWithDescricao:@"Shopping" latitude:-26.919700 longitude:-49.069400];
            [m_RAios arInsertObject:shopping];
        }
    }
    
    // inicia o desenho dos objetos
    [m_RAios arDrawStart];
    
    // layer controles
     m_ferramentasView = [[FerramentasView alloc]initWithFrame:CGRectMake(0, 0, m_fViewWidth, m_fViewHeight) toolkit:m_RAios];
     m_ferramentasView.backgroundColor = [UIColor clearColor];
     [self.view addSubview:m_ferramentasView];
     [m_ferramentasView release];
}

- (IBAction)onButtonConfiguracao:(id)sender{
    ConfigViewController *controller = [[ConfigViewController alloc]
                                        initWithNibName:@"ConfigViewController" bundle:nil];
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    m_ferramentasView = nil;
    
    [m_RAios arEnd];
    m_RAios = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    // Rotaciona a view para landscapeRight 
    self.view.frame = CGRectMake(0, 0, m_fViewHeight, m_fViewWidth);
    self.view.center = CGPointMake(m_fViewWidth/2.0, m_fViewHeight/2.0);
    CGAffineTransform  transform = CGAffineTransformRotate(m_originalTransform, (M_PI / 2.0));
    self.view.transform = transform;
}

@end
