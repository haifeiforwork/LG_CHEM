package servlet.hris.D.D11TaxAdjust;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;


/**
 * D11TaxAdjustEducationSV.java
 * �������� - Ư������ ������ ��û/����/��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author ������
 * @version 1.0, 2013/07/01
 * @version 2.0, 2014/02/10  CSR ID :C20140106_63914
 *
 * update:           20180105 cykim  [CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� ��
 *
 */
public class D11TaxAdjustEducationSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
        	//ApLog
        	String ctrl = "";
        	String cnt = "0";
        	String[] val = null;

            HttpSession              session    = req.getSession(false);
            WebUserData              user       = (WebUserData)session.getAttribute("user");
            Box                      box        = WebUtil.getBox(req);

            D11TaxAdjustEducationRFC rfc = new D11TaxAdjustEducationRFC();
            D11TaxAdjustYearCheckRFC rfc_o      = new D11TaxAdjustYearCheckRFC();
            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();
            Vector                   edu_vt     = new Vector();

            String dest       = "";
            String jobid      = "";
            String targetYear = box.get("targetYear");
            String o_flag     = "";
            String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustEducationSV?targetYear="+targetYear+"';";

            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }

            if(jobid.equals("first")){
            	edu_vt = rfc.getEdu( user.empNo, targetYear );
                //2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "edu_vt"    , edu_vt     );
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "jobid"    , jobid     );
                if( edu_vt != null && edu_vt.size() > 0 ) {
                	dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEducationDetail.jsp";
                } else {
                	dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEducationBuild.jsp";
                }
                //ApLog
                ctrl = "12";
            } else if(jobid.equals("change")){
            	edu_vt = rfc.getEdu( user.empNo, targetYear );
                //2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "edu_vt"    , edu_vt     );
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "jobid"    , jobid     );
                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEducationBuild.jsp";
                //ApLog
                ctrl = "12";
            } else if(jobid.equals("build")){
                int rowCount = box.getInt("rowCount");
                //ApLog��(ù�ุ ����)
                int apj=0;

                for( int i = 0 ; i < rowCount ; i++ ) {
                    String          idx             = Integer.toString(i);
                    String chkedit = box.get("chkedit_"+idx);
                    String empty = box.get("empty_"+idx);
                    //Logger.debug("@@@chkedit_"+idx+":"+chkedit);
                    //������
	                    if(!chkedit.equals("X")&&!empty.equals("X")){
	                    	D11TaxAdjustDeductData data = new D11TaxAdjustDeductData();
	                    	String gubun = box.get("gubun_"+idx);
	                    	String pdf = box.get("pdf_"+idx);
	                    	 // ȸ�������� 1,  eHR��û 2, ����û PDF 9 C20140106_63914
	                    	if(gubun.equals("X")){
	                    		data.GUBUN = "1";
	                    	} else {
	                    		if(pdf.equals("X")){
	                    			data.GUBUN = "9";
	                    		} else {
	                    			data.GUBUN = "2";
	                    		}
	                    	}

		                    data.SEQNR      = box.get("seqnr_"+idx)	;	//������ Ű�� ���� ����Ÿ�� ���ڵ� ��ȣ
		                    data.SUBTY      = box.get("subty_"+idx);   // ����
		                    data.F_ENAME  = box.get("fname_"+idx);   // ����
		                   // data.F_ENAME  = box.get("ename_"+idx);   // ����
		                    data.F_REGNO  = box.get("fregno_"+idx).replaceAll("-", "");   // �ֹε�Ϲ�ȣ
		                    data.FASAR      = box.get("fasar_"+idx)     ;   // ������������ �з�
		                    data.BETRG  = box.get("betrg_"+idx).replaceAll(",", "") ;   // HR �޿�����: �ݾ�
		                    data.CHNTS      = box.get("chnts_"+idx)    ;   // @v1.2����û��������
		                    data.ACT_CHECK    = box.get("actcheck_"+idx); //����� ������ ������
		                    data.OMIT_FLAG    = box.get("omitflag_"+idx); //���� �÷���

		                    //[CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� �� start
		                    if(box.get("exsty_"+idx) != ""){
		                    	data.EXSTY    = box.get("exsty_"+idx); //@2011 �������Ժ��
		                    }else if(box.get("exstyh_"+idx) != ""){
		                    	data.EXSTY    = "F";
		                    }else{
		                    	data.EXSTY		= "";
		                    }

		                    data.LOAN    = box.get("loan_"+idx); //���� �÷���
		                    //[CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� �� end
		                    edu_vt.addElement(data);
		                    //ApLog
		                    if(apj==0){
		                    	//[CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� ��
		                    	val = new String[12];
			                    val[0] = data.GUBUN;
			                    val[1] = data.SEQNR;
			                    val[2] = data.SUBTY;
			                    val[3] = data.F_ENAME;
			                    val[4] = data.F_REGNO;
			                    val[5] = data.FASAR;
			                    val[6] = data.BETRG;
			                    val[7] = data.CHNTS;
			                    val[8] = data.ACT_CHECK;
			                    val[9] = data.OMIT_FLAG;
			                    val[10] = data.EXSTY;
			                    //[CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� ��
			                    val[11] = data.LOAN;
			                    apj++;
		                    }
	                    }
                }

                rfc.change( user.empNo, targetYear, edu_vt );

                String FSTID     = box.get("FSTID")      ;    //������üũ����
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                req.setAttribute("msg", "msg007");
                req.setAttribute("url", url);
                req.setAttribute("jobid", "");
                dest = WebUtil.JspURL+"common/msg.jsp";
                //ApLog
                ctrl = "11";
                cnt = String.valueOf(edu_vt.size());
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            //ApLog ����
            ApLoggerWriter.writeApLog("��������", "������", "D11TaxAdjustEducationSV", "������", ctrl, cnt, val, user, req.getRemoteAddr());

            printJspPage(req, res, dest);

        } catch(Exception e) {
        	//Logger.error(e);
            throw new GeneralException(e);
        }
	}
}