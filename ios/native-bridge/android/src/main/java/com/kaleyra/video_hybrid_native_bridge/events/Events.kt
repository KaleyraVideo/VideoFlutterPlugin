// To parse the JSON, install kotlin's serialization plugin and do:
//
// val json   = Json { allowStructuredMapKeys = true }
// val events = json.parse(Events.serializer(), jsonString)

package com.kaleyra.video_hybrid_native_bridge.events

import kotlinx.serialization.*
import kotlinx.serialization.json.*
import kotlinx.serialization.descriptors.*
import kotlinx.serialization.encoding.*

/**
 * This enum defines all the events that may be handled
 * <br/>
 * <br/>
 * You can listen to these events via [[BandyerPlugin.on]]
 */
@Serializable
enum class Events(val value: String) {
    @SerialName("accessTokenRequest") AccessTokenRequest("accessTokenRequest"),
    @SerialName("callError") CallError("callError"),
    @SerialName("callModuleStatusChanged") CallModuleStatusChanged("callModuleStatusChanged"),
    @SerialName("chatError") ChatError("chatError"),
    @SerialName("chatModuleStatusChanged") ChatModuleStatusChanged("chatModuleStatusChanged"),
    @SerialName("iOSVoipPushTokenInvalidated") IOSVoipPushTokenInvalidated("iOSVoipPushTokenInvalidated"),
    @SerialName("iOSVoipPushTokenUpdated") IOSVoipPushTokenUpdated("iOSVoipPushTokenUpdated"),
    @SerialName("setupError") SetupError("setupError");
}
