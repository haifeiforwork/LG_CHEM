/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진                                                    */
/*   Program ID   : E15GeneralListSV                                            */
/*   Description  : 종합검진 상세일정을 조회할 수 있도록 하는 Class             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                     2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 */
/********************************************************************************/

package servlet.hris.E.E16Health;

import java.util.Vector;

import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.E.E16Health.rfc.*;
import hris.common.*;
import hris.common.rfc.PersonInfoRFC;

public class E16HealthCardSV extends EHRBaseServlet {

    private String UPMU_TYPE ="";            // 결재 업무타입(건강검진)

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

        try{
            HttpSession session = req.getSession(false);

            WebUserData user = WebUtil.getSessionUser(req);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String dest = "";
            String E_PRINT    ="";

            Box box = WebUtil.getBox(req);
            String jobid_m = box.get("jobid_m", "first");
            String year = box.get("YEAR");

            Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user] : "+user.toString());

            String PERNR  =user.empNo;
            //@$웹보안 -  권한체크 2015-08-17
            if (user.e_authorization2.indexOf("Y")>-1) {//종합검진신청_담당자승인 태스크
            	PERNR = user_m.empNo;
           	    E_PRINT ="Y";
            } // end if

            E16HealthRFC func = new E16HealthRFC();

            String currentData = DataUtil.getCurrentDate();
            if (year == null || year.equals("")) {
            	year = currentData.substring(0,4);
            } // end if

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);


            Vector ret = func.getDetail(PERNR,year,user.empNo);

            Vector e16Health9416Data_vt = new Vector();  // 검진이력
            Vector e16Health9419Data_vt = new Vector();  // 건강검진결과
            Vector e16Health9420Data_vt = new Vector();  // 건강검진 상담
            Vector e16Health9421Data_vt = new Vector();  // 가족력


            e16Health9416Data_vt = (Vector)ret.get(0);
            e16Health9419Data_vt = (Vector)ret.get(1);
            e16Health9420Data_vt = (Vector)ret.get(2);
            String E_ENAME    = (String)ret.get(3);
            String E_TITEL     = (String)ret.get(4);
            String E_REGNO    = (String)ret.get(5);
            String E_ORGEH    = (String)ret.get(6);
            String E_STEXT    = (String)ret.get(7);
            String E_DARDT    = (String)ret.get(8);
           // String E_PRINT    = (String)ret.get(9);
            String E_CENAME    = (String)ret.get(10);
            String E_HENAME    = (String)ret.get(11);
            e16Health9421Data_vt = (Vector)ret.get(12);
            String E_TITL2    = (String)ret.get(13); //[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건

            Logger.sap.println(this, "e16Health9419Data_vt : "+e16Health9419Data_vt.toString());
            if( jobid_m.equals("first")||jobid_m.equals("print") ) {           //제일처음 신청 화면에 들어온경우.
                req.setAttribute("PERNR", PERNR);
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("e16Health9416Data_vt", e16Health9416Data_vt);
                req.setAttribute("e16Health9419Data_vt",  e16Health9419Data_vt);
                req.setAttribute("e16Health9420Data_vt",  e16Health9420Data_vt);
                req.setAttribute("e16Health9421Data_vt",  e16Health9421Data_vt);
                req.setAttribute("E_ENAME",  E_ENAME);
                req.setAttribute("E_TITEL",   E_TITEL);
                req.setAttribute("E_REGNO",  E_REGNO);
                req.setAttribute("E_STEXT",  E_STEXT);
                req.setAttribute("E_DARDT",  E_DARDT);
                req.setAttribute("E_PRINT",  E_PRINT);
                req.setAttribute("E_CENAME",  E_CENAME);
                req.setAttribute("E_HENAME",  E_HENAME);
                req.setAttribute("YEAR",  year);
                req.setAttribute("jobid_m",  jobid_m);
                req.setAttribute("E_TITL2",  E_TITL2);
                if( jobid_m.equals("first")  ) {
                    dest = WebUtil.JspURL+"E/E16Health/E16HealthCard.jsp";
                }else if( jobid_m.equals("print")  ) {
                    dest = WebUtil.JspURL+"E/E16Health/E16HealthCardPrint.jsp";
                }

            }  else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //            DBUtil.close(con);
        }
    }
}

