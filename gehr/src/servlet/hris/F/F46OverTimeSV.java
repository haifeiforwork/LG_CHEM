package servlet.hris.F;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.F.rfc.*;
import hris.F.F46OverTimeData;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.WebUserData;

/**
 * F46OverTimeSV
 * �μ��� ���� ��ü �μ����� ����ٷν��� ������ ��������
 *  F46OverTimeRFC �� ȣ���ϴ� ���� class
 *
 * @author  ������
 * @version 1.0
 */
public class F46OverTimeSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
    		//ApLog
        	String ctrl = "";
        	String cnt = "0";
        	String[] val = null;

	        HttpSession session = req.getSession(false);
	        Logger.debug.println(this, "start..........");
	        F46OverTimeData data = new F46OverTimeData();
	        String hdn_deptId = WebUtil.nvl(req.getParameter("hdn_deptId"));
	        String hdn_deptNm = WebUtil.nvl(req.getParameter("hdn_deptNm"));
	        String checkYn = WebUtil.nvl(req.getParameter("chck_yeno"), "N");
	        data.I_ORGEH = hdn_deptId; 			//�μ��ڵ�...
	        data.I_LOWERYN = checkYn; 		//�����μ�����.
	        String E_YYYYMON = "";
	        data.I_GUBUN = WebUtil.nvl(req.getParameter("gubun"), "1");
	        data.I_TODAY = "";

	        data.year   = WebUtil.nvl(req.getParameter("year"));
	        data.month  = WebUtil.nvl(req.getParameter("month"));
	        data.yymmdd   = WebUtil.nvl(req.getParameter("yymmdd"));

            data.I_OVERYN = WebUtil.nvl(req.getParameter("overYn"), "N");
            String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...

            WebUserData user    = (WebUserData)session.getAttribute("user");				//����.
            String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab���� ȣ��Ǵ��� ����

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( data.I_ORGEH.equals("") ){
            	data.I_ORGEH = user.e_objid;
            }

            if(data.I_GUBUN.equals("1")){
            	if(data.year.equals("")||data.month.equals("")){
            		data.I_TODAY = DataUtil.getCurrentDate();
				} else {
					data.I_TODAY = data.year + data.month + "20";
				}
            } else {
            	if(data.yymmdd.equals("")){
            		data.I_TODAY = DataUtil.getCurrentDate();
            	} else {
            		data.I_TODAY = DataUtil.delDateGubn(data.yymmdd);
            	}
            }
	        String dest    		= "";

           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */
	        int orgFlag = user.e_authorization.indexOf("M");    //���������ѿ���.

	        Box box = WebUtil.getBox(req);
           	box.put("I_PERNR", user.empNo);
           	//�ʱ�ȭ����½� �����߻� ��ġ eunha
           	//box.put("I_ORGEH", hdn_deptId);
           	box.put("I_ORGEH", data.I_ORGEH);
           	if(orgFlag >0){
           		box.put("I_AUTHOR", "M");
           	}else{
           		box.put("I_AUTHOR", "");
           	}
           	box.put("I_GUBUN", "");
           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */
			   if(!checkBelongGroup(req, res, data.I_ORGEH, "")) return;
        	// @����༺ �߰�
			   if(!checkAuthorization(req, res)) return;

		        F46OverTimeRFC func    = new F46OverTimeRFC();
		        Vector rtnVt  = new Vector();
		        Vector overTimeVt  = new Vector();
				if ( !data.I_ORGEH.equals("") ) {
					rtnVt = func.getOverTime(data);
					E_YYYYMON = (String)rtnVt.get(0);
					overTimeVt 	= (Vector)rtnVt.get(1);
		        }
				Logger.debug.println(this, " E_YYYYMON = " + E_YYYYMON);
				Logger.debug.println(this, " overTimeVt = " + overTimeVt);
				req.setAttribute("E_YYYYMON", E_YYYYMON);
				req.setAttribute("hdn_deptId", hdn_deptId);
				req.setAttribute("hdn_deptNm", hdn_deptNm);
				req.setAttribute("checkYn", checkYn);
				req.setAttribute("searchData", data);
				req.setAttribute("overTimeVt", overTimeVt);
				req.setAttribute("subView", subView);
	        	Logger.debug.println(this, " subView = " + subView);

				 if( excelDown.equals("ED") ){ //���������� ���.
			         dest = WebUtil.JspURL+"F/F46OverTimeExcel.jsp";
			         ctrl = "24";
				 } else {
					 dest = WebUtil.JspURL+"F/F46OverTime.jsp";
					 ctrl = "12";
				 }

	        Logger.debug.println(this, " destributed = " + dest);
	        //ApLog
            ApLoggerWriter.writeApLog("�������", "����", "F46OverTimeSV", "����ٷν���������ȸ", ctrl, cnt, val, user, req.getRemoteAddr());

	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}