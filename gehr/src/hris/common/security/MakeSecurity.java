package hris.common.security;

/** 
 * 암호화 작업......
 */
public class MakeSecurity 
{
	
	public static String encode(byte[] raw) 
	{
		StringBuffer encoded = new StringBuffer();
		for (int i = 0; i < raw.length; i += 3) 
		{
			encoded.append(encodeBlock(raw, i));
		}
		return encoded.toString();
	}
  
	protected static char[] encodeBlock(byte[] raw, int offset) 
	{
		int block = 0;
		int slack = raw.length - offset - 1;
		int end = (slack >= 2) ? 2 : slack;
		for (int i = 0; i <= end; i++) 
		{
			byte b = raw[offset + i];
			int neuter = (b < 0) ? b + 256 : b;
			block += neuter << (8 * (2 - i));
		}
		char[] sec = new char[4];
		for (int i = 0; i < 4; i++) 
		{
			int sixbit = (block >>> (6 * (3 - i))) & 0x3f;
			sec[i] = getChar(sixbit);
		}
		if (slack < 1) sec[2] = '=';
		if (slack < 2) sec[3] = '=';
		return sec;
	}
  
	protected static char getChar(int sixBit) 
	{
		if (sixBit >= 0 && sixBit <= 25)
			return (char)('A' + sixBit);
		if (sixBit >= 26 && sixBit <= 51)
			return (char)('a' + (sixBit - 26));
		if (sixBit >= 52 && sixBit <= 61)
			return (char)('0' + (sixBit - 52));
		if (sixBit == 62) return '+';
		if (sixBit == 63) return '/';
			return '?';
	}
  
	public static byte[] decode(String sec) 
	{
		int pad = 0;
		for (int i = sec.length() - 1; sec.charAt(i) == '='; i--)
			pad++;
		int length = sec.length() * 6 / 8 - pad;
		byte[] raw = new byte[length];
		int rawIndex = 0;
		for (int i = 0; i < sec.length(); i += 4) 
		{
			int block = (getValue(sec.charAt(i)) << 18)
						+ (getValue(sec.charAt(i + 1)) << 12)
						+ (getValue(sec.charAt(i + 2)) << 6)
						+ (getValue(sec.charAt(i + 3)));
			for (int j = 0; j < 3 && rawIndex + j < raw.length; j++)
				raw[rawIndex + j] = (byte)((block >> (8 * (2 - j))) & 0xff);
		
			rawIndex += 3;
    	}
		return raw;
	}
  
	protected static int getValue(char c) 
	{
		if (c >= 'A' && c <= 'Z') return c - 'A';
		if (c >= 'a' && c <= 'z') return c - 'a' + 26;
		if (c >= '0' && c <= '9') return c - '0' + 52;
		if (c == '+') return 62;
		if (c == '/') return 63;
		if (c == '=') return 0;
		return -1;
	}
}