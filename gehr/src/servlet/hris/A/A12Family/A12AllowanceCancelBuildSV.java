/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 가족수당상실을 신청                                         */
/*   Program ID   : A12AllowanceCancelBuildSV                                   */
/*   Description  : 가족수당상실을 신청할 수 있도록 하는 Class                  */
/*   Note         :                                                             */
/*   Creation     : 2002-10-31  김도신                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A.A12Family;
  
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
import hris.common.util.*;
import hris.common.rfc.*;
import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.rfc.*;

public class A12AllowanceCancelBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="29";   // 결재 업무타입(가족수당상실)
    private String UPMU_NAME = "가족수당상실";
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;
        
        try{
            HttpSession session = req.getSession(false); 
            
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest = "";
            String jobid = "";
            String subty = "";
            String objps = "";
            String PERNR;
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            subty = box.get("SUBTY");
            objps = box.get("OBJPS");
            
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            // XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분            
            String ThisJspName = box.get("ThisJspName");
            req.setAttribute("ThisJspName", ThisJspName);
            //  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분 
            
            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );
                
                A12FamilyListRFC  rfc_list             = new A12FamilyListRFC();
                Vector            a12FamilyListData_vt = null;
                Vector            AppLineData_vt       = null;
                
                // 가족수당상실 신청할 가족
                a12FamilyListData_vt = rfc_list.getFamilyList(PERNR, subty, objps);
                
                // 결재자리스트
                AppLineData_vt       = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                
                Logger.debug.println(this, "가족수당상실 신청 : " + a12FamilyListData_vt.toString());
                Logger.debug.println(this, "결재 : " + AppLineData_vt.toString());
                
                req.setAttribute("a12FamilyListData_vt", a12FamilyListData_vt);
                req.setAttribute("AppLineData_vt",  AppLineData_vt);
                
                dest = WebUtil.JspURL+"A/A12Family/A12AllowanceCancelBuild.jsp";
                
            } else if( jobid.equals("create") ) {       // 가족수당상실 신청
                
                NumberGetNextRFC       func                   = new NumberGetNextRFC();
                A12FamilyAlloCancelRFC rfc                    = new A12FamilyAlloCancelRFC();
                A12FamilyBuyangData    a12FamilyBuyangData    = new A12FamilyBuyangData();
                Vector                 a12FamilyBuyangData_vt = new Vector();
                Vector                 AppLineData_vt         = new Vector();
                String                 ainf_seqn              = func.getNumberGetNext();
                
                // 가족수당상실 신청
                box.copyToEntity(a12FamilyBuyangData);
                a12FamilyBuyangData.PERNR     = PERNR;
                a12FamilyBuyangData.AINF_SEQN = ainf_seqn;
                a12FamilyBuyangData.ZPERNR    = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                a12FamilyBuyangData.UNAME     = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                a12FamilyBuyangData.AEDTM     = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                a12FamilyBuyangData_vt.addElement(a12FamilyBuyangData);
                
                Logger.debug.println(this, "가족수당상실 신청 : " + a12FamilyBuyangData.toString());
                
                // 결재정보 저장..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);
                    
                    // 여러행 자료 입력(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = a12FamilyBuyangData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                    
                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());
                
                con = DBUtil.getTransaction();
                
                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build( ainf_seqn, a12FamilyBuyangData_vt );
                con.commit();
                
                // 메일 수신자 사람 ,
                AppLineData appLine = (AppLineData)AppLineData_vt.get(0);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);              // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);            // 멜 발송자 사번
                ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // 멜 수신자 사번

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (피)신청자명
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (피)신청자 사번

                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);              // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);
                // 신청서 순번

                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");
                
                ptMailBody.setProperty("subject" ,sbSubject.toString());

                MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);

                String msg = "msg001";;
                String msg2 = "";

                if (!maTe.process()) {
                    msg2 = maTe.getMessage();
                } // end if

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    
                    ElofficInterfaceData eof = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));

                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                } // end try
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A12Family.A12AllowanceCancelDetailSV?AINF_SEQN="+ainf_seqn+"&ThisJspName="+ThisJspName+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
                
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
