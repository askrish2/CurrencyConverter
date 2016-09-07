//
//  TableCollectionViewController.m
//  CurrencyConverter
//
//  Created by Ashwini Krishnan on 9/6/16.
//  Copyright © 2016 Ash Krishnan. All rights reserved.
//

#import "TableCollectionViewController.h"
#import "TableCell.h"
@interface TableCollectionViewController ()
@property (nonatomic) NSDictionary *photos;
@property (nonatomic) NSArray *money;
@property (nonatomic) NSMutableArray *arr;
@property (nonatomic) BOOL loading;




@end

@implementation TableCollectionViewController

//static NSString * const reuseIdentifier = @"Cell";

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    
    self.navigationItem.rightBarButtonItem.enabled = !_loading;
}

- (id)init {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    //_layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(screenWidth, 50.0);
    layout.minimumInteritemSpacing = 10.0;
    layout.minimumLineSpacing = 5.0;    
    return (self = [super initWithCollectionViewLayout:layout]);

}

- (void)viewDidLoad {
        
    [super viewDidLoad];
    self.title = @"Currency Converter";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 390, 60)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"USD"];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    
    [button setTitle:@"Refresh" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refresh)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
                                   initWithCustomView:button];
    
    navigationItem.leftBarButtonItem = buttonItem;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];

    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[TableCell class] forCellWithReuseIdentifier:@"photo"];
    [self refresh];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TableCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    [cell setClearsContextBeforeDrawing:YES];
    [cell clearsContextBeforeDrawing];
    [cell.label clearsContextBeforeDrawing];
    
    cell.backgroundColor = [UIColor blackColor];
    NSLog(@"index: %@", self.photos[@"AUD"]);
    cell.tags = self.arr[indexPath.row];
    return cell;
}

- (void) refresh {
    if (self.loading) {
        return;
    }
    
    self.loading = YES;
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    //NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/snow/media/recent?access_token=%@", self.accessToken];
    
    NSString *urlString = @"http://api.fixer.io/latest?base=USD";
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"text: %@", text);
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        //NSLog(@"res0: %@", data[0]);
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //NSLog(@"res1: %@", responseDictionary);
        //self.photos = [responseDictionary valueForKeyPath:@"data"];
        //NSLog(@"res: %@", responseDictionary[@"object"]);
        NSLog(@"res: %@", responseDictionary[@"rates"]);
        self.photos = responseDictionary[@"rates"];
        
        NSEnumerator *enumerator = [self.photos keyEnumerator];
        id key;
        int i=0;
        // extra parens to suppress warning about using = instead of ==
        self.arr = [[NSMutableArray alloc] initWithCapacity:self.photos.count];
        while((key = [enumerator nextObject])) {
            NSLog(@"key=%@ value=%@", key, [self.photos objectForKey:key]);
            NSString *s = [[NSString alloc] initWithFormat:@"CURR:  %@            RATE:  %@", key, [self.photos objectForKey:key]];
            NSLog(@"s: %@", s);
            
            [self.arr insertObject:s atIndex:i];
            NSLog(@"arr:%@", self.arr[i]);
            i++;
        };
        NSLog(@"yo: %@", self.arr[0]);
        
        for (int i=0; i<self.arr.count; i++) {
            NSLog(@"hee:%@", self.arr[i]);
        }
        
        //self.money = responseDictionary[@"rates"];
        self.money = [self.photos allValues];
        NSLog(@"photos: %@", self.photos);
        //NSLog(@"photos: %@", self.photos[0]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
             self.loading = NO;
        });
    }];
    NSLog(@"bro");
    [task resume];
    NSLog(@"bros");

}




#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
