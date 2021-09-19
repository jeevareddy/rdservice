package com.madali.rdservice

class Utils {

    companion object {
        fun parseError(err: String?): ResultError {

            if (err?.contains("No Activity found") == true)
                return ResultError(
                    RDServiceErrorType.ActivityNotFound.toString(),
                    "Install the respective application and try again",
                    err
                )

            return ResultError(
                RDServiceErrorType.UnknownException.toString(),
                "Error, try again",
                err ?: "Unknown Exception"
            )


        }
    }
}