package servlet.hris.J.J03JobCreate;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.fileupload.*;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;

/**
 * J03FileUpLoadPopupSV.java
 * kesa ppt 파일을 업로드한다. 
 *
 * @author  원도연
 * @version 1.0, 2003/06/27
 */
public class J03PRCUpLoadPopupSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{           
            String              dest           = "";        
//          process ppt 파일을 업로드한다.             
	          J03PRCFileUpload multi = new J03PRCFileUpload(req, "");
            dest = WebUtil.JspURL+"J/J03JobCreate/J03UploadCheck.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);	          	    
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
