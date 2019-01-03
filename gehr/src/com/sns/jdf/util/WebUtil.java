package com.sns.jdf.util;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.util.WebUtils;

import com.common.Global;
import com.common.Utils;
import com.common.constant.Area;
import com.google.common.io.Files;
import com.sns.jdf.EntityData;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;

import hris.A.A14Bank.A14BankTypeData;
import hris.D.D01OT.D01OTReasonData;
import hris.N.AES.AESgenerUtil;
import hris.common.WebUserData;
import hris.common.util.DocumentInfo;

@SuppressWarnings({ "rawtypes", "unused" })
public final class WebUtil {

    public static String contextPath;
    public static String JspPath;
    public static String ServletPath;
    public static String JspURL;
    public static String ServletURL;
    public static String ImageURL;
    public static String DefaultPage;
    public static String ErrorPage;
    public static String UploadFilePath;

    private static int DEFAULT_DECIMALSIZE;
    private static String DEFAULT_NUMBER_FORMAT;
    private static String DEFAULT_CURRENCY_FORMAT;
    private static String DEFAULT_DATE_FORMAT;
    private static String DEFAULT_SEPARATER;

    private WebUtil() {
    }

    /*************************���⼭���� URLUtil********************************/
    static {
        try {
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();

/*            JspPath     = conf.get("com.sns.jdf.JspPath");
            ServletPath = conf.get("com.sns.jdf.ServletPath");
            JspURL      = conf.get("com.sns.jdf.JspURL");
            ServletURL  = conf.get("com.sns.jdf.ServletURL");
            ImageURL    = conf.get("com.sns.jdf.ImageURL");
            DefaultPage = conf.get("com.sns.jdf.DefaultPage");
            ErrorPage   = conf.get("com.sns.jdf.ErrorPage");*/
            DEFAULT_DECIMALSIZE = Integer.parseInt(conf.get("com.sns.jdf.DEFAULT_DECIMALSIZE"));
            DEFAULT_NUMBER_FORMAT = conf.get("com.sns.jdf.DEFAULT_NUMBER_FORMAT");
            DEFAULT_CURRENCY_FORMAT = conf.get("com.sns.jdf.DEFAULT_CURRENCY_FORMAT");
            DEFAULT_DATE_FORMAT = conf.get("com.sns.jdf.DEFAULT_DATE_FORMAT");
            DEFAULT_SEPARATER = conf.get("com.sns.jdf.DEFAULT_SEPARATER");
            UploadFilePath = conf.get("com.sns.jdf.logger.upload");
        } catch (Exception e) {
            Logger.err.println("WebUtil Exception. Failed create Configuration Object!" + DataUtil.getStackTrace(e));
            //throw new com.sns.jdf.GeneralException(e);
        }
    }

    /*************************
     * ���⼭����
     ********************************/
    public static String makePath(String s) throws com.sns.jdf.GeneralException {

        com.sns.jdf.Logger.debug.println(s.substring(s.length() - 4));
        if (s.length() >= 4 && s.substring(s.length() - 4).equals(".jsp")) {
            return (JspPath + s);
        } else {
            return (ServletPath + s);
        }
    }

    /*************************���⼭���� HttpUtil********************************/
    /**
     * Decode a string from <code>x-www-form-urlencoded</code> format.
     *
     * @param s an encoded <code>String</code> to be translated.
     * @return the original <code>String</code>.
     */
    public static String decode(String s) throws GeneralException {
        try {
            return java.net.URLDecoder.decode(s, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new GeneralException(e);
        }
    }

    /**
     * Translates a string into <code>x-www-form-urlencoded</code> format.
     *
     * @param s <code>String</code> to be translated.
     * @return the translated <code>String</code>.
     */
    public static String encode(String s) throws GeneralException {
        try {
            return java.net.URLEncoder.encode(s, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new GeneralException(e);
        }
    }

    public static String[] increaseSize(String[] original) {
        String[] temp = new String[original.length + 1];
        for (int n = 0; n < original.length; n++){
            temp[n] = original[n];
        }
        return temp;
    }

    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3; // 3MB
//    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
//    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    /**
     * @param req javax.servlet.http.HttpServletRequest
     */
    public static Box getBox(HttpServletRequest req) {

        Box box = new Box("requestbox");

        if (ServletFileUpload.isMultipartContent(req)) {

            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setRepository(Files.createTempDir());
            factory.setSizeThreshold(MEMORY_THRESHOLD);
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");
            /*���ε� ������ ��å ����*/
            // sets maximum size of upload file
            // upload.setFileSizeMax(MAX_FILE_SIZE);
            // sets maximum size of request (include file + form data)
            // upload.setSizeMax(MAX_REQUEST_SIZE);

            try {
                List<FileItem> items = upload.parseRequest(req);

                for (FileItem item : items) {
                    String fieldName = item.getFieldName();

                    if (item.isFormField()) {
                        if (box.getObject(fieldName) != null) {
                            String[] values = (String[]) box.getObject(fieldName);
                            values = increaseSize(values);
                            values[values.length - 1] = item.getString("UTF-8");
                            box.put(fieldName, values);
                        } else
                            box.put(fieldName, new String[] { item.getString("UTF-8") });
                    } else {
                        if (item.getSize() > 0)
                            box.put(fieldName, item);
                    }

                }
            } catch (Exception e) {
                Logger.error(e);
            }

        } else {
            Enumeration e = req.getParameterNames();
            while (e.hasMoreElements()) {
                String key = (String) e.nextElement();
                String values[] = req.getParameterValues(key);
                /* if (values != null) {
                    for (int i = 0; i < values.length; i++) {
                        values[i] = fromWeb(values[i]);
                    }
                }*/

                box.put(key, values);
            }
            Logger.debug.println("WebUtil.getBox(req) : " + box.getHashMap());

        }

        return box;
    }

    public static Box getBox(HttpServletRequest req, WebUserData user) {
        Box box = getBox(req);
        box.put("I_PERNR", user.empNo);
        box.put("I_MOLGA", user.area.getMolga());
        return box;
    }

    /**
     * request���� klass�� �ش��ϴ� �ʵ� ���� ������ ä�� �����Ѵ�.
     * getBox �� ������ ���
     *
     * @param request
     * @param klass
     * @param <T>
     * @return
     * @throws GeneralException
     */
    public static <T extends EntityData> T getEntityFromRequest(HttpServletRequest request, Class<T> klass) throws GeneralException {
        T entity = null;
        try {
            entity = klass.newInstance();

            Field[] fields = entity.getClass().getFields();

            for (Field field : fields) {
                Utils.setFieldValue(entity, field, request.getParameter(field.getName()));
            }
        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }

        return entity;
    }

    /**
     * getEntityFromRequest �� ��Ƽ������ ���� ��� ó��
     *
     * @param request
     * @param klass
     * @param <T>
     * @return
     * @throws GeneralException
     */
    public static <T extends EntityData> Vector<T> getEntityListFromRequest(HttpServletRequest request, Class<T> klass) throws GeneralException {

        Vector<T> resultList = new Vector<T>();

        int nMaxSize = 0;

        Field[] fields = klass.getFields();

        for (Field field : fields) {
            String[] parameters = request.getParameterValues(field.getName());
            if (parameters != null && parameters.length > nMaxSize) nMaxSize = parameters.length;
        }

        for (int n = 0; n < nMaxSize; n++) {
            try {
                T entity = klass.newInstance();

                for (Field field : fields) {
                    Utils.setFieldValue(entity, field, request.getParameter(field.getName()));
                }

                resultList.add(entity);
            } catch (Exception e) {
                Logger.error(e);
                throw new GeneralException(e);
            }
        }

        return resultList;

    }


    /**
     * @param req HttpServletRequest
     * @return boolean
     */
    public static boolean isOverIE50(HttpServletRequest req) {
        String user_agent = (String) req.getHeader("user-agent");

        if (user_agent == null) return false;

        int index = user_agent.indexOf("MSIE");
        if (index == -1) return false;

        int version = 0;
        try {
            version = Integer.parseInt(user_agent.substring(index + 5, index + 5 + 1));
        } catch (Exception e) {
        }
        if (version < 5) return false;

        return true;
    }

    ///////////////////////////////////////////////////////////////////////////////////////
    private static String fromWeb(String data) {
        /*try {
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
            if (conf.getBoolean("com.sns.jdf.util.WebConversion")) {
                return new String(data.getBytes("8859_1"));
            } else {
                return data;
            }
        } catch (Exception e) {
            Logger.error(e);
            return data;
        }*/
        return data;
    }

    private static String toWeb(String data) {           // �ѱ۷� ������
        try {
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
            if (conf.getBoolean("com.sns.jdf.util.WebConversion")) {
                //return DataUtil.E2K(data);
                return new String(data.getBytes("KSC5601"));
            } else {
                return data;
            }
        } catch (Exception e) {
            Logger.error(e);
            return data;
        }
    }

    /*************************���⼭���� JspUtil************************************/


    /*******************************************************************************
     * printString( String str )
     *******************************************************************************/
    public static String printString(String str) {
        // str==null �̸� html page���� table�� �������� ����� &nbsp; ���� �ִ´�.
        if (str == null) {
            str = "&nbsp;";
        } else {

            // �ѱ� ������
            str.trim();
            if (str.equals("")) return "&nbsp;";

            str = toWeb(str);

            /*  Ư�� ���� ��ȯ
             * & --> &amp;
             * < --> &lt;
             * > --> &gt;
             * " --> &quot;
             * ' --> &#039;
             * _ --> &nbsp;
             * \n--> ?????
             */

            str = translate(str);
        }
        return str;
    }


    /*******************************************************************************
     * printNumber(int num)
     *******************************************************************************/
    public static String printNumFormat(int num) {
        return printNumFormat(num, DEFAULT_DECIMALSIZE);
    }

    public static String printNumFormat(float num) {
        return printNumFormat(num, DEFAULT_DECIMALSIZE);
    }

    public static String printNumFormat(double num) {
        return printNumFormat(num, DEFAULT_DECIMALSIZE);
    }

    public static String printNumFormat(long num) {
        return printNumFormat(num, DEFAULT_DECIMALSIZE);
    }

    public static String printNumFormat(String num) {
        return printNumFormat(num, DEFAULT_DECIMALSIZE);
    }

    public static String printNumFormat(int num, int decimalSize) {
        double _num = (new Integer(num)).doubleValue();
        return printNumFormat(_num, decimalSize);
    }

    public static String printNumFormat(float num, int decimalSize) {
        double _num = (new Float(num)).doubleValue();
        return printNumFormat(_num, decimalSize);
    }

    public static String printNumFormat(double num, int decimalSize) {
        String format = "#,##0";
        for (int i = 0; i < decimalSize; ++i) {
            if (i == 0) format += ".";
            format += "0";
        }
        return printNumFormat(num, format);
    }

    public static String printNumFormat(long num, int decimalSize) {
        double _num = (new Long(num)).doubleValue();
        return printNumFormat(_num, decimalSize);
    }

    public static String printNumFormat(String num, int decimalSize) {
        double _num = NumberUtils.toDouble(DataUtil.removeComma(num));
        return printNumFormat(_num, decimalSize);
    }

    /**
     * 		Start: functionName+B zero�ϰ�� Blank�� ���� (ksc)
     */

    public static String printNumFormatBlank(int num, int decimalSize) {
        double _num = (new Integer(num)).doubleValue();
        if (_num==0) return "";
        return printNumFormat(_num, decimalSize);
    }

    public static String printNumFormatBlank(float num, int decimalSize) {
        double _num = (new Float(num)).doubleValue();
        if (_num==0) return "";
        return printNumFormat(_num, decimalSize);
    }

    public static String printNumFormatBlank(double num, int decimalSize) {
        if (num==0) return "";
        String format = "#,##0";
        for (int i = 0; i < decimalSize; ++i) {
            if (i == 0) format += ".";
            format += "0";
        }
        return printNumFormat(num, format);
    }

    public static String printNumFormatBlank(long num, int decimalSize) {
        double _num = (new Long(num)).doubleValue();
        if (_num==0) return "";
        return printNumFormat(_num, decimalSize);
    }

    public static String printNumFormatBlank(String num, int decimalSize) {
        double _num = NumberUtils.toDouble(DataUtil.removeComma(num));
        if (_num==0) return "";
        return printNumFormat(_num, decimalSize);
    }
    /**
     * 		END: functionName+B zero�ϰ�� Blank�� ���� (ksc)
     */

    public static String printNumFormat(double num, String format) {
        java.text.DecimalFormat df = new java.text.DecimalFormat(format);
        return df.format(num).toString();
    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    public static String printNum(int num) {
        double _num = (new Integer(num)).doubleValue();
        return printNum(_num);
    }

    public static String printNum(float num) {
        double _num = (new Float(num)).doubleValue();
        return printNum(_num);
    }

    public static String printNum(long num) {
        double _num = (new Long(num)).doubleValue();
        return printNum(_num);
    }

    public static String printNum(String num) {
        if(StringUtils.isBlank(num)) return num;
        double _num = Double.parseDouble(num);
        return printNum(_num);
    }

    public static String printNum(double num) {
        String format = "####.####";
        return printNum(num, format);
    }

    public static String printNum(double num, String format) {
        java.text.DecimalFormat df = new java.text.DecimalFormat(format);
        return df.format(num).toString();
    }


    /*******************************************************************************
     * printCurrency(int num)
     *******************************************************************************/

    public static String printCurrency(int num) {

        return printCurrency(num, DEFAULT_DECIMALSIZE);
    }

    public static String printCurrency(float num) {
        return printCurrency(num, DEFAULT_DECIMALSIZE);
    }

    public static String printCurrency(double num) {
        return printCurrency(num, DEFAULT_DECIMALSIZE);
    }

    public static String printCurrency(long num) {
        return printCurrency(num, DEFAULT_DECIMALSIZE);
    }

    public static String printCurrency(String num) {
        return printCurrency(num, DEFAULT_DECIMALSIZE);
    }


    public static String printCurrency(int num, int decimalSize) {
        double _num = (new Integer(num)).doubleValue();
        return printCurrency(_num, decimalSize);
    }


    public static String printCurrency(float num, int decimalSize) {
        double _num = (new Float(num)).doubleValue();
        return printCurrency(_num, decimalSize);
    }


    public static String printCurrency(double num, int decimalSize) {
        String format = "#,##0";
        for (int i = 0; i < decimalSize; ++i) {
            if (i == 0) format += ".";
            format += "0";
        }
        return printCurrency(num, format);
    }


    public static String printCurrency(long num, int decimalSize) {
        double _num = (new Long(num)).doubleValue();
        return printCurrency(_num, decimalSize);
    }


    public static String printCurrency(String num, int decimalSize) {
        double _num = Double.parseDouble(num);
        return printCurrency(_num, decimalSize);
    }

    public static String printCurrency(double num, String format) {
        java.text.DecimalFormat df = new java.text.DecimalFormat(format);
        return (DEFAULT_CURRENCY_FORMAT + df.format(num).toString());

    }

    /*******************************************************************************
     * printDate(String date)
     *******************************************************************************/
    public static String printDateDefault(String date, String compareValue, String defaultValue) {
        if(StringUtils.equals(date, compareValue)) date = defaultValue;
        return printDate(date, DEFAULT_SEPARATER);
    }

    /**
     * �� ��¥���� ���� ����
     * @param date
     * @return
     */
    public static boolean isEmptyDate(String date) {
        if(StringUtils.isEmpty(date)) return true;
        if(NumberUtils.toInt(date.replaceAll("[^\\d]", ""), 0) == 0) return true;

        return false;
    }

    /**
     * ��¥���·� ����
     * @param date
     * @return
     */
    public static String printDate(String date) {
        if(StringUtils.isEmpty(date)) return "";
        if(NumberUtils.toInt(date.replaceAll("[^\\d]", ""), 0) == 0) return "";

        return printDate(date, DEFAULT_SEPARATER);
    }

    public static String printDate(java.util.Date dDate) {
        return printDate(dDate, DEFAULT_SEPARATER);
    }

    public static String printDate(String date, String separater) {
        String ret = date;
        if (date.length() == 8) {
            ret = date.substring(0, 4) + separater + date.substring(4, 6) + separater + date.substring(6, 8);
        } else if (date.length() == 10) {
            ret = date.substring(0, 4) + separater + date.substring(5, 7) + separater + date.substring(8, 10);
        // [CSR ID:3438118] flexible time �ý��� ��û start
        } else if (date.length() ==6){
        	ret = date.substring(0, 4) + separater + date.substring(4, 6);
        }else if (date.length()==7){
        	 ret = date.substring(0, 4) + separater + date.substring(5, 7);
        }
                // [CSR ID:3438118] flexible time �ý��� ��û end
        return ret;
    }

    public static String printDate2(String date, String separater) {
        String ret = date;
        if (date.length() == 8) {
            ret = date.substring(2, 4) + separater + date.substring(4, 6) + separater + date.substring(6, 8);
        } else if (date.length() == 10) {
            ret = date.substring(2, 4) + separater + date.substring(5, 7) + separater + date.substring(8, 10);
        }
        return ret;
    }

    public static String printPeriod(String date, String separater) {
        String ret = date;
        if (date.length() == 21) {
            ret = date.substring(2, 4) + separater + date.substring(5, 7) + separater + date.substring(8, 10) + "~" + date.substring(13, 15) + separater + date.substring(16, 18) + separater + date.substring(19, 21);
        } else if (date.length() == 17) {
            ret = date.substring(2, 4) + separater + date.substring(4, 6) + separater + date.substring(6, 8) + "~" + date.substring(11, 13) + separater + date.substring(13, 15) + separater + date.substring(15, 17);
        }
        return ret;
    }

    public static String printDate(java.util.Date dDate, String separater) {
        String format = "yyyy" + separater + "mm" + separater + "dd";
        return printDate(dDate, format, "");
    }

    /*****
     * String no�� ���� �޼���� ������ �α����� ������
     *******/
    public static String printDate(java.util.Date dDate, String format, String no) {

        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(format);
        return formatter.format(dDate);
    }

    public static String printTime(String time)//��:��:�� �� ������ ���� ��:�� �� ����
    {
        if(StringUtils.isBlank(time)) return time;

        String ret = time;
        if (time.length()==8) {
            ret = time.substring(0, 5);
        } else if (time.length() == 6) {
            ret = time.substring(0, 2) + ":" + time.substring(2, 4);
        }
        return ret;
    }

    /*******************************************************************************
     * ��Ÿ Utillity
     *******************************************************************************/

    public static String translate(String s) {
        if (s == null) return null;

        StringBuffer buf = new StringBuffer();
        char[] c = s.toCharArray();
        int len = c.length;
        for (int i = 0; i < len; i++) {
            if (c[i] == '&') buf.append("&amp;");
            else if (c[i] == '<') buf.append("&lt;");
            else if (c[i] == '>') buf.append("&gt;");
            else if (c[i] == '"') buf.append("&quot;");
            else if (c[i] == '\'') buf.append("&#039;");
            else if (c[i] == ' ') buf.append("&nbsp;");
                //else if ( c[i] == '\n') buf.append("");
            else buf.append(c[i]);
        }
        return buf.toString();
    }

    /**
     * <pre>String ���̸� �޺κ� Ȥ�� �պκ���  byteSize��ŭ (�ѱ��� 2 byte) �ڸ��� </pre>
     */

    public static String frontCut(String s, int byteSize) {
        return com.sns.jdf.util.DataUtil.frontCut(s, byteSize);
    }


    public static String endCut(String s, int byteSize) {
        return com.sns.jdf.util.DataUtil.endCut(s, byteSize);
    }


    /**
     * <pre> ���ͷ� ����� code/ value �� html�� select ��ü�� option �� �־��ش� </pre>
     */
    public static String printOption(Vector key) {                       // selected�� �ʿ�������
        StringBuffer tag = new StringBuffer();
        for (int i = 0; i < key.size(); i++) {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity) key.get(i);
            tag.append("<option value ='" + ck.code + "' >" + ck.value + "</option>\n");
        }
        return toWeb(tag.toString());
    }

    public static String printSort(String clickSortField, String sortField, String sortValue) {
    	String returnValue = "";
    	if (sortField.equals(clickSortField)){
    		if( sortValue.toLowerCase().equals("desc"))    			returnValue = "<font color='#FF0000'><b>��</b></font>";
    		else returnValue = "<font color='#FF0000'><b>��</b></font>";
    	} else{
    		returnValue = "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>";
    	}

    	return returnValue;
    }

    public static String printOption(Vector key, String option_value) {  // selected�� �ʿ�������

        StringBuffer tag = new StringBuffer();
        int nSize = Utils.getSize(key);
        for (int i = 0; i < nSize; i++) {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity) key.get(i);
            tag.append("<option value ='" + ck.code + "' ");
            if (StringUtils.equals(option_value, ck.code)) {
                tag.append("selected");
            }
            tag.append(">" + ck.value);
            tag.append("</option>\n");
        }
        return toWeb(tag.toString());
    }

    //20151119 bankcard pangxiaolin start
    public static String printOptionBankType ( Vector key, String option_value ) {  // selected�� �ʿ�������
    	Global g = Utils.getBean("global");
        StringBuffer tag = new StringBuffer();
        for(int i=0 ; key.size()>i;i++){
        	A14BankTypeData tdata = (A14BankTypeData)key.get(i);
        	String tstext="";
        	if(tdata.STEXT.equals("Main bank")){
        		tstext = g.getMessage("MSG.A.A03.0009");
        	}else{
        		tstext= g.getMessage("MSG.A.A03.0010");
        	}
        	tag.append("<option value = '" + tstext +"' ");
//        	if(tdata.STEXT.equals(option_value)){
    		if(tstext.equals(option_value)){
        		tag.append( "selected" );
        	}
        	tag.append( ">" +tstext );
            tag.append( "</option>\n" );
        }
        return toWeb( tag.toString() );
    }
    //20151119 bankcard pangxiaolin end

    //20160504 OTReason start
    public static String printOTREasonType(Vector key,String option_value){
    	StringBuffer tag = new StringBuffer();
    	for(int i = 0; key.size() > i ; i++){
    		D01OTReasonData tdata = (D01OTReasonData)key.get(i);
    		tag.append("<option value = '" + tdata.ZRCODE +"' ");
    		if(tdata.ZRCODE.equals(option_value)){
    			tag.append("selected");
    		}
    		tag.append(">"+tdata.REASON);
    		tag.append("</option>\n");
    	}
    	return toWeb(tag.toString());
    }
//  20160504 OTReason end

    //20160928 OTReason start
    public static String printOptionREasonText ( Vector key, String option_value ) {  // ����Ÿ�� �׳� �����ٶ�

        String tags = new String();
        for ( int i=0 ; i < key.size() ; i++ )
        {
        	D01OTReasonData tdata = (D01OTReasonData)key.get(i);
            if( option_value.equals( tdata.ZRCODE ) ){
                tags =tdata.REASON;
            }
        }
        if ( (tags.trim()).equals("")) {
            tags = "&nbsp;";
        }

        return tags;
    }
    //20160928 OTReason end
    public static String printOption1 ( Vector key, String option_value ) {  // selected�? ?��?��?��?��경우

        StringBuffer tag = new StringBuffer();
        for ( int i=0 ; i < key.size() ; i++ )
        {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)key.get(i);
            tag.append( "<option value ='" + ck.value +"' " );
            if( option_value.equals( ck.code ) ){
                tag.append( "selected" );
            }
            tag.append( ">" + ck.code );
            tag.append( "</option>\n" );
        }
        return toWeb( tag.toString() );
    }

    public static String printOption2 ( Vector key, String option_value ) {  // selected�? ?��?��?��?��경우

        StringBuffer tag = new StringBuffer();
        for ( int i=0 ; i < key.size() ; i++ )
        {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)key.get(i);
            tag.append( "<option value ='" + ck.code +"' " );
            if(ck.code.substring(ck.code.length()-1,ck.code.length()).equals("X")){
                if( option_value.equals( ck.code.substring(0, ck.code.length()-1) ) ){
                    tag.append( "selected" );
                }
            }else{
                if( option_value.equals( ck.code ) ){
                    tag.append( "selected" );
                }
            }
            tag.append( ">" + ck.value );
            tag.append( "</option>\n" );
        }
        return toWeb( tag.toString() );
    }

    /*******************************************************************************
     *
     *    Leave : ?���??��?��?�� ?���? selectbox ?��무코?��.(value1)
     *
     *    2008-02-20. - jungin.
     *
     *******************************************************************************/
    public static String printOption3 ( Vector key, String option_value ) {

        StringBuffer tag = new StringBuffer();
        for ( int i=0 ; i < key.size() ; i++ )
        {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)key.get(i);
            tag.append("<input type='hidden' name='upmu_code' value="+ck.value1+">");
        }
        return toWeb( tag.toString() );
    }

    public static String printOptionText(Vector optionList, String option_value) {  // ����Ÿ�� �׳� �����ٶ�

        String tags = new String();
        for (int i = 0; i < Utils.getSize(optionList); i++) {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity) optionList.get(i);
            if (option_value.equals(ck.code)) {
                tags = ck.value;
            }
        }
        if ((tags.trim()).equals("")) {
            tags = "&nbsp;";
        }

        return tags;
    }

    public static Object findRow(Vector optionList, String fieldName, String findValue) {  // ����Ÿ�� �׳� �����ٶ�

        for (int i = 0; i < Utils.getSize(optionList); i++) {
            Object o = optionList.get(i);

            if(StringUtils.equals(findValue, ObjectUtils.toString(Utils.getFieldValue(o, fieldName))))
                return o;
        }

        return null;
    }

    public static String printOption(Vector entityList, String keyName, String textName, String selectValue) {
        StringBuffer sb = new StringBuffer();

        for(Object o : entityList) {
            String value = ObjectUtils.toString(Utils.getFieldValue(o, keyName));
            sb.append("<option value ='" + value + "' ")
                .append(StringUtils.equals(value, selectValue) ? "selected" : "").append(">")
                .append(Utils.getFieldValue(o, textName))
                .append("</option>\n");
        }

        return sb.toString();
    }

    // null �� ""�� �ٸ� ���ڷ� ��ȯ. (�����0805)
    public static String nvl(String as_str) throws Exception {
        String ls_str = "";
        if (as_str != null)
            ls_str = as_str.trim();
        return ls_str;
    }

    public static String nvl(String as_str, String default_str) throws Exception {
        String ls_str = null;
        if (as_str == null) {
            ls_str = "";
            as_str = "";
        } else {
            ls_str = as_str.trim();
        }

        if (!as_str.equals("")) {
            ls_str = ls_str.trim();
        } else {
            ls_str = default_str.trim();
        }
        return ls_str;
    }


    public static String makeGotoUrl(String UPMU_TYPE, int type, String AINF_SEQN, SAPType sapType) {
        if(sapType.isLocal())
            return makeGotoUrl(Integer.parseInt(UPMU_TYPE), type, AINF_SEQN, null);
        else
            return makeGotoUrlGlobal(Integer.parseInt(UPMU_TYPE), type, AINF_SEQN, null);
    } // end makeGotoUrl

    /**
     * �̸��� �Ǵ� ElOffic ���� ���翡�� e-HR�� ��� �� ��� �б� URL ���ϴ� �޼ҵ�
     *
     * @param UPMU_TYPE
     * @param type
     * @param AINF_SEQN
     * @return
     */
    public static String makeGotoUrl(String UPMU_TYPE, int type, String AINF_SEQN) {
        return makeGotoUrl(Integer.parseInt(UPMU_TYPE), type, AINF_SEQN, null);
    } // end makeGotoUrl

    public static String makeGotoUrl(String UPMU_TYPE, int type, String AINF_SEQN, String RequestPageName) {
        return makeGotoUrl(Integer.parseInt(UPMU_TYPE), type, AINF_SEQN, RequestPageName);
    } // end makeGotoUrl

    public static String makeGotoUrl(int UPMU_TYPE, int type, String AINF_SEQN) {
        return makeGotoUrl(UPMU_TYPE, type, AINF_SEQN, null);
    } // end makeGotoUrl

    /**
     * �̸��� �Ǵ� ElOffic ���� ���翡�� e-HR�� ��� �� ��� �б� URL ���ϴ� �޼ҵ�
     *
     * @param UPMU_TYPE       : ���� Ÿ��
     * @param type            : ���� ����
     * @param AINF_SEQN       : ���� ��ȣ
     * @param RequestPageName : ���� ������
     * @return
     */
    public static String makeGotoUrl(int UPMU_TYPE, int type, String AINF_SEQN, String RequestPageName) {
        StringBuffer detailPage = new StringBuffer(256);
        String targetPage = "";
        Logger.debug.println("WebUtil UPMU_TYPE = " + UPMU_TYPE + "\t type = " + type + "\t AINF_SEQN = " + AINF_SEQN + "\t RequestPageName = " + RequestPageName);
        switch (UPMU_TYPE) {
            case 1:// ������ ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G005ApprovalFinishCongraSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G004ApprovalCongraSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E19Congra.E19CongraDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G004ApprovalIngCongraSV";
                        break;
                } // end switch
                break;
            case 2: // ���� ���� ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G011ApprovalFinishPersonalSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G009ApprovalPersonalSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E10Personal.E10PersonalDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G010ApprovalIngPersonalSV";
                        break;
                } // end switch
                break;
            case 3: // �Ƿ�� ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G008ApprovalFinishHospitalSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G006ApprovalHospitalSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E17Hospital.E17HospitalDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G007ApprovalIngHospitalSV";
                        break;
                } // end switch
                break;
            case 4: // ���հ���
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.E.E15General.E15GeneralDetailSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.E.E15General.E15GeneralDetailSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E15General.E15GeneralDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.E.E15General.E15GeneralDetailSV";
                        break;
                } // end switch
                break;
            case 5: // ���� ���ϱ�  ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G014ApprovalFinishEntranceSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G012ApprovalEntranceSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E21Entrance.E21EntranceDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G013ApprovalIngEntranceSV";
                        break;
                } // end switch
                break;
            case 6: // ���б�/���ڱ� ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G017ApprovalFinishExpenseSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G015ApprovalExpenseSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E21Expense.E21ExpenseDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G016ApprovalIngExpenseSV";
                        break;
                } // end switch
                break;
            case 7: // �ξ簡������ ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G019ApprovalFinishSupportSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G018ApprovalSupportSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A12Family.A12SupportDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G018ApprovalIngSupportSV";
                        break;
                } // end switch
                break;
            case 8: // ������û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G058ApprovalFinishCurriculumSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G057ApprovalCurriculumSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.C.C02Curri.C02CurriDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G057ApprovalIngCurriculumSV";
                        break;
                } // end switch
                break;
            case 9: // ���ؽ�û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G021ApprovalFinishDisasterSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G020ApprovalDisasterSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E19Disaster.E19CongraDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G020ApprovalIngDisasterSV";
                        break;
                } // end switch
                break;
            case 10: // �޿�����  ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G023ApprovalFinishBankSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G022ApprovalBankSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A14Bank.A14BankDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G022ApprovalIngBankSV";
                        break;
                } // end switch
                break;
            case 11: // �Ƿ�� ��û (�����)
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G008ApprovalFinishHospitalSV";
                    break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G006ApprovalHospitalGlobalSV";
                    break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.Global.E17Hospital.E17HospitalDetailSV";
                    break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G007ApprovalIngHospitalSV";
                    break;
                } // end switch
                break;
            case 12: // �����ڱ� �űԽ�û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G054ApprovalFinishHouseSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G052ApprovalHouseSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E05House.E05HouseDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G053ApprovalIngHouseSV";
                        break;
                } // end switch
                break;
            case 13: // �����ڱ� ��ȯ
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G063ApprovalFinishRehouseSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G061ApprovalRehouseSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E06Rehouse.E06RehouseDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G062ApprovalIngRehouseSV";
                        break;
                } // end switch
                break;
            case 14: // �ڰݸ��� ���
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G025ApprovalFinishLicenceSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G024ApprovalLicenceSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A17Licence.A17LicenceDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G024ApprovalIngLicenceSV";
                        break;
                } // end switch
                break;
            case 16: // ������ ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G027ApprovalFinishCertiSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G026ApprovalCertiSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A15Certi.A15CertiDetailSV";
                        break;
                } // end switch
                break;
            case 17: // �ʰ��ٹ�(OT/Ư��) ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G029ApprovalFinishOTSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G028ApprovalOTSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D01OT.D01OTDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G028ApprovalIngOTSV";
                        break;
                } // end switch
                break;
            case 18: // �ް� ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G056ApprovalFinishVacationSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G055ApprovalVacationSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D03Vocation.D03VocationDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G055ApprovalIngVacationSV";
                        break;
                } // end switch
                break;
            case 19: // ������ ����
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G031ApprovalFinishInfojoinSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G030ApprovalInfojoinSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E25Infojoin.E25InfoDetailSV";
                        break;
                } // end switch
                break;
            case 20: // �ǰ� ���� �� �ξ��� ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G038ApprovalFinishMedicareSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G037ApprovalMedicareSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E01Medicare.E01MedicareDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G037ApprovalIngMedicareSV";
                        break;
                } // end switch
                break;
            case 21: // �ǰ� ���� ��߱� ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G040ApprovalFinishMedicareSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G039ApprovalMedicareSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E02Medicare.E02MedicareDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G039ApprovalIngMedicareSV";
                        break;
                } // end switch
                break;
            case 22: //���ο��� �ڰ� ����
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G042ApprovalFinishPensionChngSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G041ApprovalPensionChngSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E04Pension.E04PensionChngDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G041ApprovalIngPensionChngSV";
                        break;
                } // end switch
                break;
            case 23: // �ı�/������� �Ĵ�
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G045ApprovalFinishMealChargeSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G043ApprovalMealChargeSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.G.G045ApprovalFinishMealChargeSV";//"hris.G.G044ApprovalIngMealChargeSV";
                        break;
                } // end switch
                break;
            case 24: // ���� ����
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G048ApprovalFinishAllowanceSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G046ApprovalAllowanceSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A12Family.A12AllowanceDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G047ApprovalIngAllowanceSV";
                        break;
                } // end switch
                break;
            case 26: // ���� ���� ����
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G036ApprovalFinishAnnulmentSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G034ApprovalAnnulmentSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E11Personal.E11AnuulmentDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G035ApprovalIngAnnulmentSV";
                        break;
                } // end switch
                break;
            case 27: // ������ Ż��
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G033ApprovalFinishInfoSecessionSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G032ApprovalInfoSecessionSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E26InfoState.E26InfosecessionDetailSV";
                        break;
                } // end switch
                break;
            case 28: // ��õ¡��������
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G060ApprovalFinishDeductSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G059ApprovalDeductSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A18Deduct.A18DeductDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G059ApprovalIngDeductSV";
                        break;
                } // end switch
                break;
            case 29: // ���� ���� ���
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G051ApprovalFinishAllowanceCancelSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G049ApprovalAllowanceCancelSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A12Family.A12AllowanceCancelDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G050ApprovalIngAllowanceCancelSV";
                        break;
                } // end switch
                break;
            case 34: // ��� ���� ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G065ApprovalFinishCareerSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G064ApprovalCareerSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A19Career.A19CareerDetailSV";
                        break;
                } // end switch
                break;
            case 35: // �������� ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G070ApprovalFinishEduTripSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G068ApprovalEduTripSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D19EduTrip.D19EduTripDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G069ApprovalIngEduTripSV";
                        break;
                } // end switch
                break;
            case 36: // �μ����ϱ��� ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G067ApprovalFinishRotationSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G066ApprovalRotationSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D12Rotation.D12RotationDetailSV";
                        break;
                } // end switch
                break;

            case 50: // ��������/���ݻ���ں���
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G068ApprovalFinishRetireBusinessSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G069ApprovalRetireBusinessSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E03Retire.E03RetireBusinessDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G070ApprovalIngRetireBusinessSV";
                        break;
                } // end switch
                break;
            case 51: // ��������/���ݽ�û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G077ApprovalFinishRetireRegistSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G078ApprovalRetireRegistSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E03Retire.E03RetireRegistDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G079ApprovalIngRetireRegistSV";
                        break;
                } // end switch
                break;
            case 52: // ��������/������ȯ
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G074ApprovalFinishRetireTransSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G075ApprovalRetireTransSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E03Retire.E03RetireTransDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G076ApprovalIngRetireTransSV";
                        break;
                } // end switch
                break;
            case 53: // ��������/�ߵ�����
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G071ApprovalFinishRetireMidOutSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G072ApprovalRetireMidOutSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E03Retire.E03RetireMidOutDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G073ApprovalIngRetireMidOutSV";
                        break;
                } // end switch
                break;
            case 37: // ������û��ҽ�û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G080ApprovalFinishEventCancelSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G080ApprovalEventCancelSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G080ApprovalIngEventCancelSV";
                        break;
                } // end switch
                break;

            case 39: //�߰��ϰ���(7����)
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.E.E38Cancer.E38CancerDetailSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.E.E38Cancer.E38CancerDetailSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E38Cancer.E38CancerDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.E.E38Cancer.E38CancerDetailSV";
                        break;
                } // end switch
                break;

            case 38: // ������û��ҽ�û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G080ApprovalFinishEventCancelSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G080ApprovalEventCancelSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G080ApprovalIngEventCancelSV";
                        break;
                } // end switch
                break;

            case 40: // �ʰ��ٹ���ҽ�û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G086ApprovalFinishOTCancelSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G084ApprovalOTCancelSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D01OT.D01OTCancelChangeSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G085ApprovalIngOTCancelSV";
                        break;
                } // end switch
                break;

            case 41: // �ް���ҽ�û
                switch (type) {

                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G083ApprovalFinishVacationCancelSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G081ApprovalVacationCancelSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D03Vocation.D03VocationCancelChangeSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G082ApprovalIngVacationCancelSV";
                } // end switch
                break;
            // [CSR ID:3438118] flexible time �ý��� ��û
            case 42: //Flextime
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G056ApprovalFinishVacationSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G092ApprovalFlextimeSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D20Flextime.D20FlextimeDetailSV";
                        break;
                } // end switch
                break;

            case 44: //�ʰ��ٷ� ���Ľ�û [WorkTime52 PJT]
                switch (type) {
                case DocumentInfo.FINISH_APPROVAL:
                    targetPage = "hris.G.G029ApprovalFinishOTSV";
                    break;
                case DocumentInfo.MUST_APPROVAL:
                    targetPage = "hris.G.G028ApprovalOTAFSV";
                    break;
                case DocumentInfo.EDIT_DISABLE:
                case DocumentInfo.EDIT_ENABLE:
                    targetPage = "hris.D.D01OT.D01OTAfterWorkDetailSV";
                    break;
                case DocumentInfo.CANCEL_DISABLE:
                case DocumentInfo.CANCEL_ENABLE:
                    //targetPage = "hris.G.G028ApprovalIngOTSV";
                    break;
                } // end switch
                break;
        } // end switch

        if (targetPage == null || targetPage.equals("")) {
            detailPage = new StringBuffer(256);
        } else {
            detailPage.append(WebUtil.ServletURL);
            detailPage.append(targetPage);
            detailPage.append("?AINF_SEQN=");
            detailPage.append(AINF_SEQN);

            detailPage.append("&RequestPageName=");

            // �۾� �� �Ǵ� ����(��Ϻ���) ������ ����
            if (RequestPageName == null || RequestPageName.equals("")) {
                detailPage.append(WebUtil.ServletURL);
                switch (type) {
                    case DocumentInfo.MUST_APPROVAL:
                        detailPage.append("hris.G.G001ApprovalDocListSV");
                        break;
                    case DocumentInfo.FINISH_APPROVAL:
                        detailPage.append("hris.G.G003ApprovalFinishDocListSV");
                        break;
                    default:
                        detailPage.append("hris.G.G002ApprovalIngDocListSV");
                        break;
                } // end switch
            } else {
                detailPage.append(RequestPageName.replace('&', '|'));
            } // end if
        } // end if
        return detailPage.toString();
    }



    /**
     * �̸��� �Ǵ� ElOffic ���� ���翡�� e-HR�� ��� �� ��� �б� URL ���ϴ� �޼ҵ�
     * @param UPMU_TYPE
     * @param type
     * @param AINF_SEQN
     * @return
     */
    public static String makeGotoUrlGlobal(String UPMU_TYPE ,int type ,String AINF_SEQN ) {
        return makeGotoUrlGlobal(Integer.parseInt(UPMU_TYPE) ,type ,AINF_SEQN ,null);
    } // end makeGotoUrl

    public static String makeGotoUrlGlobal(String UPMU_TYPE ,int type ,String AINF_SEQN  ,String RequestPageName) {
        return makeGotoUrlGlobal(Integer.parseInt(UPMU_TYPE) ,type ,AINF_SEQN ,RequestPageName);
    } // end makeGotoUrl

    public static String makeGotoUrlGlobal(int UPMU_TYPE ,int type ,String AINF_SEQN ) {
        return makeGotoUrlGlobal(UPMU_TYPE ,type ,AINF_SEQN ,null);
    } // end makeGotoUrl

    /**
     * �̸��� �Ǵ� ElOffic ���� ���翡�� e-HR�� ��� �� ��� �б� URL ���ϴ� �޼ҵ�
     * @param UPMU_TYPE : ���� Ÿ��
     * @param type : ���� ����
     * @param AINF_SEQN : ���� ��ȣ
     * @param RequestPageName : ���� ������
     * @return
     */
    public static String makeGotoUrlGlobal(int UPMU_TYPE ,int type ,String AINF_SEQN ,String RequestPageName) {

        StringBuffer detailPage = new StringBuffer(256);
        String targetPage = "";

        Logger.debug.println("#####	[WebUtilEurp]	makeGotoUrl	1) UPMU_TYPE	:	[" + UPMU_TYPE + "]");
        Logger.debug.println("#####	[WebUtilEurp]	makeGotoUrl	2) type			:	[" + type + "]");
        Logger.debug.println("#####	[WebUtilEurp]	makeGotoUrl	3) AINF_SEQN	:	[" + AINF_SEQN + "]");
        Logger.debug.println("#####	[WebUtilEurp]	makeGotoUrl	4) RequestPageName	:	[" + RequestPageName + "]");

        switch (UPMU_TYPE) {
            case 1: // �ʰ��ٹ�(OT/Ư��) ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G029ApprovalFinishOTSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G028ApprovalOTSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D01OT.D01OTDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G028ApprovalIngOTSV";
                        break;
                } // end switch
                break;
            case 2: // �ް� ��û [Europe]
                //********************************************
            case 21:
            case 22:
            case 23:
            case 24:
                //********************************************
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
//                        targetPage = "hris.G.G056ApprovalFinishVacationEurpSV";
                        targetPage = "hris.G.G056ApprovalFinishVacationSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
//                        targetPage = "hris.G.G055ApprovalVacationEurpSV";
                        targetPage = "hris.G.G055ApprovalVacationSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D03Vocation.D03VocationDetailGlobalSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
//                        targetPage = "hris.G.G055ApprovalIngVacationEurpSV";
                        targetPage = "hris.G.G055ApprovalIngVacationSV";
                        break;
                } // end switch
                break;
            case 3: // �޿�����  ��û [Europe]
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G023ApprovalFinishBankEurpSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
//                        targetPage = "hris.G.G022ApprovalBankEurpSV";
                        targetPage = "hris.G.G022ApprovalBankSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A14Bank.A14BankDetailGlobalSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G022ApprovalIngBankEurpSV";
                        break;
                } // end switch
                break;
            case 4: // �ڰݸ��� ��� [Europe]
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G025ApprovalFinishLicenceSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G024ApprovalLicenceSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A17Licence.A17LicenceDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G024ApprovalIngLicenceSV";
                        break;
                } // end switch
                break;
            case 5: // ������ ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G027ApprovalFinishCertiSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G026ApprovalCertiSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A15Certi.A15CertiDetailSV";
                        break;
                } // end switch
                break;
            case 6:    // ������ ��û
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G005ApprovalFinishCongraSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G004ApprovalCongraGlobalSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.E19Congra.E19CongraDetailGlobalSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G004ApprovalIngCongraSV";
                        break;
                } // end switch
                break;
            case 7:    // ���� ��û
            case 8:
                switch (type) {

                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D19Duty.D19DutyDetailSV";
                        break;
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G068ApprovalFinishDutySV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G067ApprovalDutySV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G067ApprovalIngDutySV";
                        break;

                } // end switch
                break;
            case 11: // �Ƿ�� ��û (�����)
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G008ApprovalFinishHospitalSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G006ApprovalHospitalGlobalSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.Global.E17Hospital.E17HospitalDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G007ApprovalIngHospitalSV";
                        break;
                } // end switch
                break;
            case 12: // ���б�/���ڱ� ��û (�����)
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G017ApprovalFinishExpenseSV";
                    break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G015ApprovalExpenseGlobalSV";
                    break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.Global.E21Expense.E21ExpenseDetailSV";
                    break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G016ApprovalIngExpenseSV";
                    break;
                } // end switch
                break;
            case 13: // ���������� ��û  (�����)
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G066ApprovalFinishLanguageSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G066ApprovalLanguageSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.E.Global.E23Language.E23LanguageDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "";
                        break;
                } // end switch
                break;
            case 14: // Address [Europe - Germany]
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G070ApprovalFinishAddressDeSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G069ApprovalAddressSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.A.A13Address.A13AddressApprovalDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G069ApprovalIngAddressDeSV";
                        break;
                } // end switch
                break;
            case 15: // Time Sheet [USA - LGCPI(G400)]
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G072ApprovalFinishTimeSheetUsaSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G072ApprovalTimeSheetUsaSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D07TimeSheet.D07TimeSheetDetailUsaSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G072ApprovalIngTimeSheetUsaSV";
                        break;
                } // end switch
                break;
            case 16: // Contract Extension [USA]
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.G.G071ApprovalFinishContractExtensionSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G071ApprovalContractExtensionSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D09ContractExtension.D09ContractExtensionDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.G.G071ApprovalIngContractExtensionSV";
                        break;
                } // end switch
                break;
            case 17: // emppay
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.D.D15EmpPayInfo.D15EmpPayDetailSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G090ApprovalEmpPaySV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D15EmpPayInfo.D15EmpPayDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.D.D15EmpPayInfo.D15EmpPayDetailSV";
                        break;
                } // end switch
                break;
            case 18: // membership fee
                switch (type) {
                    case DocumentInfo.FINISH_APPROVAL:
                        targetPage = "hris.D.D30MembershipFee.D30MembershipFeeDetailSV";
                        break;
                    case DocumentInfo.MUST_APPROVAL:
                        targetPage = "hris.G.G091ApprovalMembershipFeeSV";
                        break;
                    case DocumentInfo.EDIT_DISABLE:
                    case DocumentInfo.EDIT_ENABLE:
                        targetPage = "hris.D.D30MembershipFee.D30MembershipFeeDetailSV";
                        break;
                    case DocumentInfo.CANCEL_DISABLE:
                    case DocumentInfo.CANCEL_ENABLE:
                        targetPage = "hris.D.D30MembershipFee.D30MembershipFeeDetailSV";
                        break;
                } // end switch
                break;

        } // end switch


        if (targetPage == null || targetPage.equals("")) {
            detailPage = new StringBuffer(256);
        } else {
            detailPage.append(ServletURL);
            detailPage.append(targetPage);
            detailPage.append("?AINF_SEQN=");
            detailPage.append(AINF_SEQN);
            detailPage.append("&RequestPageName=");

            // �۾� �� �Ǵ� ����(��Ϻ���) ������ ����
            if (RequestPageName == null || RequestPageName.equals("")) {
                detailPage.append(ServletURL);
                switch (type) {
                    case DocumentInfo.MUST_APPROVAL:
                        detailPage.append("hris.G.G001ApprovalDocListSV");
                        break;
                    case DocumentInfo.FINISH_APPROVAL:
                        detailPage.append("hris.G.G003ApprovalFinishDocListSV");
                        break;
                    default:
                        detailPage.append("hris.G.G002ApprovalIngDocListSV");
                        break;
                } // end switch
            } else {
                detailPage.append(RequestPageName.replace('&','|'));
            } // end if
        } // end if
        return detailPage.toString();
    }
    /*
     function viewDetail(UPMU_TYPE, AINF_SEQN)
     {
     alert("�̻�Ÿ");
     alert(document);
     document.form2.AINF_SEQN.value = AINF_SEQN;
     document.form2.RequestJspName.value = "";
     document.form2.jobid.value = "search";

     switch(UPMU_TYPE) {

     break;
     case "02":    // ���ο���
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E10Personal.E10PersonalDetailSV';
     break;

     break;
     case "04":    // ���հ���
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E15General.E15GeneralDetailSV';
     break;
     case "05":    // �������ϱ�
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E21Entrance.E21EntranceDetailSV';
     break;
     case "06":    // ���ڱ�/���б�
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E21Expense.E21ExpenseDetailSV';
     break;
     case "07":    // ��������(�ξ簡�� ��û)
     document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A12Family.A12SupportDetailSV';
     break;
     case "08":    // ����������û
     document.form2.action = '<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriDetailSV';

     break;
     case "09":    // ���ؽ�û
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19CongraDetailSV';
     break;
     case "10":    // �޿�����
     document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A14Bank.A14BankDetailSV';
     break;
     case "11":    // ���ǰ���
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E12Stock.E12StockDetailSV';
     break;
     case "12":    // �����ڱݽ�û
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E05House.E05HouseDetailSV';
     break;
     case "13":    // �����ڱݻ�ȯ
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E06Rehouse.E06RehouseDetailSV';
     break;
     case "14":    // �ڰݻ���
     document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A17Licence.A17LicenceDetailSV';
     break;
     case "15":    // ���а���
     document.form2.action = '';
     break;
     case "16":    // ��������
     document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A15Certi.A15CertiDetailSV';
     break;
     case "17":    // �ʰ��ٹ���û
     document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D01OT.D01OTDetailSV';
     break;
     case "18":    // �ް���û
     document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D03Vocation.D03VocationDetailSV';
     break;
     case "19":    // ������
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E25Infojoin.E25InfoDetailSV';
     break;
     case "20":    // �ǰ����� �Ǻξ���
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E01Medicare.E01MedicareDetailSV';
     break;
     case "21":    // �ǰ������� ������� ����/��߱�
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E02Medicare.E02MedicareDetailSV';
     break;
     case "22":    // ���ο��� �ڰݺ���
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E04Pension.E04PensionChngDetailSV';
     break;
     case "24":    // ��������
     document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A12Family.A12AllowanceDetailSV';
     break;
     case "26":    // ���ο����ؾ�
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E11Personal.E11AnuulmentDetailSV';
     break;
     case "27":    // ������ Ż��
     document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E26InfoState.E26InfosecessionDetailSV';
     break;
     case "28":    // �ٷμҵ� ��õ¡�� ������ �� ���ټ�
     document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A18Deduct.A18DeductDetailSV';
     break;
     case "29":    // ����������
     document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A12Family.A12AllowanceCancelDetailSV';
     break;
     case "30":    // �ξ簡�� ����(����)
     document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A12Family.A12SupportCancelDetailSV';
     break;
     case "31":    // LG����ȭ��-�������� ��û
     document.form2.action = '<%= WebUtil.ServletURL %>hris.C.C07Language.C07LanguageDetailSV';
     break;
     case "32":    // LG����ȭ��-������ �ް���û
     document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D07Maternity.D07MaternityDetailSV';
     break;
     defalut:
     document.form2.action = "<%= WebUtil.JspURL %>view.jsp"
     }
     document.form2.target = "main_ess";
     document.form2.submit();
     }
     */
    public static String startDatePrint(String str1, String str2, String str3, String str4) throws Exception {

        String[] aDate = new String[4];
        String tData = new String();
        int i = 0;
        aDate[0] = "";
        if (!"0000-00-00".equals(str1) && str1 != "") {
            aDate[i] = new String();
            aDate[i] = str1;
            i++;
        }
        if (!"0000-00-00".equals(str2) && str2 != "") {
            aDate[i] = new String();
            aDate[i] = str2;
            i++;
        }
        if (!"0000-00-00".equals(str3) && str3 != "") {
            aDate[i] = new String();
            aDate[i] = str3;
            i++;
        }
        if (!"0000-00-00".equals(str4) && str4 != "") {
            aDate[i] = new String();
            aDate[i] = str4;
            i++;
        }

        for (i = 1; i < aDate.length; i++) {
            if (aDate[i] != null && aDate[i] != "" && aDate[0].compareTo(aDate[i]) > 0) {
                tData = aDate[i];
                aDate[i] = aDate[0];
                aDate[0] = tData;
            }

        }

        Logger.debug.println("aDate[0]:" + aDate[0] + "str1:" + str1 + "str2:" + str2 + "str3:" + str3 + "str4:" + str4);

        return aDate[0];
    }

    public static String endDatePrint(String str1, String str2, String str3, String str4) {

        String tDate = "";
        if (str1.equals("0000-00-00"))
            str1 = "";
        if (str2.equals("0000-00-00"))
            str2 = "";
        if (str3.equals("0000-00-00"))
            str3 = "";
        if (str4.equals("0000-00-00"))
            str4 = "";

        if ((str1).compareTo(str2) > 0) {
            tDate = str1;

        } else {
            tDate = str2;
        }

        if (tDate.compareTo(str3) < 0) {
            tDate = str3;
        }

        if (tDate.compareTo(str4) < 0) {
            tDate = str4;
        }

        return tDate;
    }


    public static String replace(String str, String o_str, String n_str) throws Exception {
        String rv = new String(str);
        str = nvl(str);
        int fromIdx = 0;
        int toIdx = rv.length();
        int pointIdx = 0;
        int skip_len = o_str.length();
        int skip_len2 = n_str.length();

        try {
            while ((fromIdx < toIdx) && ((pointIdx = rv.indexOf(o_str, fromIdx)) > -1)) {
                rv = rv.substring(0, pointIdx) + n_str + rv.substring(pointIdx + skip_len);
                fromIdx = skip_len2 + pointIdx;
                toIdx = rv.length();
            }
        } catch (Exception e) {
        }
        return rv;
    }

    public static String printNumFormatSap(String num, int i) { //G20Ecmt��õ¡���������������
        return printNumFormat(num, i, DEFAULT_DECIMALSIZE);
    }

    public static String printNumFormat(String num, int i, int decimalSize) { //G20Ecmt��õ¡���������������
        double _num = Double.parseDouble(num);
        return printNumFormat(_num * i, decimalSize);
    }

    public static WebUserData getSessionUser(HttpServletRequest request) {
        return (WebUserData) request.getSession().getAttribute("user");
    }

    public static WebUserData getSessionMSSUser(HttpServletRequest request) {
        WebUserData mssUser = (WebUserData) request.getSession().getAttribute("user_m");

        if(mssUser == null) mssUser = getSessionUser(request);

        return mssUser;
    }

    public static boolean isLocal(HttpServletRequest request) {
        return "localhost".equalsIgnoreCase(request.getServerName()) || "127.0.0.1".equals(request.getServerName()) || request.getServerName().indexOf("local") > -1;
    }

    public static boolean isDev(HttpServletRequest request) {
        return WebUtil.isLocal(request) || StringUtils.indexOfIgnoreCase(request.getServerName(), "dev") > -1;
    }

    /**
     * �븮��û�� �����ȸ
     *  @������ ���� �߰� 2015-08-19
     *  �븮��û ������ �ִ� ��� �߰�
     * @param request
     * @return
     */
    public static String getRepresentative(HttpServletRequest request) {

        WebUserData user   = getSessionUser(request);

        String pernr = request.getParameter("PERNR") ;

        if (StringUtils.isEmpty(pernr) || !"Y".equals(user.e_representative)) pernr = user.empNo;

        return pernr;
    }

    public static String toDateString(String str){
        return str.replaceAll("-",	"");
    }

    /**
     * str���� ���� �ƴ� ��� suffix �߰� �ؼ� ����
     * @param str
     * @param suffix
     * @return
     */
    public static String appendSuffix(String str, String suffix) {
        if(StringUtils.isNotEmpty(str)) return str + suffix;
        return str;
    }

    /**
     * �ֹι�ȣ masking
     * @param regNo
     * @param mask
     * @return
     */
    public static String printRegNo(String regNo, String mask) {
        if("FULL".equals(mask)) return "******-*******";
        else if("LAST".equals(mask)) return StringUtils.substring(regNo, 0, 6) + "-*******";
        else return StringUtils.substring(regNo, 0, 6) + "-" + StringUtils.substring(regNo, 6);
    }

    /**
     * tr��  ¦�� row �� ��� class �߰�
     * @param n
     * @return
     */
    public static String printOddRow(int n) {
        return n % 2 == 0 ? "oddRow" : "";
    }

    /**
     * <p>���� ���ڿ����� Ư�� ���ڸ� ������.</p>
     *
     * @return   	����� ���ڿ�.
     */
    public static String deleteStr(String source, String depStr) {

        int spot = source.length()-1;
        String returnString;
        String origSource = new String(source);

        spot = source.indexOf(depStr);
        if (spot > -1)
            returnString = "" ;
        else
            returnString = source;
        while (spot > -1) {
            if (spot == source.length()+1) {
                returnString =
                        returnString.concat(
                                source.substring(0, source.length() - 1));
                source = "";
            } else if (spot > 0) {
                returnString =
                        returnString.concat(
                                source.substring(0, spot));
                source =
                        source.substring(spot+depStr.length(), source.length());
            } else {
                source =
                        source.substring(spot+depStr.length(), source.length());
            }
            spot = source.indexOf(depStr);
        }
        if (!source.equals(origSource)) {
            return returnString.concat(source);
        } else {
            return returnString;
        }
    }

	public static double getAgeFromBirthday(String yyyy,String mm) {
		Double year = Double.parseDouble(DataUtil.getCurrentYear())- Integer.parseInt(yyyy);
		Double month = Double.parseDouble(DataUtil.getCurrentMonth()) - Integer.parseInt(mm);
		Double result = 0.00;
		Double calcMonth = 0.00;
		if(month != 0.0){
			calcMonth = month/12;
			calcMonth = DataUtil.banolim(calcMonth,2);
		}
		result = year + calcMonth;
	    return result;
	}

    /**
     * <p>���� ���ڿ��� ������ �������� ���ڿ��� ����.</p>
     * ex) insertStr("1234567890","/","3-3-4")   ==>   return 123-456-7890
     * USA Telephone Number Format
     *
     *
     * @return   	����� ���ڿ�.
     */
    public static String insertStr(String orgStr, String insStr, String format) {

        if (StringUtils.isBlank(orgStr)) return "";

        String convStr = "";
        StringTokenizer st = new StringTokenizer(format, "-");

        // ��� ������ ��� ���� �ѱ�
        boolean isallSpace = true;
        for (int i=0 ; i<orgStr.length(); i++) {
            if (orgStr.charAt(i) != ' ') {
                isallSpace = false;
                break;
            }
        }
        if (isallSpace) return orgStr;

        int i = 0;
        try {
            while (st.hasMoreTokens()) {
                int j = Integer.parseInt(st.nextToken());
                convStr += orgStr.substring(i, i+j);
                i += j;
                if (st.hasMoreTokens()) convStr += insStr;
            }
        } catch (Exception e) {
            Logger.error(e);
        }

        return convStr;
    }

    public static String getEncryptKey(HttpServletRequest request) {
        //��ȣȭ �߰�
        HttpSession session = request.getSession();
        String AESKEY = (String)session.getAttribute("AESKEY");

        //[CSR ID:3038270] ���� ���ؼ� ���� �� Ű�� ��������.
        if(StringUtils.isBlank(AESKEY)){
            AESKEY = AESgenerUtil.getKey();
            session.setAttribute("AESKEY", AESKEY);
        }

        return AESKEY;
    }

    /**
     * ��ȭ���·� ����
     * @param currency
     * @param defaultValue
     * @return
     */
    public static String convertCurrency(String currency, String defaultValue) {
        double curr = NumberUtils.toDouble(currency);
        NumberFormat df = DecimalFormat.getInstance();

        String returnVal = StringUtils.defaultString(defaultValue);
        if(curr != 0) returnVal = df.format(curr);

        return returnVal;
    }

    public static String convertCurrencyDecimal(String currency, String defaultValue) {
        float curr = NumberUtils.toFloat(currency);
        DecimalFormat df = new DecimalFormat("#,###.00");

        String returnVal = StringUtils.defaultString(defaultValue);
        if(curr != 0) returnVal = df.format(curr);

        return returnVal;
    }

    /**
     * <p>���ڿ��� ���� �����ڷ� ���� �� �迭������ ��ȯ. (join�� �ݴ��� ����� ��)</p>
     *
     * @param s   ��� ���ڿ�.
     * @param  delimiter  ������.
     * @return   ���ڿ� ��ū�迭.
     */
    public final static String[] split(String s, String delimiter) {

        Vector v = new Vector();
        StringTokenizer st = new StringTokenizer(s, delimiter);
        while(st.hasMoreTokens())
            v.addElement(st.nextToken());

        String array[] = new String[v.size()];
        v.copyInto(array);

        return(array);
    }

    /**
     *
     * @param optionList
     * @param fieldName
     * @param findValue
     * @return
     */
    public static Object findOption(Collection optionList, String fieldName, String findValue) {
        if(Utils.getSize(optionList) == 0 ) return null;

        for(Object o : optionList) {
            Object value = Utils.getFieldValue(o, fieldName);
            if(findValue == null && value == null) {
                return o;
            } else {
                if(findValue.equals(value)) return o;
            }
        }

        return null;
    }

    public static Map<String, Object> uploadFile(HttpServletRequest request) throws Exception {
        Map<String, Object> resultMap = new HashedMap();

        boolean isMultipart = ServletFileUpload.isMultipartContent(request);

        if(!isMultipart) {
            throw new Exception("Form type is not multipart");
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setRepository(Files.createTempDir());
        factory.setSizeThreshold(MEMORY_THRESHOLD);

        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setHeaderEncoding("UTF-8");

        List<FileItem> items = upload.parseRequest(request);

        for(FileItem item:items) {
            String fieldName = item.getFieldName();

            if (item.isFormField()) { // processFormField
                resultMap.put(fieldName, item.getString());
            } else {
                if( item.getSize() > 0) resultMap.put(fieldName, item);
            }

            Logger.debug("==== upload file [" + fieldName + "] " + item);
        }

        return resultMap;
    }

    public static void setLang(HttpServletRequest req, WebUserData user) {
        //locale setting
        String lang = req.getParameter("lang");
        if(StringUtils.isBlank(lang)) lang = req.getParameter("lan");

        // [WorkTime52] G-Portal popup link�� ���� �Ǳٹ��ð� �Է����� ���Խ� �� ������� �ʴ� ���� �ذ��� ���� �߰�
        if(StringUtils.isBlank(lang)) {
            lang = (String) req.getSession().getAttribute("hrpLang");
            if(StringUtils.isBlank(lang)){
                lang = getLangFromCookie(req);
            }
        }

        if("ch".equals(lang)) lang = "zh";  //hr ��Ż�� �߱��� ǥ�� ch -> ǥ�� zh �� ����

        setLang(lang, req, user);
    }

    public static void setLang(String lang, HttpServletRequest req, WebUserData user) {
        Logger.debug("---------- setLang : " + lang);
        //locale setting
        if(StringUtils.isBlank(lang)) {
            if(user.area == Area.KR) lang = Locale.KOREAN.toString();
            else if(Arrays.asList(Area.CN, Area.HK, Area.TW).contains(user.area)) lang = Locale.CHINESE.toString();
            else lang = Locale.ENGLISH.toString();
        }
        Logger.debug("---------- before SessionLocaleResolver : " + lang + ", Locale :" + org.springframework.util.StringUtils.parseLocaleString(lang));
        WebUtils.setSessionAttribute(req, SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME,
                org.springframework.util.StringUtils.parseLocaleString(lang));
    }

    /**
     * ��Ű���� lang ���� ������
     * @param req
     * @return
     */
    public static String getLangFromCookie(HttpServletRequest req) {
        /* ��� ���� */
        String lang = null;
        Cookie[] cookies = req.getCookies();

        if(cookies != null) {
            for(Cookie cookie : cookies) {
                if("language".equals(cookie.getName())) {
                    lang = cookie.getValue();
                    break;
                }
            }
        }

        if("ch".equals(lang)) lang = "zh";
        return lang;
    }

    /**
     *  [WorkTime52] �ʰ��ٹ��� �ϰ����� ���ϰ� ����.2018-05-31
     */
    public static boolean isMultiApproval(SAPType sapType, String UPMU_TYPE, String APPU_TYPE, String APPR_SEQN) {
        if(sapType == null || StringUtils.isBlank(UPMU_TYPE)) return false;

        Logger.debug("sapType.isLocal() : " + sapType.isLocal() + " UPMU_TYPE : " + UPMU_TYPE);
        if(sapType.isLocal()) {
            //17:�ʰ��ٹ�,18:�ް�, 23:�ıǿ������
        	//[WorkTime52] �ʰ��ٹ��� �ϰ����� ���ϰ� ����.2018-05-31
            //if ("17".equals(UPMU_TYPE) || "18".equals(UPMU_TYPE) || "23".equals(UPMU_TYPE)) {
        	if ("18".equals(UPMU_TYPE) || "23".equals(UPMU_TYPE)) {
                return true;
            } else if ("02".equals(APPU_TYPE) && "02".equals(APPR_SEQN)) {
                //} else if ( !apl.UPMU_TYPE.equals("03")  && apl.APPU_TYPE.equals("02") && apl.APPR_SEQN.equals("02")) { //03:�Ƿ��� ���������ѵ��ݾ�üũ�ϹǷ� �ϰ����� ����
                return true;
            } // end if
        } else {
            /*
01		Overtime						ZHR0045T		O
021	Absence Application		ZHR0046T		O
022	Absence Application		ZHR0046T		O
023	Absence Application		ZHR0046T		O
05		Internal Certificate		ZHR0036T		O
07		Duty Allowance			ZHR0150T		O
08		Duty Allowance_Day Duty		ZHR0150T		O
14		Address						ZHR0234T		O
             */
            if ("01".equals(UPMU_TYPE) || "021".equals(UPMU_TYPE) || "022".equals(UPMU_TYPE) || "023".equals(UPMU_TYPE)
                    || "05".equals(UPMU_TYPE) || "07".equals(UPMU_TYPE)
                    || "08".equals(UPMU_TYPE) || "14".equals(UPMU_TYPE)) return true;
        }

        return false;

    }

    public static String encodeURL(String url) {
        try {
            return URLEncoder.encode(url, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            Logger.error(e);
        }

        return url;
    }

    /**
     * ���� URL�� ������ ���� method
     * @param docInfo
     * @param AINF_SEQN
     * @return
     */
    public static String approvalMappingURL(DocumentInfo docInfo, String AINF_SEQN, String RequestPageName) {
        /*public final static int FINISH_APPROVAL     = 1;     // ���� �Ϸ� ����
        public final static int MUST_APPROVAL       = 2;     // ���� �ؾ��� ����

        public final static int EDIT_ENABLE         = 3;     // ���� ������ ���� ,���� ���� ���� ����
        public final static int EDIT_DISABLE        = 4;     // ���� ������ ���� ,���� ���� �Ұ� ����

        public final static int CANCEL_ENABLE       = 5;     // ���� ������ ���� ,���� ��� ���� ����
        public final static int CANCEL_DISABLE      = 6;     // ���� ������ ���� ,���� ��� �Ұ� ����*/
        String param = "?UPMU_TYPE=" + docInfo.getUPMU_TYPE() + "&AINF_SEQN=" + AINF_SEQN + "&external=true";
        if(StringUtils.isNotBlank(RequestPageName)) param += "&RequestPageName=" + RequestPageName.replace('&', '|');

        String url =  ServletURL + "hris.G.G003ApprovalFinishDetailSV";
        if(DocumentInfo.MUST_APPROVAL == docInfo.getType()) url = ServletURL +  "hris.G.G000ApprovalDetailSV";
        else if(DocumentInfo.EDIT_ENABLE == docInfo.getType() || DocumentInfo.EDIT_DISABLE == docInfo.getType()
                || DocumentInfo.CANCEL_ENABLE == docInfo.getType() || DocumentInfo.CANCEL_DISABLE == docInfo.getType()) url = ServletURL + "hris.G.G002ApprovalIngDetailSV";

        return url + param;
    }

    public static SAPType getSAPTypeFormApproval(String AINF_SEQN) {

        if("7".equals(StringUtils.substring(AINF_SEQN, 0, 1))) {
            return SAPType.GLOBAL;
        }

        return SAPType.LOCAL;

    }

    /**
     * [WorkTime52] ������ �߰�
     *
     * request�� �Ӽ� �ϰ� ����
     *
     * @param request
     * @param attributes
     */
    public static void setAttributes(HttpServletRequest request, Map<String, Object> attributes) {

        if (MapUtils.isEmpty(attributes)) return;

        for (String key : attributes.keySet()) {
            request.setAttribute(key, attributes.get(key));
        }
    }

    /**
     * @param value XX:YY
     * @return XX�ð� YY�� (LABEL.D.D25.N7001, LABEL.COMMON.0039)
     */
    public static String humanize(Object value, String hours, String minutes) {

        String time = ObjectUtils.toString(value).trim();
        if ("".equals(time.replaceAll("[:0]", ""))) {
            time = "-";
        }
        if ("-".equals(time)) {
            return time;
        }

        Global g = Utils.getBean("global");

        String[] r = time.split(":");
        return new StringBuilder()
            .append(r.length > 0 ? (StringUtils.isNumeric(r[0]) && Integer.parseInt(r[0]) == 0 ? "" : r[0] + StringUtils.defaultIfEmpty(hours, g.getMessage("LABEL.D.D25.N7001"))) : "")
            .append(r.length > 1 ? (StringUtils.isNumeric(r[1]) && Integer.parseInt(r[1]) == 0 ? "" : " " + r[1] + StringUtils.defaultIfEmpty(minutes, g.getMessage("LABEL.COMMON.0039"))) : "")
            .toString()
            .trim()
            .replaceAll("^\\-", "&Delta; ")
            .replaceAll("\\((.*)\\)(.+)$", "$2 ($1)")
            .replaceAll("\\s00" + StringUtils.defaultIfEmpty(minutes, g.getMessage("LABEL.COMMON.0039")), "");
    }

    public static void main(String args[]) {

        try {
            Logger.debug(WebUtil.nvl(".06"));
        } catch (Exception e) {
            // TODO Auto-generated catch block
            Logger.error(e);
        }

    }

}