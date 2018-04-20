//
//  ZSSRichTextEditorViewController.m
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 11/30/13.
//  Copyright (c) 2013 Zed Said Studio. All rights reserved.
//
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "ZSSRichTextEditor.h"
#import "ZSSTextView.h"
#import <AVFoundation/AVFoundation.h>

#import "TZImagePickerController.h"


@import JavaScriptCore;


/**
 
 UIWebView modifications for hiding the inputAccessoryView
 
 **/
@interface UIWebView (HackishAccessoryHiding)
@property (nonatomic, assign) BOOL hidesInputAccessoryView;
@end

@implementation UIWebView (HackishAccessoryHiding)

static const char * const hackishFixClassName = "UIWebBrowserViewMinusAccessoryView";
static Class hackishFixClass = Nil;

- (UIView *)hackishlyFoundBrowserView {
    UIScrollView *scrollView = self.scrollView;
    
    UIView *browserView = nil;
    for (UIView *subview in scrollView.subviews) {
        if ([NSStringFromClass([subview class]) hasPrefix:@"UIWebBrowserView"]) {
            browserView = subview;
            break;
        }
    }
    return browserView;
}

- (id)methodReturningNil {
    return nil;
}

- (void)ensureHackishSubclassExistsOfBrowserViewClass:(Class)browserViewClass {
    if (!hackishFixClass) {
        Class newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        IMP nilImp = [self methodForSelector:@selector(methodReturningNil)];
        class_addMethod(newClass, @selector(inputAccessoryView), nilImp, "@@:");
        objc_registerClassPair(newClass);
        
        hackishFixClass = newClass;
    }
}

- (BOOL) hidesInputAccessoryView {
    UIView *browserView = [self hackishlyFoundBrowserView];
    return [browserView class] == hackishFixClass;
}

- (void) setHidesInputAccessoryView:(BOOL)value {
    UIView *browserView = [self hackishlyFoundBrowserView];
    if (browserView == nil) {
        return;
    }
    [self ensureHackishSubclassExistsOfBrowserViewClass:[browserView class]];
    
    if (value) {
        object_setClass(browserView, hackishFixClass);
    }
    else {
        Class normalClass = objc_getClass("UIWebBrowserView");
        object_setClass(browserView, normalClass);
    }
    [browserView reloadInputViews];
}

@end


@interface ZSSRichTextEditor ()<TZImagePickerControllerDelegate>


@property (nonatomic, strong) UIScrollView *toolScroll;

@property (nonatomic,strong) UIView *toolView;
/*
 *  Scroll view containing the toolbar
 */
@property (nonatomic, strong) UIScrollView *toolBarScroll;

/*
 *  Toolbar containing ZSSBarButtonItems
 */
@property (nonatomic, strong) UIToolbar *toolbar;

/*
 *  Holder for all of the toolbar components
 */
@property (nonatomic, strong) UIView *toolbarHolder;

/*
 *  String for the HTML
 */
@property (nonatomic, strong) NSString *htmlString;

/*
 *  CGRect for holding the frame for the editor view
 */
@property (nonatomic) CGRect editorViewFrame;

/*
 *  BOOL for holding if the resources are loaded or not
 */
@property (nonatomic) BOOL resourcesLoaded;

/*
 *  Array holding the enabled editor items
 */
@property (nonatomic, strong) NSArray *editorItemsEnabled;

/*
 *  Alert View used when inserting links/images
 */
@property (nonatomic, strong) UIAlertView *alertView;

/*
 *  NSString holding the selected links URL value
 */
@property (nonatomic, strong) NSString *selectedLinkURL;

/*
 *  NSString holding the selected links title value
 */
@property (nonatomic, strong) NSString *selectedLinkTitle;

/*
 *  NSString holding the selected image URL value
 */
@property (nonatomic, strong) NSString *selectedImageURL;

/*
 *  NSString holding the selected image Alt value
 */
@property (nonatomic, strong) NSString *selectedImageAlt;

/*
 *  CGFloat holdign the selected image scale value
 */
@property (nonatomic, assign) CGFloat selectedImageScale;

/*
 *  NSString holding the base64 value of the current image
 */
@property (nonatomic, strong) NSString *imageBase64String;

/*
 *  Bar button item for the keyboard dismiss button in the toolbar
 */
@property (nonatomic, strong) UIBarButtonItem *keyboardItem;

/*
 *  Array for custom bar button items
 */
@property (nonatomic, strong) NSMutableArray *customBarButtonItems;

/*
 *  Array for custom ZSSBarButtonItems
 */
@property (nonatomic, strong) NSMutableArray *customZSSBarButtonItems;

/*
 *  NSString holding the html
 */
@property (nonatomic, strong) NSString *internalHTML;

/*
 *  NSString holding the css
 */
@property (nonatomic, strong) NSString *customCSS;




/*
 *  Image Picker for selecting photos from users photo library
 */
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic,strong) NSMutableArray *imageURLArry;

@property (nonatomic,strong) UIButton *boldBtn;

@property (nonatomic,strong) UIButton *ItalicBtn;

@property (nonatomic,strong) UIButton *h1Btn;

@property (nonatomic,strong) UIButton *h2Btn;

@property (nonatomic,strong) UIButton *h3Btn;

@property (nonatomic,strong) UIButton *h4Btn;

@end
/*
 
 ZSSRichTextEditor
 
 */
@implementation ZSSRichTextEditor

static CGFloat kDefaultScale = 0.5;
#pragma mark - View Did Load Section
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.imageURLArry = [NSMutableArray array];

    self.view.backgroundColor = [UIColor whiteColor];
    //Initalise enabled toolbar items array
    
    //Frame for the source view and editor view
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    //Editor View
    [self createEditorViewWithFrame:frame];
    
    [self setUpImagePicker];
    
    
    [self creatCustomToolView];
    
    //Load Resources
    if (!self.resourcesLoaded) {
        
        [self loadResources];
        
    }
    
   

}

#pragma mark - 自定义工具栏
- (void)creatCustomToolView {
    
    self.toolView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
    [self.view addSubview:self.toolView];
    self.toolView.backgroundColor = UIColorFromRGB(249, 249, 249, 1);
    UIButton *keyboardBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44)];
    [keyboardBtn setImage:[UIImage imageNamed:@"ZSSkeyboard.png"] forState:UIControlStateNormal];
    [self.toolView addSubview:keyboardBtn];
    [keyboardBtn bk_whenTapped:^{
        [self.view endEditing:YES];
    }];
    
    self.toolScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 44, 44)];
    self.toolScroll.backgroundColor = UIColorFromRGB(249, 249, 249, 1);
    self.toolScroll.contentSize = CGSizeMake(390+100, 0);
    self.toolScroll.showsHorizontalScrollIndicator = NO;
    
    for (int i=0; i<10; i++) {
        
        CGRect rect = CGRectMake(10+i*44+i*5, 0, 44, 44);
       
        
        
        switch (i) {
            case 0: {
                 WEAK_SELF(self);
                UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(10+i*44+i*5, 0, 44, 44)];
                clickBtn.tag = i;
                [clickBtn bk_whenTapped:^{
                    STRONG_SELF(self);
                    [self undo];
                }];
                [clickBtn setImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
                [self.toolScroll addSubview:clickBtn];
                
            }
                break;
            case 1: {
                UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(10+i*44+i*5, 0, 44, 44)];
                clickBtn.tag = i;
                 WEAK_SELF(self);
                [clickBtn bk_whenTapped:^{
                    STRONG_SELF(self);
                    [self redo];
                }];
                [clickBtn setImage:[UIImage imageNamed:@"redo"] forState:UIControlStateNormal];
                [self.toolScroll addSubview:clickBtn];
                
            }
                break;
            case 2: {
                
                self.boldBtn = [[UIButton alloc]init];
                self.boldBtn.frame = rect;
                self.boldBtn.tag = i;
                WEAK_SELF(self);
                [self.boldBtn bk_whenTapped:^{
                    STRONG_SELF(self);
                    self.boldBtn.selected = !self.boldBtn.selected;
                    [self setBold];
                }];
                UIImage *img = [UIImage imageNamed:@"bold"];
                UIImage *selectimg = [UIImage imageNamed:@"bold_selected"];
                [self.boldBtn setImage:img forState:UIControlStateNormal];
                [self.boldBtn setImage:selectimg forState:UIControlStateSelected];
                [self.toolScroll addSubview:self.boldBtn];
                
            }
                break;
            case 3: {
                
                self.ItalicBtn = [[UIButton alloc]init];
                self.ItalicBtn.frame = rect;
                self.ItalicBtn.tag = i;
                 WEAK_SELF(self);
                [self.ItalicBtn bk_whenTapped:^{
                    STRONG_SELF(self);
                    [self setItalic];
                    self.ItalicBtn.selected = !self.ItalicBtn.selected;
                }];
                UIImage *img = [UIImage imageNamed:@"italic"];
                UIImage *selectimg = [UIImage imageNamed:@"italic_selected"];
                [self.ItalicBtn setImage:img forState:UIControlStateNormal];
                [self.ItalicBtn setImage:selectimg forState:UIControlStateSelected];
                [self.toolScroll addSubview:self.ItalicBtn];
                
            }
                break;
            case 4: {
                
                UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(10+i*44+i*5, 0, 44, 44)];
                clickBtn.tag = i;
                WEAK_SELF(self);
                [clickBtn bk_whenTapped:^{
                    STRONG_SELF(self);
                    [self insertImage];
                }];
                UIImage *img = [UIImage imageNamed:@"insert_image"];
                [clickBtn setImage:img forState:UIControlStateNormal];
                [self.toolScroll addSubview:clickBtn];
            }
                break;
            case 5: {
                
                self.h1Btn = [[UIButton alloc]init];
                self.h1Btn.frame = rect;
                self.h1Btn.tag = i;
                WEAK_SELF(self);
                [ self.h1Btn bk_whenTapped:^{
                    STRONG_SELF(self);
                    [self heading1];
                    [self reloadHeading: self.h1Btn];
                }];
                
                UIImage *img = [UIImage imageNamed:@"h1"];
                UIImage *selectimg = [UIImage imageNamed:@"h1_selected"];
                [ self.h1Btn setImage:img forState:UIControlStateNormal];
                [ self.h1Btn setImage:selectimg forState:UIControlStateSelected];
                [self.toolScroll addSubview:self.h1Btn];
            }
                break;
            case 6: {
                
                self.h2Btn = [[UIButton alloc]init];
                self.h2Btn.frame = rect;
                self.h2Btn.tag = i;
                WEAK_SELF(self);
                [self.h2Btn bk_whenTapped:^{
                    STRONG_SELF(self);
                    [self heading2];
                    [self reloadHeading:self.h2Btn];
                }];
                
                UIImage *img = [UIImage imageNamed:@"h2"];
                UIImage *selectimg = [UIImage imageNamed:@"h2_selected"];
                [self.h2Btn setImage:img forState:UIControlStateNormal];
                [self.h2Btn setImage:selectimg forState:UIControlStateSelected];
                [self.toolScroll addSubview:self.h2Btn];
                
                
            }
                break;
            case 7: {
                
                self.h3Btn = [[UIButton alloc]init];
                self.h3Btn.frame = rect;
                self.h3Btn.tag = i;
                WEAK_SELF(self);
                [self.h3Btn bk_whenTapped:^{
                    STRONG_SELF(self);
                    [self heading3];
                    [self reloadHeading:self.h3Btn];
                }];
                
                UIImage *img = [UIImage imageNamed:@"h3"];
                UIImage *selectimg = [UIImage imageNamed:@"h3_selected"];
                [self.h3Btn setImage:img forState:UIControlStateNormal];
                [self.h3Btn setImage:selectimg forState:UIControlStateSelected];
                [self.toolScroll addSubview:self.h3Btn];
                
                
            }
                break;
            case 8: {
                
                self.h4Btn = [[UIButton alloc]init];
                self.h4Btn.tag = i;
                self.h4Btn.frame = rect;
                WEAK_SELF(self);
                [self.h4Btn bk_whenTapped:^{
                    STRONG_SELF(self);
                    [self heading4];
                    [self reloadHeading:self.h4Btn];
                }];
                
                UIImage *img = [UIImage imageNamed:@"h4"];
                UIImage *selectimg = [UIImage imageNamed:@"h4_selected"];
                [self.h4Btn setImage:img forState:UIControlStateNormal];
                [self.h4Btn setImage:selectimg forState:UIControlStateSelected];
                [self.toolScroll addSubview:self.h4Btn];
                
                
            }
                break;
            case 9: {
                
                UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(10+i*44+i*5, 0, 44, 44)];
                clickBtn.tag = i;
                WEAK_SELF(self);
                [clickBtn bk_whenTapped:^{
                    STRONG_SELF(self);
                    [self setHR];
                }];
                UIImage *img = [UIImage imageNamed:@"image_xiezuo_line_19"];
                [clickBtn setImage:img forState:UIControlStateNormal];
                [self.toolScroll addSubview:clickBtn];
                
            }
                break;
            default:
                break;
        }
    }

    [self.toolView addSubview:self.toolScroll];
    
    
}



- (void)reloadHeading:(UIButton *)senderBtn {
    
    for (id object in self.toolScroll.subviews) {
        if ([object isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)object;
            if (btn.tag >=5 && btn.tag<=8) {
                if (btn.tag == senderBtn.tag) {
                    
                    if (btn.isSelected) {
                        btn.selected = NO;
                    }else {
                        btn.selected = YES;
                    }
                    
                }else {
                    btn.selected = NO;
                }
            }
        }
    }
}

- (void)undo {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.undo();"];
}

- (void)redo {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.redo();"];
}

#pragma mark - View Will Appear Section
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //Add observers for keyboard showing or hiding notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - View Will Disappear Section
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //Remove observers for keyboard showing or hiding notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - Set Up View Section
- (void)createEditorViewWithFrame:(CGRect)frame {
    
    self.editorScrollView = [[UIScrollView alloc]initWithFrame:frame];
    [self.editorScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.editorScrollView];

    
    self.editorView = [[UIWebView alloc] initWithFrame:frame];
    self.editorView.delegate = self;
    self.editorView.hidesInputAccessoryView = YES;
    self.editorView.keyboardDisplayRequiresUserAction = NO;
    self.editorView.scalesPageToFit = YES;
    self.editorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.editorView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.editorView.scrollView.bounces = NO;
    self.editorView.backgroundColor = [UIColor whiteColor];
    [self.editorScrollView addSubview:self.editorView];
    
    
}

- (void)setUpImagePicker {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = YES;
    self.selectedImageScale = kDefaultScale; //by default scale to half the size
    
}


#pragma mark - Resources Section

- (void)loadResources {
    
    //Define correct bundle for loading resources
    NSBundle* bundle = [NSBundle bundleForClass:[ZSSRichTextEditor class]];
    
    //Create a string with the contents of editor.html
    NSString *filePath = [bundle pathForResource:@"RichEditor" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    //Add jQuery.js to the html file
    NSString *jquery = [bundle pathForResource:@"richEditor" ofType:@"js"];
    NSString *jqueryString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:jquery] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- richEditor_js -->" withString:jqueryString];
    
    NSString *Css = [bundle pathForResource:@"richEditor" ofType:@"css"];
    NSString *cssString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:Css] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- richEditor_css -->" withString:cssString];
    
    NSString *editorcss = [bundle pathForResource:@"richEditor_page" ofType:@"css"];
    NSString *editorString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:editorcss] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- richEditor_page -->" withString:editorString];
    
    NSString *underscoreminCss = [bundle pathForResource:@"jquery-1.10.2.min" ofType:@"js"];
    NSString *underscoreminCssString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:underscoreminCss] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- jquery-1.10.2.min -->" withString:underscoreminCssString];
    
    
    [self.editorView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@""]];
    self.resourcesLoaded = YES;

    
}

#pragma mark - Editor Modification Section
- (NSString *)getText {
    
    return [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.getText();"];
    
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)removeFormat {
    NSString *trigger = @"RE.removeFormating();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)alignLeft {
    NSString *trigger = @"RE.setJustifyLeft();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)alignCenter {
    NSString *trigger = @"RE.setJustifyCenter();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)alignRight {
    NSString *trigger = @"RE.setJustifyRight();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)alignFull {
    NSString *trigger = @"RE.setJustifyFull();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setBold {
    NSString *trigger = @"RE.setBold();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setItalic {
    NSString *trigger = @"RE.setItalic();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setSubscript {
    NSString *trigger = @"RE.setSubscript();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setUnderline {
    NSString *trigger = @"RE.setUnderline();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setSuperscript {
    NSString *trigger = @"RE.setSuperscript();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setStrikethrough {
    NSString *trigger = @"RE.setStrikeThrough();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setUnorderedList {
    NSString *trigger = @"RE.setUnorderedList();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setOrderedList {
    NSString *trigger = @"RE.setOrderedList();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setHR {
    NSString *trigger = @"RE.insertHorizontalRule();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setIndent {
    NSString *trigger = @"RE.setIndent();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setOutdent {
    NSString *trigger = @"RE.setOutdent();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading1 {
    NSString *trigger = @"RE.setHeading('h1');";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading2 {
    NSString *trigger = @"RE.setHeading('h2');";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading3 {
    NSString *trigger = @"RE.setHeading('h3');";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading4 {
    NSString *trigger = @"RE.setHeading('h4');";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading5 {
    NSString *trigger = @"RE.setHeading('h5');";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading6 {
    NSString *trigger = @"RE.setHeading('h6');";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)paragraph {
    NSString *trigger = @"RE.setParagraph();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)undo:(ZSSBarButtonItem *)barButtonItem {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.undo();"];
}

- (void)redo:(ZSSBarButtonItem *)barButtonItem {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.redo();"];
}

- (void)insertLink:(NSString *)url title:(NSString *)title {
    
    NSString *trigger = [NSString stringWithFormat:@"RE.insertLink(\"%@\", \"%@\");", url, title];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
}


- (void)updateLink:(NSString *)url title:(NSString *)title {
    NSString *trigger = [NSString stringWithFormat:@"RE.updateLink(\"%@\", \"%@\");", url, title];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)removeLink {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.unlink();"];
}

- (void)quickLink {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.quickLink();"];
}

- (void)insertImage {
    
    // Save the selection location
    [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.prepareInsert();"];
    
    [self showInsertImageDialogWithLink:self.selectedImageURL alt:self.selectedImageAlt];
    
}

- (void)insertImageFromDevice {
    
    // Save the selection location
    [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.prepareInsert();"];
    
    [self showInsertImageDialogFromDeviceWithScale:self.selectedImageScale alt:self.selectedImageAlt];
    
}

#pragma mark - 从相册插入图片
- (void)showInsertImageDialogWithLink:(NSString *)url alt:(NSString *)alt {
    
    [self getPhotosFromLocal];
}

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    WEAK_SELF(self);
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;

    // 你可以通过block或者代理，来得到用户选择的照片.
    NSMutableArray *tempPicArray = [NSMutableArray array];
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        STRONG_SELF(self);

        if (photos.count > 0) {
            for (UIImage *image in photos) {
                //对图片进行压缩处理
                if (!isSelectOriginalPhoto) {
                    UIImage *imageCompress = [Tools compressImageWithImage:image ScalePercent:0.05];
                    [tempPicArray addObject:imageCompress];
                } else {
                    [tempPicArray addObject:image];
                }
            }
            
            [self requestUpdateImages:tempPicArray];
        }
        
    }];
    
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
    
}

#pragma mark - 批量上传图片
- (void)requestUpdateImages:(NSMutableArray *)imageArr
{
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
        for (int i = 0; i < [imageArr count]; i++) {
            UIImage *image = [imageArr objectAtIndex:i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData
                                        name:[NSString stringWithFormat:@"dynamic_picture%d",i]
                                    fileName:[NSString stringWithFormat:@"dynamic_picture%d.jpg",i]
                                    mimeType:@"multipart/form-data"];
        }
    } success:^(NSArray *imageArray) {
        
        [self dismissProgress];
        
     NSArray *imageArrysss = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
        for (BATImage *image in imageArrysss) {
            [self.imageURLArry addObject:image.url];
        }
        
        for (BATImage *image in imageArrysss) {
            if (!self.selectedImageURL) {
                
                [self insertImage:image.url alt:image.filename];
            } else {
                [self updateImage:image.url alt:image.filename];
            }
        }
       
    
    } failure:^(NSError *error) {
        
    } fractionCompleted:^(double count) {
        
        [self showProgres:count];
        
    }];
    
}

- (void)showInsertImageDialogFromDeviceWithScale:(CGFloat)scale alt:(NSString *)alt {
    
    [self getPhotosFromCamera];
    
}

#pragma mark - 从相机中获取图片
- (void)getPhotosFromCamera
{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            DDLogDebug(@"Authorized");
            break;
        case AVAuthorizationStatusDenied:
        {
            DDLogDebug(@"Denied");
            //提示开启相机
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"相机权限已关闭" message:@"请到设置->隐私->相机开启权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                
                return ;
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            break;
        case AVAuthorizationStatusNotDetermined:
            DDLogDebug(@"not Determined");
            break;
        case AVAuthorizationStatusRestricted:
            DDLogDebug(@"Restricted");
            break;
        default:
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
      //  NSLog(@"模拟器中无法打开相机，请在真机中使用");
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    NSMutableArray *imageArr = [NSMutableArray array];
    [imageArr addObject:image];
    
    [self requestUpdateImages:imageArr];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)insertImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"RE.insertImage(\"%@\", \"%@\");", url, alt];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)updateImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"RE.updateImage(\"%@\", \"%@\");", url, alt];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)insertImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"RE.insertImageBase64String(\"%@\", \"%@\");", imageBase64String, alt];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)updateImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"RE.updateImageBase64String(\"%@\", \"%@\");", imageBase64String, alt];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = [[request URL] absoluteString];
    
    if ([urlString rangeOfString:@"re-state://img_loaded"].location != NSNotFound) {
      //  NSLog(@"加载完毕");
//        if (!self.isCanEdit) {
//            
//            
//            
//            
//            self.editorView.scrollView.scrollEnabled = NO;
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"DIDFINISHLOADWEBVIEW" object:@(self.editorView.scrollView.contentSize.height)];
//            
//            
//            
//        }else {
//            
//            
//            
//            
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"DIDFINISHLOADWEBVIEW" object:nil];
//            
//            
//            
//            
//        }

    }

    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    } else if ([urlString rangeOfString:@"re-callback://"].location != NSNotFound) {
        
        // We recieved the callback
//        NSString *className = [urlString stringByReplacingOccurrencesOfString:@"re-callback://" withString:@""];
      
        
        NSString *summryString111 =  [self.editorView stringByEvaluatingJavaScriptFromString:@"RE.enabledEditingItems();"];
        
        
        if ([summryString111 rangeOfString:@"bold"].location != NSNotFound) {
            
            self.boldBtn.selected = YES;
        }else {
            self.boldBtn.selected = NO;
        }
        
        if ([summryString111 rangeOfString:@"italic"].location != NSNotFound) {
        
            self.ItalicBtn.selected = YES;
            
        }else {
        
            self.ItalicBtn.selected = NO;
        }
        
        if ([summryString111 rangeOfString:@"h1"].location != NSNotFound) {
            
            self.h1Btn.selected = YES;
            
        }else {
        
            self.h1Btn.selected = NO;
            
        }
        
        if ([summryString111 rangeOfString:@"h2"].location != NSNotFound) {
            
            self.h2Btn.selected = YES;
            
        }else {
        
            self.h2Btn.selected = NO;
        }
        
        if ([summryString111 rangeOfString:@"h3"].location != NSNotFound) {
            
            self.h3Btn.selected = YES;
            
        }else {
        
            self.h3Btn.selected = NO;
        }
        
        
        if ([summryString111 rangeOfString:@"h4"].location != NSNotFound) {
            
            self.h4Btn.selected = YES;
            
        }else {
           
            self.h4Btn.selected = NO;
        }
        
        
        
    }
    
    return YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (!self.isCanEdit) {
        
        
        
        
        self.editorView.scrollView.scrollEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DIDFINISHLOADWEBVIEW" object:@(self.editorView.scrollView.contentSize.height)];
        
        
        
    }else {
        
        
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DIDFINISHLOADWEBVIEW" object:nil];
        
        
        
        
    }
    
}

#pragma mark - Keyboard status

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Toolbar Sizes
    CGFloat sizeOfToolbar = self.toolbarHolder.frame.size.height;
    
    // Keyboard Size
    //Checks if IOS8, gets correct keyboard height
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) ? keyboardEnd.size.height : keyboardEnd.size.width : keyboardEnd.size.height;
    
    // Correct Curve
    UIViewAnimationOptions animationOptions = curve << 16;
    
    const int extraHeight = 50;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        if (self.isCanEdit == YES) {
            
            [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
                
                self.toolView.frame = CGRectMake(0, self.view.frame.size.height - keyboardEnd.size.height - 44, SCREEN_WIDTH, 44);
                // Editor View
                CGRect editorFrame = self.editorView.frame;
                editorFrame.size.height = (self.view.frame.size.height - keyboardHeight) - sizeOfToolbar - extraHeight - 5;
                self.editorView.frame = editorFrame;
                // self.editorViewFrame = self.editorView.frame;
                // self.editorScrollView.frame = editorFrame;
                [self.editorScrollView setContentSize:CGSizeZero];
                
                
            } completion:nil];
        }
       // NSLog(@"%f",SCREEN_HEIGHT);
   //     NSLog(@"%zd",SCREEN_HEIGHT-keyboardHeight);
//        page.setKeyBoardToTop
      //  [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"page.setKeyBoardToTop(\'%@\');",[NSString stringWithFormat:@"%f",SCREEN_HEIGHT-keyboardHeight]]];
        
        
        
    } else {
        
           if (self.isCanEdit == YES) {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            self.toolView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
            
            // Editor View
            CGRect editorFrame = self.editorView.frame;
            

            editorFrame.size.height = self.view.frame.size.height;
            
            
            self.editorView.frame = editorFrame;
          //  self.editorScrollView.frame = editorFrame;
            [self.editorScrollView setContentSize:CGSizeZero];
           // self.editorViewFrame = self.editorView.frame;
            
        } completion:nil];
               
      }
        
    }

}

#pragma mark - Memory Warning Section
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
