//
//  TangramDefaultItemModelFactory.m
//  Tangram
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "TangramDefaultItemModelFactory.h"
#import "TangramDefaultItemModel.h"
#import "TMUtils.h"

#import "TangramDefaultLayoutFactory.h"
#import "TangramDefaultDataSourceHelper.h"

@interface TangramDefaultItemModelFactory()

@property (nonatomic, strong) NSMutableDictionary *elementTypeMap;

@end

@implementation TangramDefaultItemModelFactory

+ (TangramDefaultItemModelFactory*)sharedInstance
{
    static TangramDefaultItemModelFactory *_itemModelFactory= nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _itemModelFactory = [[TangramDefaultItemModelFactory alloc] init];
    });
    return _itemModelFactory;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.elementTypeMap = [[NSMutableDictionary alloc]init];
        NSString *elementMapPath = [[NSBundle mainBundle] pathForResource:@"TangramKitVVElementTypeMap" ofType:@"plist"];
        [self.elementTypeMap addEntriesFromDictionary:[TangramDefaultItemModelFactory decodeElementTypeMap:[NSArray arrayWithContentsOfFile:elementMapPath]]];
    }
    return self;
}

+ (NSObject<TangramItemModelProtocol> *)itemModelByDict:(NSDictionary *)dict
{
    // 先创建一个光杆itemModel实例
    TangramDefaultItemModel *itemModel = [[TangramDefaultItemModel alloc]init];
    // 然后从dict中拾取属性添加到itemModel实例上
    return [[self class]praseDictToItemModel:itemModel dict:dict];
}

+ (TangramDefaultItemModel *)praseDictToItemModel:(TangramDefaultItemModel *)itemModel dict:(NSDictionary *)dict
{
    NSString *type = [dict tm_stringForKey:@"type"];
    itemModel.type = type;
    NSDictionary *styleDict =[dict tm_dictionaryForKey:@"style"];
    NSObject *margin =[styleDict objectForKey:@"margin"];
    if ([margin isKindOfClass:[NSString class]]) {
        NSString *marginString = [(NSString *)margin stringByReplacingOccurrencesOfString:@"[" withString:@""];
        marginString = [marginString stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSArray *marginArray = [marginString componentsSeparatedByString:@","];
        if (marginArray && 4 == marginArray.count) {
            itemModel.margin = [TangramDefaultDataSourceHelper parseArrayWithRP:marginArray];
        }
    }
    else if(![margin isKindOfClass:[NSArray class]])
    {
        itemModel.margin = @[@0, @0, @0, @0];
    }
    else{
        itemModel.margin = [TangramDefaultDataSourceHelper parseArrayWithRP:[styleDict tm_safeObjectForKey:@"margin"]];
    }
    if ([[styleDict tm_stringForKey:@"display"] isEqualToString:@"block"]) {
        itemModel.display = @"block";
    }
    else{
        itemModel.display = @"inline";
    }
    //针对style中的height和width
    if ([styleDict tm_safeObjectForKey:@"height"] != nil) {
        if([[styleDict tm_stringForKey:@"height"]containsString:@"rp"]){
            itemModel.heightFromStyle = [TangramDefaultDataSourceHelper floatValueByRPObject:[styleDict tm_safeObjectForKey:@"height"]];
        }
        else{
            itemModel.heightFromStyle = [styleDict tm_floatForKey:@"height"];
        }
    }
    if ([styleDict tm_safeObjectForKey:@"width"] != nil) {
        if([[styleDict tm_stringForKey:@"width"]containsString:@"rp"]){
            itemModel.heightFromStyle = [TangramDefaultDataSourceHelper floatValueByRPObject:[styleDict tm_safeObjectForKey:@"width"]];
        }
        else{
            itemModel.widthFromStyle = [styleDict tm_floatForKey:@"width"];
        }
    }
    else if ([[styleDict tm_stringForKey:@"width"] isEqualToString:@"-1"]) {
        //width 配-1 意味着屏幕宽度
        itemModel.widthFromStyle = [UIScreen mainScreen].bounds.size.width;
    }
    if ([styleDict tm_floatForKey:@"aspectRatio"] > 0.f) {
        itemModel.modelAspectRatio  = [styleDict tm_floatForKey:@"aspectRatio"];
    }
    if ([styleDict tm_floatForKey:@"ratio"] > 0.f) {
        itemModel.modelAspectRatio = [styleDict tm_floatForKey:@"ratio"];
    }
    itemModel.colspan = [styleDict tm_integerForKey:@"colspan"];
    itemModel.position = [dict tm_stringForKey:@"position"];
    itemModel.specificReuseIdentifier = [styleDict tm_stringForKey:@"reuseId"];
    itemModel.disableReuse = [styleDict tm_boolForKey:@"disableReuse"];
    
    for (NSString *key in [dict allKeys]) {
        if ([key isEqualToString:@"type"] || [key isEqualToString:@"style"] ) {
            continue;
        }
        else{
            [itemModel setBizValue:[dict tm_safeObjectForKey:key] forKey:key];
        }
    }
    for (NSString *key in [styleDict allKeys]) {
        if ([key isEqualToString:@"margin"] || [key isEqualToString:@"display"]||[key isEqualToString:@"colspan"]
            || [key isEqualToString:@"height"] || [key isEqualToString:@"width"]  ) {
            continue;
        }
        else{
            [itemModel setStyleValue:[styleDict tm_safeObjectForKey:key] forKey:key];
        }
    }
    // 🥵 itemModel的字典中的type的特殊处理，当itemModel的type是一个layout，而不是一个element的情况
    if ([[dict tm_stringForKey:@"kind"] isEqualToString:@"row"] || [TangramDefaultLayoutFactory layoutClassNameByType:type].length > 0) {
        // 此时记录了itemModel字典中id到layoutIdentifierForLayoutModel的属性中，
        // 后续继续观察layoutIdentifierForLayoutModel这个属性起了什么作用？
        // itemModel中“可能”需要加入一个id字段，
        // itemModel->id和layoutIdentifierForLayoutModel构成了关联，如果没有id之后会怎么样？
        itemModel.layoutIdentifierForLayoutModel = [dict tm_stringForKey:@"id"];
    }
    //itemModel.specificReuseIdentifier = [dict tm_stringForKey:@"muiID"];
    // itemModel最终通过字典将type转换成了element的名字。
    itemModel.linkElementName = [[TangramDefaultItemModelFactory sharedInstance].elementTypeMap tm_stringForKey:itemModel.type];
    //TODO specificMuiID 增加逻辑
    return itemModel;
}
+ (NSMutableDictionary *)decodeElementTypeMap:(NSArray *)mapArray
{
    NSMutableDictionary *mapDict = [[NSMutableDictionary alloc]init];
    for (NSDictionary *dict in mapArray) {
        NSString *key = [dict tm_stringForKey:@"type"];
        NSString *value = [dict tm_stringForKey:@"element"];
        if (key.length > 0 && value.length > 0) {
            NSAssert(![[mapDict allKeys] containsObject:key], @"There are repeat registration for element!Please check type!");
            [mapDict setObject:value forKey:key];
        }
    }
    return mapDict;
}
/**
 Regist Element
 
 @param type In ItemModel we need return a itemType, the itemType will be used here
 */
+ (void)registElementType:(NSString *)type className:(NSString *)elementClassName
{
    if ([type isKindOfClass:[NSString class]] && type.length > 0
        && [elementClassName isKindOfClass:[NSString class]] && elementClassName.length > 0) {
        [[TangramDefaultItemModelFactory sharedInstance].elementTypeMap tm_safeSetObject:[elementClassName copy] forKey:[type copy]];
    }
}

+ (BOOL)isTypeRegisted:(NSString *)type
{
    if ([[[TangramDefaultItemModelFactory sharedInstance].elementTypeMap allKeys]containsObject:type]) {
        return YES;
    }
    return NO;
}

@end
