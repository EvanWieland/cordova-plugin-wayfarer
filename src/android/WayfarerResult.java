package io.bitsmithy.wayfarer;

import org.json.JSONException;
import org.json.JSONObject;

public class WayfarerResult {
  public String ActivityType;
  public int Probability;

  public WayfarerResult() {
    ActivityType = "NoActivityYet";
    Probability = 0;
  }

  public JSONObject GetJSONObject() throws JSONException {
    JSONObject result = new JSONObject();
    result.put("ActivityType", ActivityType);
    result.put("Probability", Probability);
    return result;
  }
}
