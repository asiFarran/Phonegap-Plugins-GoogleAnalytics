
               
               /*
                underscore impl of each and extend
                */
               var breaker = {};
               var ArrayProto = Array.prototype;
               
               var push = ArrayProto.push,
               slice = ArrayProto.slice,
               concat = ArrayProto.concat;
               
               var nativeForEach = ArrayProto.forEach;
               
               var each = function(obj, iterator, context) {
               if (obj == null) return;
               if (nativeForEach && obj.forEach === nativeForEach) {
               obj.forEach(iterator, context);
               } else if (obj.length === +obj.length) {
               for (var i = 0, l = obj.length; i < l; i++) {
               if (iterator.call(context, obj[i], i, obj) === breaker) return;
               }
               } else {
               for (var key in obj) {
               if (_.has(obj, key)) {
               if (iterator.call(context, obj[key], key, obj) === breaker) return;
               }
               }
               }
               };
               
               var extend = function(obj) {
               each(slice.call(arguments, 1), function(source) {
                    if (source) {
                    for (var prop in source) {
                    obj[prop] = source[prop];
                    }
                    }
                    });
               return obj;
               };
               
               /*
                end of underscore ext
                */
               
               var exec = require('cordova/exec');

               var nativePluginName = 'GoogleAnalytics';
               
               var GoogleAnalyticsPlugin = function () {
               };
               
               function ensureValidCallback(callback){
               
               if (callback == null || typeof callback != "function") {
               callback = function(){};
               }
               
               return callback;
               }
               
               function convertDimensionsOrMetricsToArray(src){
               
               if(src == null || src.length == 0){
               return [];
               
               }else{
               var arr = [];
               
               for(var i = 0; i < src.length; i++){
               arr.push([src[i].index, src[i].value]);
               }
               
               return arr;
               }
               }
               
               
               // initialize google analytics with an account ID and the min number of seconds between posting
               //
               // id = the GA account ID of the form 'UA-00000000-0'
               // dispatchIntrval = the minimum interval for transmitting tracking events if any exist in the queue
               GoogleAnalyticsPlugin.prototype.init = function(id, dispatchIntrval, success, fail) {
               
               success = ensureValidCallback(success);
               fail = ensureValidCallback(fail);
               
               if(!dispatchIntrval || typeof dispatchIntrval != 'number' || dispatchIntrval < 10){
               dispatchIntrval = 10;
               }
               
               return exec(success, fail, nativePluginName, 'init', [id, dispatchIntrval]);
               };
               
               // logs an event
               //
               // eventObj :{
               //      category: (string) required
               //      action:  (string) required
               //      label: (string) optional
               //      value: (int) optional
               //      dimensions: [     : (array) optional
               //          {
               //              index: (int) required
               //              value: (string) required
               //          }
               //      ]
               //      metrics: [     : (array) optional
               //          {
               //              index: (int) required
               //              value: (int) required
               //          }
               //      ]
               //  }
               
               GoogleAnalyticsPlugin.prototype.trackEvent = function(eventObj, success, fail) {
               
               var data = {
               category: null,
               action: null,
               label: null,
               value: null,
               dimensions: [],
               metrics:[]
               };
               
               extend(data, eventObj);
               
               success = ensureValidCallback(success);
               fail = ensureValidCallback(fail);
               
               var params =  [data.category, data.action, data.label, data.value];
               
               params.push(convertDimensionsOrMetricsToArray(data.dimensions));
               params.push(convertDimensionsOrMetricsToArray(data.metrics));
               
               return exec(success, fail, nativePluginName, 'trackEvent', params);
               };
               
               
               // log a page/screen view
               //
               // viewObj :{
               //      name: (string) required
               //      dimensions: [     : (array) optional
               //          {
               //              index: (int) required
               //              value: (string) required
               //          }
               //      ]
               //      metrics: [     : (array) optional
               //          {
               //              index: (int) required
               //              value: (int) required
               //          }
               //      ]
               //  }
               GoogleAnalyticsPlugin.prototype.trackView = function(viewObj, success, fail) {
               
               var data = {
               name: null,
               dimensions: [],
               metrics:[]
               };
               
               extend(data, viewObj);
               
               success = ensureValidCallback(success);
               fail = ensureValidCallback(fail);
               
               var params =  [data.name];
               
               params.push(convertDimensionsOrMetricsToArray(data.dimensions));
               params.push(convertDimensionsOrMetricsToArray(data.metrics));
               
               return exec(success, fail, nativePluginName, 'trackView', params);
               };
               
               
               // set session dimensions and metrics
               //
               // vars :{
               //      dimensions: [     : (array) optional
               //          {
               //              index: (int) required
               //              value: (string) required
               //          }
               //      ]
               //      metrics: [     : (array) optional
               //          {
               //              index: (int) required
               //              value: (int) required
               //          }
               //      ]
               //  }
               
               GoogleAnalyticsPlugin.prototype.setSessionDimensionsAndMetrics = function(vars, success, fail) {
               
               var data = {
               dimensions: [],
               metrics:[]
               };
               
               extend(data, vars);
               
               success = ensureValidCallback(success);
               fail = ensureValidCallback(fail);
               
               var params =  [];
               
               params.push(convertDimensionsOrMetricsToArray(data.dimensions));
               params.push(convertDimensionsOrMetricsToArray(data.metrics));
               
               return exec(success, fail, nativePluginName, 'setSessionDimensionsAndMetrics', params);
               };
               
               
               
               var plugin = new GoogleAnalyticsPlugin();
               module.exports = plugin;

