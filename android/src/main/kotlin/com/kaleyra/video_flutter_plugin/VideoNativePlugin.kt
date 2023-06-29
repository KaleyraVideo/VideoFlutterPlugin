// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_flutter_plugin

import android.util.Log
import com.kaleyra.video_hybrid_native_bridge.VideoSDKHybridBridge
import com.kaleyra.video_hybrid_native_bridge.utils.CaseInsensitiveEnumTypeAdapterFactory
import com.google.gson.GsonBuilder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.MainScope
import org.json.JSONArray
import kotlin.reflect.jvm.javaType
import kotlin.reflect.jvm.kotlinFunction
@Suppress("unused", "UNUSED_PARAMETER")
class VideoNativePlugin private constructor(private val contextContainer: FlutterContextContainer) : FlutterPlugin, MethodCallHandler, ActivityAware by contextContainer {
    constructor() : this(FlutterContextContainer())

    private lateinit var channel: MethodChannel

    private lateinit var proxyPlugin: VideoSDKHybridBridge

    companion object {
        internal val gson = GsonBuilder().registerTypeAdapterFactory(CaseInsensitiveEnumTypeAdapterFactory()).create()
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val eventsEmitterChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "kaleyra_dart_channel")
        proxyPlugin = VideoSDKHybridBridge(
            contextContainer,
            tokenProvider = FlutterTokenProvider(eventsEmitterChannel, MainScope()),
            eventsEmitter = FlutterEventsEmitter(eventsEmitterChannel, MainScope())
        )
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "kaleyra_native_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = channel.setMethodCallHandler(null)

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.v("Invoked", "hybrid_method=${call.method}, args=${call.arguments} ")
        val arguments = JSONArray(call.arguments?.toString()?.let { arrayOf(it) } ?: arrayOf<Any>())
        if (proxyPlugin.invoke(call.method, arguments)) result.success(true)
        else result.notImplemented()
    }

    fun VideoSDKHybridBridge.invoke(functionName: String, params: JSONArray, result: Result? = null): Boolean {
        this::class.java.methods.find { it.name == functionName }?.kotlinFunction?.let { function ->
            when {
                params.length() == 1 -> {
                    val arg = gson.fromJson<Any>(params.getString(0), function.parameters[1].type.javaType)
                    result?.let { function.call(this, arg, it) } ?: function.call(this, arg)
                }
                else                 -> result?.let { function.call(this, it) } ?: function.call(this)
            }
            return true
        }
        return false
    }

}
