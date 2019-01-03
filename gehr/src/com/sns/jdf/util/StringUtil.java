package com.sns.jdf.util;
/** JDK API */
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.sns.jdf.Logger;

public final class StringUtil
{

    public StringUtil() {
    }

    public static void makelog(String msg) throws Exception
    {
        StringBuffer WriteMsg = new StringBuffer("");
        String temp = "";
        int i = 0;

        java.util.StringTokenizer BUFF = new java.util.StringTokenizer(msg, "\n");
        int COUNT = BUFF.countTokens();
        for(i = 0; i < COUNT; i++)
        {
            temp = BUFF.nextToken();
            WriteMsg.append(rtrim(temp) + "\n");
        }

        try
        {
            java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter("C:/java.log", true), true);
            log.print("\n-------------------------------------------------------------------------------------\n");
            log.print(WriteMsg.toString());
            log.close();
        }
        catch(Exception e1)
        {
            return;
        }
    }

    public static boolean isNull(String p_value)
    {
        if( p_value == null || p_value.trim().length() == 0 || p_value.trim().equals("") || p_value.trim().equalsIgnoreCase("null") )
            return true;
        else
            return false;
    }

    public static String rtrim(String buff) throws Exception
    {
        int i = 0;
        String temp = "";

        if( !isnull(buff) )
        {
            for(i = buff.length() - 1; i != 0; i--)
            {
                temp = buff.substring(i, i + 1);
                if( !temp.equals("\n") && !temp.equals("\r") && !temp.equals(" ") )
                    break;
            }
            return buff.substring(0, i + 1);
        }
        else
        {
            return "";
        }
    }

    public static boolean strcmp(String str1, String str2) throws Exception
    {
        if( isnull(str1) && isnull(str2) ) // ?ëò?ã§?Ñê?ù¥Î©? Í∞ôÏ?Í±∞Í≥†
            return true;

        if( isnull(str1) && !isnull(str2) ) // ?ïò?ÇòÎßåÎÑê?ù¥Í≥? ?ã§Î•∏Í±¥ ?Ñê?ù¥ ?ïÑ?ãàÎ©? ??Î¶∞Í≤É?ù¥Í≥?
            return false;

        if( !isnull(str1) && isnull(str2) ) // ?ïò?ÇòÎßåÎÑê?ù¥Í≥? ?ã§Î•∏Í±¥ ?Ñê?ù¥ ?ïÑ?ãàÎ©? ??Î¶∞Í≤É?ù¥Í≥?
            return false;

        if( str1.equals(str2) )
            return true;
        else
            return false;
    }

    public static boolean stricmp(String str1, String str2) throws Exception
    {
        if( isnull(str1) && isnull(str2) ) // ?ëò?ã§?Ñê?ù¥Î©? Í∞ôÏ?Í±∞Í≥†
            return true;

        if( isnull(str1) && !isnull(str2) ) // ?ïò?ÇòÎßåÎÑê?ù¥Í≥? ?ã§Î•∏Í±¥ ?Ñê?ù¥ ?ïÑ?ãàÎ©? ??Î¶∞Í≤É?ù¥Í≥?
            return false;

        if( !isnull(str1) && isnull(str2) ) // ?ïò?ÇòÎßåÎÑê?ù¥Í≥? ?ã§Î•∏Í±¥ ?Ñê?ù¥ ?ïÑ?ãàÎ©? ??Î¶∞Í≤É?ù¥Í≥?
            return false;

        if( str1.toUpperCase().equals(str2.toUpperCase()) )
            return true;
        else
            return false;
    }

    public static String nullcheck(String buff) throws Exception
    {
        if( isnull(buff) )
            return "";
        else
            return buff;
    }

    public static String numberFormat(float values) throws Exception
    {
        java.text.NumberFormat NF = java.text.NumberFormat.getInstance();
        return NF.format(values);
    }

    public static boolean isnull(String value) throws Exception
    {
        if( value == null )
            return true;

        try
        {
            if( value.length() > 0 )
                return false;
            else
                return true;
        }
        catch(NullPointerException e)
        {
            return false;
        }
    }

    public static int atoi(String value) throws Exception
    {
        if( value == null )
            return 0;

        if( value.length() == 0 )
            return 0;

        try
        {
            int i = Integer.parseInt( strReplace(",", "", value.trim()));
            return i;
        }
        catch(NumberFormatException e)
        {
            return 0;
        }
    }

    public static String itos(int value)
    {
        String RtnVal = new Integer(value).toString();
        return RtnVal;
    }

    public static String strReplace(String from, String to, String src) throws Exception
    {
        StringBuffer rtnval = new StringBuffer("");

        if( isnull(from) || isnull(src) )
            return src;

        int i = 0;
        int offset = 0;
        int srclength = src.length();
        int fromlength = from.length();
        while(true)
        {
            if( i == srclength )
                break;

            if( i > srclength - fromlength - 1 )
                offset = srclength - i;
            else
                offset = fromlength;

            if( src.substring(i, i + offset).equals(from) )
            {
                rtnval.append(to);
                i += fromlength;
            }
            else
            {
                rtnval.append(src.substring(i, i + 1));
                ++i;
            }
        }

        return rtnval.toString();
    }

    public static String striReplace(String from, String to, String src) throws Exception
    {
        StringBuffer rtnval = new StringBuffer("");

        if( isnull(from) || isnull(src) )
            return src;

        String dupsrc = src.toLowerCase();
        String dupfrom = from.toLowerCase();

        int i = 0;
        int offset = 0;
        int srclength = src.length();
        int fromlength = from.length();
        while(true)
        {
            if( i == srclength )
                break;

            if( i > srclength - fromlength - 1 )
                offset = srclength - i;
            else
                offset = fromlength;

            if( dupsrc.substring(i, i + offset).equals(dupfrom) )
            {
                rtnval.append(to);
                i += fromlength;
            }
            else
            {
                rtnval.append(src.substring(i, i + 1));
                ++i;
            }
        }

        return rtnval.toString();
    }

    public static String getFileExtention(String FileName)
    {
        int i;
        int COUNT;
        String RtnVal = "";

        java.util.StringTokenizer BUFF = new java.util.StringTokenizer(FileName, ".");
        COUNT = BUFF.countTokens();
        for(i = 0; i < COUNT; i++)
            RtnVal = BUFF.nextToken();

        return RtnVal;
    }

    public static String htmlspecialchars(String src) throws Exception
    {
        if( isnull(src) )
            return "";

        StringBuffer rtnval = new StringBuffer("");

        int i = 0;
        int srclength = src.length();
        while(true)
        {
            if( i == srclength )
                break;

            if( src.substring(i, i + 1).equals("&") )
                rtnval.append("&amp;");
            else if( src.substring(i, i + 1).equals("\"") )
                rtnval.append("&quot;");
            else if( src.substring(i, i + 1).equals("<") )
                rtnval.append("&lt;");
            else if( src.substring(i, i + 1).equals(">") )
                rtnval.append("&gt;");
            else if( src.substring(i, i + 1).equals("\"") )
                rtnval.append("&quot;");
            else if( src.substring(i, i + 1).equals("\n") )
                rtnval.append("<BR>\n");
            else
                rtnval.append(src.substring(i, i + 1));

            ++i;
        }

        return rtnval.toString();
    }

    public static String getSQLString(String value) throws Exception
    {
        if( isnull(value) )
            return "";
        else
            return strReplace("'", "''", value);
    }

    public static String getDateFormat(String str) throws Exception
    {
        String NEWFORMAT = striReplace("YYYY", "yyyy", str);
        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(NEWFORMAT);
        return formatter.format(new java.util.Date());
    }

    public static String getStrtokSQL(String str) throws Exception
    {
        int i;
        int COUNT;
        StringBuffer RtnVal = new StringBuffer("");

        java.util.StringTokenizer BUFF = new java.util.StringTokenizer(str, ",");
        COUNT = BUFF.countTokens();
        for(i = 0; i < COUNT; i++)
        {
            if( i == COUNT - 1 )
                RtnVal.append("'" + getSQLString(BUFF.nextToken()) + "'");
            else
                RtnVal.append("'" + getSQLString(BUFF.nextToken()) + "',");
        }

        return RtnVal.toString();
    }

    public static String getStrtokSQL(String str, int index) throws Exception
    {
        int i;
        int COUNT;
        StringBuffer RtnVal = new StringBuffer("");

        java.util.StringTokenizer BUFF = new java.util.StringTokenizer(str, ",");
        COUNT = BUFF.countTokens();
        for(i = 0; i < COUNT; i++)
        {
            if( i == COUNT - 1 )
                RtnVal.append("'" + getSQLString(BUFF.nextToken().substring(0, index)) + "'");
            else
                RtnVal.append("'" + getSQLString(BUFF.nextToken().substring(0, index)) + "',");
        }

        return RtnVal.toString();
    }

    public static int indexOf(StringBuffer a, String b, int pos)
    {
        int c = pos;
        while(c <= a.length() - b.length())
        {
            String sub = a.substring(c, c + b.length());
            if( sub.equals(b) )
                return c;
            c++;
        }
        return -1;
    }

    // ?õπ?éò?ù¥Ïß??ùò ?ûÖ?†•Í∞íÏùÑ Vector ?óê?ã§ ?Ñ£?ñ¥Ï§??ã§.
    public Vector getInputData(HttpServletRequest request) throws Exception
    {
        Vector vecList = new Vector();
        HashMap row = new HashMap();

        if( request == null )
            return vecList;

        java.util.Enumeration requestKeys = request.getParameterNames();
        while(requestKeys.hasMoreElements())
        {
            String keyValue = (String) requestKeys.nextElement();
            String value = request.getParameter(keyValue);

            // ?óêÏΩîÎî©?ùÑ ?ï†Í≤ÉÏù∏Ïß? ÎßêÍ≤É?ù∏Ïß?Î•? ?Ñ§?†ï...
            if( true )
                row.put(keyValue, new String(value.getBytes("8859_1"), "EUC-KR"));
            else
                row.put(keyValue, value);

        }

        vecList.addElement(row);
        return vecList;
    }

    /**
     * Î¨∏Ïûê?ó¥?óê ?äπ?†ïÎ¨∏ÏûêÎ•? ???ÜåÎ¨∏Ïûê?ùò Íµ¨Î≥Ñ?óÜ?ù¥ ?ä§?ä∏ÎßÅÏùÑ Î¶¨Ìîå?†à?ù¥?ä§?ïú?ã§. 2006-05-01 ÏµúÌòÑ?àò
     *
     * @param fromString Î≥?Í≤ΩÎê† ???ÉÅÎ¨∏Ïûê?ó¥
     * @param toString Î≥?Í≤ΩÌï† Î¨∏Ïûê?ó¥
     * @param orgSting Î≥?Í≤ΩÌï† Î¨∏Ïûê?ó¥ ?õêÎ≥?
     * @return returnString Í≤∞Í≥º?ùò Î¶¨ÌÑ¥Í∞?
     * @throws LException
     */
    public static String replaceiString(String from, String to, String src) throws Exception
    {
        StringBuffer rtnval = new StringBuffer("");

        if( isNull(from) || isNull(src) )
            return src;

        String dupsrc = src.toLowerCase();
        String dupfrom = from.toLowerCase();

        int i = 0;
        int offset = 0;
        int srclength = src.length();
        int fromlength = from.length();
        while(true)
        {
            if( i == srclength )
                break;

            if( i > srclength - fromlength - 1 )
                offset = srclength - i;
            else
                offset = fromlength;

            if( dupsrc.substring(i, i + offset).equals(dupfrom) )
            {
                rtnval.append(to);
                i += fromlength;
            }
            else
            {
                rtnval.append(src.substring(i, i + 1));
                ++i;
            }
        }

        return rtnval.toString();
    }

    /**
     * --REGION AND REGION = '@REGION' ?ùò SQLÏ§? ?ûÖ?†•Í∞? replaceValue Í∞? null ?ù¥ ?ïÑ?ãàÎ©? AND Ï°∞Í±¥?†à?ùÑ Ï≤òÎ¶¨?ï† ?àò ?ûà?ã§. 2006.07.21 mrchoi73
     *
     * @param String Î¶¨Ìîå?†à?ù¥?ä§?ï† ?å®?Ñ¥
     * @param String Î¶¨Ìîå?†à?ù¥?ä§?ê† Í∞?
     * @return String Í≤∞Í≥º?ùò Î¶¨ÌÑ¥Í∞?
     * @throws LException
     */
    public static String checkNReplace(String andQuery, String replaceValue, String sql) throws Exception
    {
        if( !isNull(replaceValue) )
            return replaceiString("@" + andQuery, replaceValue, replaceiString("--" + andQuery, "", sql));
        else
            return sql;
    }

    public static boolean isUnicode(String format)
    {
        try
        {
            return !format.equals(new String(format.getBytes("KSC5601"), "KSC5601"));
        }
        catch(UnsupportedEncodingException e)
        {
            return true;
        }
    }

    public static String numberFormat(String value) throws Exception
    {
        if( isnull(value) )
            return "";

        long d = Long.parseLong(value);
        java.text.DecimalFormat df = new java.text.DecimalFormat("00");
        return df.format(d).toString();
    }

    public static boolean in_array(String[] array, String value)
    {
        try
        {
            for(int i=0;i<array.length;i++)
            {
                if( strcmp(array[i], value) )
                    return true;
            }

            return false;
        }
        catch(Exception e)
        {
            return false;
        }
    }

    public static float getFloat(String value) throws Exception
    {
        if( isnull(value) )
            return 0;
        else
            return Float.parseFloat(strReplace(",", "", value));
    }

    /*public static String getFileContents(String fileName)
    {
        try
        {
            FileInputStream fd = new FileInputStream(fileName);
            BufferedReader read = new BufferedReader(new InputStreamReader(fd));
            StringBuffer buff = new StringBuffer();
            final int MAX_SIZE = 200000;
            char[] buffer = new char[MAX_SIZE];
            String temp = "";

            while((read.read( buffer, 0, MAX_SIZE) > 0)){
            	buff.append(temp);
            }

            //1¬˜ ∫∏æ»¡¯¥‹ ∞≥º±
            *//*while((temp = read.readLine())!=null)
            {
                buff.append(temp);
            }*//*

            return buff.toString();
        }
        catch(Exception e)
        {
            return "";
        }
    }*/

    public static String zero2null(Object invalue)
    {
        String rtnVal = "";

        try
        {
            if( invalue instanceof String )
            {
                if( strcmp( ((String)invalue).trim(), "0") )
                    rtnVal = "";
                else
                {
                    float value = getFloat((String)invalue);
                    if( value == 0 )
                        rtnVal = "";
                    else
                        rtnVal = (String)invalue;
                }
            }
            else if( invalue instanceof Integer )
            {
                if( Integer.parseInt((String)invalue) == 0 )
                    rtnVal = "";
                else
                    rtnVal = (String)invalue;
            }
            else if( invalue instanceof Float )
            {
                if( Float.parseFloat((String)invalue) == 0 )
                    rtnVal = "";
                else
                    rtnVal = (String)invalue;
            }

            return rtnVal;
        }
        catch(Exception e)
        {
            return "";
        }
    }
}
