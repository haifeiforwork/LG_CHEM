package servlet.hris.C.C10Education;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.mail.*;
import hris.common.util.*;
import hris.common.db.*;
import hris.common.rfc.*;

import hris.C.C02Curri.*;
import hris.C.C02Curri.rfc.*;
import hris.C.C10Education.*;
import hris.C.C10Education.rfc.*;

/**
 * C10EducationBuildSV.java
 * 교육 과정 신청 정보를 조회 하는 Class
 *
 * @author  김도신   
 * @version 1.0, 2004/05/28
 * 2018/07/25 rdcamel 사용 안함
 */
public class C10EducationBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="08";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);
            
            
            Vector AppLineData_vt = new Vector();
            
            String dest      = "";
            String jobid     = "";
            String i_objid_D = "";      //비즈니스 이벤트 그룹 ID
            String i_objid_L = "";
            String idx_Radio = "";
            String page      = "";
            String CNT_REM   = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            i_objid_D = box.get("OBJID_D");           // 과정 ID
            i_objid_L = box.get("OBJID_L");           // 비즈니스 이벤트 그룹 ID
//          Page별 Interface 추가
            idx_Radio = box.get("idx_Radio");         // 과정 목록에서 선택된 래디오 버튼
            page      = box.get("page");              // 과정 목록에서 선택된 page
            CNT_REM   = box.get("CNT_REM");           // 잔여강좌 count

            req.setAttribute("i_objid_L",           i_objid_L);
            req.setAttribute("i_objid_D",           i_objid_D);
//          Page별 Interface 추가
            req.setAttribute("idx_Radio",           idx_Radio);         // 과정 목록에서 선택된 래디오 버튼
            req.setAttribute("page",                page);              // 과정 목록에서 선택된 page
            req.setAttribute("CNT_REM",             CNT_REM);           // 잔여강좌 count

            if( jobid.equals("first") ) {

                Vector c10EventListData_vt = ( new C10EducationEventListRFC() ).getList( i_objid_D );
                Logger.debug.println(this, "c10EventListData_vt : "+ c10EventListData_vt.toString());

//              교육과정 상세 정보
                C10EducationInformRFC rfc_info       = new C10EducationInformRFC();
                Vector                ret            = rfc_info.getInfo( i_objid_D );
                Vector                c10Inform01_vt = (Vector)ret.get(0);
                
                // 결재자리스트
                AppLineData_vt = AppUtil.getAppVector( user.empNo, UPMU_TYPE );
                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                req.setAttribute("c10EventListData_vt", c10EventListData_vt);
                req.setAttribute("c10Inform01_vt",      c10Inform01_vt);
                
                req.setAttribute("AppLineData_vt",      AppLineData_vt);

                dest = WebUtil.JspURL+"C/C10Education/C10EducationBuild.jsp";
                
//          교육과정 안내 상세정보
            } else if( jobid.equals("detail") ) {
            
//              교육과정 상세 정보
                C10EducationInformRFC rfc_info       = new C10EducationInformRFC();
                Vector                ret            = rfc_info.getInfo( i_objid_D );
                Vector                c10Inform01_vt = (Vector)ret.get(0);
                Vector                c10Inform02_vt = (Vector)ret.get(1); 
                
                req.setAttribute("c10Inform01_vt",      c10Inform01_vt);
                req.setAttribute("c10Inform02_vt",      c10Inform02_vt);
                
                dest = WebUtil.JspURL+"C/C10Education/C10EducationInform.jsp";
            
            } else if( jobid.equals("create") ) {

                NumberGetNextRFC seqn  = new NumberGetNextRFC();
                C02CurriApplRFC  rfc   = new C02CurriApplRFC();
                String ainf_seqn       = seqn.getNumberGetNext();
                String date            = DataUtil.getCurrentDate();

                Vector C02CurriApplData_vt    = new Vector();
                C02CurriApplData data         = new C02CurriApplData();

                box.copyToEntity(data);

                data.MANDT     = user.clientNo;
                data.PERNR     = user.empNo;
                data.BEGDA     = date;
                data.AINF_SEQN = ainf_seqn;
                data.GWAJUNG   = box.get("GWAJUNG");
                data.GBEGDA    = box.get("BEGDA");
                data.GENDDA    = box.get("ENDDA");
                data.CHASU     = box.get("CHASU");
                data.CHAID     = box.get("CHAID");

//              개인정보 조회
                C02CurriPersonRFC func = new C02CurriPersonRFC();
                Vector C02CurriPersonData_vt = func.getCurriPerson( user.empNo );
                C02CurriPersonData personData = (C02CurriPersonData)C02CurriPersonData_vt.get(0);
                data.ENAME     = personData.ENAME;
                data.ORGTX     = personData.ORGTX;
                data.TITEL     = personData.TITEL;
                data.TRFGR     = personData.TRFGR;
                data.TRFST     = personData.TRFST;
                data.VGLST     = personData.VGLST;

                data.P_AINF_SEQN = ainf_seqn;  //결재정보 일련번호
                data.P_PERNR     = user.empNo;
                data.P_CHAID     = box.get("CHAID");;      
                data.P_FDATE     = box.get("SDATE");
                data.P_TDATE     = box.get("EDATE");
 
                C02CurriApplData_vt.addElement(data);

                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = user.empNo;
                    appLine.APPL_BEGDA     = date;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_FLAG = box.get("APPL_UPMU_FLAG"+idx);
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                    appLine.APPL_APPR_TYPE = box.get("APPL_APPR_TYPE"+idx);
                    appLine.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    appLine.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    appLine.APPL_OTYPE     = box.get("APPL_OTYPE"+idx);
                    appLine.APPL_OBJID     = box.get("APPL_OBJID"+idx);
                    appLine.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println( this, C02CurriApplData_vt.toString() );
                Logger.debug.println( this, "결제라인 : "+AppLineData_vt.toString() );

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build( data.P_AINF_SEQN, data.P_CHAID, data.P_PERNR, data.P_FDATE, data.P_TDATE, C02CurriApplData_vt );
                con.commit();
                
                String upmu = "교육과정 신청";
                MailMgr.sendMail(user,AppLineData_vt,upmu);
                String msg = "msg001";
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C10Education.C10EducationDetailSV?AINF_SEQN="+ainf_seqn+"&OBJID_L="+i_objid_L+"&idx_Radio="+idx_Radio+"&page="+page+"';";
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
             DBUtil.close(con);
        }
    }
}