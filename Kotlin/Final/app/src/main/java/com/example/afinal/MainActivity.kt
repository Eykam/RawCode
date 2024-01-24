package com.example.afinal

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import android.widget.Switch
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.initialization.InitializationStatus
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener


class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        val startButton = findViewById<View>(R.id.start)
        var prefs  = this!!.getSharedPreferences( this.packageName + "_preferences", Context.MODE_PRIVATE )
        var gamesWon = prefs.getInt("gamesWon", 0)
        var totalGames = prefs.getInt("totalGames", 0)
        var difficulty = prefs.getString("difficulty","Easy")

        var won = findViewById<TextView>(R.id.won)
        var total = findViewById<TextView>(R.id.total)

        var difficultyButton = findViewById<Switch>(R.id.difficulty)

        if(difficulty == "hard"){
            difficultyButton.toggle()
        }

        difficultyButton.text = difficulty



        won.text = "Rounds Won: " + gamesWon
        total.text = "Total Games: " + totalGames


        var initializer : AdInitializer = AdInitializer()
        MobileAds.initialize( this, initializer )

        // build the Adview
        var adView: AdView = AdView( this )

        var adSize : AdSize = AdSize( AdSize.FULL_WIDTH, AdSize.AUTO_HEIGHT )
        adView.setAdSize( adSize )
        var adUnitId : String = "ca-app-pub-3940256099942544/6300978111"
        adView.adUnitId = adUnitId

        // build the AdRequest
        var builder : AdRequest.Builder = AdRequest.Builder( )
        builder.addKeyword( "workout" )
        builder.addKeyword( "fitness" )
        var request : AdRequest = builder.build()

        // add adView to LinearLayout
        var adLayout : LinearLayout = findViewById<LinearLayout>( R.id.ad_view )
        adLayout.addView( adView )

        adLayout.y = 1660F

        // load the ad
        try {
            adView.loadAd( request )
        } catch( e : Exception ) {
            Log.w( "MainActivity", "Ad failed tom load" )
        }

        difficultyButton.setOnCheckedChangeListener { _,isChecked ->
            if (isChecked){
                difficulty = "hard"
                difficultyButton.text = "Hard"
            }else{
                difficulty = "easy"
                difficultyButton.text = "Easy"
            }

            var editor = prefs.edit()
            editor.putString("difficulty", difficulty)
            editor.commit()
        }

        startButton.setOnClickListener {
            adView.destroy()

            val intent = Intent(this, MapsActivity::class.java)
            intent.putExtra("difficulty",difficulty)
            startActivity(intent)
        }
    }

    class AdInitializer : OnInitializationCompleteListener {
        override fun onInitializationComplete(p0: InitializationStatus) {
            Log.w( "MainActivty", "ad initialization complete" )
        }

    }
}