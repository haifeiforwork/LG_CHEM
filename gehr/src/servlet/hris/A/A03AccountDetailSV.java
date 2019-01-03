/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 계좌 정보                                                   */
/*   Program Name : 계좌 정보                                                   */
/*   Program ID   : A03AccountDetailSV                                          */
/*   Description  : 계좌 정보를 조회할 수 있도록 하는 Class                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-07  김도신                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A;

import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.*;

import com.common.constant.Area;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.A.rfc.*;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;


public class A03AccountDetailSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");

            /**
             * Start: 국가별 분기처리 
             */
            String fdUrl = ".";
            
           if (!user.area.equals(Area.KR) ) {	// 한국
              
				printJspPage(req, res, WebUtil.ServletURL+ "hris.A.A03AccountGlobalSV"); // 나머지국가
				return;
			}

           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );
          

            /**
             * END: 국가별 분기처리 
             */
            
            Box box = WebUtil.getBox(req);
            String dest  = "";
            String PERNR;

            PERNR =  getPERNR(box, user); //box.get("PERNR");
            
//          @웹보안진단 20151124
            String reSabunCk = user.e_representative;
            if (PERNR.equals("") || !reSabunCk.equals("Y")) {
                PERNR = user.empNo;
            } // end if

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            A03AccountDetailRFC func1 = new A03AccountDetailRFC();
            Vector a03AccountDetail1Data_vt = func1.getAccountDetail(PERNR, "10");  // 급여계좌
            Vector a03AccountDetail2Data_vt = func1.getAccountDetail(PERNR, "08");  // 증권계좌
            Vector a03AccountDetail3Data_vt = func1.getAccountDetail(PERNR, "05");  // F/B개인계좌

            Logger.debug.println(this, "급여계좌 : "+ a03AccountDetail1Data_vt.toString());
            Logger.debug.println(this, "증권계좌 : "+ a03AccountDetail2Data_vt.toString());
            Logger.debug.println(this, "개인계좌 : "+ a03AccountDetail3Data_vt.toString());

            req.setAttribute("PersonData" , phonenumdata );
            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("a03AccountDetail1Data_vt", a03AccountDetail1Data_vt);
            req.setAttribute("a03AccountDetail2Data_vt", a03AccountDetail2Data_vt);
            req.setAttribute("a03AccountDetail3Data_vt", a03AccountDetail3Data_vt);

            dest = WebUtil.JspURL+"A/A03AccountDetail_KR.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
