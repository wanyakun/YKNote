//
//  SingleLink.h
//  YKNote
//
//  Created by wanyakun on 2016/12/30.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#ifndef SingleLink_h
#define SingleLink_h

//定义节点元素
typedef void* ElemType;

//定义节点
typedef struct LinkNode Node;
struct LinkNode {
    ElemType *data;
    Node *next;
};

//定义链表，指向头结点
typedef struct LinkNode SingleLink;


//创建链表
SingleLink* initLink();

//获取第i个位置的节点
Node* get(SingleLink *link, int i);

//在第i个位置插入节点
Node* insert(SingleLink *link, int i, ElemType *data);

//链表翻转
void traverse(SingleLink *link);


#endif /* SingleLink_h */
