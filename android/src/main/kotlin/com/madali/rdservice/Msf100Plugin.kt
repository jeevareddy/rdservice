package com.madali.rdservice

import android.app.Activity.RESULT_OK
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** Msf100Plugin */
class Msf100Plugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var rdService: RDService


    private var binding: ActivityPluginBinding? = null
    private var result: Result? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "msf100")
        channel.setMethodCallHandler(this)
        rdService = RDService()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        this.result = result
        if (this.binding == null) result.error("-1", "Service not initialized", "")
        when (call.method) {
            "deviceInfo" -> {
                rdService.deviceInfo(this.binding!!.activity, onError = ::handleError)
            }
            "capture" -> {
                rdService.capture(this.binding!!.activity, onError = ::handleError)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleError(it: ResultError) {
        this.result?.error(it.errorCode, it.errorMessage, it.detailedError)
        this.result = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (result == null) return true
        when (requestCode) {
            1 -> if (resultCode == RESULT_OK && requestCode == RDService.REQUESTCODE_DEVICEINFO) {
                if (data == null) {
                    result!!.error("", "No data from Service", "")
                } else {
                    val res = data.getStringExtra("RD_SERVICE_INFO")
                    if (res != null)
                        result!!.success(res)
                    else
                        result!!.error("", "No data from device", "")
                }
                result = null
                return true
            }
            2 -> if (resultCode == RESULT_OK && requestCode == RDService.REQUESTCODE_CAPTURE) {
                if (data == null) {
                    result!!.error("", "No data from device", "")
                } else {
                    val res = data.getStringExtra("PID_DATA")
                    Log.d("Msf100Plugin", res.toString())
                    if (res != null)
                        result!!.success(res)
                    else
                        result!!.error("", "No data from device", "")
                }
                result = null
                return true
            }
            else -> return false
        }
        result?.error("", "Unknown error", "")
        return false
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addActivityResultListener(this)
        rdService = RDService()
    }

    override fun onDetachedFromActivity() {
        this.binding?.removeActivityResultListener(this)
        this.binding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

}
