/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 입학축하금                                                  */
/*   Program Name : 입학축하금 수정                                             */
/*   Program ID   : E21EntranceChangeSV                                         */
/*   Description  : 입학축하금을 수정할 수 있도록 하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E21Entrance;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A04FamilyDetailData;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.E.E21Entrance.E21EntranceData;
import hris.E.E21Entrance.rfc.E21EntranceDupCheckRFC;
import hris.E.E21Entrance.rfc.E21EntranceRFC;
import hris.common.*;
import hris.common.db.AppLineDB;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

public class E21EntranceChangeSV extends EHRBaseServlet {

    private String UPMU_TYPE ="05";    // 결재 업무타입(입학축하금)

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";
            String msgFLAG = "";
            String msgTEXT = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E21EntranceRFC   rfc       = new E21EntranceRFC();
            E21EntranceData  firstData = new E21EntranceData();

            Vector e21EntranceData_vt  = null;
            Vector AppLineData_vt      = null;
            String ainf_seqn           = box.get("AINF_SEQN");

            e21EntranceData_vt = rfc.getEntrance( "", ainf_seqn );
            Logger.debug.println(this, "e21EntranceData_vt : " + e21EntranceData_vt.toString());

            firstData = (E21EntranceData)e21EntranceData_vt.get(0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // 최종 돌아갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            if( jobid.equals("first") ) {     // 제일처음 신청 화면에 들어온경우.

                AppLineData_vt = new Vector();

                // 가족리스트(자녀)를 구성한다.
                A04FamilyDetailRFC  rfc_family = new A04FamilyDetailRFC();
                A04FamilyDetailData data       = new A04FamilyDetailData();

                Vector a04FamilyDetailData_vt = new Vector();
                box.put("I_PERNR", firstData.PERNR);
                Vector temp_vt                = rfc_family.getFamilyDetail(box) ;
                Vector e21EntranceDupCheck_vt = (new E21EntranceDupCheckRFC()).getCheckList( firstData.PERNR );

                for( int i = 0 ; i < temp_vt.size() ; i++ ) {
                    data = (A04FamilyDetailData)temp_vt.get(i);

                    if( data.SUBTY.equals("2") ) {
                        a04FamilyDetailData_vt.addElement(data);
                    }
                }
                // 가족리스트(자녀)를 구성한다.

                if( a04FamilyDetailData_vt.size() == 0 ) {  // 수정이기때문에 이 조건을 만족하기는 힘들겠다.
                    //String msg = "입학축하금을 신청할 자녀가 없습니다.";
                    msgFLAG = "C";
                    msgTEXT = "입학축하금을 신청할 자녀가 없습니다.";
                } 
                // 자녀리스트
                Logger.debug.println(this, "a04FamilyDetailData_vt : "+ a04FamilyDetailData_vt.toString());
                
                req.setAttribute("a04FamilyDetailData_vt", a04FamilyDetailData_vt);
                
                // 결재자리스트
                AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);
                
                req.setAttribute("e21EntranceData_vt",     e21EntranceData_vt);
                req.setAttribute("AppLineData_vt",         AppLineData_vt);
                req.setAttribute("e21EntranceDupCheck_vt", e21EntranceDupCheck_vt);
                
                dest = WebUtil.JspURL+"E/E21Entrance/E21EntranceChange.jsp";

            } else if( jobid.equals("change") ) {

                E21EntranceData e21EntranceData = new E21EntranceData();
                AppLineData_vt = new Vector();

                // 입학축하금 수정..
                e21EntranceData.AINF_SEQN = ainf_seqn;               // 결재정보 일련번호
                e21EntranceData.PERNR     = firstData.PERNR;         // 사원번호
                e21EntranceData.SUBF_TYPE = "1";                     // 입학축하금 신청구분 (1)
                e21EntranceData.BEGDA     = box.get("BEGDA");        // 신청일자
                e21EntranceData.FAMSA     = box.get("FAMSA");        // 가족레코드유형
                e21EntranceData.ATEXT     = box.get("ATEXT");        // 텍스트, 20문자
                e21EntranceData.LNMHG     = box.get("LNMHG");        // 성(한글)
                e21EntranceData.FNMHG     = box.get("FNMHG");        // 이름(한글)
                e21EntranceData.REGNO     = DataUtil.removeSeparate(box.get("REGNO"));    // 주민등록번호
                e21EntranceData.ACAD_CARE = box.get("ACAD_CARE");    // 학력
                e21EntranceData.STEXT     = box.get("STEXT");        // 학교유형테스트
                e21EntranceData.FASIN     = box.get("FASIN");        // 교육기관
                e21EntranceData.ZPERNR    = firstData.ZPERNR;        // 신청자 사번(대리신청, 본인 신청)
                e21EntranceData.UNAME     = user.empNo;              // 신청자 성명(대리신청, 본인 신청)
                e21EntranceData.AEDTM     = DataUtil.getCurrentDate();  // 변경일(현재날짜)
				e21EntranceData.PROP_YEAR = box.get("PROP_YEAR"); // 신청년도(입학년도)

                Logger.debug.println(this, e21EntranceData.toString());

                // 결재정보 저장..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // 같은 이름으로 여러행 받을때
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = firstData.PERNR;
                    appLine.APPL_BEGDA     = e21EntranceData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);

                String msg;
                String msg2 = null;

                if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {

                    // 기존 결재자 리스트
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                    appDB.change(AppLineData_vt);
                    rfc.change( firstData.PERNR, ainf_seqn , e21EntranceData );
                    con.commit();

                    msg = "msg002";

                    AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                    AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);

                    Logger.debug.println(this ,oldAppLine);
                    Logger.debug.println(this ,newAppLine);

                    if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

                        // 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
                        phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);

                        // 이메일 보내기
                        Properties ptMailBody = new Properties();
                        ptMailBody.setProperty("SServer",user.SServer);             // ElOffice 접속 서버
                        ptMailBody.setProperty("from_empNo" ,user.empNo);           // 멜 발송자 사번
                        ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);  // 멜 수신자 사번

                        ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);      // (피)신청자명
                        ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);      // (피)신청자 사번

                        ptMailBody.setProperty("UPMU_NAME" ,"입학축하금");          // 문서 이름
                        ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);             // 신청서 순번

                        // 멜 제목
                        StringBuffer sbSubject = new StringBuffer(512);

                        sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                        sbSubject.append( ptMailBody.getProperty("ename") + "님이 신청을 삭제하셨습니다.");
                        ptMailBody.setProperty("subject" ,sbSubject.toString());

                        ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                        MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
                        // 기존 결재자 멜 전송
                        if (!maTe.process()) {
                            msg2 = msg2 + " 삭제 " + maTe.getMessage();
                        } // end if

                        // 멜 제목
                        sbSubject = new StringBuffer(512);
                        sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                        sbSubject.append(ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");
                        
                        ptMailBody.setProperty("subject" ,sbSubject.toString());
                        ptMailBody.remove("FileName");
                        ptMailBody.setProperty("to_empNo" ,newAppLine.APPL_APPU_NUMB);

                        maTe = new MailSendToEloffic(ptMailBody);
                        // 신규 결재자 멜 전송
                        if (!maTe.process()) {
                            msg2 = msg2 +" \\n 신청 " + maTe.getMessage();
                        } // end if

//                      ElOffice 인터페이스
                        try {
                            DraftDocForEloffice ddfe = new DraftDocForEloffice();
                            ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);
                            Vector vcElofficInterfaceData = new Vector();
                            vcElofficInterfaceData.add(eof);

                            ElofficInterfaceData eofD = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                            vcElofficInterfaceData.add(eofD);
                            
                            req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                            dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                        } catch (Exception e) {
                            dest = WebUtil.JspURL+"common/msg.jsp";
                            msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                        } // end try
                    } else {
                        msg = "msg002";
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if
                } else {
                    msg = "msg005";
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if

                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E21Entrance.E21EntranceDetailSV?AINF_SEQN="+ainf_seqn+"" +
                "&RequestPageName=" + RequestPageName + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, "destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
    }
}
