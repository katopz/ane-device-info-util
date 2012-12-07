package com.debokeh.anes.utils
{
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;

	public class DeviceInfoUtil extends EventDispatcher
	{
		private static const _EXTENSION_ID:String = "com.debokeh.anes.utils.DeviceInfoUtil";

		/**
		 * Will provide current WiFi SSID name.
		 * @return String as SSID
		 */
		public static function getCurrentSSID():String
		{
			var context:ExtensionContext;
			try
			{
				context = ExtensionContext.createExtensionContext(_EXTENSION_ID, 'getCurrentSSID');
				return context.call('getCurrentSSID') as String;
			}
			catch (error:Error)
			{
				trace(error.message);
			}
			
			if (context)
			{
				context.dispose();
				context = null;
			}

			return null;
		}
		
		/**
		 * Will return MACAddress
		 * @return String as MACAddress
		 */
		public static function getCurrentMACAddress():String
		{
			var context:ExtensionContext;
			try
			{
				context = ExtensionContext.createExtensionContext(_EXTENSION_ID, 'getCurrentMACAddress');
				return context.call('getCurrentMACAddress') as String;
			}
			catch (error:Error)
			{
				trace(error.message);
			}
			
			if (context)
			{
				context.dispose();
				context = null;
			}
			
			return null;
		}
		
		
		/**
		 * Will return device name
		 * @return String as device name
		 */
		public static function getCurrentDeviceName():String
		{
			var context:ExtensionContext;
			try
			{
				context = ExtensionContext.createExtensionContext(_EXTENSION_ID, 'getCurrentDeviceName');
				return context.call('getCurrentDeviceName') as String;
			}
			catch (error:Error)
			{
				trace(error.message);
			}
			
			if (context)
			{
				context.dispose();
				context = null;
			}
			
			return null;
		}
	}
}