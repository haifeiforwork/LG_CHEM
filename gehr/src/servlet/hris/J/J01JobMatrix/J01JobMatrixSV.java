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
 * J01JobMatrixSV.java
 * Objective ID와 명을 넘겨받아서 JobMatrix를 조회한다. 
 *
 * @author  김도신
 * @version 1.0, 2003/02/12
 */
public class J01JobMatrixSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession       session          = req.getSession(false);
            WebUserData       user             = (WebUserData)session.getAttribute("user");
            
            Box               box              = WebUtil.getBox(req);

            J01LevelListRFC   rfc_Level        = new J01LevelListRFC();
            J01JobMatrixRFC   rfc_Matrix       = new J01JobMatrixRFC();

//          Header Stext RFC 선언
            J01HeaderStextRFC rfc_Stext        = new J01HeaderStextRFC();
            Vector            j01Stext_vt      = new Vector();

            Vector            ret              = new Vector();
            Vector            j01LevelList_vt  = new Vector();
            Vector            j01DgubunList_vt = new Vector();
            Vector            j01JobProfile_vt = new Vector();

            String            i_pernr          = "";
            String            i_sobid          = "";
            String            E_PER_INFO       = "";
            String            i_begda          = "";
            String            dest             = "";
            
            //i_pernr    = box.get("i_pernr"); 
            i_pernr    = user.empNo; // 2005/03/17 수정
            i_sobid    = box.get("i_sobid");
//          적용일자(조회기준일) 추가
            i_begda    = box.get("BEGDA");
            if( i_begda.equals("") || i_begda == null ) {
                i_begda = DataUtil.getCurrentDate();
            }

//          Header Stext 조회
            j01Stext_vt      = rfc_Stext.getDetail( i_sobid, "", i_pernr, i_begda );

//          Level List 조회(세로축)            
            j01LevelList_vt  = rfc_Level.getDetail( i_begda );

//          JobMatrix 조회
            ret              = rfc_Matrix.getDetail( i_pernr, i_sobid, i_begda );

            j01JobProfile_vt = (Vector)ret.get(0);
            j01DgubunList_vt = (Vector)ret.get(1);
            E_PER_INFO       = (String)ret.get(2);

//          Job Matrix 정보
            req.setAttribute("j01LevelList_vt",  j01LevelList_vt);
            req.setAttribute("j01DgubunList_vt", j01DgubunList_vt);
            req.setAttribute("j01JobProfile_vt", j01JobProfile_vt);
//          Header Stext 조회
            req.setAttribute("j01Stext_vt",      j01Stext_vt);
//          사원 성명, 직위
            req.setAttribute("E_PER_INFO",       E_PER_INFO);
//          사원번호, Objective ID
            req.setAttribute("i_sobid",          i_sobid);
            req.setAttribute("i_pernr",          i_pernr);
            req.setAttribute("i_begda",          i_begda);

            dest = WebUtil.JspURL+"J/J01JobMatrix/J01JobMatrix.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
