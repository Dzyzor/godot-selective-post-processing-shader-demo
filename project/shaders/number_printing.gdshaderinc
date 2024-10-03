// Debug view copied from this project by Danil: (https://github.com/danilw/godot-utils-and-other) MIT license
// "print in shader" ShaderToy by @P_Malin: (https://www.shadertoy.com/view/4sBSWW) CC0 license
float DigitBin(in int x)
{
    if (x==0)return 480599.0;else if(x==1) return 139810.0;else if(x==2) return 476951.0;
	else if(x==3) return 476999.0;else if(x==4) return 350020.0;else if(x==5) return 464711.0;
	else if(x==6) return 464727.0;else if(x==7) return 476228.0;else if(x==8) return 481111.0;
	else if(x==9) return 481095.0;return 0.0;
}

float PrintValue(vec2 fragCoord, vec2 pixelCoord, vec2 fontSize, float value,
		float digits, float decimals) {
	vec2 charCoord = (fragCoord - pixelCoord) / fontSize;
	if(charCoord.y < 0.0 || charCoord.y >= 1.0) return 0.0;
	float bits = 0.0;
	float digitIndex1 = digits - floor(charCoord.x)+ 1.0;
	if(- digitIndex1 <= decimals) {
		float pow1 = pow(10.0, digitIndex1);
		float absValue = abs(value);
		float pivot = max(absValue, 1.5) * 10.0;
		if(pivot < pow1) {
			if(value < 0.0 && pivot >= pow1 * 0.1) bits = 1792.0;
		} else if(digitIndex1 == 0.0) {
			if(decimals > 0.0) bits = 2.0;
		} else {
			value = digitIndex1 < 0.0 ? fract(absValue) : absValue * 10.0;
			bits = DigitBin(int (mod(value / pow1, 10.0)));
		}
	}
	return floor(mod(bits / pow(2.0, floor(fract(charCoord.x) * 4.0) + floor(charCoord.y * 5.0) * 4.0), 2.0));
}

float print_number(in vec2 uv ,float number){
	uv.x += 0.5;
   	vec2 vPixelCoord2 = vec2(0.0);
	float fDigits = 2.0;
	float fDecimalPlaces = 0.0;
    vec2 fontSize = vec2(8.)/vec2(16.,9.);
	float fIsDigit2 = PrintValue(uv, vPixelCoord2, fontSize, number, fDigits, fDecimalPlaces);
    return fIsDigit2;
}
