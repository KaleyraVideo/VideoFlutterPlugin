// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.notifications

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
//import com.bandyer.flutter_plugin.exceptions.PluginNotificationKeyNotFound
//import com.bandyer.flutter_plugin.exceptions.NotificationPayloadDataPathNotDefined
//import com.bandyer.flutter_plugin.extensions.asJSONObject
import org.json.JSONObject

/**
 * @author kristiyan
 */
class KaleyraVideoNotificationReceiver : BroadcastReceiver() {

    companion object {
        private val GCM_RECEIVE_ACTION = "com.google.android.c2dm.intent.RECEIVE"
        private val GCM_TYPE = "gcm"
        private val MESSAGE_TYPE_EXTRA_KEY = "message_type"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val bundle = intent.extras
        // check if is from gcm/fcm, else return because it is not a notification
        if (bundle == null || "google.com/iid" == bundle.getString("from")) return
        if (!isGcmMessage(intent)) {
            if (isOrderedBroadcast) resultCode = Activity.RESULT_OK
            return
        }

        // check if a bandyer notification service was defined in the manifest
        val serviceIntent = Intent().setAction("com.bandyer.NotificationEvent").setPackage(context.packageName)
        val resolveInfo = context.packageManager.queryIntentServices(serviceIntent, PackageManager.GET_RESOLVED_FILTER)
        if (resolveInfo.size < 1) return

        val bandyerPayloadPath: String
        try {
            bandyerPayloadPath = resolveInfo[0].filter.getDataPath(0).path
        } catch (e: Throwable) {
            throw Throwable("You have not defined data path in your intent-filter!! Bandyer requires it to know where to find the payload!")
        }

        val payload = getBandyerPayload(intent, bandyerPayloadPath)
        // if bandyer can handle payload proceed
        if (payload == null) {
            resultCode = Activity.RESULT_OK
            return
        }

        val component = ComponentName(context, resolveInfo[0].serviceInfo.name)

        serviceIntent.component = component
        serviceIntent.putExtra("payload", payload)

        KaleyraVideoNotificationService.enqueueWork(context, component, serviceIntent)

        if (isOrderedBroadcast) abortBroadcast()
        resultCode = Activity.RESULT_OK
    }

    private fun getBandyerPayload(intent: Intent, bandyerPayloadPath: String): String? {
        try {
            val keyPath = bandyerPayloadPath.split("\\.".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
            val payload = intent.extras!!.asJSONObject()
            if (!payload.toString().isBandyerNotification()) return null
            if (!payload.has(keyPath[0]))
                throw PluginNotificationKeyNotFound("\nRequired jsonObject:" + keyPath[0] + " is not contained in " + payload.keys().asString())
            var bandyerData = payload.getString(keyPath[0])
            for (i in 1 until keyPath.size) {
                val data = JSONObject(bandyerData)
                if (!data.has(keyPath[i]))
                    throw PluginNotificationKeyNotFound("\nRequired jsonObject:" + keyPath[i] + " is not contained in " + payload.keys().asString())
                bandyerData = JSONObject(bandyerData).getString(keyPath[i])
            }
            return bandyerData
        } catch (e: Throwable) {
            if (e is PluginNotificationKeyNotFound) {
                Log.w(
                    "BandyerNotReceiver", "Failed to handle notification!!!" + e.message +
                            "\nThis notification will not be handled by Bandyer!" +
                            "\nBandyer payload not found in the following path: " + bandyerPayloadPath
                )
            } else
                Log.w(
                    "BandyerNotReceiver", "Failed to handle notification!!!" +
                            "\nThis notification will not be handled by Bandyer!" +
                            e.localizedMessage!!
                )
        }
        return null
    }

    private fun Iterator<String>.asString(): String {
        val value = StringBuilder()
        value.append("<")
        while (hasNext()) {
            value.append(next())
            if (hasNext()) value.append(",")
        }
        value.append(">")
        return value.toString()
    }

    private fun String.isBandyerNotification(): Boolean = contains("on_call_incoming") || contains("on_message_sent");

    private fun isGcmMessage(intent: Intent): Boolean {
        if (GCM_RECEIVE_ACTION == intent.action) {
            val messageType = intent.getStringExtra(MESSAGE_TYPE_EXTRA_KEY)
            return messageType == null || GCM_TYPE == messageType
        }
        return false
    }

    private fun Bundle.asJSONObject(): JSONObject {
        val json = JSONObject()
        val keys = keySet()

        for (key in keys) {
            try {
                json.put(key, get(key))
            } catch (e: Throwable) {
                e.printStackTrace()
            }
        }
        return json
    }

    class PluginNotificationKeyNotFound(override val message: String?): Throwable(message)

}

