package com.example.fluter_power_method_channels

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.util.Log
import android.view.KeyEvent
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private var screenBroadcastReceiver:ScreenBroadcastReceiver? = null
     private val CHANNEL = "samples.flutter.dev/battery"
     private val intentFilter = IntentFilter()
    private var countPowerOff = 0

     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
         super.configureFlutterEngine(flutterEngine)


         intentFilter.addAction("android.intent.action.SCREEN_ON")
         intentFilter.addAction("android.intent.action.SCREEN_OFF")

         intentFilter.priority = 100

         screenBroadcastReceiver = ScreenBroadcastReceiver()

         registerReceiver(screenBroadcastReceiver,intentFilter)

         Log.d(ScreenBroadcastReceiver.SCREEN_TOGGLE_TAG, "onCreate: screenOnOffReceiver is registered.")

         MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler{
             call,result ->

             if (call.method == "getBatteryLevel"){
                 val batteryLevel = getBatteryLevel()

                 if (batteryLevel != -1){
                     result.success(batteryLevel)
                 }else{
                     result.error("UNAVAILABLE", "Battery level not available.",null)
                 }
             }else{
                 result.notImplemented()
             }
         }

     }
 
     private fun getBatteryLevel(): Int {
         val batteryLevel : Int
         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
             val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
             batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
         }else{
             val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(
                 Intent.ACTION_BATTERY_CHANGED))
             batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 /intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)

         }
         return batteryLevel
     }


     override fun onDestroy() {
         super.onDestroy()
       
         intentFilter.addAction("android.intent.action.SCREEN_ON")
         intentFilter.addAction("android.intent.action.SCREEN_OFF")

         intentFilter.priority = 100

         screenBroadcastReceiver = ScreenBroadcastReceiver()

         registerReceiver(screenBroadcastReceiver,intentFilter)

         Log.d(ScreenBroadcastReceiver.SCREEN_TOGGLE_TAG, "onCreate: screenOnOffReceiver is registered.")


     }

 }


