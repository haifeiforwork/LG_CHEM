/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 이월종합검진                                                    */
/*   Program Name : 이월종합검진 조회                                               */
/*   Program ID   : E13CyGeneralDetailSV                                          */
/*   Description  : 신청된 이월종합검진을 조회 및 삭제할 수 있도록 하는 Class       */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  이형석                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E13CyGeneral;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.db.*;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.*;
import hris.E.E15General.E15GeneralData;
import hris.E.E15General.rfc.*;
import hris.A.A16Appl.*;
import hris.A.A16Appl.rfc.*;

public class E13CyGeneralDetailSV extends ApprovalBaseServlet {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private String UPMU_TYPE ="04";    // 결재 업무타입(종합검진)
    private String UPMU_NAME = "종합검진";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
        	HttpSession session = req.getSession(false);
			final WebUserData user = (WebUserData) session.getAttribute("user");

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");
			String PERNR =  box.get("PERNR", user.empNo); //getPERNR(box, user); //신청대상자 사번
			String AINF_SEQN = box.get("AINF_SEQN");

            A16ApplListKey key = new A16ApplListKey();
            Vector A16ApplListData_vt = new Vector();

            E15GeneralListRFC  rfc       = new E15GeneralListRFC();
            Vector E15General_vt  = null;

            E15General_vt = rfc.getGeneralList( PERNR, AINF_SEQN );

            E15GeneralData E15GeneralData = (E15GeneralData)E15General_vt.get(0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(E15GeneralData.PERNR);

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.

                Logger.debug.println(this, "E15General_vt : " + E15General_vt.toString());

                key.I_BEGDA     = "19000101";
                key.I_ENDDA     = "99991231";
                key.I_PERNR     = E15GeneralData.PERNR;
                key.I_STAT_TYPE = "";
                key.I_UPMU_TYPE = "04";

                A16ApplListRFC func = new A16ApplListRFC();
                A16ApplListData_vt = func.getAppList(key);
				String STAT_TYPE = "";
				for( int i = 0 ; i < A16ApplListData_vt.size(); i++ ) {
					A16ApplListData data = (A16ApplListData)A16ApplListData_vt.get(i);
					if(data.AINF_SEQN.equals(AINF_SEQN)){
						STAT_TYPE = data.STAT_TYPE;
					}
				}

				//  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분
                String ThisJspName = box.get("ThisJspName");
                //String STAT_TYPE = box.get("STAT_TYPE");
                Logger.debug.println(this,"/////////////////////////STAT_TYPE///////////////"+STAT_TYPE);
                req.setAttribute("STAT_TYPE", STAT_TYPE);
                req.setAttribute("ThisJspName", ThisJspName);
                //  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("E15General_vt"   , E15General_vt);

                printJspPage(req, res, WebUtil.JspURL + "E/E13CyGeneral/E13CyGeneralDetail.jsp");

            } else if( jobid.equals("delete") ) {

            	String dest = "";

                    rfc.delete(PERNR, AINF_SEQN );
                    printJspPage(req, res, dest);


            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }



        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }
}
