package	servlet.hris.E.E25Infojoin;

import java.io.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.*;
import hris.E.E25Infojoin.*;
import hris.E.E25Infojoin.rfc.*;
import hris.E.E26InfoState.*;
import hris.E.E26InfoState.rfc.*;

/**
 * E25InfoSV.java
 * 인포멀에 가입신청에 대한 결과를 가져와 E26InfosecessionDetailSV로 넘겨주는Class
 *
 * @author 이형석   
 * @version 1.0, 2002/01/04
 */
public class E25InfoSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);
   
            Vector InfoListData_vt = null;
			Vector E26InfoStateData_vt = null;  

            InfoListData_vt = (new E25InfoJoinRFC()).getInfoJoin(user.empNo,  box.get("AINF_SEQN"));
			
            if(InfoListData_vt.size() == 0){
            
                 dest = WebUtil.ServletURL+"hris.E.E26InfoState.E26InfosecessionDetailSV?AINF_SEQN="+box.get("AINF_SEQN")+"&ThisJspName="+box.get("ThisJspName");
            
            } else {

                 dest = WebUtil.ServletURL+"hris.E.E25Infojoin.E25InfoDetailSV?AINF_SEQN="+box.get("AINF_SEQN")+"&ThisJspName="+box.get("ThisJspName");

            }
                       
            res.sendRedirect(dest);
            Logger.debug.println(this, " destributed = " + dest);
           
        
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
    }
}
