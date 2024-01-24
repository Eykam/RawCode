package com.example.project2

import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        var textViewStop = findViewById<TextView>(R.id.textView)
        var textViewWait = findViewById<TextView>(R.id.textView2)
        var textViewGo = findViewById<TextView>(R.id.textView3)
        var buttonRUN = findViewById<Button>(R.id.button2)

        textViewStop.setBackgroundColor(Color.parseColor("#FF0000"))

        var counter = 2
        buttonRUN.setOnClickListener{
            if (counter == 0){
                textViewGo.setBackgroundColor(Color.parseColor("#00FF00"))
                textViewWait.setBackgroundColor(Color.parseColor("#00FFFFFF"))
                textViewStop.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
            else if (counter == 1){
                textViewGo.setBackgroundColor(Color.parseColor("#00FFFFFF"))
                textViewWait.setBackgroundColor(Color.parseColor("#FFFF00"))
                textViewStop.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
            else{
                textViewGo.setBackgroundColor(Color.parseColor("#00FFFFFF"))
                textViewWait.setBackgroundColor(Color.parseColor("#00FFFFFF"))
                textViewStop.setBackgroundColor(Color.parseColor("#FF0000"))
            }
            counter = (counter + 1) % 3
        }
    }
}