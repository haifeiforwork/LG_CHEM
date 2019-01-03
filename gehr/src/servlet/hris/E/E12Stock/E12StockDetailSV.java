package servlet.hris.E.E12Stock;

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
import hris.common.db.*;
import hris.common.mail.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.E.E12Stock.*;
import hris.E.E12Stock.rfc.*;

/**
 * E12StockDetailSV.java
 * 증권계좌에 대한 상세내용을 조회하여 E12StockDetail.jsp 값을 넘겨주는 class
 * jobid가 first일 경우는 AppLineDB.class를 호출하여 값을 jsp페이지로 넘겨준다.
 *
 * @author 김도신   
 * @version 1.0, 2002/01/08
 **/
public class E12StockDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="11";            // 결재 업무타입(증권)

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest      = "";
            String jobid     = "";
            String bankflag  = "02";
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            if( jobid.equals("first") ) {
                
                E12BankStockFeeRFC rfc                     = new E12BankStockFeeRFC();
                Vector             e12BankStockFeeData_vt  = null;
                Vector             AppLineData_vt          = null;
                String             ainf_seqn               = box.get("AINF_SEQN");

                e12BankStockFeeData_vt = rfc.getBankStockFee( user.empNo, ainf_seqn, bankflag );
                Logger.debug.println(this, "증권계좌 상세조회 : " + e12BankStockFeeData_vt.toString());

//  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분            
                String ThisJspName = box.get("ThisJspName");
                req.setAttribute("ThisJspName", ThisJspName);
//  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분 
          
                AppLineData_vt = AppUtil.getAppDetailVt(ainf_seqn);

                req.setAttribute("e12BankStockFeeData_vt", e12BankStockFeeData_vt);
                req.setAttribute("AppLineData_vt"        , AppLineData_vt);

                dest = WebUtil.JspURL+"E/E12Stock/E12StockDetail.jsp";

            } else if( jobid.equals("delete") ) {
                
                /////////////////////////////////////////////////////////////////////////////
                // 증권계좌 삭제..
                E12BankStockFeeRFC rfc            = new E12BankStockFeeRFC();
                Vector             AppLineData_vt = new Vector();
                String             ainf_seqn      = box.get("AINF_SEQN");

                // 결재정보 삭제..
                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = user.empNo;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = box.get("AINF_SEQN");

// 2002.07.25.---------------------------------------------------------------------------
//              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
//              결재
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    app.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    app.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    app.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);
                    
                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
//              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
// 2002.07.25.---------------------------------------------------------------------------

                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);
                
                String ThisJspName = box.get("ThisJspName");
                
                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    rfc.delete( user.empNo, ainf_seqn, bankflag  );
                    con.commit();

// 2002.07.25.---------------------------------------------------------------------------
//                  신청건 삭제시 메일 보내기.
                    String upmu = "증권계좌 신청";
                    MailMgr.sendMailDel(user,AppLineData_vt,upmu);
//                  신청건 삭제시 메일 보내기.
// 2002.07.25.---------------------------------------------------------------------------

                    String msg = "msg003";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E12Stock.E12StockBuildSV?ThisJspName="+ThisJspName+"';";
//  삭제 실행후 삭제전 페이지로 이동하기 위한 구분            
                    if( ThisJspName.equals("A16ApplList.jsp") ){
                        url = "location.href = '" + WebUtil.ServletURL+"hris.A.A16Appl.A16ApplListSV';";
                    }
//  삭제 실행후 삭제전 페이지로 이동하기 위한 구분            
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E12Stock.E12StockDetailSV?AINF_SEQN="+ainf_seqn+"&ThisJspName="+ThisJspName+"';";
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