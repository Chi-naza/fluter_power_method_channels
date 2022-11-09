// 5


// You should be implement below way

// Dart Code

// method_channel_helper.dart

// class AmazonFileUpload {
//   static const platform = const MethodChannel('amazon');
//   static StreamController<String> _controller = StreamController.broadcast();

//   static Stream get streamData => _controller.stream;

//   Future<BaseResponse> uploadFile() async {
//     try {
//       platform.setMethodCallHandler((call) {
//         switch (call.method) {
//           case "callBack":
//             _controller.add("");
//             break;
//         }
//       });
//       final Map result = await platform.invokeMethod('s3_upload');
//       return BaseResponse(result["success"], result["error"], "");
//     } on PlatformException catch (e) {
//       return BaseResponse(false, e.message, "");
//     }
//   }
// }
// home_page.dart

// class _HomePageState extends State<HomePage> {

//   @override
//   void initState() {
//     super.initState();
//     AmazonFileUpload.streamData.listen((event) {
//       print("========$callbackFromKotlinToDart--------");
//     });
//     AmazonFileUpload().uploadFile();



//   @override
//   Widget build(BuildContext context) {

// }
// Android Code

// class MainActivity : FlutterActivity(), TransferListener {
//     private val CHANNEL = "amazon"

//     var methodResult: MethodChannel.Result? = null
//     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//         GeneratedPluginRegistrant.registerWith(flutterEngine);
//         val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

//         channel.setMethodCallHandler { call, result ->
//             methodResult = result
//             if (call.method == "s3_upload") {
//                 //Add you login here 
//                 channel.invokeMethod("callBack", "data1")



//             }
//         }

//     }
// Share
// Edit
// Follow




//this is kotlin main activity code
// package com.example.fluter_power_method_channel


// import ScreenBroadcastReceiver
// import android.content.*
// import android.os.BatteryManager
// import android.os.Build
// import android.util.Log
// import android.view.KeyEvent
// import android.view.Window
// import android.view.WindowManager
// import android.widget.Toast
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel

// class MainActivity: FlutterActivity() {
//     private var screenBroadcastReceiver:ScreenBroadcastReceiver? = null
//     private val CHANNEL = "samples.flutter.dev/battery"
//     private val intentFilter = IntentFilter()

//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)

//         intentFilter.addAction("android.intent.action.SCREEN_ON")
//         intentFilter.addAction("android.intent.action.SCREEN_OFF")

//         intentFilter.priority = 100

//         screenBroadcastReceiver = ScreenBroadcastReceiver()

//         registerReceiver(screenBroadcastReceiver,intentFilter)

//         Log.d(ScreenBroadcastReceiver.SCREEN_TOGGLE_TAG, "onCreate: screenOnOffReceiver is registered.")

// //        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler{
// //            call,result ->
// //
// //            if (call.method == "getBatteryLevel"){
// //                val batteryLevel = getBatteryLevel()
// //
// //                if (batteryLevel != -1){
// //                    result.success(batteryLevel)
// //                }else{
// //                    result.error("UNAVAILABLE", "Battery level not available.",null)
// //                }
// //            }else{
// //                result.notImplemented()
// //            }
// //        }

//     }
//     // onKeyDown handles what happens when the volume button-keys are pressed
//     override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
//         when (keyCode) {
//             KeyEvent.KEYCODE_VOLUME_DOWN -> Toast.makeText(applicationContext, "Volume Down Key Pressed", Toast.LENGTH_SHORT).show()
//             KeyEvent.KEYCODE_VOLUME_UP -> Toast.makeText(applicationContext, "Volume Up Key Pressed", Toast.LENGTH_SHORT).show()
//             KeyEvent.KEYCODE_BACK -> Toast.makeText(applicationContext, "Back Key Pressed", Toast.LENGTH_SHORT).show()

//         }
//         if (keyCode == KeyEvent.KEYCODE_POWER) {
//             // Do something here...
//             Toast.makeText(applicationContext, "Power Key Pressed", Toast.LENGTH_SHORT).show()
//             event?.startTracking(); // Needed to track long presses
//             return true;
//         }

//         return super.onKeyDown(keyCode, event);
//     }

//     // getVatteryLevel is a function that gets the mobile phone's battery percentage
//     private fun getBatteryLevel(): Int {
//         val batteryLevel : Int
//         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
//             val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
//             batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//         }else{
//             val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
//             batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 /intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)

//         }
//         return batteryLevel
//     }


//     override fun onDestroy() {
//         super.onDestroy()
//         // Unregister screenOnOffReceiver when destroy.
// //        if (screenBroadcastReceiver != null) {
// //            unregisterReceiver(screenBroadcastReceiver)
// //            Log.d(
// //                ScreenBroadcastReceiver.SCREEN_TOGGLE_TAG,
// //                "onDestroy: screenOnOffReceiver is unregistered."
// //            )
// //        }
//         intentFilter.addAction("android.intent.action.SCREEN_ON")
//         intentFilter.addAction("android.intent.action.SCREEN_OFF")

//         intentFilter.priority = 100

//         screenBroadcastReceiver = ScreenBroadcastReceiver()

//         registerReceiver(screenBroadcastReceiver,intentFilter)

//         Log.d(ScreenBroadcastReceiver.SCREEN_TOGGLE_TAG, "onCreate: screenOnOffReceiver is registered.")


//     }

// }



// broadcast receiver code

// import android.content.BroadcastReceiver
// import android.content.Context
// import android.content.Intent
// import android.util.Log
// import android.widget.Toast

// class ScreenBroadcastReceiver:BroadcastReceiver(){
//     var countPowerOff = 0
//     override fun onReceive(context: Context?, intent: Intent?) {
//         val action = intent?.action
//         if (Intent.ACTION_SCREEN_OFF == action){
//             Log.d(SCREEN_TOGGLE_TAG,"Screen is now off.")
//             countPowerOff++
//         }else if (Intent.ACTION_SCREEN_ON == action){
//             Log.d(SCREEN_TOGGLE_TAG,"Screen is now on.")

//             if (countPowerOff==3){
//                 Log.d(SCREEN_TOGGLE_TAG,"Sending emergency message now...")
//                 Toast.makeText(context, "Power button clicked 3 times", Toast.LENGTH_SHORT).show()
//                 countPowerOff = 0
//             }
//         }

//     }
//     companion object {
//         const val SCREEN_TOGGLE_TAG = "SCREEN_TOGGLE_TAG"
//     }

// }

