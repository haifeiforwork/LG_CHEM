/********************************************************************************/
/*   System Name  : 
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : AjaxResultMap.java
/*   Description  : 
/*   Note         : 
/*   Creation     : 
/*   Update       : [WorkTime52] 2018-05-04 유정우
/********************************************************************************/

package com.common;

import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by many7 on 2016-04-12.
 */
@SuppressWarnings("serial")
public class AjaxResultMap extends HashMap<String, Object> {

    public static final String CODE = "code";
    public static final String MESSAGE = "message";
    public static final String ERROR = "error";

    public AjaxResultMap() {
        put(AjaxResultMap.CODE, "success");
    }

    private AjaxResultMap(String code, String messsage) {
        this();
        put(AjaxResultMap.CODE, code);
        put(AjaxResultMap.MESSAGE, messsage);
    }

    public Map<String, Object> addResult(String key, Object value) {
        put(key, value);
        return this;
    }

    /**
     * [WorkTime52] 유정우 추가
     * 
     * @param data
     * @return
     */
    public AjaxResultMap addResult(Map<String, Object> data) {
        putAll(data);
        return this;
    }

    public static AjaxResultMap getInstance() {
        return new AjaxResultMap();
    }

    public static AjaxResultMap getInstance(String code, String messsage) {
        return new AjaxResultMap(code, messsage);
    }

    public AjaxResultMap setErrorMessage(String messsage) {
        setCode(AjaxResultMap.ERROR);
        setMesssage(messsage);
        return this;
    }

    public void writeJson(HttpServletResponse response) throws Exception {
        JsonUtils.writeJson(this, response);
    }

    public String getCode() {
        return String.valueOf(get(AjaxResultMap.CODE));
    }

    public void setCode(String code) {
        put(AjaxResultMap.CODE, code);
    }

    public String getMesssage() {
        return String.valueOf(get(AjaxResultMap.MESSAGE));
    }

    public void setMesssage(String messsage) {
        put(AjaxResultMap.MESSAGE, messsage);
    }

}