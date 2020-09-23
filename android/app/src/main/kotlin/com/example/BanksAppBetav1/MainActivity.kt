package com.example.BanksAppBetav1


import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import android.widget.Toast
import androidx.security.crypto.EncryptedFile
import androidx.security.crypto.MasterKeys
import java.io.*
import java.lang.StringBuilder
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import java.security.Provider

class MainActivity: FlutterActivity() {
  private val CHANNEL = "samples.flutter.dev/encryption"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
       if (call.method == "encryptData") {
        // (call.arguments as? String)  ?: "1234"
      var text:String  = ""
       val test :String?= call.argument<String>("text") ;
       if(test != null){
       text = test      
         
       }
        val gotencryptData = getEncryptData(text)

        if (gotencryptData != null) {
          result.success(gotencryptData)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }
      } 
      else if(call.method == "readEncData"){
        val readEncryptData = readEncryptData()

        if (readEncryptData != null) {
          result.success(readEncryptData)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }

      }
      else {
        result.notImplemented()
      }
    }
      // Note: this method is invoked on the main thread.
      // TODO
    }

   
// private fun init()
// { 
//     lateinit var secretFile: File
//      lateinit var encryptedFile: EncryptedFile

//       secretFile = File(filesDir, "secret")

//         encryptedFile = EncryptedFile.Builder(
//             secretFile,
//             applicationContext,
//             MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC), //master key
//             EncryptedFile.FileEncryptionScheme.AES256_GCM_HKDF_4KB
//         )
//             .setKeysetAlias("file_key") //optional
//             .setKeysetPrefName("secret_file_shared_prefs")  //optional
//             .build()
// }
lateinit var secretFile: File
lateinit var encryptedFile: EncryptedFile

 


      
     private fun getEncryptData(abc: String): String {
        var encryptedData : String = ""   
 if(VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP){
   
     secretFile = File(filesDir, "encrypt")

       encryptedFile = EncryptedFile.Builder(
           secretFile,
           applicationContext,
           MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC), //master key
           EncryptedFile.FileEncryptionScheme.AES256_GCM_HKDF_4KB
       )
           .setKeysetAlias("file_key") //optional
           .setKeysetPrefName("secret_file_shared_prefs")  //optional
           .build()


                /**
                 * Editing an already saved file throws an exception
                 */

                secretFile.delete()

                encryptedFile.openFileOutput().use { outputstream ->
                    outputstream.write(abc.toByteArray())

                   
                }


          

             if (secretFile.exists()) {
            val strBuilder = StringBuilder()
            BufferedReader(FileReader(secretFile)).readLines().forEach {
                strBuilder.append(it)
            }
            encryptedData = strBuilder.toString()
        } 
    }
    return encryptedData 
}




    private fun readEncryptData(): String {
        var abcf : String = ""
        if(VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP){
    //         lateinit var secretFile: File
    // lateinit var encryptedFile: EncryptedFile

    //  secretFile = File(filesDir, "secret1")

    //    encryptedFile = EncryptedFile.Builder(
    //        secretFile,
    //        applicationContext,
    //        MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC), //master key
    //        EncryptedFile.FileEncryptionScheme.AES256_GCM_HKDF_4KB
    //    )
    //        .setKeysetAlias("file_key") //optional
    //        .setKeysetPrefName("secret_file_shared_prefs")  //optional
    //        .build()
    secretFile = File(filesDir, "encrypt")

               encryptedFile.openFileInput().use { inputstream ->
                abcf = String(inputstream.readBytes(), Charsets.UTF_8)
            }
        
    }
    return abcf


  }


}

     

