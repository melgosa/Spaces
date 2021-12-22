package com.gh.spacesgh;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.monitoria/pulceras";
    private static final String TAG  = "DebugMainActivity";
    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterEngine().getDartExecutor(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler(){
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result){
                if(methodCall.method.equals("init")){
                    Log.d(TAG, "Valores : "+methodCall.argument("userName")+ ", "+methodCall.argument("idSeguimiento") );
                }else{
                    result.success("Holaaaaaa Melgosa from Java");
                }
            }
        });
    }
}
