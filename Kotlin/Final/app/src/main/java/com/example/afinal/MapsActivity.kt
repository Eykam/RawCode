package com.example.afinal
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.SystemClock
import android.widget.Chronometer
import com.google.android.gms.maps.MapsInitializer
import com.google.android.gms.maps.SupportStreetViewPanoramaFragment
import com.google.android.gms.maps.model.LatLng
import java.util.*
import kotlin.concurrent.schedule
import android.util.Log

class MapsActivity : AppCompatActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_maps)

        val mapObject = MapObject()
        val randCountry = mapObject.getRandomCountry()

        val country = randCountry.getString("country")
        val countryToGuess = LatLng(randCountry.getDouble("lat"), randCountry.getDouble("lng"))
        val difficulty = intent.getStringExtra("difficulty")
        var time = 0L

        when (difficulty) {
            "hard" -> {
                time = 10000L
            }
            else -> {
                time = 15000L
            }
        }

        Log.d("Country", randCountry.toString())

        val streetViewPanoramaFragment =
            supportFragmentManager.findFragmentById(R.id.streetviewpanorama) as SupportStreetViewPanoramaFragment?

        streetViewPanoramaFragment?.getStreetViewPanoramaAsync { panorama ->
            // Only set the panorama to SYDNEY on startup (when no panoramas have been
            // loaded which is when the savedInstanceState is null).
            savedInstanceState ?: panorama.setPosition(countryToGuess, 1000)
        }


        var view_timer : Chronometer= findViewById<Chronometer>(R.id.view_timer)
        view_timer.stop()
        view_timer.isCountDown =true
        view_timer.base = SystemClock.elapsedRealtime() + time
        view_timer.start()

        Timer("SettingUp", false).schedule(time) {
            moveToGuess(country)
        }
    }

    fun moveToGuess(country : String) {
        val intent = Intent(this, GuessActivity::class.java)
        intent.putExtra("country", country)
        startActivity(intent)
    }

}