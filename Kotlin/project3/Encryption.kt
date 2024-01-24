package com.example.project3

class Encryption{
    var offset: Int = 0

    fun setOff(off: Int){
        offset = off
    }

    fun encrypt(word: String): String{
        var newWord = ""
        for (curr: Char in word.toCharArray()){
            newWord += ((((curr.code-64) + offset) % 26) + 64).toChar()
        }
        return newWord
    }


}