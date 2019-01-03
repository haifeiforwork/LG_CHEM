/********************************************************************************/
/*   System Name  : 
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : JsonUtils.java
/*   Description  : 
/*   Note         : 
/*   Creation     : 
/*   Update       : [WorkTime52] 2018-05-04 유정우
/********************************************************************************/

package com.common;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.Logger;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import net.sf.json.util.PropertyFilter;

/**
 * Created by manyjung on 2016-07-13.
 */
public class JsonUtils {

    /**
     * 객체를 response에 write
     * @param o
     * @param response
     * @throws Exception
     */
    public static void writeJson(Object o, HttpServletResponse response) throws Exception {
        response.setHeader("Access-Control-Allow-Origin","*");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        JSONSerializer.toJSON(o).write(out);
        out.flush();

    }

    public static String getJson(Object o, PropertyFilter filter) {

        JsonConfig jsonConfig = new JsonConfig();
        if(filter != null)  jsonConfig.setJsonPropertyFilter(filter);

        jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
        try {
            JSONObject jsonObject = JSONObject.fromObject(o, jsonConfig);
            return jsonObject.toString();
        } catch(Exception e) {
            Logger.error(e);
        }

        return null;
    }

    /**
     * [WorkTime52] 유정우 추가
     * 
     * @param o
     * @param clazz
     * @param map
     * @return
     */
    public static <T, K, V> T getObject(String o, Class<T> clazz) {

        return (T) JSONObject.toBean(JSONObject.fromObject(o), clazz);
    }

    /**
     * [WorkTime52] 유정우 추가
     * 
     * @param o
     * @param clazz
     * @param map
     * @return
     */
    public static <T, K, V> T getObject(String o, Class<T> clazz, Map<K, V> map) {

        return (T) JSONObject.toBean(JSONObject.fromObject(o), clazz, map);
    }

    /**
     * [WorkTime52] 유정우 추가
     * 
     * @param o
     * @param tableName
     * @return
     */
    @SuppressWarnings("serial")
    public static Map<String, List<Map<String, Object>>> getMap(String o, final String tableName) {

        return getObject(o, HashMap.class, new HashMap<String, Object>() {
            {
                put(tableName, HashMap.class);
            }
        });
    }

    /**
     * [WorkTime52] 유정우 추가
     * 
     * @param o
     * @param tableNames
     * @return
     */
    @SuppressWarnings("serial")
    public static Map<String, List<Map<String, Object>>> getMap(String o, final String[] tableNames) {

        return getObject(o, HashMap.class, new HashMap<String, Object>() {
            {
                for (String tableName : tableNames) {
                    put(tableName, HashMap.class);
                }
            }
        });
    }
}