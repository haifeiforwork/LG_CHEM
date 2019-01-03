/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항 추가입력                                           */
/*   Program Name : 가족사항 추가입력                                           */
/*   Program ID   : A12FamilyBuild01SV                                          */
/*   Description  : 가족사항 신청을 조회할 수 있도록 하는 Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-28  김도신                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A12Family;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.PersonInfoRFC;
import hris.A.A12Family.A12FamilyListData;
import hris.A.A12Family.rfc.*;

public class A12FamilyBuild01SV extends EHRBaseServlet {

    //private String UPMU_TYPE ="12";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            String subty = "";
            String objps = "";
            String PERNR;

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            subty = box.get("SUBTY");
            objps = box.get("OBJPS");
            String screen = box.get("SCREEN");
            
            Vector  a12FamilyListData_vt = new Vector();
   
            if( jobid.equals("") ){
                jobid = "first";
            }
            if( screen.equals("") ){
            	screen = "A12";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            

           
            
            /******************************
             * 
             * @$ 웹보안진단 marco257
             * 대리신청 권한체크 추가
             * user.e_representative;
             * 
             ******************************/
            //대리신청 권한이 있는 사람 추가
            PERNR = WebUtil.nvl(box.get("PERNR"));
            String reSabunCk = user.e_representative;
            if (PERNR.equals("") || !reSabunCk.equals("Y")) {
                PERNR = user.empNo;
            } // end if

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
            req.setAttribute("PhoneNumData2" , phonenumdata );

            if( jobid.equals("first") ) {              // 제일처음 조회 화면에 들어온경우.
              
                a12FamilyListData_vt = (new A12FamilyListRFC()).getFamilyList(PERNR, subty, objps);
                
                Logger.debug.println(this, a12FamilyListData_vt.toString());

                req.setAttribute("SCREEN" , screen );
                req.setAttribute("a12FamilyListData_vt", a12FamilyListData_vt);
                dest = WebUtil.JspURL+"A/A12Family/A12FamilyBuild01.jsp";
                            
            } else if( jobid.equals("del_first") ) {    // 가족사항 리스트화면에서 삭제버튼 클릭..
              
                a12FamilyListData_vt = (new A12FamilyListRFC()).getFamilyList(PERNR, subty, objps);
                
                Logger.debug.println(this, "삭제할 데이터 : " + a12FamilyListData_vt.toString());
                
                req.setAttribute("a12FamilyListData_vt", a12FamilyListData_vt);
                dest = WebUtil.JspURL+"A/A12Family/A12FamilyDelete.jsp";
                            
            } else if( jobid.equals("delete") ) {   

                A12FamilyListRFC   rfc                  = new A12FamilyListRFC();
                A12FamilyListData  a12FamilyListData    = new A12FamilyListData();
                                
                // 주소 입력
                box.copyToEntity(a12FamilyListData);
                a12FamilyListData.PERNR  = PERNR;                                     // 사번
                a12FamilyListData.REGNO  = DataUtil.removeSeparate(box.get("REGNO"));   // 주민등록번호

                a12FamilyListData_vt.addElement(a12FamilyListData);
                
                Logger.debug.println(this, "가족사항 삭제 데이터 : " + a12FamilyListData_vt.toString());

                // 수정 RFC Call
                rfc.delete(PERNR, subty, objps, a12FamilyListData_vt);

                String msg = "msg003";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A04FamilyDetailSV?PERNR="+PERNR+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
                
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
	}

}