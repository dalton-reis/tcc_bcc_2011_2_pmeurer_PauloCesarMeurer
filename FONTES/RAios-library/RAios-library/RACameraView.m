/*!
 *  RACameraView.m
 *  FURB RA
 *
 *  Created by Paulo Cesar Meurer on 8/9/11.
 */

#import "RACameraView.h"

@implementation RACameraView

#pragma mark -
#pragma mark Inicialização

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //m_imageView = nil;
        m_prevLayer = nil;
        m_captureSession = nil;
        m_parentView = nil;
        
        // configuração default do vídeo
        m_raCameraFrameRate = CMTimeMake(1, 30);
        m_raCameraQualidadeCaptura = AVCaptureSessionPresetMedium;
    }
    return self;
}

- (void)initCapture:(UIView*)parentView{
    //developer.apple.com/library/mac/#documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/04_MediaCapture.html
    //developer.apple.com/library/ios/#documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/00_Introduction.html
    //developer.apple.com/library/ios/#documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/03_MediaCapture.html#//apple_ref/doc/uid/TP40010188-CH5-SW2
    
    m_parentView = parentView;
    
    // Configura a captura de dados da câmera
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
    
    if(!captureInput){
        NSLog(@"Erro ao criar o dispositivo de captura de video.");
        return;
    }
    
    // Configura o processamento dos frames de vídeo que estão sendo capturados
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc]init];
    
    if(!captureOutput){
        NSLog(@"Erro ao criar o dispositivo de saída de video.");
        return;
    }
    
    // Evita que outros frames sejam adicionados na fila enquando um frame estiver sendo
    // processado pelo delegate -captureOutput:didOutputSampleBuffer:fromConnection:
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    // Duração mínima para cada frame. framerate máximo de 60fps.
    captureOutput.minFrameDuration = m_raCameraFrameRate;//CMTimeMake(1, 60);
    
    // Fila para manipular o processamento dos frames
    /*dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);*/
    
    // Configura a saída de vídeo para armazenar o frame em BRGA (mais rápido)
    NSString *key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    // inicializa a seção de captura
    m_captureSession = [[AVCaptureSession alloc]init];
    
    // configura a qualidade da captura
    [m_captureSession setSessionPreset:m_raCameraQualidadeCaptura];
    
    // adiciona a entrada e saída
    if([m_captureSession canAddInput:captureInput])
        [m_captureSession addInput:captureInput];
    
    if([m_captureSession canAddOutput:captureOutput])
        [m_captureSession addOutput:captureOutput];
    
    // libera a memória alocada
    [captureOutput release];
    
    // Adiciona o layer responsável pela exibição do vídeo
    m_prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:m_captureSession];
    m_prevLayer.frame = parentView.bounds;
    m_prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [parentView.layer addSublayer:m_prevLayer];
    
    // Adiciona o UIImageView como sublayer do parentView
    //m_imageView = [[UIImageView alloc]init];
    //m_imageView.frame = parentView.bounds;
    //[parentView.layer addSublayer:m_imageView.layer];
    
    // Inicia a captura de vídeo
    [m_captureSession startRunning];
}

#pragma mark -
#pragma mark AVCaptureSession delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    // Exemplo da Apple:
    // UIImage *image = imageFromSampleBuffer(sampleBuffer);
    
    /*/ Cria um autorelease pool, pois este código não está sendo executado na thread principal
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    uint8_t *baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    // Libera o contexto e o color space
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    // Inverte a orientação da imagem para mostrar corretamente
    UIImage *image = [UIImage imageWithCGImage:newImage];
    //UIImage *image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    
    CGImageRelease(newImage);
    
    // Operações de exibição deve ser executadas na thread principal
    //[m_imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
    
    
    [pool drain];*/
}

- (void)stopCapture{
    
    // encerra a sessão de captura
    if(m_captureSession){
        if([m_captureSession isRunning])
            [m_captureSession stopRunning];
        
        [m_captureSession release];
        m_captureSession = nil;
    }
    
    // remove o layer da view superior
    if(m_prevLayer){
        [m_prevLayer removeFromSuperlayer]; // esta mensagem decrementa o retain count
        m_prevLayer = nil;
     }
    
    // libera a memória alocada para UIImageView
    /*if(m_imageView){
        [m_imageView.layer removeFromSuperlayer];
        m_imageView.image = nil;
        [m_imageView release];
        m_imageView = nil;
    }*/
}

#pragma mark -
#pragma mark Gerenciamento de memória

- (void)dealloc
{
    [self stopCapture];
    
    [super dealloc];
}
@end
