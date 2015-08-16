package
{
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.avdw.align.spaceHorizontally;
	import trading.entity.*;
	import trading.good.*;
	import trading.good.converter.*;
	import trading.good.storage.Warehouse;
	
	public class MarketSimulator extends Sprite
	{
		private var goods:List;
		private var cities:List;
		private var consumers:List;
		private var producers:List;
		private var converters:List;
		private var inputs:List;
		private var outputs:List;
		
		public function MarketSimulator()
		{
			var city:City = new City(new Warehouse());
			city.storage.goods.push(new Wheat());
			city.storage.goods.push(new Water());
			city.storage.goods.push(new Malt());
			
			city.converters.push(new Malthouse(city.storage));
			
			cities = new List(this, 0, 0, [city]);
			consumers = new List(this, 0, 0);
			goods = new List(this, 0, 0);
			producers = new List(this, 0, 0);
			inputs = new List(this, cities.width, cities.height);
			converters = new List(this, 0, cities.height);
			outputs = new List(this, 0, cities.height);
			
			spaceHorizontally([cities, producers, goods, consumers]);
			spaceHorizontally([inputs, converters, outputs]);
			
			cities.addEventListener(Event.SELECT, citySelected);
			goods.addEventListener(Event.SELECT, goodSelected);
			converters.addEventListener(Event.SELECT, converterSelected);
		}
		
		private function converterSelected(e:Event):void 
		{
			var item:Object;
			inputs.removeAll();
			outputs.removeAll();
			
			for each (item in converters.selectedItem.inputs)
				inputs.addItem(item);
				
			for each (item in converters.selectedItem.outputs)
				outputs.addItem(item);
		}
		
		private function goodSelected(e:Event):void 
		{
			var item:Object;
			consumers.removeAll();
			producers.removeAll();
			
			for each (item in goods.selectedItem.consumers)
				consumers.addItem(item);
				
			for each (item in goods.selectedItem.producers)
				producers.addItem(item);
		}
		
		private function citySelected(e:Event):void
		{
			var item:Object;
			goods.removeAll();
			converters.removeAll();
			
			for each (item in cities.selectedItem.storage.goods)
				goods.addItem(item);
				
			for each (item in cities.selectedItem.converters)
				converters.addItem(item);
		}
	}
}