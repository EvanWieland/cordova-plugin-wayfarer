package io.bitsmithy.wayfarer;

import android.app.IntentService;
import android.content.Intent;
import com.google.android.gms.location.ActivityRecognitionResult;
import com.google.android.gms.location.DetectedActivity;

public class WayfarerIntentService extends IntentService {
  public static WayfarerResult Activity;

  public WayfarerIntentService() {
    super("WayfarerIntentService");
  }

  @Override
  protected void onHandleIntent(Intent intent) {
    if (ActivityRecognitionResult.hasResult(intent)) {
      ActivityRecognitionResult result = ActivityRecognitionResult.extractResult(intent);
      DetectedActivity CurrentActivity = result.getMostProbableActivity();

      if (Activity != null) {
          Activity.ActivityType = CurrentActivity.toString();
          Activity.Probability = CurrentActivity.getConfidence();
      }
    } else {
        if (Activity != null) {
            Activity.ActivityType = "NoResult";
        }
    }
  }
}
