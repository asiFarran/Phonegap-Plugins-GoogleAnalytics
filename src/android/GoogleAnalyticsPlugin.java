package com.stratogos.cordova.googleAnalytics;

import java.util.Map;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import com.google.analytics.tracking.android.*;
import com.google.analytics.tracking.android.Logger.LogLevel;

public class GoogleAnalyticsPlugin extends CordovaPlugin {

	private Tracker tracker;
	
	public GoogleAnalyticsPlugin(){
		
	}
	
	
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
	        PluginResult.Status status = PluginResult.Status.OK;
	        String result = "";

	        if (action.equalsIgnoreCase("init")) {	        	
	            this.init(args.getString(0), args.getInt(1));
	        }
	        else if (action.equalsIgnoreCase("trackView")) {
	        		        	 
	            this.trackView(args.getString(0), args.getJSONArray(1), args.getJSONArray(2));
	        }
	        else if (action.equalsIgnoreCase("trackEvent")) {
	        	
	        	Long val = null;
	        	
	        
	        		try {
						val = args.getLong(3);
					} catch (Exception e) {
						
					}
	        
	        	
	        	this.tackEvent(args.getString(0),args.getString(1),args.getString(2),val, args.getJSONArray(4), args.getJSONArray(5));
	        }
	        else if (action.equalsIgnoreCase("setSessionDimensionsAndMetrics")){
	        	this.setSessionDimensionsAndMetrics(args.getJSONArray(0), args.getJSONArray(1));	
	        }
	        else { // Unrecognized action.
	            return false;
	        }

	        callbackContext.sendPluginResult(new PluginResult(status, result));

	        return true;
	    }
	
	private void trackView(String viewName, JSONArray dimensions, JSONArray metrics) throws JSONException{
				
		MapBuilder builder = MapBuilder.createAppView();
		builder.set(Fields.SCREEN_NAME, viewName);
		
		JSONArray tmp = null;
		int count = dimensions.length();
		
		if(count > 0){
			
			for(int i = 0 ; i < count ; i++){
				
				tmp = dimensions.getJSONArray(i);
				
				builder.set(Fields.customDimension(tmp.getInt(0)), tmp.getString(1));
			}
		}
		
		count = metrics.length();
		
		if(count > 0){
			
			for(int i = 0 ; i < count ; i++){
				
				tmp = metrics.getJSONArray(i);
				
				builder.set(Fields.customMetric(tmp.getInt(0)), tmp.getString(1));
			}
		}

		this.tracker.send(builder.build());		
	}
	 
	private void tackEvent(String category, String action, String label, Long value, JSONArray dimensions, JSONArray metrics) throws JSONException{
		
		MapBuilder builder = MapBuilder.createEvent(category,action,label,value);
		
		
		JSONArray tmp = null;
		int count = dimensions.length();
		
		if(count > 0){
			
			for(int i = 0 ; i < count ; i++){
				
				tmp = dimensions.getJSONArray(i);
				
				builder.set(Fields.customDimension(tmp.getInt(0)), tmp.getString(1));
			}
		}
		
		count = metrics.length();
		
		if(count > 0){
			
			for(int i = 0 ; i < count ; i++){
				
				tmp = metrics.getJSONArray(i);
				
				builder.set(Fields.customMetric(tmp.getInt(0)), tmp.getString(1));
			}
		}

		this.tracker.send(builder.build());		
	}
	
	private void setSessionDimensionsAndMetrics(JSONArray dimensions, JSONArray metrics) throws JSONException{

		JSONArray tmp = null;
		int count = dimensions.length();
		
		if(count > 0){
			
			for(int i = 0 ; i < count ; i++){
				
				tmp = dimensions.getJSONArray(i);
				
				this.tracker.set(Fields.customDimension(tmp.getInt(0)), tmp.getString(1));
			}
		}
		
		count = metrics.length();
		
		if(count > 0){
			
			for(int i = 0 ; i < count ; i++){
				
				tmp = metrics.getJSONArray(i);
				
				this.tracker.set(Fields.customMetric(tmp.getInt(0)), tmp.getString(1));
			}
		}
	}
	
	@SuppressWarnings("deprecation")
	private void init(String trackingId, int dispatchPeriod ){
		 
		 GoogleAnalytics ga = GoogleAnalytics.getInstance(cordova.getActivity());

         // Optional: set debug to YES for extra debugging information.
		 //ga.setDryRun(true);

		 // Optional: set Logger to VERBOSE for debug information.
		 //ga.getLogger().setLogLevel(LogLevel.VERBOSE);
		 
		this.tracker = ga.getTracker(trackingId);
		
    	GAServiceManager.getInstance().setLocalDispatchPeriod(dispatchPeriod);
	}
}
