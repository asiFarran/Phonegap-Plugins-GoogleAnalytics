# Phonegap-Plugins-GoogleAnalytics

> Google Analytics plugin for iOS and Android adapted for cordova/phongap 3 

## Preparation:
Before you can begin collecting metrics data, you need to set up a GoogleAnalytics Mobile App account so you can view them. When you do so, you will obtain an app tracking id which we'll use during session initialization. Start by going to the [Google Analytics](http://www.google.com/analytics/features/mobile-app-analytics.html) site and click on the **Create an Account** button. Once signed in, click on the **Admin** button and the **+ New Account** button under the **Accounts** tab. At the top of the resulting tab, select the **App** button in answer to the **What would you like to track?** query. Fill out the form as appropriate. Complete instructions can be found [here](http://www.google.com/analytics/features/mobile-app-analytics.html).

## Installation:

    phonegap local plugin add https://github.com/asiFarran/Phonegap-Plugins-GoogleAnalytics.git


## Usage
The plugin creates the object window.googleAnalytics

Before using the plugin to track events and view it must be initialized;

	 // id = a valid GA account ID  (e.g 'UA-00000000-0')
     // dispatchIntrval = the minimum interval for transmitting tracking events if any exist in the queue
     init(id, dispatchInterval)
     
     e.g:
     
    function onDeviceReady() {		
		window.googleAnalytics.init("UA-12345678-1", 10); 
	}

	
To track an event: 
	
     trackEvent(eventObj) 
     
     where eventObj takes thie following form:
     
     {
        category: (string) required
        action:  (string) required
        label: (string) optional
        value: (int) optional
        dimensions: [      optional array of custom dimensions
            {
                index: (int) required
                value: (string) required
        }],
        metrics: [       optional array of custom metrics
            {
                index: (int) required
                value: (int) required
        }]
    }
     
     
     e.g:
     
    window.googleAnalytics.trackEvent({
        category: 'myCategory',
        action: 'myAction',
        label: 'myLabel'
    });
	


To track an view: 
    
     trackView(viewObj) 
     
     where viewObj takes thie following form:
     
     {
        name: (string) required       
        dimensions: [      optional array of custom dimensions
            {
                index: (int) required
                value: (string) required
        }],
        metrics: [       optional array of custom metrics
            {
                index: (int) required
                value: (int) required
        }]
    }
     
     
     e.g:
     
     window.googleAnalytics.trackView({
        name: 'myViewName'
    });

