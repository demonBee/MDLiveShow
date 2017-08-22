//
//  DBChooseHotelShowView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBChooseHotelShowView.h"

@interface DBChooseHotelShowView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;



@property (weak, nonatomic) IBOutlet UITableView *tableView0;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@property(nonatomic,strong)NSMutableArray*data0;
@property(nonatomic,strong)NSMutableArray*data1;
@property(nonatomic,strong)NSMutableArray*data2;

@property(nonatomic,assign)NSInteger selected0;
@property(nonatomic,assign)NSInteger selected1;
@property(nonatomic,assign)NSInteger selected2;


@end
@implementation DBChooseHotelShowView

+(instancetype)chooseHotelShowView{
    DBChooseHotelShowView*showView=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    showView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    showView.hidden=YES;
    showView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:showView action:@selector(clickBG:)];
    tap.delegate=showView;
    [showView addGestureRecognizer:tap];
    
    showView.tableView0.delegate=showView;
    showView.tableView1.delegate=showView;
    showView.tableView2.delegate=showView;
    showView.tableView0.dataSource=showView;
    showView.tableView1.dataSource=showView;
    showView.tableView2.dataSource=showView;
    
    
    showView.selected0=0;
    showView.selected1=-100;
    showView.selected2=-100;
    
    return showView;
}


-(void)getValue:(NSMutableArray*)allDatas{
      self.allDatas=allDatas;
    
     [self.tableView0 reloadData];
}


#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView0]) {
        return self.allDatas.count;
    }else if ([tableView isEqual:self.tableView1]){
        if (_selected0==-100) {
            return 0;
        }
        
       chooseCityModel*model=self.allDatas[_selected0];
        return model.content.count;
    }else if ([tableView isEqual:self.tableView2]){
        if (_selected0==-100||_selected1==-100) {
            return 0;
        }
        
        chooseCityModel*model=self.allDatas[_selected0];
        if (model.content.count<1) {
            return 0;
        }else{
        chooseCityModel*model1=model.content[_selected1];
        return model1.content.count;
        }
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:10];
    
    if ([tableView isEqual:self.tableView0]) {
       chooseCityModel*model=self.allDatas[indexPath.row];
       cell.textLabel.text=model.city_name;
        
    }else if ([tableView isEqual:self.tableView1]){
       chooseCityModel*model=self.allDatas[_selected0];
       chooseCityModel*model1= model.content[indexPath.row];
       cell.textLabel.text=model1.city_name;
    }else if ([tableView isEqual:self.tableView2]){
        chooseCityModel*model=self.allDatas[_selected0];
        chooseCityModel*model1= model.content[_selected1];
        chooseCityModel*model2=model1.content[indexPath.row];
       cell.textLabel.text=model2.city_name;
    }

    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView0]) {
        _selected0=indexPath.row;
        _selected1=-100;
        _selected2=-100;
        [self.tableView1 reloadData];
        [self.tableView2 setHidden:YES];
    }else if ([tableView isEqual:self.tableView1]){
        _selected1=indexPath.row;
        _selected2=-100;
        [self.tableView2 setHidden:NO];
        [self.tableView2 reloadData];
    }else if ([tableView isEqual:self.tableView2]){
        _selected2=indexPath.row;

        
    }

    
}





-(void)show{
    self.hidden=NO;
}
-(void)hidden{
    self.hidden=YES;

    

}


#pragma mark  --touch
- (IBAction)clickSure:(id)sender {
    chooseCityModel*resultModel;
    
    if (_selected1==-100&&_selected2==-100) {
        //选中的第一个
         chooseCityModel*model=self.allDatas[_selected0];
        resultModel=model;
        
        
        
    }else if (_selected1!=-100&&_selected2==-100){
        //选中的第二个
        chooseCityModel*model=self.allDatas[_selected0];
        chooseCityModel*model1= model.content[_selected1];
        resultModel=model1;
        
    }else if (_selected1!=-100&&_selected2!=-100){
        //选中的第三个
        chooseCityModel*model=self.allDatas[_selected0];
        chooseCityModel*model1= model.content[_selected1];
        chooseCityModel*model2=model1.content[_selected2];
        resultModel=model2;

    }
    
    MyLog(@"%@",resultModel.city_name);
    if (self.clickCityBlock) {
        self.clickCityBlock(resultModel);
    }
    
    [self hidden];
}

- (IBAction)clickCancel:(id)sender {
    [self hidden];
    
}



#pragma mark  --tap
-(void)clickBG:(UITapGestureRecognizer*)tap{
    [self hidden];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    
    return YES;
}


#pragma mark  --set
-(NSMutableArray *)data0{
    if (!_data0) {
        _data0=[NSMutableArray array];
    }
    return _data0;
}

-(NSMutableArray *)data1{
    if (!_data1) {
        _data1=[NSMutableArray array];
    }
    return _data1;

}

-(NSMutableArray *)data2{
    if (!_data2) {
        _data2=[NSMutableArray array];
    }
    return _data2;
    
}

@end
