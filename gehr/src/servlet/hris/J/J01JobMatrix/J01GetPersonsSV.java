package servlet.hris.J.J01JobMatrix;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;

import hris.J.J01JobMatrix.*;
import hris.J.J01JobMatrix.rfc.*;

/**
 * J01GetPersonsSV.java
 * 팀장의 사원리스트를 조회한다. 해당하는 Objective에 해당하는 사원만 조회한다.
 *
 * @author  김도신
 * @version 1.0, 2003/04/23
 */
public class J01GetPersonsSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{

            HttpSession      session       = req.getSession(false);
            WebUserData      user          = (WebUserData)session.getAttribute("user");
            
            Box              box           = WebUtil.getBox(req);

            J01GetPersonsRFC rfc           = new J01GetPersonsRFC();

            Vector           j01Persons_vt = new Vector();

            String           i_objid       = "";
            String           gubun         = "";
            String           i_begda       = "";            
            String           dest          = "";
            
            i_objid  = box.get("i_objid");     //Objective ID
            gubun    = box.get("gubun");       //ESS Menu에서 넘어온 구분코드(Job Description 조회 = "R", Job Description 생성 = "C")
//          적용일자(조회기준일) 추가            
            i_begda  = box.get("BEGDA");            
            if( i_begda.equals("") || i_begda == null ) {
                i_begda = DataUtil.getCurrentDate();
            }
            j01Persons_vt = rfc.getDetail( user.empNo, i_objid, i_begda );

            req.setAttribute("j01Persons_vt", j01Persons_vt);
            req.setAttribute("i_objid",       i_objid      );
            req.setAttribute("gubun",         gubun        );
            req.setAttribute("i_begda",       i_begda      );                        

            dest = WebUtil.JspURL+"J/J01JobMatrix/J01GetPersons.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
