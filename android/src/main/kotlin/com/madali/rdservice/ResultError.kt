package com.madali.rdservice

data class ResultError(
    val errorCode:String,
    val errorMessage:String,
    val detailedError:String
)
