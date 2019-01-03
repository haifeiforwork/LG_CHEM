/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 입학축하금                                                  */
/*   Program Name : 입학축하금 신청                                             */
/*   Program ID   : E21EntranceBuildSV                                          */
/*   Description  : 입학축하금을 신청할 수 있도록 하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                     2018/07/25 rdcamel 사용안함                                                         */
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
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

public class E21EntranceBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="05";    // 결재 업무타입(입학축하금)
    private String UPMU_NAME = "입학축하금";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";
            String PERNR;
            String msgFLAG = "";
            String msgTEXT = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            PERNR = box.get("PERNR", user.empNo);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {   //제일처음 신청 화면에 들어온경우.

                Vector AppLineData_vt = null;

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );

                //*********** 가족리스트(자녀)를 구성한다. *********************************
                A04FamilyDetailRFC  rfc_family = new A04FamilyDetailRFC();
                A04FamilyDetailData data       = new A04FamilyDetailData();

                Vector a04FamilyDetailData_vt = new Vector();
                box.put("I_PERNR", PERNR);
                Vector temp_vt                = rfc_family.getFamilyDetail(box) ;
                Vector e21EntranceDupCheck_vt = (new E21EntranceDupCheckRFC()).getCheckList( PERNR );

                for( int i = 0 ; i < temp_vt.size() ; i++ ) {
                    data = (A04FamilyDetailData)temp_vt.get(i);

                    if( data.SUBTY.equals("2") ) {
                        a04FamilyDetailData_vt.addElement(data);
                    }
                }
                //*********** 가족리스트(자녀)를 구성한다. *********************************

                if( a04FamilyDetailData_vt.size() == 0 ) {
                    //String msg = "입학축하금을 신청할 자녀가 없습니다.";
                    msgFLAG = "C";
                    msgTEXT = "입학축하금을 신청할 자녀가 없습니다.";
                }
                
                // 자녀리스트
                Logger.debug.println(this, "a04FamilyDetailData_vt : "+ a04FamilyDetailData_vt.toString());
                req.setAttribute("a04FamilyDetailData_vt", a04FamilyDetailData_vt);
                
                // 결재자리스트
                AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());
                req.setAttribute("msgFLAG", msgFLAG);
                req.setAttribute("msgTEXT", msgTEXT);
                req.setAttribute("AppLineData_vt",         AppLineData_vt);
                req.setAttribute("e21EntranceDupCheck_vt", e21EntranceDupCheck_vt);
                
                dest = WebUtil.JspURL+"E/E21Entrance/E21EntranceBuild.jsp";
                

            } else if( jobid.equals("create") ) {
//            	@웹취약성 결재자 인위적 변경 체크 2015-08-25-------------------------------------------------------
            	Vector   AppLine_vt     = null;
            	String		appLineCheck = "Y";
            	AppLine_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
            	
            	for (int i = 0; i < AppLine_vt.size(); i++){
            		AppLineData appLine = new AppLineData();
            		appLine = (AppLineData)AppLine_vt.get(i);
            		if(!appLine.APPL_APPU_TYPE.equals("01")){//변경 가능한 결재자 제외
            			Logger.debug.println(this, "appLine.APPL_PERNR : " + appLine.APPL_PERNR.toString());
            			Logger.debug.println(this, "box.get(APPL_APPU_NUMBi) : " + box.get("APPL_APPU_NUMB"+i));
            			if(!appLine.APPL_PERNR.equals(box.get("APPL_APPU_NUMB"+i))){
            				appLineCheck = "N";
            			}
            		}
            	}
            	
            	if(appLineCheck.equals("N")){
            		String msg = "msg020";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                    Logger.debug.println(this, " destributed = " + dest);
                    printJspPage(req, res, dest);
                    return;
            	}
//@웹취약성 결재자 인위적 변경 체크 끝-------------------------------------------------------
                // if( ! user.e_oversea.equals("X") ){  // 해외근무자가 아닐경우만
                /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ***************************************/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                if( ! accountInfoRFC.hasPersAccount(PERNR) ){
                    String msg = "msg006";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                    Logger.debug.println(this, " destributed = " + dest);
                    printJspPage(req, res, dest);
                    return;
                }
                /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ***************************************/
                // }

                NumberGetNextRFC func            = new NumberGetNextRFC();
                E21EntranceRFC   rfc             = new E21EntranceRFC();
                E21EntranceData  e21EntranceData = new E21EntranceData();

                Vector AppLineData_vt = new Vector();
                String ainf_seqn      = func.getNumberGetNext();

                /////////////////////////////////////////////////////////////////
                // 입학축하금 저장..
                e21EntranceData.AINF_SEQN = ainf_seqn;             // 결재정보 일련번호
                e21EntranceData.PERNR     = PERNR;                 // 사원번호
                e21EntranceData.SUBF_TYPE = "1";                   // 입학축하금 신청구분 (1)
                e21EntranceData.BEGDA     = box.get("BEGDA");      // 신청일자
                e21EntranceData.FAMSA     = box.get("FAMSA");      // 가족레코드유형
                e21EntranceData.ATEXT     = box.get("ATEXT");      // 텍스트, 20문자
                e21EntranceData.LNMHG     = box.get("LNMHG");      // 성(한글)
                e21EntranceData.FNMHG     = box.get("FNMHG");      // 이름(한글)
                e21EntranceData.REGNO     = DataUtil.removeSeparate(box.get("REGNO"));  // 주민등록번호
                e21EntranceData.ACAD_CARE = box.get("ACAD_CARE");  // 학력
                e21EntranceData.STEXT     = box.get("STEXT");      // 학교유형테스트
                e21EntranceData.FASIN     = box.get("FASIN");      // 교육기관
                e21EntranceData.ZPERNR    = user.empNo;            // 신청자 사번(대리신청, 본인 신청)
                e21EntranceData.UNAME     = user.empNo;            // 신청자 사번(대리신청, 본인 신청)
                e21EntranceData.AEDTM     = DataUtil.getCurrentDate();  // 변경일(현재날짜)
				e21EntranceData.PROP_YEAR = box.get("PROP_YEAR"); // 신청년도(입학년도)

                Logger.debug.println(this, e21EntranceData.toString());

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
                    appLine.APPL_BEGDA     = e21EntranceData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build( PERNR, ainf_seqn , e21EntranceData );
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
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E21Entrance.E21EntranceDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
