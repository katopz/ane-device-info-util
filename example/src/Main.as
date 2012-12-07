package
{
	import com.debokeh.anes.utils.DeviceInfoUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class Main extends Sprite
	{
		public function Main()
		{
			var tf:TextField;
			addChild(tf = new TextField);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = "CurrentSSID : " + DeviceInfoUtil.getCurrentSSID();
			tf.appendText("\nCurrentMACAddress : " +  DeviceInfoUtil.getCurrentMACAddress());
			tf.appendText("\nCurrentDeviceName : " +  DeviceInfoUtil.getCurrentDeviceName());
		}
	}
}