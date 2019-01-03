package com.sns.jdf.util;

import com.sns.jdf.Logger;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.util.StringUtils;

import java.text.ParseException;
import java.util.Date;

/**
 * @(#) DateTime.java
 */
public final class DateTime {

	/**
	 * Don't let anyone instantiate this class
	 */
	private DateTime() {}

	/**
	 * check date string validation with the default format "yyyy-MM-dd".
	 * @param s date string you want to check with default format "yyyy-MM-dd".
	 */
	public static void check(String s) throws Exception {
		DateTime.check(s, "yyyy-MM-dd");
	}

	/**
	 * check date string validation with an user defined format.
	 * @param s date string you want to check.
	 * @param format string representation of the date format. For example, "yyyy-MM-dd".
	 */
	public static void check(String s, String format) throws java.text.ParseException {
		if ( s == null )
			throw new NullPointerException("date string to check is null");
		if ( format == null ) 
			throw new NullPointerException("format string to check date is null");

		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat (format, java.util.Locale.KOREA);
		java.util.Date date = null;
		try {
			date = formatter.parse(s);
		}
		catch(java.text.ParseException e) {
			throw new java.text.ParseException(
				e.getMessage() + " with format \"" + format + "\"",
				e.getErrorOffset()
			);
		}
		
		if ( ! formatter.format(date).equals(s) )
			throw new java.text.ParseException(
				"Out of bound date:\"" + s + "\" with format \"" + format + "\"",
				0
			);
	}

	/**
	 * @return formatted string representation of current day with  "yyyy-MM-dd".
	 */
	public static String getDateString() {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat ("yyyy-MM-dd", java.util.Locale.KOREA);
		return formatter.format(new java.util.Date());
	}

	/**
	 *
	 * For example, String time = DateTime.getFormatString("yyyy-MM-dd HH:mm:ss");
	 *
	 * @param java.lang.String pattern  "yyyy, MM, dd, HH, mm, ss and more"
	 * @return formatted string representation of current day and time with  your pattern.
	 */
	public static int getDay() {
		return getNumberByPattern("dd");
	}

	/**
	 *
	 * For example, String time = DateTime.getFormatString("yyyy-MM-dd HH:mm:ss");
	 *
	 * @param java.lang.String pattern  "yyyy, MM, dd, HH, mm, ss and more"
	 * @return formatted string representation of current day and time with  your pattern.
	 */
	public static String getFormatString(String pattern) {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat (pattern, java.util.Locale.KOREA);
		String dateString = formatter.format(new java.util.Date());
		return dateString;
	}

	/**
	 *
	 * For example, String time = DateTime.getFormatString("yyyy-MM-dd HH:mm:ss");
	 *
	 * @param java.lang.String pattern  "yyyy, MM, dd, HH, mm, ss and more"
	 * @return formatted string representation of current day and time with  your pattern.
	 */
	public static int getMonth() {
		return getNumberByPattern("MM");
	}

	/**
	 *
	 * For example, String time = DateTime.getFormatString("yyyy-MM-dd HH:mm:ss");
	 *
	 * @param java.lang.String pattern  "yyyy, MM, dd, HH, mm, ss and more"
	 * @return formatted string representation of current day and time with  your pattern.
	 */
	public static int getNumberByPattern(String pattern) {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat (pattern, java.util.Locale.KOREA);
		String dateString = formatter.format(new java.util.Date());
		return Integer.parseInt(dateString);
	}

	/**
	 * @return formatted string representation of current day with  "yyyyMMdd".
	 */
	public static String getShortDateString() {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat ("yyyyMMdd", java.util.Locale.KOREA);
		return formatter.format(new java.util.Date());
	}

	/**
	 * @return formatted string representation of current time with  "HHmmss".
	 */
	public static String getShortTimeString() {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat ("HHmmss:SS", java.util.Locale.KOREA);
		return formatter.format(new java.util.Date());
	}

	/**
	 * @return formatted string representation of current time with  "yyyy-MM-dd-HH:mm:ss".
	 */
	public static String getTimeStampString() {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat ("yyyy-MM-dd-HH:mm:ss:SSS", java.util.Locale.KOREA);
		return formatter.format(new java.util.Date());
	}

	/**
	 * @return formatted string representation of current time with  "HH:mm:ss".
	 */
	public static String getTimeString() {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat ("HH:mm:ss", java.util.Locale.KOREA);
		return formatter.format(new java.util.Date());
	}

	/**
	 *
	 * For example, String time = DateTime.getFormatString("yyyy-MM-dd HH:mm:ss");
	 *
	 * @param java.lang.String pattern  "yyyy, MM, dd, HH, mm, ss and more"
	 * @return formatted string representation of current day and time with  your pattern.
	 */
	public static int getYear() {
		return getNumberByPattern("yyyy");
	}
/******************************************************************************
*
*		[추가] String 관련 Util 함수들.. by kim.sung.il
*           한글과 영문의 String을 Byte 수를 고려하여 잘라낸다..
*******************************************************************************/

    public static String frontCut(String str, int limit)     
    {   
        if (str == null || limit < 4) return str;

        int len = str.length();
        int cnt=0, index=len-1;
        while ( cnt < limit )
        {
            if (str.charAt(index--) < 256) // 1바이트 문자라면...
                cnt++;     // 길이 1 증가
            else {// 2바이트 문자라면...
                cnt += 2;  // 길이 2 증가
                if(cnt > limit){
                    Logger.debug.println("1234567890-=");
                    index++;
                }
            }
        }

        if (index < len)
            str = str.substring(index+1);

        return str;
    }

    public static String endCut(String str, int limit)     
    {   
        if (str == null || limit < 4) return str;

        int len = str.length();
        int cnt=0, index=0;

        while (index < len && cnt < limit)
        {
            if (str.charAt(index++) < 256) // 1바이트 문자라면...
                cnt++;     // 길이 1 증가
            else {// 2바이트 문자라면...
                cnt += 2;  // 길이 2 증가
                if(cnt > limit){
                     //Logger.debug("1234567890-=");
                    index--;
                }
            }
       }

        if (index < len)
            str = str.substring(0, index);

        return str;
    }

	public static Date parseDate(String dateString) {
		if(StringUtils.isEmpty(dateString)) return null;
		try {
			return DateUtils.parseDate(dateString, new String[] {"yyyy.MM.dd"});
		} catch (ParseException e) {
			Logger.error(e);
		}
		return  null;
	}

}
