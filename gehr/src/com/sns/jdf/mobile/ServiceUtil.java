package com.sns.jdf.mobile;

import com.sns.jdf.Logger;

import java.text.ParseException;
import java.util.Date;

public class ServiceUtil {

    public static String dateFormat(String dateString, String format) {

        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yy'.'MM'.'dd hh:mm");
        Date date = null;
        try {
          date = sdf.parse(dateString);
        }
        catch (ParseException e) {
          Logger.error(e);
        }
        if (date != null) {
            sdf.applyPattern(format);
            dateString=sdf.format(date);
        }
        return dateString;
    }

    /**
     * 데이터 포멧을 변경한다.
     * yyyyMMddHHmmss 데이터를 yyyy-MM-dd HH:mm:ss로 변경한다.
     * @param dateString
     * @return
     */
    public static String dateFormat(String dateString) {
        String srcFormat = "yyyyMMddHHmmss";
        String targetFormat = "yyyy-MM-dd HH:mm:ss";
        return dateFormat(dateString , srcFormat, targetFormat);
    }

    /**
     * 데이터 포멧을 변경한다.
     *     "yyyy.MM.dd G 'at' hh:mm:ss z"    ->>  1996.07. 10 AD at 15:08:56 PDT
     *     "EEE, MMM d, ''yy"                ->>  Wed, July 10, '96
     *     "h:mm a"                          ->>  12:08 PM
     *     "hh 'o''clock' a, zzzz"           ->>  12 o'clock PM, Pacific Daylight Time
     *     "K:mm a, z"                       ->>  0:00 PM, PST
     *     "yyyyy.MMMMM.dd GGG hh:mm aaa"    ->>  1996. July. 10 AD 12:08 PM
     *     "yy'/'MM'/'dd,hh:mm"
     *
     * @param dateString 원시데이터
     * @param srcFormat 원시데이터의 포멧
     * @param targetFormat 변경할고자 하는 데이터의 포멧
     * @return
     */
    public static String dateFormat(String dateString , String srcFormat, String targetFormat) {

        if (dateString == null || dateString.equals(""))
            return "";
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat( srcFormat);
        Date date = null;
        try {
            date = sdf.parse(dateString);
        } catch (ParseException e) {
            Logger.error(e);
        }
        if (date != null) {
            sdf.applyPattern(targetFormat);
            dateString = sdf.format(date);
        }
        return dateString;
    }

}
