package servlet.hris.J.J02CompetencyList;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.J.J01JobMatrix.rfc.J01CompetencyDetailRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;
/**
 * J01CompetencyListDetailSV.java
 * CompetencyList Detail 상세내역을 조회한다. 
 *
 * @author 원도연
 * @version 1.0, 2003/05/16
 */
public class J02CompetencyListDetailSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");
            
            Box                 box            = WebUtil.getBox(req);

            J01CompetencyDetailRFC rfc            = new J01CompetencyDetailRFC();

            Vector              ret            = new Vector();
            Vector              j02Result_vt   = new Vector();
            Vector              j02Result_D_vt = new Vector();
            String              E_STEXT_Q      = "";
            String              i_sobid        = "";
            String              i_gubun        = "";
            String              i_inx_s        = "";
            String              i_inx_e        = "";
            String              i_find         = ""; 
            String              paging         = "";           
            String              dest           = "";
                        
            i_gubun  = box.get("I_GUBUN");
            i_inx_s  = box.get("I_INX_S");            
            i_inx_e  = box.get("I_INX_E");                        
            i_find   = box.get("I_FIND");           
            paging   = box.get("PAGING"); 
            i_sobid  = box.get("SOBID");            

            if( !i_sobid.equals("") ) {
//              적용일자(조회기준일)를 현재날짜로 넣어준다.
                ret            = rfc.getDetail( i_sobid, DataUtil.getCurrentDate() );
                j02Result_vt   = (Vector)ret.get(0);
                j02Result_D_vt = (Vector)ret.get(1);
                E_STEXT_Q      = (String)ret.get(2);                
            }
    
            req.setAttribute("j02Result_vt",   j02Result_vt);
            req.setAttribute("j02Result_D_vt", j02Result_D_vt);
            req.setAttribute("E_STEXT_Q",      E_STEXT_Q);                
            req.setAttribute("i_gubun",        i_gubun);            
            req.setAttribute("i_inx_s",        i_inx_s);
            req.setAttribute("i_inx_e",        i_inx_e);            
            req.setAttribute("i_find",         i_find);            
            req.setAttribute("paging",         paging);
                                
            dest = WebUtil.JspURL+"J/J02CompetencyList/J02CompetencyListDetail.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}