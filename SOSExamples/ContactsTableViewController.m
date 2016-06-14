/*
 * Copyright © salesforce.com, inc. 2014-2016
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice, this
 * list of conditions and the following disclaimer in the documentation and/or
 * other materials provided with the distribution.
 *
 * Neither the name of salesforce.com nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ContactsTableViewController.h"

@implementation ContactsTableViewController {
  NSMutableArray *_contacts;
}

- (void)addContactWithName:(NSString *)name company:(NSString *)company {
  [_contacts addObject:@{@"name": name, @"company": company}];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _contacts = _contacts ?: [[NSMutableArray alloc] init];

  [self addContactWithName:@"Keith Allen" company:@"salesforce.com"];
  [self addContactWithName:@"Harry Roberts" company:@"salesforce.com"];
  [self addContactWithName:@"Raymond Patterson" company:@"salesforce.com"];
  [self addContactWithName:@"Jerry Ford" company:@"salesforce.com"];
  [self addContactWithName:@"Kimberly Douglas" company:@"salesforce.com"];
  [self addContactWithName:@"Jose Estrada" company:@"salesforce.com"];
  [self addContactWithName:@"Rebecca Morris" company:@"salesforce.com"];
  [self addContactWithName:@"Joe Duncan" company:@"salesforce.com"];
  [self addContactWithName:@"Geoff Teehan" company:@"salesforce.com"];
  [self addContactWithName:@"Adam Castro" company:@"salesforce.com"];
  [self addContactWithName:@"Billy Wildman" company:@"salesforce.com"];
  [self addContactWithName:@"Roger McKinnon" company:@"salesforce.com"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell"];
  [[cell textLabel] setText:_contacts[[indexPath row]][@"name"]];
  [[cell detailTextLabel] setText:@"salesforce.com"];

  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UITableViewCell *cell = sender;
  NSIndexPath *index = [[self tableView] indexPathForCell:cell];

  UILabel *name = (UILabel *)[[[segue destinationViewController] view] viewWithTag:100];
  UILabel *company = (UILabel *)[[[segue destinationViewController] view] viewWithTag:200];

  [name setText:_contacts[[index row]][@"name"]];
  [company setText:_contacts[[index row]][@"company"]];
}

@end
