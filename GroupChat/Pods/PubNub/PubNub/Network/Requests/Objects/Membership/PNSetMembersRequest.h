#import "PNBaseObjectsMembershipRequest.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark Interface declaration

/**
 * @brief \c Set \c channel's members request.
 *
 * @author Serhii Mamontov
 * @version 4.14.0
 * @since 4.14.0
 * @copyright © 2010-2020 PubNub, Inc.
 */
@interface PNSetMembersRequest : PNBaseObjectsMembershipRequest


#pragma mark - Information

/**
 * @brief Bitfield set to fields which should be returned with response.
 *
 * @note Supported keys specified in \b PNMemberFields enum.
 */
@property (nonatomic, assign) PNMemberFields includeFields;


#pragma mark - Initialization & Configuration

/**
 * @brief Create and configure \c set \c channel's members request.
 *
 * @discussion Request will set \c UUID's \c metadata associated with it in context of \c channel.
 *
 * @param channel Name of channel for which members \c metadata should be set.
 * @param uuids List of \c UUIDs for which \c metadata associated with each of them in context of
 *     \c channel should be set.
 *     Each entry is dictionary with \c uuid and \b optional \c custom fields. \c custom should
 *     be dictionary with simple objects: \a NSString and \a NSNumber.
 *
 * @return Configured and ready to use \c set \c channel's members request.
 */
+ (instancetype)requestWithChannel:(NSString *)channel uuids:(NSArray<NSDictionary *> *)uuids;

/**
 * @brief Forbids request initialization.
 *
 * @throws Interface not available exception and requirement to use provided constructor method.
 *
 * @return Initialized request.
 */
- (instancetype)init NS_UNAVAILABLE;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
