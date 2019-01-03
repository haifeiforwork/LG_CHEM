package servlet.hris.D.D11TaxAdjust;

import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.db.*;
import hris.common.rfc.*;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;
/**
 * D11TaxAdjustRentSV.java
 * �������� - �������� �� ��û/����/��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2010/12/03
 * @version 1.0, 2013/12/10 CSR ID:C20140106_63914 �Ӵ��μ���, �Ӵ����ֹε�Ϲ�ȣ, �Դ�����༭ �� �ּ���  �߰�
 */
public class D11TaxAdjustRentSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
        	//req.setCharacterEncoding("KSC5601");
        	//ApLog
        	String ctrl = "";
        	String cnt = "0";
        	String[] val = null;
            HttpSession              session    = req.getSession(false);
            WebUserData              user       = (WebUserData)session.getAttribute("user");
            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();
            Box                      box        = WebUtil.getBox(req);

            D11TaxAdjustRentRFC       rfc        = new D11TaxAdjustRentRFC();
            D11TaxAdjustYearCheckRFC rfc_o      = new D11TaxAdjustYearCheckRFC();
            Vector                   rent_vt     = new Vector();

            String                   dest       = "";
            String                   jobid      = "";
            String                   targetYear = box.get("targetYear");
            String                   o_flag     = "";

            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }


            Logger.debug.println(this, "build jobid = " + jobid);
            if(jobid.equals("first")){
            	rent_vt   = rfc.getRent( user.empNo, targetYear );

                //2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                if( rent_vt.size() >0 ) {          // ��ȸ
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustRentDetail.jsp";
                } else {                          // �ű�
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustRentBuild.jsp";
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "rent_vt"    , rent_vt     );
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "o_flag"    , o_flag     );
                //ApLog
                ctrl = "12";
            } else  if(jobid.equals("build")){

                int rent_count = box.getInt("rent_count");


                for( int i = 0 ; i < rent_count ; i++ ) {
                	D11TaxAdjustRentData data = new D11TaxAdjustRentData();
                    String          idx             = Integer.toString(i);

                    data.RCBEG        = box.get("RCBEG_"+idx);   // �Ӵ����������
                    if ( data.RCBEG.equals("") || data.RCBEG.equals(" ") ) {
                        continue;
                    }
                    Logger.debug.println(this, "build   1 =I = " + i);
                    data.PERNR         = user.empNo;   // ��� ��ȣ
                    data.WORK_YEAR = targetYear;
                    data.RCEND        = box.get("RCEND_"+idx);   // �Ӵ�����������
                    data.NAM01       = box.get("NAM01_"+idx);   //    �ݾ�

                    data.PNSTY       = box.get("PNSTY_"+idx);   //  CSR ID:C20140106_63914 ��������
                    data.PNSTX       = box.get("PNSTX_"+idx);   //  CSR ID:C20140106_63914 �������� (01 :����, 02:����)
                    data.LDNAM       = box.get("LDNAM_"+idx);   //  CSR ID:C20140106_63914 �ֹε�Ϲ�ȣ (�ѱ�)
                    data.LDREG       = box.get("LDREG_"+idx);    //  CSR ID:C20140106_63914 �ֹε�Ϲ�ȣ (�ѱ�)
                    data.ADDRE       = box.get("ADDRE_"+idx);   //  CSR ID:C20140106_63914 �Ӵ�����༭ �� �ּ���
                    data.HOUTY      = box.get("HOUTY_"+idx);   //  @2014 �������� ���������ڵ�
                    data.HOSTX      = box.get("HOSTX_"+idx);   //  @2014 �������� ��������name
                    data.FLRAR      = box.get("FLRAR_"+idx);     //  @2014 �������� ���ð�����
                    rent_vt.addElement(data);

                    //ApLog
                    if(i==0){
                    	val = new String[5];
	                    val[0] = data.RCBEG;
	                    val[1] = data.PERNR;
	                    val[2] = data.WORK_YEAR;
	                    val[3] = data.RCEND;
	                    val[4] = data.NAM01;
                    }
                }


                Logger.debug.println(this, "build rent_vt = " + rent_vt.toString());
                rfc.change( user.empNo, targetYear, rent_vt );
                String FSTID     = box.get("FSTID")      ;    //������üũ����
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg007";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustRentSV?targetYear="+targetYear+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
                //ApLog
                ctrl = "11";
                cnt = String.valueOf(rent_vt.size());
            } else  if(jobid.equals("change_first")){
            	rent_vt   = rfc.getRent( user.empNo, targetYear );

                //2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustRentChange.jsp";

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "rent_vt"    , rent_vt     );
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "o_flag"    , o_flag     );
                //ApLog
                ctrl = "12";
            } else if(jobid.equals("change")){
                int rent_count = box.getInt("rent_count");

                for( int i = 0 ; i < rent_count ; i++ ) {
                    D11TaxAdjustRentData data = new D11TaxAdjustRentData();
                    String          idx             = Integer.toString(i);
                    data.RCBEG        = box.get("RCBEG_"+idx);   // �Ӵ����������
                    if ( data.RCBEG.equals("") || data.RCBEG.equals(" ") ) {
                        continue;
                    }
                    data.PERNR         = user.empNo;   // ��� ��ȣ
                    data.WORK_YEAR = targetYear;
                    data.RCEND        = box.get("RCEND_"+idx);   // �Ӵ�����������
                    data.NAM01       = box.get("NAM01_"+idx);   //    �ݾ�

                    data.PNSTY       = box.get("PNSTY_"+idx);   //  CSR ID:C20140106_63914 ��������
                    data.PNSTX       = box.get("PNSTX_"+idx);   //  CSR ID:C20140106_63914 �������� (01 :����, 02:����)
                    data.LDNAM       = box.get("LDNAM_"+idx);   //  CSR ID:C20140106_63914 �ֹε�Ϲ�ȣ (�ѱ�)
                    data.LDREG       = box.get("LDREG_"+idx);    //  CSR ID:C20140106_63914 �ֹε�Ϲ�ȣ (�ѱ�)
                    data.ADDRE       = box.get("ADDRE_"+idx);   //  CSR ID:C20140106_63914 �Ӵ�����༭ �� �ּ���
                    data.HOUTY      = box.get("HOUTY_"+idx);   //  @2014 �������� ���������ڵ�
                    data.HOSTX      = box.get("HOSTX_"+idx);   //  @2014 �������� ��������name
                    data.FLRAR      = box.get("FLRAR_"+idx);     //  @2014 �������� ���ð�����
                    rent_vt.addElement(data);
                    //ApLog
                    if(i==0){
                    	val = new String[5];
	                    val[0] = data.RCBEG;
	                    val[1] = data.PERNR;
	                    val[2] = data.WORK_YEAR;
	                    val[3] = data.RCEND;
	                    val[4] = data.NAM01;
                    }
                }

                Logger.debug.println(this, " rent_vt = " + rent_vt.toString());
                rfc.change( user.empNo, targetYear, rent_vt );
                String FSTID     = box.get("FSTID")      ;    //������üũ����
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg002";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustRentSV?targetYear="+targetYear+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
                //ApLog
                ctrl = "11";
                cnt = String.valueOf(rent_vt.size());
            } else if(jobid.equals("AddorDel")){

                int    rent_count = box.getInt("rent_count");
                String curr_job   = box.getString("curr_job");
                String rowCount   = box.getString("rowCount");      //@v1.2

                //2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                for( int i = 0 ; i < rent_count ; i++ ) {
                	D11TaxAdjustRentData data = new D11TaxAdjustRentData();
                    String idx = Integer.toString(i);

                    data.RCBEG        = box.get("RCBEG_"+idx);   // �Ӵ����������
                    if ( data.RCBEG.equals("") || data.RCBEG.equals(" ") ) {
                        continue;
                    }
                    if( box.get("use_flag"+idx).equals("N") ) continue; //

                    data.PERNR         = user.empNo;   // ��� ��ȣ
                    data.WORK_YEAR = targetYear;
                    data.RCEND        = box.get("RCEND_"+idx);   // �Ӵ�����������
                    data.NAM01       = box.get("NAM01_"+idx);   //    �ݾ�

                    data.PNSTY       = box.get("PNSTY_"+idx);   //  CSR ID:C20140106_63914 ��������
                    data.PNSTX       = box.get("PNSTX_"+idx);   //  CSR ID:C20140106_63914 �������� (01 :����, 02:����)
                    data.LDNAM       = box.get("LDNAM_"+idx);   //  CSR ID:C20140106_63914 �ֹε�Ϲ�ȣ (�ѱ�)
                    data.LDREG       = box.get("LDREG_"+idx);    //  CSR ID:C20140106_63914 �ֹε�Ϲ�ȣ (�ѱ�)
                    data.ADDRE       = box.get("ADDRE_"+idx);   //  CSR ID:C20140106_63914 �Ӵ�����༭ �� �ּ���
                    data.HOUTY      = box.get("HOUTY_"+idx);   //  @2014 �������� ���������ڵ�
                    data.HOSTX      = box.get("HOSTX_"+idx);   //  @2014 �������� ��������name
                    data.FLRAR      = box.get("FLRAR_"+idx);     //  @2014 �������� ���ð�����

                    rent_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "rent_vt"   , rent_vt    );
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , rowCount   );

                if ( curr_job.equals("build") ) {    // �Է�ȭ��
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustRentBuild.jsp";
                } else {                             // �Է�
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustRentChange.jsp";
                }

            } else {

                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));

            }

            Logger.debug.println(this, " destributed = " + dest);
            //ApLog ����
            if(jobid.equals("first")||jobid.equals("build")||jobid.equals("change_first")||jobid.equals("change")){
            	ApLoggerWriter.writeApLog("��������", "��������", "D11TaxAdjustRentSV", "��������", ctrl, cnt, val, user, req.getRemoteAddr());
            }
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}