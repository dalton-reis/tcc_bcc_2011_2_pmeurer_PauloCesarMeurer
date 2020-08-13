//
//  ConfigViewController.m
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 9/13/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import "ConfigViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation ConfigViewController
@synthesize labelSliderDistanciaPOI;
@synthesize labelSliderDistanciaAtuGPS;
@synthesize sliderDistanciaPOI;
@synthesize sliderDistanciaAtuGPS;
@synthesize switchFPS;
@synthesize switchTextura;
@synthesize textObjetosSimu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [labelSliderDistanciaAtuGPS release];
    [labelSliderDistanciaPOI release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self carregarConfiguracao];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onButtonSalvar:(id)sender{
    [self salvarConfiguracao];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sliderPOIChanged:(id)sender{
    UISlider *slider = (UISlider *)sender;
    int progressAsInt = (int)(slider.value + 0.5f);
    NSString *newText = [[NSString alloc]initWithFormat:@"%dm", progressAsInt];
    labelSliderDistanciaPOI.text = newText;
    [newText release];
}

- (IBAction)sliderGPSChanged:(id)sender{
    UISlider *slider = (UISlider *)sender;
    int progressAsInt = (int)(slider.value + 0.5f);
    NSString *newText = [[NSString alloc]initWithFormat:@"%dm", progressAsInt];
    labelSliderDistanciaAtuGPS.text = newText;
    [newText release];
}
- (IBAction) backgroundTap:(id)sender{
    [textObjetosSimu resignFirstResponder];
}

- (void)salvarConfiguracao{
    int progressAsInt = 0;
    
    // distância para atualização do GPS
    progressAsInt = (int)(sliderDistanciaAtuGPS.value + 0.5f);
    [[NSUserDefaults standardUserDefaults] setInteger:progressAsInt forKey:@"atuGPS"];
    
    // distância máxima dos pontos de interesse
    progressAsInt = (int)(sliderDistanciaPOI.value + 0.5f);
    [[NSUserDefaults standardUserDefaults] setInteger:progressAsInt forKey:@"distPOI"];
    
    // Profile FPS
    BOOL bFPS = switchFPS.on;
    [[NSUserDefaults standardUserDefaults]setBool:bFPS forKey:@"fps"];
    
    // Profile Textura
    BOOL bTextura = switchTextura.on;
    [[NSUserDefaults standardUserDefaults]setBool:bTextura forKey:@"textura"];
    
    // Profile objetos simulados
    [[NSUserDefaults standardUserDefaults]setInteger:[textObjetosSimu.text intValue] forKey:@"numObjetos"];
}

- (void)carregarConfiguracao{
    BOOL bValue;
    int progressAsInt = 0;
    NSString *texto = nil;
    
    // distância para atualização do GPS
    progressAsInt = [[NSUserDefaults standardUserDefaults] integerForKey:@"atuGPS"];
    sliderDistanciaAtuGPS.value = progressAsInt;
    texto = [[NSString alloc]initWithFormat:@"%dm", progressAsInt];
    labelSliderDistanciaAtuGPS.text = texto;
    [texto release];
    
    // distância máxima dos pontos de interesse
    progressAsInt = [[NSUserDefaults standardUserDefaults] integerForKey:@"distPOI"];
    sliderDistanciaPOI.value = progressAsInt;
    texto = [[NSString alloc]initWithFormat:@"%dm", progressAsInt];
    labelSliderDistanciaPOI.text = texto;
    [texto release];
    
    // Profile FPS
    bValue = [[NSUserDefaults standardUserDefaults]boolForKey:@"fps"];
    switchFPS.on = bValue;
    
    // Profile Textura
    bValue = [[NSUserDefaults standardUserDefaults]boolForKey:@"textura"];
    switchTextura.on = bValue;
    
    // Profile objetos simulados
    texto = [[NSString alloc]initWithFormat:@"%d", [[NSUserDefaults standardUserDefaults]integerForKey:@"numObjetos"]];
    textObjetosSimu.text = texto;
    [texto release];
}

@end
