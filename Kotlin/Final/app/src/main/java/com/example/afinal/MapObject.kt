package com.example.afinal

import android.util.Log
import org.json.JSONArray
import org.json.JSONObject
import kotlin.random.Random

class MapObject {

    val mapObject = """
   [{
      "lat": 35.6897,
      "lng": 139.6922,
      "country": "Japan"
   },
   {
      "lat": -6.175,
      "lng": 106.8275,
      "country": "Indonesia"
   },
   {
      "lat": 28.61,
      "lng": 77.23,
      "country": "India"
   },
   {
      "lat": 23.13,
      "lng": 113.26,
      "country": "China"
   },
   {
      "lat": 19.0761,
      "lng": 72.8775,
      "country": "India"
   },
   {
      "lat": 14.5958,
      "lng": 120.9772,
      "country": "Philippines"
   },
   {
      "lat": 31.1667,
      "lng": 121.4667,
      "country": "China"
   },
   {
      "lat": -23.55,
      "lng": -46.6333,
      "country": "Brazil"
   },
   {
      "lat": 37.56,
      "lng": 126.99,
      "country": "South Korea"
   },
   {
      "lat": 19.4333,
      "lng": -99.1333,
      "country": "Mexico"
   },
   {
      "lat": 30.0444,
      "lng": 31.2358,
      "country": "Egypt"
   },
   {
      "lat": 40.6943,
      "lng": -73.9249,
      "country": "United States"
   },
   {
      "lat": 23.7639,
      "lng": 90.3889,
      "country": "Bangladesh"
   },
   {
      "lat": 39.904,
      "lng": 116.4075,
      "country": "China"
   },
   {
      "lat": 22.5675,
      "lng": 88.37,
      "country": "India"
   },
   {
      "lat": 13.7525,
      "lng": 100.4942,
      "country": "Thailand"
   },
   {
      "lat": 22.535,
      "lng": 114.054,
      "country": "China"
   },
   {
      "lat": 55.7558,
      "lng": 37.6178,
      "country": "Russia"
   },
   {
      "lat": -34.5997,
      "lng": -58.3819,
      "country": "Argentina"
   },
   {
      "lat": 6.455,
      "lng": 3.3841,
      "country": "Nigeria"
   },
   {
      "lat": 41.0136,
      "lng": 28.955,
      "country": "Turkey"
   },
   {
      "lat": 24.86,
      "lng": 67.01,
      "country": "Pakistan"
   },
   {
      "lat": 12.9789,
      "lng": 77.5917,
      "country": "India"
   },
   {
      "lat": 10.7756,
      "lng": 106.7019,
      "country": "Vietnam"
   },
   {
      "lat": 34.6939,
      "lng": 135.5022,
      "country": "Japan"
   },
   {
      "lat": 30.66,
      "lng": 104.0633,
      "country": "China"
   },
   {
      "lat": 35.6892,
      "lng": 51.3889,
      "country": "Iran"
   },
   {
      "lat": -4.325,
      "lng": 15.3222,
      "country": "Congo (Kinshasa)"
   },
   {
      "lat": -22.9111,
      "lng": -43.2056,
      "country": "Brazil"
   },
   {
      "lat": 13.0825,
      "lng": 80.275,
      "country": "India"
   },
   {
      "lat": 34.2667,
      "lng": 108.9,
      "country": "China"
   },
   {
      "lat": 31.5497,
      "lng": 74.3436,
      "country": "Pakistan"
   },
   {
      "lat": 29.55,
      "lng": 106.5069,
      "country": "China"
   },
   {
      "lat": -4.2694,
      "lng": 15.2714,
      "country": "Congo (Brazzaville)"
   },
   {
      "lat": 42.0127,
      "lng": 121.6486,
      "country": "China"
   },
   {
      "lat": 37.9278,
      "lng": 102.6329,
      "country": "China"
   },
   {
      "lat": 36.8,
      "lng": 34.6333,
      "country": "Turkey"
   },
   {
      "lat": 23.25,
      "lng": 77.4167,
      "country": "India"
   },
   {
      "lat": -11.6647,
      "lng": 27.4794,
      "country": "Congo (Kinshasa)"
   },
   {
      "lat": -8.65,
      "lng": 115.2167,
      "country": "Indonesia"
   },
   {
      "lat": 7.0667,
      "lng": 125.6,
      "country": "Philippines"
   },
   {
      "lat": 34.1299,
      "lng": 118.7734,
      "country": "China"
   },
   {
      "lat": 37,
      "lng": 35.3213,
      "country": "Turkey"
   },
   {
      "lat": 33.5131,
      "lng": 36.2919,
      "country": "Syria"
   },
   {
      "lat": 50.8467,
      "lng": 4.3525,
      "country": "Belgium"
   },
   {
      "lat": 25.3792,
      "lng": 68.3683,
      "country": "Pakistan"
   },
   {
      "lat": 37.91,
      "lng": 40.24,
      "country": "Turkey"
   },
   {
      "lat": 37.3012,
      "lng": -121.848,
      "country": "United States"
   },
   {
      "lat": 18.6186,
      "lng": 73.8037,
      "country": "India"
   },
   {
      "lat": -34.8836,
      "lng": -56.1819,
      "country": "Uruguay"
   },
   {
      "lat": 40.4397,
      "lng": -79.9763,
      "country": "United States"
   },
   {
      "lat": 39.3408,
      "lng": 112.4292,
      "country": "China"
   },
   {
      "lat": 39.1413,
      "lng": -84.506,
      "country": "United States"
   },
   {
      "lat": 41.292,
      "lng": 123.761,
      "country": "China"
   },
   {
      "lat": 36.5448,
      "lng": 104.1766,
      "country": "China"
   },
   {
      "lat": 36.34,
      "lng": 43.13,
      "country": "Iraq"
   },
   {
      "lat": 40.7834,
      "lng": -73.9662,
      "country": "United States"
   },
   {
      "lat": 14.65,
      "lng": 120.97,
      "country": "Philippines"
   },
   {
      "lat": 0.3136,
      "lng": 32.5811,
      "country": "Uganda"
   },
   {
      "lat": 25.6,
      "lng": 85.1,
      "country": "India"
   },
   {
      "lat": 14.1,
      "lng": -87.2167,
      "country": "Honduras"
   },
   {
      "lat": 41.4764,
      "lng": -81.6805,
      "country": "United States"
   },
   {
      "lat": 30.82,
      "lng": 108.4,
      "country": "China"
   },
   {
      "lat": 31.65,
      "lng": 120.7333,
      "country": "China"
   },
   {
      "lat": 21.4225,
      "lng": 39.8233,
      "country": "Saudi Arabia"
   },
   {
      "lat": 50.2458,
      "lng": 127.4886,
      "country": "China"
   },
   {
      "lat": 29.2942,
      "lng": 117.2036,
      "country": "China"
   },
   {
      "lat": 9.5092,
      "lng": -13.7122,
      "country": "Guinea"
   },
   {
      "lat": -8.05,
      "lng": -34.9,
      "country": "Brazil"
   },
   {
      "lat": 39.7771,
      "lng": -86.1458,
      "country": "United States"
   },
   {
      "lat": 30.3005,
      "lng": -97.7522,
      "country": "United States"
   },
   {
      "lat": -6.2889,
      "lng": 106.7181,
      "country": "Indonesia"
   },
   {
      "lat": 39.1238,
      "lng": -94.5541,
      "country": "United States"
   },
   {
      "lat": 24.965,
      "lng": 121.2168,
      "country": "Taiwan"
   },
   {
      "lat": 55.0333,
      "lng": 82.9167,
      "country": "Russia"
   },
   {
      "lat": 22.09,
      "lng": 82.15,
      "country": "India"
   },
   {
      "lat": -6.9667,
      "lng": 110.4167,
      "country": "Indonesia"
   },
   {
      "lat": 30.91,
      "lng": 75.85,
      "country": "India"
   },
   {
      "lat": 23.62,
      "lng": 90.5,
      "country": "Bangladesh"
   },
   {
      "lat": 59.3294,
      "lng": 18.0686,
      "country": "Sweden"
   },
   {
      "lat": 35.0833,
      "lng": 117.15,
      "country": "China"
   },
   {
      "lat": 27.18,
      "lng": 78.02,
      "country": "India"
   },
   {
      "lat": 13.3558,
      "lng": -9.5517,
      "country": "Mali"
   },
   {
      "lat": 27.18,
      "lng": 78.02,
      "country": "India"
   },
   {
      "lat": 21.1167,
      "lng": -101.6833,
      "country": "Mexico"
   },
   {
      "lat": 5.3167,
      "lng": -4.0667,
      "country": "CÃ´te d'Ivoire"
   },
   {
      "lat": 19.0333,
      "lng": -98.1833,
      "country": "Mexico"
   },
   {
      "lat": 9.9252,
      "lng": 78.1198,
      "country": "India"
   },
   {
      "lat": 35.7497,
      "lng": 114.2887,
      "country": "China"
   },
   {
      "lat": -31.4167,
      "lng": -64.1833,
      "country": "Argentina"
   },
   {
      "lat": 29.61,
      "lng": 52.5425,
      "country": "Iran"
   },
   {
      "lat": 22.7925,
      "lng": 86.1842,
      "country": "India"
   },
   {
      "lat": 38.0814,
      "lng": 46.3006,
      "country": "Iran"
   },
   {
      "lat": 30.8925,
      "lng": 120.0875,
      "country": "China"
   },
   {
      "lat": 39.9862,
      "lng": -82.9855,
      "country": "United States"
   },
   {
      "lat": 42.7,
      "lng": 23.33,
      "country": "Bulgaria"
   },
   {
      "lat": 35.5167,
      "lng": 139.7,
      "country": "Japan"
   },
   {
      "lat": 9.9325,
      "lng": -84.08,
      "country": "Costa Rica"
   },
   {
      "lat": 5.1167,
      "lng": 7.3667,
      "country": "Nigeria"
   },
   {
      "lat": -2.9861,
      "lng": 104.7556,
      "country": "Indonesia"
   },
   {
      "lat": 29.1255,
      "lng": 110.4844,
      "country": "China"
   },
   {
      "lat": 34.69,
      "lng": 135.1956,
      "country": "Japan"
   },
   {
      "lat": 47.8667,
      "lng": 12.6333,
      "country": "Germany"
   },
   {
      "lat": 50.1833,
      "lng": 8.9167,
      "country": "Germany"
   },
   {
      "lat": 25.4758,
      "lng": 86.3786,
      "country": "India"
   },
   {
      "lat": 9.1833,
      "lng": 76.55,
      "country": "India"
   },
   {
      "lat": 54.8333,
      "lng": 37.6167,
      "country": "Russia"
   },
   {
      "lat": 55.942,
      "lng": -3.054,
      "country": "United Kingdom"
   },
   {
      "lat": 47.5167,
      "lng": 8.5333,
      "country": "Switzerland"
   },
   {
      "lat": 57.45,
      "lng": 40.5833,
      "country": "Russia"
   },
   {
      "lat": 16.2842,
      "lng": 121.0917,
      "country": "Philippines"
   },
   {
      "lat": 18.2333,
      "lng": -96.8167,
      "country": "Mexico"
   },
   {
      "lat": 20.1803,
      "lng": -75.0514,
      "country": "Cuba"
   },
   {
      "lat": -22.4328,
      "lng": -46.5728,
      "country": "Brazil"
   },
   {
      "lat": 12.766,
      "lng": 75.122,
      "country": "India"
   },
   {
      "lat": 40.369,
      "lng": -79.9669,
      "country": "United States"
   },
   {
      "lat": 41.2381,
      "lng": -8.5253,
      "country": "Portugal"
   },
   {
      "lat": -22.085,
      "lng": -41.8678,
      "country": "Brazil"
   },
   {
      "lat": -21.1333,
      "lng": -56.4833,
      "country": "Brazil"
   },
   {
      "lat": 26.3768,
      "lng": 84.7952,
      "country": "India"
   },
   {
      "lat": -21.19,
      "lng": -46.98,
      "country": "Brazil"
   },
   {
      "lat": 8.2055,
      "lng": 77.5755,
      "country": "India"
   },
   {
      "lat": 51.2853,
      "lng": 5.5881,
      "country": "Netherlands"
   },
   {
      "lat": 39.3333,
      "lng": -8.9333,
      "country": "Portugal"
   },
   {
      "lat": 15.9,
      "lng": 80.6667,
      "country": "India"
   },
   {
      "lat": 10.4339,
      "lng": 124.7278,
      "country": "Philippines"
   },
   {
      "lat": 40.8714,
      "lng": -73.0466,
      "country": "United States"
   },
   {
      "lat": 39.9784,
      "lng": -74.9413,
      "country": "United States"
   },
   {
      "lat": 5.6167,
      "lng": -75.4667,
      "country": "Colombia"
   },
   {
      "lat": -21.7203,
      "lng": -51.0189,
      "country": "Brazil"
   },
   {
      "lat": 10.0015,
      "lng": 77.6769,
      "country": "India"
   },
   {
      "lat": -18.55,
      "lng": 45.85,
      "country": "Madagascar"
   },
   {
      "lat": 14.9667,
      "lng": -91.7333,
      "country": "Guatemala"
   },
   {
      "lat": 11.3357,
      "lng": 76.6971,
      "country": "India"
   },
   {
      "lat": -27.1939,
      "lng": -51.495,
      "country": "Brazil"
   },
   {
      "lat": 41.6833,
      "lng": 13.25,
      "country": "Italy"
   },
   {
      "lat": 48.8039,
      "lng": 19.6436,
      "country": "Slovakia"
   },
   {
      "lat": -15.1169,
      "lng": -40.07,
      "country": "Brazil"
   },
   {
      "lat": 8.2994,
      "lng": -74.4756,
      "country": "Colombia"
   },
   {
      "lat": -26.9333,
      "lng": -65.35,
      "country": "Argentina"
   },
   {
      "lat": 35.9259,
      "lng": -79.0878,
      "country": "United States"
   },
   {
      "lat": 9.1259,
      "lng": 77.3634,
      "country": "India"
   },
   {
      "lat": 23.6048,
      "lng": 90.7628,
      "country": "Bangladesh"
   },
   {
      "lat": 13.5444,
      "lng": -86.1644,
      "country": "Nicaragua"
   },
   {
      "lat": -4.3828,
      "lng": -44.3328,
      "country": "Brazil"
   },
   {
      "lat": 12.2833,
      "lng": -2.2167,
      "country": "Burkina Faso"
   },
   {
      "lat": 16.5333,
      "lng": 80.8,
      "country": "India"
   },
   {
      "lat": 33.9275,
      "lng": 49.4117,
      "country": "Iran"
   },
   {
      "lat": 6.6386,
      "lng": 100.424,
      "country": "Thailand"
   },
   {
      "lat": 14.4551,
      "lng": 75.3952,
      "country": "India"
   },
   {
      "lat": 28.65,
      "lng": -17.9,
      "country": "Spain"
   },
   {
      "lat": -21.9704,
      "lng": 28.4233,
      "country": "Botswana"
   },
   {
      "lat": 19.45,
      "lng": -70.53,
      "country": "Dominican Republic"
   },
   {
      "lat": -11.96,
      "lng": -40.1678,
      "country": "Brazil"
   },
   {
      "lat": 42.2681,
      "lng": -71.614,
      "country": "United States"
   },
   {
      "lat": -25.4333,
      "lng": 31.95,
      "country": "South Africa"
   },
   {
      "lat": 12.0528,
      "lng": -1.6036,
      "country": "Burkina Faso"
   },
   {
      "lat": 42.0455,
      "lng": 14.7315,
      "country": "Italy"
   },
   {
      "lat": -22.9228,
      "lng": -53.1369,
      "country": "Brazil"
   },
   {
      "lat": 41.3043,
      "lng": -74.1941,
      "country": "United States"
   },
   {
      "lat": 48.0678,
      "lng": 11.3739,
      "country": "Germany"
   },
   {
      "lat": -14.1028,
      "lng": -39.015,
      "country": "Brazil"
   },
   {
      "lat": 35.9167,
      "lng": 103.8471,
      "country": "China"
   },
   {
      "lat": 37.8572,
      "lng": 109.4972,
      "country": "China"
   },
   {
      "lat": 20.5619,
      "lng": -76.4694,
      "country": "Cuba"
   },
   {
      "lat": 39.7034,
      "lng": 116.8954,
      "country": "China"
   },
   {
      "lat": 62.3167,
      "lng": 27.8917,
      "country": "Finland"
   },
   {
      "lat": 4.6141,
      "lng": 114.3302,
      "country": "Brunei"
   },
   {
      "lat": 42.5266,
      "lng": -87.8895,
      "country": "United States"
   },
   {
      "lat": 17.4494,
      "lng": 78.6853,
      "country": "India"
   },
   {
      "lat": 38.9476,
      "lng": -85.8911,
      "country": "United States"
   },
   {
      "lat": 36.1816,
      "lng": 139.8911,
      "country": "Japan"
   },
   {
      "lat": -21.9167,
      "lng": -50.7333,
      "country": "Brazil"
   },
   {
      "lat": 57.7667,
      "lng": 36.7,
      "country": "Russia"
   },
   {
      "lat": 60.6494,
      "lng": 11.3664,
      "country": "Norway"
   },
   {
      "lat": -19.6667,
      "lng": 47.3333,
      "country": "Madagascar"
   },
   {
      "lat": 42.5845,
      "lng": -71.9868,
      "country": "United States"
   },
   {
      "lat": -14.4089,
      "lng": -56.4458,
      "country": "Brazil"
   },
   {
      "lat": 41.5199,
      "lng": -90.3879,
      "country": "United States"
   },
   {
      "lat": -22.9667,
      "lng": 47.4667,
      "country": "Madagascar"
   },
   {
      "lat": 45.1679,
      "lng": -93.083,
      "country": "United States"
   },
   {
      "lat": 51.1167,
      "lng": 7.4,
      "country": "Germany"
   },
   {
      "lat": -20.4333,
      "lng": 47.2333,
      "country": "Madagascar"
   },
   {
      "lat": 11.4167,
      "lng": 79.1167,
      "country": "India"
   },
   {
      "lat": 23.7898,
      "lng": 88.2583,
      "country": "India"
   },
   {
      "lat": 44.1167,
      "lng": -79.1333,
      "country": "Canada"
   },
   {
      "lat": 42.2357,
      "lng": 122.9455,
      "country": "China"
   },
   {
      "lat": 32.2833,
      "lng": -6.4667,
      "country": "Morocco"
   },
   {
      "lat": 22.1475,
      "lng": -78.9669,
      "country": "Cuba"
   },
   {
      "lat": 1.9833,
      "lng": -75.8167,
      "country": "Colombia"
   },
   {
      "lat": 57.8833,
      "lng": 34.05,
      "country": "Russia"
   },
   {
      "lat": 32.505,
      "lng": -7.1927,
      "country": "Morocco"
   },
   {
      "lat": 27.2891,
      "lng": 95.3418,
      "country": "India"
   },
   {
      "lat": 16.9789,
      "lng": 121.3272,
      "country": "Philippines"
   },
   {
      "lat": -22.5167,
      "lng": 47.5667,
      "country": "Madagascar"
   },
   {
      "lat": 38.7333,
      "lng": -27.0667,
      "country": "Portugal"
   },
   {
      "lat": 39.5078,
      "lng": 46.3386,
      "country": "Armenia"
   },
   {
      "lat": 16.9667,
      "lng": 121.7333,
      "country": "Philippines"
   },
   {
      "lat": 14.185,
      "lng": 121.5109,
      "country": "Philippines"
   },
   {
      "lat": -13.5378,
      "lng": -39.0989,
      "country": "Brazil"
   },
   {
      "lat": -10.9,
      "lng": 18.0833,
      "country": "Angola"
   },
   {
      "lat": 8.6667,
      "lng": 39.4333,
      "country": "Ethiopia"
   },
   {
      "lat": 5.8867,
      "lng": 10.5331,
      "country": "Cameroon"
   },
   {
      "lat": -35.6167,
      "lng": -61.3667,
      "country": "Argentina"
   },
   {
      "lat": -50.3333,
      "lng": -72.2833,
      "country": "Argentina"
   },
   {
      "lat": 5.2167,
      "lng": -73.6,
      "country": "Colombia"
   },
   {
      "lat": 49.3833,
      "lng": 8.3667,
      "country": "Germany"
   },
   {
      "lat": 52.0833,
      "lng": 6.15,
      "country": "Netherlands"
   },
   {
      "lat": 51.4719,
      "lng": 7.7658,
      "country": "Germany"
   }]
    """.trimIndent()

    val mapArray : JSONArray = JSONArray(mapObject)

    fun getRandomCountry() : JSONObject {
        val num = Random.nextInt(mapArray.length())

        return mapArray.getJSONObject(num)
    }

    fun getRemainingChoices(answer: String?) : ArrayList<String> {
        var countries = ArrayList<String>()
        lateinit var randCountry : String
        for(i in 0..2){
            do {
                var rand = getRandomCountry()
                randCountry = rand.getString("country")
            }
            while ( randCountry == answer || randCountry in countries)

            countries.add(randCountry)
        }

        Log.d("RemChoices", countries.toString())
        return countries
    }

}