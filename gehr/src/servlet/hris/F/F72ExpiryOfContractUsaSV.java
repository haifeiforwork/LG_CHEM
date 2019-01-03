/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name  	: Organization & Staffing
/*   2Depth Name  	: Personel Info
/*   Program Name 	: Expiry of Contract
/*   Program ID   		: F72ExpiryOfContractUsaSV.java
/*   Description  		: ��ุ����Ȳ ���� ��ȸ�� ���� class (USA - LGCPI(G400))
/*   Note         		:
/*   Creation       	: 2010-11-05 jungin @v1.0 LGCPI���� ���� ������ ���� ó��
/********************************************************************************/

package servlet.hris.F;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.F.rfc.*;
import hris.common.WebUserData;
import hris.common.rfc.BukrsCodeByOrgehRFCEurp;

/**
 * F72ExpiryOfContractUsaSV
 * ��ุ����Ȳ ������ �������� F72ExpiryOfContractRFCEurp �� ȣ���ϴ� ���� class
 *
 * @author jungin
 * @version 1.0
 */
public class F72ExpiryOfContractUsaSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
    		req.setCharacterEncoding("utf-8");

	        HttpSession session = req.getSession(false);

	        WebUserData user = (WebUserData)session.getAttribute("user");			// ����
	        String jobid = WebUtil.nvl(req.getParameter("jobid"));
	        String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); 				// �μ��ڵ�.
	        String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		// �����μ�����.

	        String searchBtnClickYn = WebUtil.nvl(req.getParameter("hdn_searchBtnClickYn"));
	        String excelDown = WebUtil.nvl(req.getParameter("hdn_excel"));  			// excelDown

			String begda = "";
			String endda = "";

			if (jobid.equals("")) {
				jobid = "first";
			}

			if (jobid.equals("first")) {
				begda = DataUtil.getCurrentDate();
				endda = DataUtil.addDays(DataUtil.getCurrentDate(),31);
			} else {
				begda = WebUtil.nvl(req.getParameter("BEGDA")); 		// �˻�������.
		        endda = WebUtil.nvl(req.getParameter("ENDDA")); 		// �˻�������.
			}


            // �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if (deptId.equals("")) {
            	deptId = user.e_objid;
            }

			if(!checkBelongGroup( req, res, deptId, "")){
				return;
			}
			if(!checkAuthorization(req, res)) return;

	        String dest = "";

	        String E_RETURN = "";
	        String E_MESSAGE = "��ุ����Ȳ ������ �������µ� �����Ͽ����ϴ�.";
	        boolean isSuccess = false;

	        F72ExpiryOfContractRFCEurp func = null;
	        Vector Dept4YearValuation_vt = null;


	        if (!deptId.equals("")) {
	        	func = new F72ExpiryOfContractRFCEurp();
	            Dept4YearValuation_vt = func.getDept4YearValuation(deptId, begda, endda, checkYN);

				isSuccess = func.getReturn().isSuccess();
	        }

        	req.setAttribute("checkYn", checkYN);
	        req.setAttribute("Dept4YearValuation_vt", Dept4YearValuation_vt);
	        req.setAttribute("begda", begda);
	        req.setAttribute("endda", endda);

	        if (excelDown.equals("ED")) { // ���������� ���.
	        	dest = WebUtil.JspURL+"F/F72ExpiryOfContractExcelUsa.jsp";
	        } else {
	        	dest = WebUtil.JspURL + "F/F72ExpiryOfContractUsa.jsp";
	        }

	        printJspPage(req, res, dest);

    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }

}
