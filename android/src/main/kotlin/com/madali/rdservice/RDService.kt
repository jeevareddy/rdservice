package com.madali.rdservice

import android.app.Activity
import android.content.Intent


class RDService {

    companion object {
        const val REQUESTCODE_DEVICEINFO = 1
        const val REQUESTCODE_CAPTURE = 2

    }

    fun deviceInfo(activity: Activity, onError: (ResultError) -> Unit) {

        try {
            val intent = Intent()
            intent.action = "in.gov.uidai.rdservice.fp.INFO"
            activity.startActivityForResult(intent, REQUESTCODE_DEVICEINFO)
        } catch (e: Exception) {
            onError(Utils.parseError(e.message))
            e.printStackTrace()
        }
    }

    fun capture(activity: Activity, onError: (ResultError) -> Unit) {

        try {
            val intent = Intent()
            intent.action = "in.gov.uidai.rdservice.fp.CAPTURE"
            intent.putExtra("PID_OPTIONS", getPidOption())
            activity.startActivityForResult(intent, REQUESTCODE_CAPTURE)
        } catch (e: Exception) {
            onError(Utils.parseError(e.message))
            e.printStackTrace()
        }
    }

/*  private fun isRDServiceAvailable(activity: Activity): Boolean {
        val intent = Intent("in.gov.uidai.rdservice.fp.INFO")
        val resolveInfoList: List<ResolveInfo> =
            activity.packageManager.queryIntentActivities(intent, 0)
        if (resolveInfoList.isNotEmpty()) return true;
        return false;
    }*/

    private fun getPidOption(): String {
        return """<PidOptions ver="1.0"><Opts fCount="1" fType="0" iCount="0" iType="0" pCount="0" pType="0" format="0" pidVer="2.0" timeout="10000"/></PidOptions>"""
        //return """<PidOptions ver="1.0"><Opts env="S" fCount="1" fType="0" format="0" iCount="0" iType="0" pCount="0" pType="0" pidVer="2.0" posh="UNKNOWN" timeout="10000"/></PidOptions>"""
    }

}