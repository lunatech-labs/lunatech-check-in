//
//  MenuViewController.m
//  CheckIn
//
//  Created by wolfert on 10/30/12.
//
//

#import "MenuViewController.h"

#define kInputStateUser 1
#define kInputStateMode 2
#define kInputStateModeManual 3

@interface MenuViewController () {
}

@property (nonatomic, strong) UITextField * userInputField;
@property (nonatomic, strong) NSString * user;
@property (nonatomic, strong) UITableViewCell * activeCheckInMode;
@property (nonatomic) int state;
@property (nonatomic) BOOL automatic_checkin;
- (IBAction) toggleMode: (id) sender;

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _user = [[NSUserDefaults standardUserDefaults] stringForKey: @"email_preferences"];
    _automatic_checkin =  [[NSUserDefaults standardUserDefaults] boolForKey:@"automatic_checkin"];
    
    if (_user && ![_user isEqualToString:@""])
        _state = kInputStateMode;
    else
        _state = kInputStateUser;
    self.tableView.tableHeaderView = [[TableViewHeader alloc] initWithFrame:CGRectMake(0, 30, 320, 130)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_state == kInputStateUser) return 1;
    return _state == kInputStateMode ? 2 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)  return 1;
    return section == 1 ? 2 : [[[Geofencer sharedFencer] locations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSLog(@"index row: %d", indexPath.row);
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inputCell"];
        _userInputField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 24)];
        _userInputField.placeholder = @"your email";
        _userInputField.delegate = self;
        _userInputField.autocorrectionType = UITextAutocorrectionTypeNo;
        _userInputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _userInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userInputField.returnKeyType = UIReturnKeyDone;
        _userInputField.text = _user;
        _userInputField.textColor = kTableViewCellTextColor;
        _userInputField.font = kTableViewCellFont;
        _userInputField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [cell.contentView addSubview:_userInputField];

    } else if (indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkMarkCell"];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Automatic";
            if (_automatic_checkin) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                _activeCheckInMode = cell;
            }
        } else {
            cell.textLabel.text = @"Manual";
            if (!_automatic_checkin) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                _activeCheckInMode = cell;
            }
        }
        
        cell.tag = indexPath.row;
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationCell"];
        cell.textLabel.text = [[[[Geofencer sharedFencer] locations] objectAtIndex:indexPath.row] identifier];
    }
    cell.textLabel.textColor = kTableViewCellTextColor;
    cell.textLabel.font = kTableViewCellFont;
    cell.selectionStyle = kTableViewCellSelectionStyle;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"You";
    return section == 1 ? @"Check in mode" : @"Locations";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.bounds.size.width - 10, 18)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = kTableViewHeaderTextColor;
    label.font = kTableViewHeaderFont;
    label.shadowOffset = CGSizeMake(0, 1);
    label.shadowColor = [UIColor lightGrayColor];
    [headerView addSubview:label];
    return headerView;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.activeCheckInMode = [tableView cellForRowAtIndexPath:indexPath];
    } else if (indexPath.section == 2) {
        UITableViewCell * selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone) {
            [[Geofencer sharedFencer] enteredRegion:indexPath.row];
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            [[Geofencer sharedFencer] exitedRegion:indexPath.row];
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Set override
- (void) setActiveCheckInMode:(UITableViewCell *)activeCheckInMode {
    if (_activeCheckInMode)
        _activeCheckInMode.accessoryType = UITableViewCellAccessoryNone;

    NSIndexSet * indexSet = [[NSIndexSet alloc] initWithIndex:2];

    if (activeCheckInMode.tag == 0) {
        // automatic
        [[Geofencer sharedFencer] startMonitoring];
        if (_state == kInputStateModeManual) {
            _state = kInputStateMode;
            [self.tableView beginUpdates];
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        
    } else if (activeCheckInMode.tag == 1 && _state != kInputStateModeManual)  {
        // manual
        [[Geofencer sharedFencer] stopMonitoring];
        _state = kInputStateModeManual;
        [self.tableView beginUpdates];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        for (int i = 0; i < [[[Geofencer sharedFencer] locations] count]; i++) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:2];
            [self.tableView  insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.tableView endUpdates];
    }
    
    _activeCheckInMode = activeCheckInMode;
    _activeCheckInMode.accessoryType = UITableViewCellAccessoryCheckmark;
}


#pragma mark - Keyboard delegat

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_userInputField resignFirstResponder];
    [_userInputField resignFirstResponder];
    
    _user = _userInputField.text;
    if (![self saveUser:_user] || _state != kInputStateUser)
        return false;

    if (_state == kInputStateUser) {
        _state = kInputStateMode;
        
        [self.tableView beginUpdates];
        [self.tableView insertSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        
        for (int i = 0; i < [[[Geofencer sharedFencer] locations] count]; i++) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:1];
            [self.tableView  insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.tableView endUpdates];
   
        _automatic_checkin = YES;
    } else {
        _state = kInputStateUser;
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        _automatic_checkin = NO;
        
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:_automatic_checkin forKey:@"automatic_checkin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (BOOL) saveUser:(NSString*)user
{

    #warning email adres needs to be valided!
    if (!user || [user isEqualToString:@""]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"email_preferences"]) {
            _userInputField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email_preferences"];
            return YES;
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email_preferences"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"email_preferences"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}
@end
