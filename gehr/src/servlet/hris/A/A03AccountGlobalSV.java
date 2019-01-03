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
/*   Update       : 2016-09-13 ksc A03AccountDetailEurpSV과 통합 					      */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.A.rfc.A03AccountDetailRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;


public class A03AccountGlobalSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            Box box = WebUtil.getBox(req);

            String dest  = "";
            String PERNR;

            PERNR =  getPERNR(box, user); //box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            // 대리 신청 추가
//            PhoneNumRFC  numfunc = new PhoneNumRFC();
//            PhoneNumData phonenumdata;
//            phonenumdata = (PhoneNumData)numfunc.getPhoneNum(PERNR);
//            req.setAttribute("PhoneNumData" , phonenumdata ); 

            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // 대리 신청 추가
            PersonInfoRFC func = new PersonInfoRFC();
            PersonData personData;
            personData = (PersonData)func.getPersonInfo(PERNR);
            
            A03AccountDetailRFC func1 = new A03AccountDetailRFC();
            Vector a03AccountDetail1Data_vt = func1.getAccountDetail(PERNR);  // 급여계좌
            
            Logger.debug.println(this, "급여계좌 : "+ a03AccountDetail1Data_vt.toString());
//            Logger.debug.println(this, "phonenumdata : "+ phonenumdata.toString());

            req.setAttribute("PersonData" , personData ); // SearchDeptPersion.jsp에서 접근을위해 국내와 통일함(ksc) PersonData
            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("a03AccountDetail1Data_vt", a03AccountDetail1Data_vt);

            if (false && user.area.equals(Area.PL)){
            	dest = WebUtil.JspURL+"A/A03AccountDetail_PL.jsp";
            }else{
            	dest = WebUtil.JspURL+"A/A03AccountDetail_Global.jsp";
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
