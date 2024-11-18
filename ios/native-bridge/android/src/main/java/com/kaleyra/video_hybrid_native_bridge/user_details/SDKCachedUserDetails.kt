// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.user_details

import android.net.Uri
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.UserDetails
import com.kaleyra.video_hybrid_native_bridge.extensions.toDatabaseEntity
import com.kaleyra.video_hybrid_native_bridge.extensions.toSDK
import com.kaleyra.video_hybrid_native_bridge.extensions.toUserDetails
import com.kaleyra.video_hybrid_native_bridge.repository.VideoHybridBridgeRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.async
import kotlinx.coroutines.launch

internal class SDKCachedUserDetails(
    private val sdk: KaleyraVideo,
    private val repository: VideoHybridBridgeRepository,
    private val coroutineScope: CoroutineScope,
) : CachedUserDetails {

    override val cachedUserDetails = androidx.collection.ArraySet<UserDetails>()

    override fun addUsersDetails(userDetails: Array<UserDetails>) {
        coroutineScope.launch {
            val usersDao = userDetails
                .filter { it.userID.isNotBlank() }
                .map { it.toDatabaseEntity() }

            if (usersDao.isEmpty()) return@launch
            repository.userDao().insert(usersDao)
            cachedUserDetails.addAll(userDetails)
        }
        setDetailsProvider()
    }

    private fun setDetailsProvider() {
        sdk.userDetailsProvider = { userIds: List<String> ->
            coroutineScope.async {
                Result.success(
                    userIds.map { userAlias ->
                        cachedUserDetails.firstOrNull { it.userID == userAlias }?.toSDK()
                            ?: repository.userDao().getUserDetailsEntity(userAlias)?.toSDK()
                            ?: com.kaleyra.video_common_ui.model.UserDetails(userAlias, userAlias, Uri.EMPTY)
                    }
                )
            }.await()
        }
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
