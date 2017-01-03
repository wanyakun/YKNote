//
//  SingleLink.c
//  YKNote
//
//  Created by wanyakun on 2016/12/30.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include "SingleLink.h"

static Node *headerNode = NULL;

Node* createNode(ElemType *data) {
    Node *node = NULL;
    node = (Node *)malloc(sizeof(Node));
    if (!node) {
        printf("create node error \n");
        return NULL;
    }
    
    node->data = data;

    node->next = NULL;
    
    
    return node;
}

SingleLink* initLink() {
    //创建表头
    headerNode = createNode(NULL);
    if (!headerNode) {
        return 0;
    }
    
    return headerNode;
}

Node* get(SingleLink *link, int i) {
    if (i <= 0) {
        return headerNode;
    }
    
    Node *node = link->next;
    int j = 1;
    while (node && j < i) {
        node = node->next;
        j++;
    }
    
    return node;
}

Node* insert(SingleLink *link, int i, ElemType *data) {
    Node *preNode = get(link, i);
    
    if (!preNode) {
        return NULL;
    }
    
    Node *node = createNode(data);
    if (!node) {
        return NULL;
    }
    
    preNode->next = node;
    
    return node;
}

void reverse(SingleLink *link) {
    Node *head, *node, *tmp;
    //尾部指向表头
    Node *tail = link;
    //表头指向链表的下个节点
    head = link->next;
    //只有表头，第一个节点为NULL，直接返回
    if (head == NULL) {
        return;
    }
    //使node指向link第二个节点
    node = head->next;
    if (node == NULL) {
        return;
    }
    tmp = node->next;
    //使link的头结点与第二个节点断开.并作为head的尾节点
    head->next = NULL;
    
    while (tmp) {
        //使node与node所指的下个节点断开.
        //断开后,使tmp的下个节点指向head;
        node->next = head;
        //head向后移
        head = node;
        //node向后移
        node = tmp;
        //tmp向后移
        tmp = tmp->next;
    }
    //node已经移动到末尾
    node->next = head;
    //head再次移动指向原链表link的末尾指针
    head = node;
    //将原链表的头结点添加到反转后的节点的头部
    tail->next = head;
    head = tail;
}

