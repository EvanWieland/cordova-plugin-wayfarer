package io.bitsmithy.wayfarer;

import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.GoogleApiClient.ConnectionCallbacks;
import com.google.android.gms.common.api.GoogleApiClient.OnConnectionFailedListener;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.ActivityRecognition;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

/** This class echoes a string called from JavaScript. */
public class Wayfarer extends CordovaPlugin
    implements ConnectionCallbacks, OnConnectionFailedListener {

  public GoogleApiClient mApiClient;
  public CallbackContext callback;
  private PendingIntent pendingIntent;
  private Boolean ActivityUpdatesStarted = false;

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    WayfarerIntentService.Activity = new WayfarerResult();
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext)
      throws JSONException {
    callback = callbackContext;
    if (action.equals("GetActivity")) {
      this.GetActivity();
      return true;
    }
    if (action.equals("Connect")) {
      this.Connect();
      return true;
    }
    if (action.equals("Disconnect")) {
      this.Disconnect();
      return true;
    }
    if (action.equals("StartActivityUpdates")) {
      int interval = args.getInt(0);
      this.StartActivityUpdates(interval);
      return true;
    }
    if (action.equals("StopActivityUpdates")) {
      this.StopActivityUpdates();
      return true;
    }
    if (action.equals("Destroy")) {
      this.onDestroy();
      return true;
    }

    return false;
  }

  private void GetActivity() {
    if (mApiClient != null && mApiClient.isConnected()) {
      try {
        callback.success(WayfarerIntentService.Activity.GetJSONObject());
      } catch (JSONException json) {
        callback.error("JSONException");
      }
    } else {
      callback.error("Not Connected");
    }
  }

  private void Connect() {

    if (mApiClient == null || !mApiClient.isConnected()) {
      mApiClient =
          new GoogleApiClient.Builder(cordova.getActivity())
              .addApi(ActivityRecognition.API)
              .addConnectionCallbacks(this)
              .addOnConnectionFailedListener(this)
              .build();

      mApiClient.connect();

    } else callback.error("Already Connected!");
  }

  @Override
  public void onConnected(Bundle bundle) {
    callback.success();
  }

  @Override
  public void onConnectionSuspended(int i) {}

  @Override
  public void onConnectionFailed(ConnectionResult connectionResult) {
    callback.error("Connection Failed !");
  }

  private void Disconnect() {
    if (mApiClient != null && mApiClient.isConnected()) {
      mApiClient.disconnect();
      callback.success();
    } else {
      callback.error("Not Connected");
    }
  }

  private void StartActivityUpdates(int interval) {
    if (mApiClient != null && mApiClient.isConnected()) {
      PendingResult<Status> result;
      Intent intent = new Intent(cordova.getActivity(), WayfarerIntentService.class);
      pendingIntent =
          PendingIntent.getService(
              cordova.getActivity(), 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
      result =
          ActivityRecognition.ActivityRecognitionApi.requestActivityUpdates(
              mApiClient, interval, pendingIntent);
        ActivityUpdatesStarted = true;
        callback.success();
    } else {
      callback.error("Not Connected");
    }
  }

  private void StopActivityUpdates() {
    if (mApiClient != null && mApiClient.isConnected()) {
      ActivityRecognition.ActivityRecognitionApi.removeActivityUpdates(mApiClient, pendingIntent);
      ActivityUpdatesStarted = false;
      callback.success();
    } else {
      callback.error("Not Connected");
    }
  }

  @Override
  public void onDestroy() {
    if (ActivityUpdatesStarted)
      ActivityRecognition.ActivityRecognitionApi.removeActivityUpdates(mApiClient, pendingIntent);
    if (mApiClient != null && mApiClient.isConnected()) {
      mApiClient.disconnect();
    }
    super.onDestroy();
  }
}
