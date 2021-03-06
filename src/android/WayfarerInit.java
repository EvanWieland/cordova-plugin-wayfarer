package io.bitsmithy.wayfarer;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.GoogleApiClient.ConnectionCallbacks;
import com.google.android.gms.common.api.GoogleApiClient.OnConnectionFailedListener;
import com.google.android.gms.location.ActivityRecognition;

public class WayfarerInit extends Activity
    implements ConnectionCallbacks, OnConnectionFailedListener {
  public GoogleApiClient mApiClient;
  private Boolean Connected;
  private PendingIntent pendingIntent;

  public WayfarerInit() {
    Connected = false;
    mApiClient =
        new GoogleApiClient.Builder(this)
            .addApi(ActivityRecognition.API)
            .addConnectionCallbacks(this)
            .addOnConnectionFailedListener(this)
            .build();

    mApiClient.connect();
  }

  public Boolean StartRequestingActivity(int Interval) {
    if (Connected) {
      Intent intent = new Intent(this, WayfarerIntentService.class);
      pendingIntent = PendingIntent.getService(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
      ActivityRecognition.ActivityRecognitionApi.requestActivityUpdates(
          mApiClient, Interval, pendingIntent);
      return true;
    } else return false;
  }

  public void RemoveActivityUpdates() {
    ActivityRecognition.ActivityRecognitionApi.removeActivityUpdates(mApiClient, pendingIntent);
  }

  @Override
  public void onConnected(Bundle bundle) {
    Connected = true;
  }

  @Override
  public void onConnectionSuspended(int i) {}

  @Override
  public void onConnectionFailed(ConnectionResult connectionResult) {}
}
