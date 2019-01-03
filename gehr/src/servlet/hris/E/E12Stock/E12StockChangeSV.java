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
import hris.common.util.*;
import hris.common.rfc.*;
import hris.E.E12Stock.*;
import hris.E.E12Stock.rfc.*;

/**
 * E12StockChangeSV.java
 * ���ǰ��¸� ������ �� �ֵ��� �ϴ� Class
 *
 * @author �赵��   
 * @version 1.0, 2002/01/08
 */
public class E12StockChangeSV extends EHRBaseServlet {

    private String UPMU_TYPE ="11";            // ���� ����Ÿ��(���ǰ���)

	  protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest     = "";
            String jobid    = "";
            String bankflag = "02";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.

                Vector              AppLineData_vt         = null;
                
                //////////////////////////////////////////////////////////////////////////////////////
                // ���ǰ��� ����Ʈ�� �����Ѵ�.
                E12StockCodeRFC  rfc_bank           = new E12StockCodeRFC();
                E12StockCodeData data               = new E12StockCodeData();
                Vector          e12StockCodeData_vt = rfc_bank.getStockCode();
                
                if( e12StockCodeData_vt.size() == 0 ) {  // �����̱⶧���� �� ������ �����ϱ�� ����ڴ�.
                    String msg = "���ǰ��� ������ �������� �ʽ��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } else {
                    E12BankStockFeeRFC rfc                     = new E12BankStockFeeRFC();
                    Vector             e12BankStockFeeData_vt  = null;
                    String             ainf_seqn               = box.get("AINF_SEQN");

                    // ���ǰ��� ����Ʈ
                    req.setAttribute("e12StockCodeData_vt", e12StockCodeData_vt);
                    
                    // ���� ������ ���ڵ�..
                    e12BankStockFeeData_vt = rfc.getBankStockFee( user.empNo, ainf_seqn, bankflag );
                    Logger.debug.println(this, "���ǰ��� ����ȸ : " + e12BankStockFeeData_vt.toString());
                    
                    req.setAttribute("e12BankStockFeeData_vt", e12BankStockFeeData_vt);
                    
                    // �����ڸ���Ʈ
                    AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                    req.setAttribute("AppLineData_vt", AppLineData_vt);
                
//  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�            
                    String ThisJspName = box.get("ThisJspName");
                    req.setAttribute("ThisJspName", ThisJspName);
//  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ� 

                    dest = WebUtil.JspURL+"E/E12Stock/E12StockChange.jsp";
                }

            } else if( jobid.equals("change") ) {       //
                
                E12BankStockFeeRFC  rfc                 = new E12BankStockFeeRFC();
                E12BankStockFeeData e12BankStockFeeData = new E12BankStockFeeData();
                Vector              AppLineData_vt      = new Vector();
                String              ainf_seqn           = box.get("AINF_SEQN");

                /////////////////////////////////////////////////////////////////////////////
                // ���ǰ��� ����..
                e12BankStockFeeData.AINF_SEQN = ainf_seqn;    			    // �������� �Ϸù�ȣ
                e12BankStockFeeData.PERNR     = user.empNo;    				  // �����ȣ         
                e12BankStockFeeData.BEGDA     = box.get("BEGDA");       // ��û��           
                e12BankStockFeeData.BANK_FLAG = box.get("BANK_FLAG");	  // ����(����/����)  
                e12BankStockFeeData.SECU_CODE = box.get("SECU_CODE");   // ����/���� ȸ��   
                e12BankStockFeeData.SECU_NAME = box.get("SECU_NAME");   // ����/���� ȸ��� 
                e12BankStockFeeData.GAPP_CONT = box.get("GAPP_CONT");   // ����/���� ����   

                Logger.debug.println(this, "���ǰ��� ���� : " + e12BankStockFeeData.toString());
                
                
                
                
                /////////////////////////////////////////////////////////////////////////////
                // �������� ����..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = user.empNo;
                    appLine.APPL_BEGDA     = e12BankStockFeeData.BEGDA;
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
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);

//  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�            
                String ThisJspName = box.get("ThisJspName");
//  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ� 
                
                if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {
                    appDB.change(AppLineData_vt);
                    rfc.change( user.empNo, ainf_seqn, bankflag, e12BankStockFeeData );
                    con.commit();
                    String msg = "msg002";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E12Stock.E12StockDetailSV?AINF_SEQN="+ainf_seqn+"&ThisJspName="+ThisJspName+"';";
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
            Logger.debug.println(this, "destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
	}
}
