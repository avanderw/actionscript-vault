package trading.good.converter
{
	import trading.good.*;
	import trading.good.storage.*;
	
	public class Malthouse extends AGoodsConverter
	{
		public function Malthouse(storage:AGoodsStorage)
		{
			inputGoods.push(ACerealGrain, Water);
			outputGoods.push(Malt);
			
			for each (var good:AGood in storage.goods)
			{
				for each (var input:Class in inputGoods)
					if (good is input)
					{
						inputs.push(good);
						good.consumers.push(this);
					}
				for each (var output:Class in outputGoods)
					if (good is output)
					{
						outputs.push(good);
						good.producers.push(this);
					}
			}
		}
	}
}