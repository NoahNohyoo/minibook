package com.mini.util;

public class NumberUtil {
	public static int StringToInt(String str, int defaultValue, int totalRows) {	
		if (str == null) {
			return defaultValue;
		}
		
		try {
			int number = Integer.parseInt(str);
			if (number > totalRows || number < 1) {
				return defaultValue;
			}
			return number;
		} catch (NumberFormatException e) {
			e.printStackTrace();
			return defaultValue;
		}
	}
}
