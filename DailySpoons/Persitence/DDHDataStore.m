//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHDataStore.h"
#import "DDHDay.h"
#import "DDHHistoryEntry.h"
#import "DDHAction.h"
#import "NSFileManager+Extension.h"
#import <sqlite3.h>

@interface DDHDataStore ()
@property (nonatomic, readwrite) DDHDay *day;
@property (nonatomic, readwrite) NSArray<DDHAction *> *actions;
@end

@implementation DDHDataStore
- (instancetype)init {
  if (self = [super init]) {
    _actions = [self loadActions];
    _day = [self loadDay];
  }
  return self;
}

- (void)addAction:(DDHAction *)action {
  self.actions = [self.actions arrayByAddingObject:action];
  [self saveActions:self.actions];
}

- (void)removeAction:(DDHAction *)action {
  NSMutableArray<DDHAction *> *actions = [self.actions mutableCopy];
  [actions removeObject:action];
  self.actions = [actions copy];
}

- (void)saveData {
  [self saveDay:self.day];
  [self saveActions:self.actions];
}

- (DDHAction *)actionForId:(NSUUID *)actionId {
  __block DDHAction *foundAction;
  [self.actions enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([action.actionId isEqual:actionId]) {
      foundAction = action;
      *stop = YES;
    }
  }];
  return foundAction;
}

// MARK: - private methods
- (NSArray<DDHAction *> *)loadActions {
  NSURL *fileURL = [[NSFileManager defaultManager] actionsURL];
  NSData *data = [[NSData alloc] initWithContentsOfURL:fileURL];
  if (data != nil) {
    NSError *jsonError = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    __block NSMutableArray<DDHAction *> *actions = [[NSMutableArray alloc] initWithCapacity:[jsonArray count]];
    [jsonArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
      DDHAction *action = [[DDHAction alloc] initWithDictionary:dictionary];
      [actions addObject:action];
    }];
    if (jsonError) {
      NSLog(@"JSON error: %@", jsonError);
    }
    return [actions copy];
  } else {
    return [[NSArray alloc] init];
  }
}

- (DDHDay *)loadDay {
  NSURL *fileURL = [[NSFileManager defaultManager] dayURL];
  NSData *data = [[NSData alloc] initWithContentsOfURL:fileURL];
  if (data != nil) {
    NSError *jsonError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if (jsonError) {
      NSLog(@"JSON error: %@", jsonError);
    }
    return [[DDHDay alloc] initWithDictionary:jsonDictionary];
  } else {
    return [[DDHDay alloc] init];
  }
}

- (void)saveDay:(DDHDay *)day {
  NSError *jsonError = nil;
  NSData *data = [NSJSONSerialization dataWithJSONObject:[day dictionary] options:0 error:&jsonError];
  if (jsonError) {
    NSLog(@"JSON error: %@", jsonError);
  }
  NSURL *fileURL = [[NSFileManager defaultManager] dayURL];
  [data writeToURL:fileURL atomically:YES];
}

- (void)saveActions:(NSArray<DDHAction *> *)actions {
  NSError *jsonError = nil;
  __block NSMutableArray<NSDictionary *> *jsonArray = [[NSMutableArray alloc] initWithCapacity:[actions count]];
  [actions enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    [jsonArray addObject:[action dictionary]];
  }];

  NSData *data = [NSJSONSerialization dataWithJSONObject:jsonArray options:0 error:&jsonError];
  if (jsonError != nil) {
    NSLog(@"JSON error: %@", jsonError);
  }
  NSURL *fileURL = [[NSFileManager defaultManager] actionsURL];
  [data writeToURL:fileURL atomically:YES];
}

// MARK: - History

- (NSString *)databasePath {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *databaseURL = [fileManager historyURL];
  return [databaseURL path];
}

- (void)createHistoryDatabaseIfNeeded {
  NSString *databasePath = [self databasePath];
  BOOL databaseFileExists = [[NSFileManager defaultManager] fileExistsAtPath:databasePath];
  if (NO == databaseFileExists) {
    const char *utf8Path = [databasePath UTF8String];

    sqlite3 *database;
    if (sqlite3_open(utf8Path, &database) == SQLITE_OK) {
      char *errorMessage;
      const char *sql_statement = "CREATE TABLE IF NOT EXISTS spoonsHistory (id INTEGER PRIMARY KEY AUTOINCREMENT, uuid TEXT NOT NULL UNIQUE, date INT, amountOfSpoons INT, plannedSpoons INT, completedSpoons INT, completedActions TEXT)";

      if (sqlite3_exec(database, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
        NSLog(@"Failed to create table: %s", sqlite3_errmsg(database));
      }

      sqlite3_close(database);
    }
  }
}

- (BOOL)insertHistoryDay:(DDHDay *)day {
  BOOL success = NO;
  const char *databasePath = [[self databasePath] UTF8String];
  sqlite3 *database;
  if (sqlite3_open(databasePath, &database) == SQLITE_OK) {
    const char *insert_statement = "INSERT INTO spoonsHistory (uuid, date, amountOfSpoons, plannedSpoons, completedSpoons, completedActions) VALUES (?,?,?,?,?,?)";
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(database, insert_statement, -1, &statement, NULL) == SQLITE_OK) {
      sqlite3_bind_text(statement, 1, [[[NSUUID UUID] UUIDString] UTF8String], -1, SQLITE_TRANSIENT);
      sqlite3_bind_int(statement, 2, (int)[day.date timeIntervalSince1970]);
      sqlite3_bind_int(statement, 3, (int)[day amountOfSpoons]);
      sqlite3_bind_int(statement, 4, (int)[day plannedSpoons]);
      sqlite3_bind_int(statement, 5, (int)[day completedSpoons]);
      NSMutableArray<NSString *> *actionsStringArray = [[NSMutableArray alloc] init];
      for (DDHAction *action in day.completedActions) {
        NSString *actionNameWithoutSlash = [action.name stringByReplacingOccurrencesOfString:@"/" withString:@"slash"];
        [actionsStringArray addObject:[NSString stringWithFormat:@"%@(%ld)", actionNameWithoutSlash, action.spoons]];
      }
      NSString *actionsString = [actionsStringArray componentsJoinedByString:@"/"];
      sqlite3_bind_text(statement, 6, [actionsString UTF8String], -1, SQLITE_TRANSIENT);

      if (sqlite3_step(statement) == SQLITE_DONE) {
        success = YES;
      } else {
        NSLog(@"Failed to add day: %s", sqlite3_errmsg(database));
      }

      sqlite3_finalize(statement);
    } else {
      NSLog(@"Failed to prepare database: %s", sqlite3_errmsg(database));
    }

    sqlite3_close(database);
  } else {
    NSLog(@"Failed to open database: %s", sqlite3_errmsg(database));
  }
  return success;
}

- (BOOL)deleteHistoryEntry:(DDHHistoryEntry *)entry {
  BOOL success = NO;
  const char *databasePath = [[self databasePath] UTF8String];
  sqlite3 *database;
  if (sqlite3_open(databasePath, &database) == SQLITE_OK) {
    const char *delete_statement = "DELETE FROM spoonsHistory WHERE uuid = ?";
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(database, delete_statement, -1, &statement, NULL) == SQLITE_OK) {
      sqlite3_bind_text(statement, 1, [[entry.uuid UUIDString] UTF8String], -1, SQLITE_TRANSIENT);

      if (sqlite3_step(statement) == SQLITE_DONE) {
        success = YES;
      } else {
        NSLog(@"Failed to delete history entry: %s", sqlite3_errmsg(database));
      }

      sqlite3_finalize(statement);
    } else {
      NSLog(@"Failed to prepare database: %s", sqlite3_errmsg(database));
    }

    sqlite3_close(database);
  } else {
    NSLog(@"Failed to open database: %s", sqlite3_errmsg(database));
  }
  return success;
}

- (NSArray<DDHHistoryEntry *> *)history {
  const char *databasePath = [[self databasePath] UTF8String];
  sqlite3 *database;
  NSMutableArray<DDHHistoryEntry *> *history = [[NSMutableArray alloc] init];

  if (sqlite3_open(databasePath, &database) == SQLITE_OK) {
    const char *fetch_statement = "SELECT * FROM spoonsHistory ORDER BY date DESC LIMIT 100";
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(database, fetch_statement, -1, &statement, NULL) == SQLITE_OK) {
      while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *uuidString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        int timeInterval = sqlite3_column_int(statement, 2);
        int amountOfSpoons = sqlite3_column_int(statement, 3);
        int plannedSpoons = sqlite3_column_int(statement, 4);
        int completedSpoons = sqlite3_column_int(statement, 5);
        char *rawActionsString = (char *)sqlite3_column_text(statement, 6);
        NSString *actionsString = (rawActionsString != NULL) ? [NSString stringWithUTF8String:rawActionsString] : @"";

        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        DDHHistoryEntry *historyEntry = [[DDHHistoryEntry alloc] initUUID:uuid date:date amountOfSpoons:amountOfSpoons plannedSpoons:plannedSpoons completedSpoons:completedSpoons completedActionsString:actionsString];
        [history addObject:historyEntry];
      }
    }
  }
  return history;
}

@end
