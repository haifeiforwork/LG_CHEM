package	servlet.hris.A.A16Appl;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A16Appl.A16ApplListKey;
import hris.A.A16Appl.rfc.A16ApplListRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * ApplListSV.java
 * 결재정보를 jsp로 넘겨주는 class 
 * jobid가 first일 경우는 AppListKey의 값을 ApplList.jsp로 넘겨주고,
 * jobid가 search 일경우는 결재정보 List 를 가져오는 ApplListRFC를 호출하여 ApplList.jsp로 결재정보를 넘겨준다.
 *
 * @author 김성일   
 * @version 1.0, 2001/12/13
 */
public class A16ApplListSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            String page  = "";

            A16ApplListKey key = new A16ApplListKey();
            Vector A16ApplListData_vt = new Vector();

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            page  = box.get("page");

            if( jobid.equals("") ) {
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            if( jobid.equals("first") ){
//                key.BEGDA     = DataUtil.getCurrentDate();
//              2002.05.21. default세팅 : 신청일 --> 현재날짜를 기준으로 일주일을 세팅.
//                                        list  --> 일주일간의 신청건을 default로 뿌려주도록 한다.
                key.I_BEGDA     = DataUtil.getAfterDate(DataUtil.getCurrentDate(), -7);
                key.I_ENDDA     = DataUtil.getCurrentDate();
                key.I_PERNR     = user.empNo;
                key.I_STAT_TYPE = "";
                key.I_UPMU_TYPE = "";

                A16ApplListRFC func = new A16ApplListRFC();
                A16ApplListData_vt = func.getAppList(key);
            } else if( jobid.equals("search") ) {
                box.copyToEntity(key);
                key.I_PERNR     = user.empNo;
                A16ApplListRFC func = new A16ApplListRFC();
                A16ApplListData_vt = func.getAppList(key);
            }
            
            req.setAttribute("jobid",              jobid);
            req.setAttribute("page",               page);
            req.setAttribute("A16ApplListKey",     key);
            req.setAttribute("A16ApplListData_vt", A16ApplListData_vt);

            dest = WebUtil.JspURL+"A/A16Appl/A16ApplList.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
