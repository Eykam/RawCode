package com.example.project3

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class EncryptActivity: AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_encrypt)

        var stringToShift = findViewById<EditText>(R.id.shiftInput)
        var shiftAmountLabel = findViewById<TextView>(R.id.shiftAmountLabel)
        var shiftedString = findViewById<TextView>(R.id.resultingString)
        var shiftButton = findViewById<Button>(R.id.encryptButton)
        var backButton = findViewById<Button>(R.id.backButton)

        val extras = intent
        var encryptionObj = Encryption()

        if (extras != null) {
            var offset = extras.getIntExtra("encryptionOffset",0)

            shiftAmountLabel.text = "Shift = " + offset.toString()

            var str = stringToShift.text.toString()

            encryptionObj .setOff(offset)
        }

        shiftButton.setOnClickListener{
            var str = stringToShift.text.toString()

            if (str != ""){
                shiftedString.text = encryptionObj.encrypt(str)
            }
        }

        backButton.setOnClickListener{
            val intent = Intent(this, MainActivity::class.java)
            intent.putExtra("encryptionOffset", extras.getIntExtra("encryptionOffset",0))

            startActivity(intent)
        }

    }
}