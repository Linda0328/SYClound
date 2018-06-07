//
//  SYScanViewController.m
//  SYMerchantsApp
//
//  Created by 文清 on 2016/10/29.
//
//

#import "SYScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HexColor.h"
#import "SYCSystem.h"
#import "UILabel+SYCNavigationTitle.h"
#import "SYCShareVersionInfo.h"
#import "UIImage+SYColorExtension.h"
#import "ZXingObjC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
@interface SYScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,CAAnimationDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    CALayer *_scanLayer;
    UIView *_boxView;
}
@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
@end

@implementation SYScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    UIColor *color = [UIColor colorWithHexString:@"458DEF"];
//    UINavigationBar *bar = [UINavigationBar appearance];
//    UIImage *imageOrigin = [UIImage imageNamed:@"navBarBG"];
//    UIImage *imageBG = [imageOrigin image:imageOrigin withColor:color];
//    [bar setBackgroundImage:imageBG forBarMetrics:UIBarMetricsDefault];
//    [bar setShadowImage:[[UIImage alloc]init]];
    UILabel *titleLab = [UILabel navTitle:@"扫一扫" TitleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:20]];
    self.navigationItem.titleView = titleLab;
    
    UIImage *image = [UIImage imageNamed:@"ps_left_back"];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width+20*[SYCSystem PointCoefficient], image.size.height+5*[SYCSystem PointCoefficient])];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = @[item,negativeSpacer];

//    UIImage *Image = [UIImage imageNamed:@"scanImage"];
    UIButton *ScanImageB = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60*[SYCSystem PointCoefficient], 40*[SYCSystem PointCoefficient])];
//    [ScanImageB setImage:Image forState:UIControlStateNormal];
    [ScanImageB setTitle:@"相册" forState:UIControlStateNormal];
    [ScanImageB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ScanImageB addTarget:self action:@selector(ScanPictureFromPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ImageItem = [[UIBarButtonItem alloc]initWithCustomView:ScanImageB];
    self.navigationItem.rightBarButtonItems = @[ImageItem];
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    CGFloat width = CGRectGetWidth(self.view.frame);
//    CGFloat height = CGRectGetHeight(self.view.frame);
    //CGrectmake()四个值都是0-1的范围，而且与一般的rect对应不同，x、y是互相的，width、height也会互相的
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGRect rect = CGRectMake(0.1*width, 0.3*height-(isIphoneX?88:64), width * 0.8f, height * 0.4f);
    [_output setRectOfInterest:CGRectMake(0.3-(isIphoneX?88:64)/height, 0.1, 0.4, 0.8)];
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    //直接输入和输出
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    //设置条码类型
    _output.metadataObjectTypes = @[AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    
    //添加扫描画面
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    //扫描框
    _boxView = [[UIView alloc] initWithFrame:rect];
//    _boxView.center = self.view.center;
    _boxView.layer.borderColor = [UIColor whiteColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    [self.view addSubview:_boxView];
    
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor colorWithHexString:@"c59d5f"].CGColor;
    [_boxView.layer addSublayer:_scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    //开始扫描
    [_session startRunning];
}
- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.05f animations:^{
            _scanLayer.frame = frame;
        }];
    }
}
-(void)backToLast{
    if (_isFromRegister) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue = nil;
    if ([metadataObjects count]>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if (_block) {
            _block(stringValue);
        }
        _lastMain.scanResult = stringValue;
        [SYCShareVersionInfo sharedVersion].scanResult = stringValue;
        [self performSelector:@selector(backToLast) withObject:nil afterDelay:1.0];
    }

}
-(void)ScanPictureFromPhotoAlbum{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.mode = MBProgressHUDModeText;
    //判断是否已授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusDenied) {
            hud.label.text = @"请前往设置打开访问相册权限";
            [hud showAnimated:YES];
            [hud hideAnimated:NO afterDelay:1.2];
            return;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        hud.label.text = @"您没有图片";
        [hud showAnimated:YES];
        [hud hideAnimated:NO afterDelay:1.2];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{
        [self getInfoWithImage:newPhoto];
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    [animationMove setFromValue:fromY];
    
    [animationMove setToValue:toY];
    
    animationMove.duration = time;
    
    animationMove.delegate = self;
    
    animationMove.repeatCount  = rep;
    
    animationMove.fillMode = kCAFillModeForwards;
    
    animationMove.removedOnCompletion = NO;
    
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animationMove;
    
}
-(void)getInfoWithImage:(UIImage*)image{
    UIImage *loadImage = image;
    CGImageRef imageToDecode = loadImage.CGImage;
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc]initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitMap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    NSError *error = nil;
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitMap hints:hints error:&error];
    if (result) {
        NSString *contents = result.text;
        if (_block) {
            _block(contents);
        }
        _lastMain.scanResult = contents;
        [SYCShareVersionInfo sharedVersion].scanResult = contents;
        [self performSelector:@selector(backToLast) withObject:nil afterDelay:1.0];
    }else{
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"图片解析失败";
        [hud showAnimated:YES];
        [hud hideAnimated:NO afterDelay:1.2];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
