package trading.entity
{
	import trading.good.converter.AGoodsConverter;
	import trading.good.storage.AGoodsStorage;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class City extends ATradingEntity
	{
		public var converters:Vector.<AGoodsConverter> = new Vector.<AGoodsConverter>;
		
		public function City(storage:AGoodsStorage)
		{
			this.storage = storage;
		}
	}
}