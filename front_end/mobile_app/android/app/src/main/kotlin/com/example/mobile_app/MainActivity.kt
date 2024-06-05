package com.example.mobile_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.mobile_app.flutter/python"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "calculateScore") {
                val filePath = call.argument<String>("filePath")
                val skills = call.argument<List<String>>("skills")
                if (filePath != null && skills != null) {
                    val skillsString = skills.joinToString(",")
                    val score = runPythonScript(filePath, skillsString)
                    result.success(score)
                } else {
                    result.error("INVALID_ARGUMENT", "File path or skills are null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun runPythonScript(filePath: String, skills: String): Int {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("python", "c:/Users/oumay/OneDrive/Bureau/pf1/pfe/front_end/mobile_app/lib/smart_recurtement/script.py", filePath, skills))
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val output = StringBuilder()
            var line: String? = reader.readLine()
            while (line != null) {
                output.append(line).append("\n")
                line = reader.readLine()
            }
            process.waitFor()
            reader.close()
            // Parse the output to get the score
            val score = parseScore(output.toString())
            score
        } catch (e: Exception) {
            e.printStackTrace()
            0
        }
    }

    private fun parseScore(output: String): Int {
        // Implement your logic to parse the score from the Python script output
        // For simplicity, assume the score is printed at the end of the output
        return try {
            val lines = output.split("\n")
            val scoreLine = lines.find { it.startsWith("Skill Match Score:") }
            scoreLine?.split(":")?.get(1)?.trim()?.toInt() ?: 0
        } catch (e: Exception) {
            e.printStackTrace()
            0
        }
    }
}
