// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.notifications

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.JobIntentService
import com.kaleyra.video_hybrid_native_bridge.VideoSDKHybridBridge
import com.kaleyra.video_hybrid_native_bridge.ContextContainer
import com.kaleyra.video_hybrid_native_bridge.CrossPlatformAccessTokenProvider
import com.kaleyra.video_hybrid_native_bridge.events.Events
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.asCoroutineDispatcher
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.util.concurrent.Executors

/**
 * @author kristiyan
 */
class KaleyraVideoNotificationService : JobIntentService() {

    companion object {
        fun enqueueWork(
            context: Context,
            componentName: ComponentName,
            intent: Intent
        ) = enqueueWork(
          context,
          componentName,
          KaleyraVideoNotificationReceiver::class.java.simpleName.hashCode(),
          intent
        )
    }

    override fun onHandleWork(intent: Intent) {
        val extras = intent.extras ?: return
        val payload = extras.getString("payload") ?: return
        try {
            val webHookPayload = JSONObject(payload).get("payload").toString()
            val userToken = JSONObject(payload).getString("user_token")

            val scope = CoroutineScope(Executors.newSingleThreadExecutor().asCoroutineDispatcher())
            val plugin = VideoSDKHybridBridge(
                contextContainer = ServiceContextContainer(),
                tokenProvider = SingleTokenProvider(userToken),
                backgroundScope = scope,
                eventsReporter = NoOpEventsReporter(),
                eventsEmitter = NoOpEventsEmitter(),
            )
            scope.launch {
                val savedConfiguration = plugin.lastConfiguration!!
                val savedUsed = plugin.lastConnectedUserId!!
                plugin.addUsersDetails(plugin.cachedUserDetails.toTypedArray())
                plugin.configureBridge(savedConfiguration)
                plugin.connect(savedUsed)
                plugin.handlePushNotificationPayload(webHookPayload)
            }
        } catch (exception: Throwable) {
            Log.e("KaleyraNotService", "" + exception.message)
        }
    }

    private inner class ServiceContextContainer : ContextContainer {
        override val context: Context = applicationContext
    }

    private class SingleTokenProvider(private val token: String) : CrossPlatformAccessTokenProvider {
        override fun provideAccessToken(userId: String, completion: (Result<String>) -> Unit) = completion(Result.success(token))
    }

    private class NoOpEventsEmitter : EventsEmitter {
        override fun sendEvent(event: Events, args: Any?) = Unit
    }

    private class NoOpEventsReporter : EventsReporter {
        override fun start() = Unit
        override fun stop() = Unit
    }
}
