package com.example.fluter_power_method_channels

import android.content.*
import android.os.Build
import android.util.Log
import android.widget.Toast
import android.os.VibrationEffect
import android.os.Vibrator
import android.content.Intent
import android.net.Uri

class ScreenBroadcastReceiver: BroadcastReceiver() {
    private val CHANNEL = "samples.flutter.dev/battery"
    var countPowerOff = 0
    private lateinit var context: Context

    override fun onReceive(context: Context, intent: Intent) {

        val action = intent.action
        if (Intent.ACTION_SCREEN_OFF == action){
             Log.d(SCREEN_TOGGLE_TAG,"Screen is now off.")
            val vibrator:Vibrator = context.applicationContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            vibrator.vibrate(2000)
             countPowerOff++
         }else if (Intent.ACTION_SCREEN_ON == action){
             Log.d(SCREEN_TOGGLE_TAG,"Screen is now on.")
            Log.d(SCREEN_TOGGLE_TAG,getBatteryLevel())

             if (countPowerOff==3){
                 val dialIntent = Intent(Intent.ACTION_DIAL)
                 dialIntent.data = Uri.parse("tel:"+"911")
                 context.startActivity(dialIntent)

                 val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                 if (vibrator.hasVibrator()) { // Vibrator availability checking
                     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                         vibrator.vibrate(VibrationEffect.createOneShot(3000, VibrationEffect.DEFAULT_AMPLITUDE)) // New vibrate method for API Level 26 or higher
                     } else {
                         vibrator.vibrate(3000) // Vibrate method for below API Level 26
                     }
                 }
                 Log.d(SCREEN_TOGGLE_TAG,"Sending emergency message now... ")
                 Toast.makeText(context, "Power button clicked 3 times", Toast.LENGTH_SHORT).show()
                 countPowerOff = 0
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


     companion object {
         const val SCREEN_TOGGLE_TAG = "SCREEN_TOGGLE_TAG"
     }

 }