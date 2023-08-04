// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.user_details

import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.bandyer.android_sdk.client.Completion
import com.bandyer.android_sdk.utils.provider.UserDetailsProvider
import com.kaleyra.video_hybrid_native_bridge.ContextContainer
import com.kaleyra.video_hybrid_native_bridge.UserDetails
import com.kaleyra.video_hybrid_native_bridge.UserDetailsFormat
import com.kaleyra.video_hybrid_native_bridge.extensions.toSDK
import com.kaleyra.video_hybrid_native_bridge.extensions.toUserDetails
import com.kaleyra.video_hybrid_native_bridge.extensions.toUserDetailsEntity
import com.kaleyra.video_hybrid_native_bridge.repository.VideoHybridBridgeRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import kotlin.collections.forEach

internal class SDKCachedUserDetails(
  private val sdk: BandyerSDKInstance,
  private val contextContainer: ContextContainer,
  private val repository: VideoHybridBridgeRepository,
  private val coroutineScope: CoroutineScope
) : CachedUserDetails {
    override fun setUserDetailsFormat(format: UserDetailsFormat) = sdk.setUserDetailsFormatter(CachedUserDetailsFormatter(contextContainer.context.applicationContext, format))

    override val cachedUserDetails = androidx.collection.ArraySet<UserDetails>()
    override fun addUsersDetails(userDetails: Array<UserDetails>) {
        coroutineScope.launch {
            val usersDao = userDetails.filter { it.userID.isNotBlank() }.map {
                com.bandyer.android_sdk.utils.provider.UserDetails.Builder(it.userID).build().copy(
                    nickName = it.nickName,
                    firstName = it.firstName,
                    lastName = it.lastName,
                    email = it.email,
                    imageUrl = it.profileImageURL
                ).toUserDetailsEntity()
            }
            if (usersDao.isEmpty()) return@launch
            repository.userDao().insert(usersDao)
            cachedUserDetails.addAll(userDetails)
        }
        setDetailsProvider()
    }

    private fun setDetailsProvider() {
        sdk.setUserDetailsProvider(object : UserDetailsProvider {
            override fun onUserDetailsRequested(userAliases: List<String>, completion: Completion<Iterable<com.bandyer.android_sdk.utils.provider.UserDetails>>) {
                coroutineScope.launch {
                    val details = userAliases.map { userAlias ->
                        repository.userDao().getUserDetailsEntity(userAlias)?.toSDK() ?: com.bandyer.android_sdk.utils.provider.UserDetails.Builder(userAlias).build()
                    }
                    completion.success(details)
                }
            }
        })
    }

    override fun removeUserDetails() {
        coroutineScope.launch {
            repository.userDao().clear()
            cachedUserDetails.clear()
        }
    }

    init {
        coroutineScope.launch {
            repository.userDao().all.forEach {
                cachedUserDetails.add(it.toUserDetails())
            }
        }
    }
}
