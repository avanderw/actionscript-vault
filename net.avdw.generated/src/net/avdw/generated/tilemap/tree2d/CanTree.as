package net.avdw.tilemap.tree2d
{
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class CanTree
	{
		
		public function CanTree()
		{
		
		}
		
		private function normalVariate(a, b)
		{
			return a + (Math.random() * 2 + Math.random() * 2 + Math.random() * 2 - 3) / 3 * b / 2;
		}
		
		private function tree(a)
		{
			var canvas2d = a;
			var ctx2d = a.getContext("2d");
			var string = "lL[+L][-L]";
			var branchTexture;
			var treePosY = 50;
			var iterations = 10;
			var angleMean = 20 / 180 * Math.PI;
			var angleVariation = 10 / 180 * Math.PI;
			var length = 30;
			var lengthReduction = 0.8;
			var thickness = 15;
			var thicknessReduction = 0.65;
			var rules = {L: {developsInto: ["l", "+lL", "-lL", "L[+LL][-LL]l", "[+L][-L]", "L[+lLL]", "L[-lLL]"]}, l: {developsInto: ["l"]}, "[": {developsInto: ["["]}, "]": {developsInto: ["]"]}, "+": {developsInto: ["+"]}, "-": {developsInto: ["-"]}};
			var leafTextures = [];
			var leafScaleVariation = 0.5;
			var leafMinDepth = 4;
			var leafProba = 0.5;
			var leafScale = 1;
			var leafTotalPerBranch = 1;
			var leafProbaLighterMult = 0.5;
			var curveXVariation = 10;
			var curveYVariation = 5;
			var shadowProba = 0.2;
			var shadowAlpha = 0.025;
			var shadowRadius = 40;
		}
		
		private function addLeafTexture(a, b, c)
		{
			leafTextures.push({img: a, targetWidthInPixel: b, relativeProba: c});
		}
		
		private function removeLeafTexture(a)
		{
			for (var b = 0; b < this.leafTextures.length; b++)
			{
				var c = this.leafTextures[b];
				if (c.img == a)
				{
					this.leafTextures.splice(b, 1);
					break
				}
			}
		}
		
		private function hasLeafTexture(a)
		{
			for (var b = 0; b < this.leafTextures.length; b++)
			{
				var c = this.leafTextures[b];
				if (c.img == a)
				{
					return true
				}
			}
			return false
		}
		
		private function totalLeafTextures()
		{
			return this.leafTextures.length
		}
		
		private function draw()
		{
			for (var s = 0; s < this.leafTextures.length; s++)
			{
				var l = this.leafTextures[s];
				if (!l.img.complete)
				{
					return l.img.src.substring(0, 100) + " is not completely loaded, wait until all textures are loaded"
				}
				if (l.img.naturalWidth === 0 || l.img.naturalHeight === 0)
				{
					return l.img.src.substring(0, 100) + " is not a valid image"
				}
			}
			if (!this.branchTexture.complete)
			{
				return this.branchTexture.src.substring(0, 100) + " is not completely loaded, wait until all textures are loaded"
			}
			if (this.branchTexture.naturalWidth === 0 || this.branchTexture.naturalHeight === 0)
			{
				return this.branchTexture.src.substring(0, 100) + " is not a valid image"
			}
			var n = this.ctx2d;
			var o;
			n.setTransform(1, 0, 0, 1, 0, 0);
			n.save();
			try
			{
				var r = this.string;
				var d;
				for (var m = 0; m < this.iterations; m++)
				{
					d = "";
					for (var s = 0; s < r.length; s++)
					{
						var g = r[s];
						var c = this.rules[g].developsInto;
						if (c.length <= 0)
						{
							continue
						}
						var a = c[parseInt(Math.random() * c.length)];
						d += a
					}
					r = d
				}
				var w = 0.1;
				var f = 1 / this.iterations;
				var k = this.ctx2d.createPattern(this.branchTexture, "repeat");
				n.strokeStyle = k;
				n.lineWidth = this.thickness;
				n.lineCap = "round";
				var p = 1;
				var h = 0;
				n.clearRect(0, 0, this.canvas2d.width, this.canvas2d.height);
				n.translate(this.canvas2d.width / 2, this.canvas2d.height - this.treePosY);
				for (var s = 0; s < d.length; s++)
				{
					var b = d[s];
					if (b == "l")
					{
						n.strokeStyle = k;
						n.beginPath();
						n.moveTo(0, 0);
						n.quadraticCurveTo(trees2d.normalVariate(0, this.curveXVariation), trees2d.normalVariate(0, this.curveYVariation) - this.length / 2, 0, -this.length);
						n.stroke();
						if (Math.random() <= this.shadowProba)
						{
							n.save();
							n.globalCompositeOperation = "source-atop";
							n.globalAlpha = this.shadowAlpha;
							n.beginPath();
							n.arc(0, 0, this.shadowRadius, 0, Math.PI * 2, false);
							n.fill();
							n.restore()
						}
						h++;
						n.translate(0, -this.length);
						if (this.leafTextures.length > 0 && p >= this.leafMinDepth && Math.random() <= this.leafProba)
						{
							for (var q = 0; q < this.leafTotalPerBranch; q++)
							{
								n.save();
								if (Math.random() <= (p / this.iterations * this.leafProbaLighterMult))
								{
									n.globalCompositeOperation = "lighter"
								}
								var t = this.leafTextures[parseInt(Math.random() * this.leafTextures.length)];
								var u = t.targetWidthInPixel / t.img.naturalWidth * this.leafScale;
								n.scale(u * (1 + (Math.random() * 2 - 1) * this.leafScaleVariation), u * (1 + (Math.random() * 2 - 1) * this.leafScaleVariation));
								n.rotate(Math.random() * Math.PI * 2);
								n.drawImage(t.img, 0, 0);
								n.restore()
							}
						}
					}
					else
					{
						if (b == "+")
						{
							n.rotate(trees2d.normalVariate(this.angleMean, this.angleVariation))
						}
						else
						{
							if (b == "-")
							{
								n.rotate(-trees2d.normalVariate(this.angleMean, this.angleVariation))
							}
							else
							{
								if (b == "[")
								{
									n.save();
									this.length *= this.lengthReduction;
									p++;
									w += f;
									n.lineWidth *= this.thicknessReduction
								}
								else
								{
									if (b == "]")
									{
										this.length *= 1 / this.lengthReduction;
										p--;
										w -= f;
										n.restore()
									}
								}
							}
						}
					}
				}
			}
			catch (v)
			{
				o = v
			}
			n.restore();
			return o
		}
	}

}

