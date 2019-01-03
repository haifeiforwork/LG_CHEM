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


import com.nhncorp.lucy.security.xss.XssSaxFilter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;


/**
 * Example filter that can be attached to either an individual servlet
 * or to a URL pattern.  This filter performs the following functions:
 * <ul>
 * <li>Attaches itself as a request attribute, under the attribute name
 *     defined by the value of the <code>attribute</code> initialization
 *     parameter.</li>
 * <li>Calculates the number of milliseconds required to perform the
 *     servlet processing required by this request, including any
 *     subsequently defined filters, and logs the result to the servlet
 *     context log for this application.
 * </ul>
 *
 * @author Craig McClanahan
 * @version $Id: ExampleFilter.java,v 1.1 2013/05/09 08:58:27 bbibbi Exp $
 */
/* kji 2015.01.28 웹취약성 보안 필터 추가 */
public final class AuthServletFilter implements Filter {


    // ----------------------------------------------------- Instance Variables


    /**
     * The request attribute name under which we store a reference to ourself.
     */
    private String attribute = null;


    /**
     * The filter configuration object we are associated with.  If this value
     * is null, this filter instance is not currently configured.
     */
    private FilterConfig filterConfig = null;


    // --------------------------------------------------------- Public Methods


    /**
     * Take this filter out of service.
     */
    public void destroy() {

        this.attribute = null;
        this.filterConfig = null;

    }


    /**
     * Time the processing that is performed by all subsequent filters in the
     * current filter stack, including the ultimately invoked servlet.
     *
     * @param request The servlet request we are processing
     * @param chain The filter chain we are processing
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet error occurs
     */
    public void doFilter(ServletRequest request, ServletResponse response,FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest)request;
        HttpSession httpsession = req.getSession();
        
        chain.doFilter(new XSSRequestWrapper(req), response); // 요청페이지 이동
        
    }


    /**
     * Place this filter into service.
     *
     * @param filterConfig The filter configuration object
     */
    public void init(FilterConfig filterConfig) throws ServletException {

	this.filterConfig = filterConfig;
        this.attribute = filterConfig.getInitParameter("attribute");

    }


    /**
     * Return a String representation of this object.
     */
    public String toString() {

	if (filterConfig == null)
	    return ("InvokerFilter()");
	StringBuffer sb = new StringBuffer("InvokerFilter(");
	sb.append(filterConfig);
	sb.append(")");
	return (sb.toString());

    }
    
    /* 원하는 내용은 요기만 추가하면됨 */
    public String cleanXSS(String value){
        if(value == null || "".equals(value)){
            return value;
        }

        try {
            XssSaxFilter filter = XssSaxFilter.getInstance();
            return filter.doFilter(value);
        } catch(Exception e) {
            value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
            value = value.replaceAll("\"", "&#34");
            value = value.replaceAll("/", "&#47");
        }
        return value;
    }    
}

