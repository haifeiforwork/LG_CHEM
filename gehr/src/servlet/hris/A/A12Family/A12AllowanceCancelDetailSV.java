/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 가족수당상실 신청 조회                                      */
/*   Program ID   : A12AllowanceCancelDetailSV                                  */
/*   Description  : 가족수당상실 신청에 대한 내용을 조회할 수 있도록 하는 Class */
/*   Note         :                                                             */
/*   Creation     : 2002-10-31  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A12Family;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.db.*;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.*;
import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.rfc.*;

public class A12AllowanceCancelDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="29";            // 결재 업무타입(가족수당상실)

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            A12FamilyAlloCancelRFC rfc    = new A12FamilyAlloCancelRFC();
            A12FamilyBuyangData firstData = new A12FamilyBuyangData();

            Vector a12FamilyBuyangData_vt = null;
            Vector AppLineData_vt         = null;
            String ainf_seqn              = box.get("AINF_SEQN");

            a12FamilyBuyangData_vt = rfc.getFamilyAlloCancel( ainf_seqn );
            Logger.debug.println(this, "가족수당상실 신청 조회 : " + a12FamilyBuyangData_vt.toString());

            firstData = (A12FamilyBuyangData)a12FamilyBuyangData_vt.get(0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // 최종 돌아갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            // XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분
            String ThisJspName = box.get("ThisJspName");
            req.setAttribute("ThisJspName", ThisJspName);
            //  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분

            if( jobid.equals("first") ) {

                AppLineData_vt = AppUtil.getAppDetailVt( ainf_seqn );

                req.setAttribute("a12FamilyBuyangData_vt", a12FamilyBuyangData_vt);
                req.setAttribute("AppLineData_vt", AppLineData_vt);

                dest = WebUtil.JspURL+"A/A12Family/A12AllowanceCancelDetail.jsp";

            } else if( jobid.equals("delete") ) {

                // 가족수당상실 신청 삭제
                AppLineData_vt = new Vector();
                String subty = box.get("SUBTY");
                String objps = box.get("OBJPS");

                // 결재정보 삭제..
                AppLineData  appLine   = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = firstData.PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = ainf_seqn;

                // 2002.07.25.---------------------------------------------------------------------------
                // 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                // 결재
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // 같은 이름으로 여러행 받을때
                    box.copyToEntity(app ,i);

                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
                // 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                // 2002.07.25.---------------------------------------------------------------------------

                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);

                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    rfc.delete( ainf_seqn );
                    con.commit();

                    // 신청건 삭제시 메일 보내기.
                    appLine = (AppLineData)AppLineData_vt.get(0);
                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);              // ElOffice 접속 서버
                    ptMailBody.setProperty("from_empNo" ,user.empNo);            // 멜 발송자 사번
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // 멜 수신자 사번

                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (피)신청자명
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (피)신청자 사번

                    ptMailBody.setProperty("UPMU_NAME" ,"가족수당상실");             // 문서 이름
                    ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);              // 신청서 순번
                    // 신청건 삭제시 메일 보내기.

                    // 멜 제목
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append( ptMailBody.getProperty("ename") + "님이 신청을 삭제하셨습니다.");
                    ptMailBody.setProperty("subject" ,sbSubject.toString());    // 멜 제목 설정

                    ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    String msg2 = null;
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(ainf_seqn ,user.SServer ,ptMailBody.getProperty("UPMU_NAME") 
                                ,firstData.PERNR ,appLine.APPL_APPU_NUMB);
                        
                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                    } // end try
                    
                    String msg = "msg003";
                    String url ;

                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.A.A04FamilyDetailSV';";
                    } // end if
                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A12Family.A12AllowanceCancelDetailSV?AINF_SEQN="+ainf_seqn+"&ThisJspName="+ThisJspName+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
    }
}