package net.avdw.bit 
{
		public function unsetBit(field:uint, mask:uint):uint 
		{
			return field &= ~mask;
		}
}