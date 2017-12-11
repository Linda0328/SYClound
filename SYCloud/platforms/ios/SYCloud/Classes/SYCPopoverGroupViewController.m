//
//  SYCPopoverGroupViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/5/5.
//
//

#import "SYCPopoverGroupViewController.h"
#import "SYCGroupModel.h"
#import "HexColor.h"
#import "SYCSystem.h"
float const cellHeight = 46.0f;
static float const cellNum = 3;

@interface SYCPopoverGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *groupTable;
@end

@implementation SYCPopoverGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
    _groupTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, cellNum*cellHeight*[SYCSystem PointCoefficient])];
    _groupTable.delegate = self;
    _groupTable.dataSource = self;
    _groupTable.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
    [self.view addSubview:_groupTable];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight*[SYCSystem PointCoefficient];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_groupArr count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SYCGroupModel *model = _groupArr[indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:model.ico]];
    cell.textLabel.text = model.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:[SYCSystem judgeNSString:model.ico]?14.0f*[SYCSystem PointCoefficient]:17.0f*[SYCSystem PointCoefficient]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SYCGroupModel *model = _groupArr[indexPath.row];
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *groupActionDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_actionEvent,groupEventKey,model.ID, groupItemIDKey,nil];
    [self dismissViewControllerAnimated:YES completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[NSNotificationCenter defaultCenter] postNotificationName:groupRefreshNotify object:strongSelf.PresentingVC userInfo:groupActionDic];
    }];
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
