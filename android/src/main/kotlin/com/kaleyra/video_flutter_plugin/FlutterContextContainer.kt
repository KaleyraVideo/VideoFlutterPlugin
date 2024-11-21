// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_flutter_plugin

import android.content.Context
import com.kaleyra.video_hybrid_native_bridge.ContextContainer
import com.kaleyra.video_utils.ContextRetainer
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class FlutterContextContainer : ContextContainer, ActivityAware {

    override var context: Context = ContextRetainer.context

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        context = binding.activity
    }

    override fun onDetachedFromActivity() {
        context = ContextRetainer.context
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()
}