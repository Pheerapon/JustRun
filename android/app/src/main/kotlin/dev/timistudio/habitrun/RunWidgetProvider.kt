package dev.timistudio.habitrun

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.util.*

class RunWidgetProvider : AppWidgetProvider() {
	override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray
    ) {
		appWidgetIds.forEach { appWidgetId ->
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    super.onUpdate(context, appWidgetManager, appWidgetIds)
	}
    override fun onEnabled(context: Context) { // Enter relevant functionality for when the first widget is created

        // start alarm
        val appWidgetAlarm = AppWidgetAlarm(context.applicationContext)
        appWidgetAlarm.startAlarm()
    }

    override fun onDisabled(context: Context) { // Enter relevant functionality for when the last widget is disabled

        // stop alarm only if all widgets have been disabled
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val thisAppWidgetComponentName = ComponentName(context.packageName, javaClass.name)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(thisAppWidgetComponentName)
        if (appWidgetIds.isEmpty()) {
            // stop alarm
            val appWidgetAlarm = AppWidgetAlarm(context.applicationContext)
            appWidgetAlarm.stopAlarm()
        }
    }

    companion object {

        const val ACTION_AUTO_UPDATE = "AUTO_UPDATE"

        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val widgetData : SharedPreferences = HomeWidgetPlugin.getData(context)
            val launchActivity = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context, 0, launchActivity, 0)
            val views: RemoteViews = RemoteViews(
                    context.packageName,
                    R.layout.widget_layout
            ).apply {
                setTextViewText(R.id.date, widgetData.getString("date", "Today"))
                setTextViewText(R.id.distance, widgetData.getString("distance", "0.0") + " ")
                setProgressBar(R.id.progress, 100, widgetData.getInt("progress", 0), false)
                setOnClickPendingIntent(R.id.run, pendingIntent)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

class AppWidgetAlarm(private val context: Context?) {
    private val alarmId = 0
    private val intervalMillis : Long = 1800000

    fun startAlarm() {
        val calendar: Calendar = Calendar.getInstance()
        calendar.add(Calendar.MILLISECOND, intervalMillis.toInt())

        val alarmIntent = Intent(context, RunWidgetProvider::class.java).let { intent ->
            //intent.action = AppWidget.ACTION_AUTO_UPDATE
            PendingIntent.getBroadcast(context, 0, intent, 0)
        }
        with(context!!.getSystemService(Context.ALARM_SERVICE) as AlarmManager) {
            setRepeating(AlarmManager.RTC, calendar.timeInMillis, intervalMillis, alarmIntent)
        }
    }

    fun stopAlarm() {
        val alarmIntent = Intent(RunWidgetProvider.ACTION_AUTO_UPDATE)
        val pendingIntent = PendingIntent.getBroadcast(context, alarmId, alarmIntent, PendingIntent.FLAG_CANCEL_CURRENT)
        val alarmManager = context!!.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent)
    }
}



