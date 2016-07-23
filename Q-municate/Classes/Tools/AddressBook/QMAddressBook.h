//
//  QMAddressBook.h


#import <Foundation/Foundation.h>

typedef void(^AddressBookResult)(NSArray *contacts, BOOL success, NSError *error);

@interface QMAddressBook : NSObject

+ (void)getAllContactsFromAddressBook:(AddressBookResult)block;
+ (void)getContactsWithEmailsWithCompletionBlock:(AddressBookResult)block;

@end
