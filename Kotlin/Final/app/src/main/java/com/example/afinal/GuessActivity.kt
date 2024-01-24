package com.example.afinal

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.TextView
import android.widget.Toast
import android.widget.Toast.makeText
import androidx.appcompat.app.AppCompatActivity
import java.util.*
import kotlin.concurrent.schedule
import kotlin.random.Random

class GuessActivity : AppCompatActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_guess)

        var answer = intent.getStringExtra("country")

        var question = findViewById<TextView>(R.id.question)
        var submit = findViewById<Button>(R.id.submit)
        var choice = findViewById<RadioGroup>(R.id.radioGroup)
        var mapObject = MapObject()
        var alternateChoices = mapObject.getRemainingChoices(answer)

        question.text = "What Country was the previous image from?"

        var correctAnswer = Random.nextInt(1,5)
        lateinit var correctID : TextView

        var choice1 = findViewById<TextView>(R.id.radioButton1)
        var choice2 = findViewById<TextView>(R.id.radioButton2)
        var choice3 = findViewById<TextView>(R.id.radioButton3)
        var choice4 = findViewById<TextView>(R.id.radioButton4)

        when (correctAnswer) {
            1 -> {
                choice1.text = answer
                choice2.text = alternateChoices.get(0)
                choice3.text = alternateChoices.get(1)
                choice4.text = alternateChoices.get(2)

                correctID = choice1
            }
            2 -> {
                choice2.text = answer
                choice1.text = alternateChoices.get(0)
                choice3.text = alternateChoices.get(1)
                choice4.text = alternateChoices.get(2)

                correctID = choice2
            }
            3 -> {
                choice3.text = answer
                choice2.text = alternateChoices.get(0)
                choice1.text = alternateChoices.get(1)
                choice4.text = alternateChoices.get(2)

                correctID = choice3
            }
            else -> {
                choice4.text = answer
                choice2.text = alternateChoices.get(0)
                choice3.text = alternateChoices.get(1)
                choice1.text = alternateChoices.get(2)

                correctID = choice4
            }
        }

        submit.setOnClickListener{
            var givenAnswer = choice.checkedRadioButtonId


            var buttonText = findViewById<RadioButton>(givenAnswer)
            var prefs  = this!!.getSharedPreferences( this.packageName + "_preferences", Context.MODE_PRIVATE )
            var gamesWon = prefs.getInt("gamesWon", 0)
            var totalGames = prefs.getInt("totalGames", 0)
            var editor = prefs.edit()

            if(buttonText?.text == answer){

                buttonText.setBackgroundColor(Color.GREEN)

                var results = makeText(this, "Correct!", Toast.LENGTH_LONG)
                results.show()
                gamesWon = gamesWon + 1
                editor.putInt("gamesWon", gamesWon)

            }else{
                buttonText.setBackgroundColor(Color.RED)
                correctID.setBackgroundColor(Color.GREEN)

                var results = makeText(this, "Incorrect!", Toast.LENGTH_LONG)
                results.show()
            }

            totalGames = totalGames + 1
            editor.putInt("totalGames", totalGames)
            editor.commit()

            val intent = Intent(this, MainActivity::class.java)

            Timer("SettingUp", false).schedule(2000) {
                startActivity(intent)
            }


        }
    }
}