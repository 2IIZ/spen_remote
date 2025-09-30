package com.twiz.spen_remote

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.EventChannel
import com.samsung.android.sdk.penremote.*

class SpenRemotePlugin: 
    FlutterPlugin, 
    MethodChannel.MethodCallHandler, 
    EventChannel.StreamHandler,
    ActivityAware {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    private var context: Context? = null
    private var activity: Activity? = null
    private var spenUnitManager: SpenUnitManager? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        methodChannel = MethodChannel(binding.binaryMessenger, "spen_remote/methods")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(binding.binaryMessenger, "spen_remote/events")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    // Handle activity context
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "connect" -> {
                val act = activity
                if (act == null) {
                    result.error("NO_ACTIVITY", "Activity context not available", null)
                    return
                }
                connect(act)
                result.success(null)
            }
            "disconnect" -> {
                disconnect()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun connect(act: Activity) {
        val spenRemote = SpenRemote.getInstance()
        if (!spenRemote.isConnected) {
            spenRemote.connect(act, object : SpenRemote.ConnectionResultCallback {
                override fun onSuccess(manager: SpenUnitManager) {
                    spenUnitManager = manager
                    initListeners()
                }
                override fun onFailure(error: Int) {
                    activity?.runOnUiThread {
                        eventSink?.error("CONNECT_FAILED", "Error code $error", null)
                    }
                }
            })
        }
    }

    private fun disconnect() {
        val spenRemote = SpenRemote.getInstance()
        if (spenRemote.isConnected) {
            activity?.let { spenRemote.disconnect(it) }
        }
        spenUnitManager = null
    }

    private fun initListeners() {
        val manager = spenUnitManager ?: return

        // Button unit
        val buttonUnit = manager.getUnit(SpenUnit.TYPE_BUTTON)
        if (buttonUnit != null) {
            manager.registerSpenEventListener({ event ->
                val be = ButtonEvent(event)
                val map = hashMapOf<String, Any>(
                    "type" to "button",
                    "action" to be.action
                )
                activity?.runOnUiThread {
                    eventSink?.success(map)
                }
            }, buttonUnit)
        }

        // Air motion unit
        val motionUnit = manager.getUnit(SpenUnit.TYPE_AIR_MOTION)
        if (motionUnit != null) {
            manager.registerSpenEventListener({ event ->
                val am = AirMotionEvent(event)
                val map = hashMapOf<String, Any>(
                    "type" to "motion",
                    "dx" to am.deltaX,
                    "dy" to am.deltaY
                )
                activity?.runOnUiThread {
                    eventSink?.success(map)
                }
            }, motionUnit)
        }
    }

    // EventChannel.StreamHandler
    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        eventSink = sink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
