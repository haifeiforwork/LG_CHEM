/*
* Licensed to the Apache Software Foundation (ASF) under one or more
* contributor license agreements.  See the NOTICE file distributed with
* this work for additional information regarding copyright ownership.
* The ASF licenses this file to You under the Apache License, Version 2.0
* (the "License"); you may not use this file except in compliance with
* the License.  You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

package filters;


import com.nhncorp.lucy.security.xss.XssFilter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 * kji 2015.02.06 XSS 필터 추가
 */

public final class XSSRequestWrapper extends HttpServletRequestWrapper {

    public XSSRequestWrapper(HttpServletRequest httpServletRequest){
        
        super(httpServletRequest);
        //Logger.debug("XSSRequestWrapper");
    }

    /* 원하는 내용은 요기만 추가하면됨 */
    public String cleanXSS(String value){
        if(value == null || "".equals(value)){
            return value;
        }

        XssFilter filter = XssFilter.getInstance("resources/lucy-xss-superset.xml");
        return filter.doFilter(value);

        /*value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        //value = value.replaceAll("\"", "&#34");
        //value = value.replaceAll("/", "&#47");

        return value;*/
    }
    
    public String[] getParameterValues(String parameter){

        String[] values = super.getParameterValues(parameter);
        if(values == null){
            return null;
        }
        int count = values.length;
        String[] encodedValues = new String[count];
        for(int i = 0; i< count; i++){
            encodedValues[i] = cleanXSS(values[i]);
        }
        return encodedValues;
    }
    
    public String getQueryParameters(String queryParam){
        String values = super.getQueryString();
        return cleanXSS(values);
    }
    
    public String getParameter(String parameter){

        String value = super.getParameter(parameter);
        if(value == null){
            return null;
        }
        return cleanXSS(value);
    }
    
    public String getHeader(String name){

        String value = super.getHeader(name);
        if(value == null){
            return null;
        }
        return cleanXSS(value); 
    }
    
    @Override
    public Map<String,String[]> getParameterMap(){
        @SuppressWarnings("unchecked")
        Map<String,String[]> parameterMap = super.getParameterMap();
        Set<String> keySet = parameterMap.keySet();
        Iterator<String>  itrator = keySet.iterator();
        Map<String,String[]> cleanMap = new HashMap<String, String[]>();

        while(itrator.hasNext()){
            String key = itrator.next();
            String[] paramValues = parameterMap.get(key);
            if(paramValues == null){
                cleanMap.put(key, paramValues);
            } else{
                int count = paramValues.length;
                String[] encodedValues = new String[count];
                for (int i = 0; i < count; i++) {
                    encodedValues[i] = cleanXSS(paramValues[i]);
                }
                cleanMap.put(key, encodedValues);
            }
        }
        return cleanMap;
    }    
}

