package servlet.hris.N.executive;

import java.io.*;
import java.sql.*;
import java.util.Arrays;

import javax.servlet.*;
import javax.servlet.http.*;
import java.lang.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.*;

/**
 * goExecutiveSV.java
 *  집행임원서약서 연결으로 연결 할 수 있도록 하는 Class
 *
 * @author 김은하
 * @version 1.0, 2017/09/07
 */


import javax.servlet.http.* ;
import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;
/**
 * ExecutiveSV
 * 집행임원인사관리규정
 * @author
 * @version 1.0
 * [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha
 */
public class ExecutiveSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

    	 try{

    		WebUserData user = WebUtil.getSessionUser(req);
    		Box box = WebUtil.getBox(req);
    		String jobid = box.get("jobid", "first");

 /*   		if(!Arrays.asList("00215019","00037466","00218588","00030041","00037567"
                    ,"00217852","00006882","00117332","00022778","00201234"
                    ,"00212710","00043713","00204291","00111090","00219561"
                    ,"00038096","00219341","00080798","00003913","00037916"
                    ,"00027108","00005487","00116534","00203593").contains(user.empNo)){
    			req.setAttribute("msg", "msg015");
    			printJspPage(req, res, WebUtil.JspURL+"common/caution.jsp");
    		}
 */

    		if (jobid.equals("first")) {
    			String dest = WebUtil.JspURL+"N/executive/executive.jsp";
    			Logger.debug.println(this, " destributed = " + dest);
    			printJspPage(req, res, dest);

    		}else if (jobid.equals("download")) {

    			try {
    				String filePath = "" ;
    				if(WebUtil.isLocal(req))  {
    					filePath = "C:/download/insarule_eloffice_Confidential.2016.pdf" ;
    				}else {
    					filePath = "/sorc001/gehr/download/insarule_eloffice_Confidential.2016.pdf" ;
    				}
    				File file = new File(filePath);
    				   if ( ! file.getAbsolutePath().equals(file.getCanonicalPath()) ){
   				    			req.setAttribute("msg", "File path and file name checking");
   				                req.setAttribute("url", "history.back();");
   				                printJspPage(req, res, WebUtil.JspURL+"common/msg.jsp");
    					}
    					res.setHeader("content-disposition", "attachment;fileName=" + "insarule_eloffice_Confidential.2016.pdf");
    					InputStream in = new FileInputStream(file);
    					OutputStream out = res.getOutputStream();
    					byte[] b = new byte[1024];
    					int len = -1;
    					while ((len = in.read(b)) != -1){
    						out.write(b, 0, len);
    					}
    					out.close();
    					in.close();
    				} catch (UnsupportedEncodingException e) {
    					throw new  GeneralException(e);
    				} catch (IOException e) {
    					throw new GeneralException(e);
    				} catch(Exception e) {
    		            throw new GeneralException(e);
    		        }
    		}
    	 }catch (GeneralException e) {
                req.setAttribute("msg", e.getMessage());
                req.setAttribute("url", "history.back();");
            } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
