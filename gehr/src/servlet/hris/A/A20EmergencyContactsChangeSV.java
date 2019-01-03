/********************************************************************************/
/*	  System Name  	: g-HR                                                														
/*   1Depth Name  	: Personal HR Info                                                  														
/*   2Depth Name  	: Personal Info                                                    																                                                 
/*   Program Name 	: Emergency Contacts                                              
/*   Program ID   		: A20EmergencyContactsChangeSV.java
/*   Description  		: 비상연락망을 신청 수정을 할 수 있도록 하는 Class [USA]                         
/*   Note         		:                                                            
/*   Creation     		: 2010-09-30 jungin                                      
/********************************************************************************/

package servlet.hris.A;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A20EmergencyContactsData;
import hris.A.rfc.A20EmergencyContactsRFC;
import hris.common.WebUserData;
import hris.common.rfc.RelationListRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.Vector;

public class A20EmergencyContactsChangeSV extends EHRBaseServlet {

	// private String UPMU_NAME = "Emergency Contacts";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		
		Connection con = null;

		try {
			WebUserData user   = WebUtil.getSessionUser(req);

			String dest = "";

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");

			if (jobid.equals("first")) { // 제일처음 신청 화면에 들어온경우.

				A20EmergencyContactsRFC func1 = new A20EmergencyContactsRFC();
				Vector<A20EmergencyContactsData> resultList = func1.getEmergencyContactList(user.empNo);

				req.setAttribute("resultData", Utils.indexOf(resultList, 0));
				req.setAttribute("relationList", (new RelationListRFC()).getRelationList());
	            
				printJspPage(req, res, WebUtil.JspURL + "A/A20EmergencyContactsChange.jsp");

			} else if (jobid.equals("change")) {

				A20EmergencyContactsRFC rfc = new A20EmergencyContactsRFC();
				A20EmergencyContactsData a20EmergencyContactsData = new A20EmergencyContactsData();
				Vector a20EmergencyContactsData_vt = new Vector();

				box.copyToEntity(a20EmergencyContactsData);

				String I_DATLO = DataUtil.getCurrentDate();

				a20EmergencyContactsData_vt.addElement(a20EmergencyContactsData);

				RFCReturnEntity returnEntity = rfc.build(user.empNo, "3", I_DATLO, a20EmergencyContactsData_vt);

				if(returnEntity.isSuccess()) {
					moveMsgPage(req, res, "msg001", "location.href = '" + WebUtil.ServletURL
							+ "hris.A.A20EmergencyContactsListSV';");
				} else {
					moveMsgPage(req, res, g.getMessage("MSG.COMMON.SAVE.FAIL") + "\\n" + returnEntity.MSGTX
							, "location.href = 'javascript:history.go(-1);';");
				}
			} else {
				throw new BusinessException("#####	내부명령(jobid)이 올바르지 않습니다.");
			}
			
            Logger.debug.println(this, "#####	dest = " + dest);
            


		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			DBUtil.close(con);
		}
	}
}
