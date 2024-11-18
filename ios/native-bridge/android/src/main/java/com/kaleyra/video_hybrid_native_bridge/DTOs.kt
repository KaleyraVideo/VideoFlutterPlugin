package com.kaleyra.video_hybrid_native_bridge

data class AccessTokenRequest (
    val requestID: String,
    val userID: String
)

data class AccessTokenResponse (
    val data: String,
    val error: String? = null,
    val requestID: String,
    val success: Boolean
)

/**
 * This class defines the display modes supported per call.
 */
enum class CallDisplayMode {
    Background,
    Foreground,
    ForegroundPictureInPicture
}

/**
 * Options to be used when creating a call
 */
data class CreateCallOptions (
    /**
     * Array of callees identifiers to call.
     */
    val callees: List<String>,

    /**
     * Type of call to create
     */
    val callType: CallType,

    /**
     * May have three different values, NONE, AUTOMATIC, MANUAL
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: none</b>
     */
    val recordingType: RecordingType? = null
)

/**
 * This class defines the types of calls supported.
 *
 * Type of call to create
 */
enum class CallType {
    Audio,
    AudioUpgradable,
    AudioVideo
}

/**
 * Recording type of the call
 *
 * May have three different values, NONE, AUTOMATIC, MANUAL
 * <br/>
 * <br/>
 * <b><font color="blue">default</font>: none</b>
 */
enum class RecordingType {
    Automatic,
    Manual,
    None
}

/**
 * Generic configuration used for setup
 */
data class KaleyraVideoConfiguration (
    /**
     * This key will be provided to you by us.
     */
    val appID: String,

    /**
     * This variable defines the environment where you will be sandbox or production.
     */
    val environment: Environment,

    /**
     * Define to customize the iOS configuration
     */
    val iosConfig: IosConfiguration? = null,

    /**
     * Set to true to enable log, default value is false
     */
    val logEnabled: Boolean? = null,

    /**
     * This variable defines the region where you will be europe, india or us.
     */
    val region: Region,

    /**
     * Define the tools to use
     */
    val tools: Tools? = null
)

/**
 * An environment where your integration will run
 *
 * This variable defines the environment where you will be sandbox or production.
 */
data class Environment (
    /**
     * name of the environment
     */
    val name: String
)

/**
 * Configuration for iOS platform
 *
 * Define to customize the iOS configuration
 */
data class IosConfiguration (
    /**
     * Specify the callkit configuration to enable the usage and it's behaviour
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: enabled</b>
     */
    val callkit: CallKitConfiguration? = null,

    /**
     * Specify the voip handling strategy.
     * <br/>
     * This allows you to disable or leave the plugin behaviour for handling the voip
     * notifications.
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: VoipHandlingStrategy.AUTOMATIC </b>
     */
    val voipHandlingStrategy: VoipHandlingStrategy? = null
)

/**
 * Configuration for callkit
 *
 * Specify the callkit configuration to enable the usage and it's behaviour
 * <br/>
 * <br/>
 * <b><font color="blue">default</font>: enabled</b>
 */
data class CallKitConfiguration (
    /**
     * The icon resource name to be used in the callkit UI to represent the app
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: null</b>
     */
    val appIconName: String? = null,

    /**
     * Set to false to disable
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: true</b>
     */
    val enabled: Boolean? = null,

    /**
     * The ringtone resource name to be used when callkit is launched
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: system</b>
     */
    val ringtoneSoundName: String? = null
)

/**
 * This class defines the voip notification strategy per call.
 *
 * Specify the voip handling strategy.
 * <br/>
 * This allows you to disable or leave the plugin behaviour for handling the voip
 * notifications.
 * <br/>
 * <br/>
 * <b><font color="blue">default</font>: VoipHandlingStrategy.AUTOMATIC </b>
 */
enum class VoipHandlingStrategy {
    Automatic,
    Disabled
}

/**
 * A region where your integration will run
 *
 * This variable defines the region where you will be europe, india or us.
 */
data class Region (
    /**
     * name of the region
     */
    val name: String
)

/**
 * Video Module Tools
 *
 * Define the tools to use
 */
data class Tools (
    /**
     * Set to enable the chat feature
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: no chat</b>
     */
    val chat: ChatToolConfiguration? = null,

    /**
     * Set to true to enable the feedback request after a call ends.
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    val feedback: Boolean? = null,

    /**
     * Set to true to enable the file sharing feature
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    val fileShare: Boolean? = null,

    /**
     * Set to enable the screen sharing feature
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: no screen share</b>
     */
    val screenShare: ScreenShareToolConfiguration? = null,

    /**
     * Set to true to enable the whiteboard feature
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    val whiteboard: Boolean? = null
)

/**
 * Chat tool configuration
 *
 * Set to enable the chat feature
 * <br/>
 * <br/>
 * <b><font color="blue">default</font>: no chat</b>
 */
data class ChatToolConfiguration (
    /**
     * Defining this object will enable an option to start an audio call from chat UI
     */
    val audioCallOption: AudioCallOptions? = null,

    /**
     * Defining this object will enable an option to start an audio&video call from chat UI
     */
    val videoCallOption: CallOptions? = null
)

/**
 * Audio call options used for chat
 *
 * Defining this object will enable an option to start an audio call from chat UI
 */
data class AudioCallOptions (
    /**
     * May have three different values, NONE, AUTOMATIC, MANUAL
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: none</b>
     */
    val recordingType: RecordingType? = null,

    /**
     * Type of audioCall to launch when an option of the chat is tapped.
     */
    val type: AudioCallType
)

/**
 * This class defines the types of audio calls supported.
 *
 * Type of audioCall to launch when an option of the chat is tapped.
 */
enum class AudioCallType {
    Audio,
    AudioUpgradable
}

/**
 * Options available for a call
 *
 * Defining this object will enable an option to start an audio&video call from chat UI
 */
data class CallOptions (
    /**
     * May have three different values, NONE, AUTOMATIC, MANUAL
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: none</b>
     */
    val recordingType: RecordingType? = null
)

/**
 * Screen Share tool configuration
 *
 * Set to enable the screen sharing feature
 * <br/>
 * <br/>
 * <b><font color="blue">default</font>: no screen share</b>
 */
data class ScreenShareToolConfiguration (
    /**
     * Set to true to enable the in app screen share
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    val inApp: Boolean? = null,

    /**
     * Set to true to enable the whole device screen share
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    val wholeDevice: Boolean? = null
)

/**
 * Session
 */
data class Session (
    /**
     * The user id you want to connect
     */
    val userID: String
)

/**
 * This is used to define the user details in the call/chat UI
 */
data class UserDetails (
    /**
     * Image url to use as placeholder for the user.
     */
    val imageURL: String? = null,

    /**
     * The user's display name.
     */
    val name: String? = null,

    /**
     * User identifier
     */
    val userID: String
)
