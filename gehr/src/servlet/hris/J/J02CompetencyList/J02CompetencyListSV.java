package servlet.hris.J.J02CompetencyList;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.J.J02CompetencyList.rfc.J02CompetencyListRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * J02CompetencyListSV.java
 * Competency List를 조회한다. 
 *
 * @author 원도연
 * @version 1.0, 2003/05/14
 */
public class J02CompetencyListSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");
            Box                 box            = WebUtil.getBox(req);
            
            J02CompetencyListRFC rfc           = new J02CompetencyListRFC();

            Vector              j02Result_vt   = new Vector();
            String              i_gubun        = "";
            String              i_inx_s        = "";
            String              i_inx_e        = "";
            String              i_find         = ""; 
            String              paging         = "";           
            String              i_QKid         = "";
            String              dest           = "";
                        
            i_gubun  = box.get("I_GUBUN");
            i_inx_s  = box.get("I_INX_S");            
            i_inx_e  = box.get("I_INX_E");                        
            i_find   = box.get("I_FIND");           
            paging   = box.get("PAGING"); 
            
            if( i_gubun.equals("") ) {
                i_gubun = "1";
                i_inx_s = "가";
                i_inx_e = "나";

                j02Result_vt  = rfc.getDetail( i_gubun, i_inx_s, i_inx_e, i_find, i_QKid );

            } else if ( !i_gubun.equals("") ) {
                j02Result_vt  = rfc.getDetail( i_gubun, i_inx_s, i_inx_e, i_find, i_QKid );  

            }
    
            req.setAttribute("j02Result_vt",   j02Result_vt);
            req.setAttribute("i_gubun",        i_gubun);            
            req.setAttribute("i_inx_s",        i_inx_s);
            req.setAttribute("i_inx_e",        i_inx_e);            
            req.setAttribute("i_find",         i_find);            
            req.setAttribute("paging",         paging);
                                            
            dest = WebUtil.JspURL+"J/J02CompetencyList/J02CompetencyList.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
