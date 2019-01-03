package com.sns.jdf.servlet;

import com.common.Global;
import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.util.WebUtil;
import org.apache.commons.lang.StringUtils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@SuppressWarnings("serial")
public abstract class JDFBaseServlet extends HttpServlet {

    protected static String lineSeparator  = System.getProperty("line.separator");

	/**
	 * BaseServlet constructor comment.
	 */
	public JDFBaseServlet() {
		super();
	}

	/**
	 * Performs the HTTP GET operation; the default implementation
	 * reports an HTTP BAD_REQUEST error.  Overriding this method to
	 * support the GET operation also automatically supports the HEAD
	 * operation.  (HEAD is a GET that returns no body in the response;
	 * it just returns the request HEADer fields.)
	 *
	 * <p>Servlet writers who override this method should read any data
	 * from the request, set entity headers in the response, access the
	 * writer or output stream, and, finally, write any response data.
	 * The headers that are set should include content type, and
	 * encoding.  If a writer is to be used to write response data, the
	 * content type must be set before the writer is accessed.  In
	 * general, the servlet implementor must write the headers before
	 * the response data because the headers can be flushed at any time
	 * after the data starts to be written.
	 *
	 * <p>Setting content length allows the servlet to take advantage
	 * of HTTP "connection keep alive".  If content length can not be
	 * set in advance, the performance penalties associated with not
	 * using keep alives will sometimes be avoided if the response
	 * entity fits in an internal buffer.
	 *
	 * <p>Entity data written for a HEAD request is ignored.  Servlet
	 * writers can, as a simple performance optimization, omit writing
	 * response data for HEAD methods.  If no response data is to be
	 * written, then the content length field must be set explicitly.
	 *
	 * <P>The GET operation is expected to be safe: without any side
	 * effects for which users might be held responsible.  For example,
	 * most form queries have no side effects.  Requests intended to
	 * change stored data should use some other HTTP method.  (There
	 * have been cases of significant security breaches reported
	 * because web-based applications used GET inappropriately.)
	 *
	 * <P> The GET operation is also expected to be idempotent: it can
	 * safely be repeated.  This is not quite the same as being safe,
	 * but in some common examples the requirements have the same
	 * result.  For example, repeating queries is both safe and
	 * idempotent (unless payment is required!), but buying something
	 * or modifying data is neither safe nor idempotent.
	 *
	 * @param req HttpServletRequest that encapsulates the request to
	 * the servlet
	 * @param res HttpServletResponse that encapsulates the response
	 * from the servlet
	 *
	 * @exception IOException if detected when handling the request
	 * @exception ServletException if the request could not be handled
	 *
	 * @see javax.servlet.ServletResponse#setContentType
	 */
	protected void doGet(HttpServletRequest req, HttpServletResponse res)
		throws ServletException, IOException
	{
		performBasePreTask(req, res);
	}

	/**
	 *
	 * Performs the HTTP POST operation; the default implementation
	 * reports an HTTP BAD_REQUEST error.  Servlet writers who override
	 * this method should read any data from the request (for example,
	 * form parameters), set entity headers in the response, access the
	 * writer or output stream and, finally, write any response data
	 * using the servlet output stream.  The headers that are set
	 * should include content type, and encoding.  If a writer is to be
	 * used to write response data, the content type must be set before
	 * the writer is accessed.  In general, the servlet implementor
	 * must write the headers before the response data because the
	 * headers can be flushed at any time after the data starts to be
	 * written.
	 *
	 * <p>If HTTP/1.1 chunked encoding is used (that is, if the
	 * transfer-encoding header is present), then the content-length
	 * header should not be set.  For HTTP/1.1 communications that do
	 * not use chunked encoding and HTTP 1.0 communications, setting
	 * content length allows the servlet to take advantage of HTTP
	 * "connection keep alive".  For just such communications, if
	 * content length can not be set, the performance penalties
	 * associated with not using keep alives will sometimes be avoided
	 * if the response entity fits in an internal buffer.
	 *
	 * <P> This method does not need to be either "safe" or
	 * "idempotent".  Operations requested through POST can have side
	 * effects for which the user can be held accountable.  Specific
	 * examples including updating stored data or buying things online.
	 *
	 * @param req HttpServletRequest that encapsulates the request to
	 * the servlet
	 * @param res HttpServletResponse that encapsulates the response
	 * from the servlet
	 *
	 * @exception IOException if detected when handling the request
	 * @exception ServletException if the request could not be handled
	 *
	 * @see javax.servlet.ServletResponse#setContentType
	 */
	protected void doPost (HttpServletRequest req, HttpServletResponse res)
		throws ServletException, IOException
	{
		performBasePreTask(req, res);
	}

	/**
	 *
	 * @param req HttpServletRequest
	 * @param res HttpServletResponse
	 */
	protected void performBasePreTask (HttpServletRequest req, HttpServletResponse res)
		throws ServletException, IOException
	{
		boolean trace = false;
        long start = 0, end = 0;
        String logMsg = null;

		try {
			Config conf = new Configuration();
			trace = conf.getBoolean("com.sns.jdf.servlet.baseservlet.trace");

            if ( trace ) {
                logMsg = req.getRequestURI() + " " + req.getRemoteHost() + "(" + req.getRemoteAddr() + ")";
                String user = req.getRemoteUser();
                if ( user != null ) logMsg += " " + user;

                start = System.currentTimeMillis();
                Logger.sys.println(this, logMsg + " calling");
            }

			performPreTask(req, res);
		}catch(ConfigurationException e){
            printExceptionPage(req, res, e);
        }catch(GeneralException e){
            Logger.err.println(this, "Exception StackTrace : "+e.getStackTrace());
            printExceptionPage(req, res, e);
		}

		if ( trace ) {
			end = System.currentTimeMillis();
			Logger.sys.println(this, logMsg + " end(elapsed= " + (end-start) + " )" + lineSeparator);
		}
	}

	/**
	 *
	 * @param req HttpServletRequest
	 * @param res HttpServletResponse
	 */
	protected abstract void performPreTask (HttpServletRequest req, HttpServletResponse res) throws GeneralException;
    protected abstract void printExceptionPage (HttpServletRequest req, HttpServletResponse res, Exception e);
	/**
	* Sends a temporary redirect response to the client using the
	* specified redirect location URL.  The URL must be absolute (for
	* example, <code><em>https://hostname/path/file.html</em></code>).
	* Relative URLs are not permitted here.
	*
	* @param req javax.servlet.http.HttpServletRequest
	* @param res javax.servlet.http.HttpServletResponse
	* @param location the redirect location URL
	* @exception IOException If an I/O error has occurred.
	*/
	protected void printHtmlPage (HttpServletRequest req, HttpServletResponse res, String location) throws Exception {
		try {
			res.sendRedirect(location);
		}
		catch (Exception e) {
            Logger.debug.println(this, "HTML page 오류");
			throw new GeneralException(e, "", "HTML page 오류");
		}
	}

	/**
	* Sends a temporary redirect response to the client using the
	* specified redirect location of jsp file.  The URL must be absolute (for
	* example, <code><em>/example/result.jsp</em></code>).
	* Relative URLs are not permitted here.
	*
	* @param req javax.servlet.http.HttpServletRequest
	* @param res javax.servlet.http.HttpServletResponse
	* @param jspfile the redirect location URL of jsp file.
	*/
	protected void printJspPage (HttpServletRequest req, HttpServletResponse res, String jspfile) throws GeneralException
	{
		try {
			RequestDispatcher dispatcher = getServletContext().getRequestDispatcher( jspfile );
			dispatcher.forward(req, res);
		}
		catch (Exception e) {
			Logger.error(e);
            Logger.debug.println(this, "JSP page 오류");
			throw new GeneralException(e, "", "JSP page 오류");
		}
	}

	/**
	 * 로그인 사용자의 권한 조합이 E가 아닌지 확인
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws GeneralException
	 */
	protected boolean checkAuthorization(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		if (WebUtil.getSessionUser(request).e_authorization.equals("E")) {
			Logger.debug.println(this, "E Authorization!!");
			request.setAttribute("msg", "msg015");
			printJspPage(request, response, WebUtil.JspURL+"common/caution.jsp");
			return false;
		}
		return true;
	}

	protected boolean checkTimeAuthorization(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		if (!WebUtil.getSessionUser(request).e_timeadmin.equals("Y")) {
			Logger.debug.println(this, "Not TimeAdmin Authorization!!");
			request.setAttribute("msg", "msg015");
			printJspPage(request, response, WebUtil.JspURL+"common/caution.jsp");
			return false;
		}
		return true;
	}
	protected Global g = Utils.getBean("global");

	protected void redirect(HttpServletResponse response, String redirectPage) throws GeneralException {
		if(StringUtils.indexOf(redirectPage, WebUtil.contextPath) < 0)
			redirectPage = WebUtil.contextPath + redirectPage;
		try {
			response.sendRedirect(redirectPage);
		} catch (IOException e) {
			throw new GeneralException(e);
		}
	}

/*
	protected void redirect(HttpServletResponse response, String redirectPage, String param, String value, String ... paris) throws Exception {
		if(StringUtils.indexOf(redirectPage, WebUtil.contextPath) < 0)
			redirectPage = WebUtil.contextPath + redirectPage;

		StringBuffer sb = new StringBuffer(redirectPage);

		sb.append("?").append(param).append("=").append(value);

		for(int n = 0; n < paris.length; n+=2) {
			sb.append("&").append(paris[n]).append("=").append(paris[n+1]);
		}

		redirect(response, sb.toString());
	}*/
}
