//
//  YKNoteDataStructureViewController.m
//  YKNote
//
//  Created by wanyakun on 2017/1/3.
//  Copyright © 2017年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteDataStructureViewController.h"
#import "SingleLink.h"

@interface YKNoteDataStructureViewController ()

@end

@implementation YKNoteDataStructureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"DataStructure";
    self.view.backgroundColor = [UIColor whiteColor];
    
    SingleLink *link = initLink();
    insert(link, 0, 1);
    insert(link, 1, 2);
    insert(link, 2, 3);
    insert(link, 3, 4);
    insert(link, 4, 5);

    reverse(link);
    
    while (link) {
        NSLog(@"%d", link->data);
        link = link->next;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
