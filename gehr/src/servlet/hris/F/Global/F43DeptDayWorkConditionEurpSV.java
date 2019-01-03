/******************************************************************************/
 /*	System Name	: g-HR
 /*   	1Depth Name 	: Organization & Staffing
 /*   	2Depth Name 	: Time Management
 /*   	Program Name	: Daily Time Statement
 /*   	Program ID   	: F43DeptDayWorkConditionEurpSV.java
 /*   	Description  	: �μ��� �ϰ� ���� ����ǥ ��ȸ�� ���� servlet[������]
 /*   	Note         		: ����
 /*    Creation     	: 2010-07-21 yji
 /*    Update       	: 2010-10-22 jungin @v1.0 �̱����� ���� ������ �߰�
/******************************************************************************/

package servlet.hris.F.Global;

import hris.D.BetweenDateData;
import hris.D.rfc.BetweenDateRFC;
import hris.F.Global.F43DeptDayDataWorkConditionData;
import hris.F.Global.F43DeptDayTitleWorkConditionData;
import hris.F.rfc.F42DeptMonthWorkConditionRFC;
import hris.common.WebUserData;
import hris.common.rfc.BukrsCodeByOrgehRFCEurp;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import com.sns.jdf.Logger;
/**
 * F43DeptDayWorkConditionEurpSV �μ��� ���� ��ü �μ����� �ϰ� ���� ����ǥ ������ ��������
 * F42DeptMonthWorkConditionRFC �� ȣ���ϴ� ���� class[������]
 *
 * @author yji
 * @version 1.0
 * @PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32"))  2018/02/09 rdcamel
 */
public class F43DeptDayWorkConditionEurpSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		try {
			req.setCharacterEncoding("utf-8");

			HttpSession session = req.getSession(false);

			WebUserData user = (WebUserData) session.getAttribute("user"); 		// ����

			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); 				// �μ��ڵ�
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N");		// �����μ�����
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); 			// excelDown

			String year = WebUtil.nvl(req.getParameter("year1"));
			String month = WebUtil.nvl(req.getParameter("month1"));
			String yymmdd = "";
			String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab���� ȣ��Ǵ��� ����
            String E_BUKRS = WebUtil.nvl(req.getParameter("E_BUKRS"));
			String dest_deail = "";
			String dest = "";
			Area area = null;

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}
	    	BukrsCodeByOrgehRFCEurp rfc = new BukrsCodeByOrgehRFCEurp();
	    	Vector vt = rfc.getBukrsCode(deptId);
	        E_BUKRS = (String)vt.get(1);

        	if ( E_BUKRS.equals("G290")) {
        		dest_deail ="PL";
        		area = Area.PL ;

        	} else if ( E_BUKRS.equals("G260")) {
        		dest_deail = "DE";
        		area = Area.DE ;

        	} else if (E_BUKRS.equals("G340") || E_BUKRS.equals("G400") ) {
        		dest_deail = "US";
        		area = Area.US ;
        		
        	} else if (E_BUKRS.equals("G560")) {//@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32"))  2018/02/09 rdcamel
        		dest_deail = "US";
        		area = Area.MX ;

        	} else {
        		dest_deail = "CN";
        		area = Area.CN ;
 	        }

            /**         * Start: ������ �б�ó�� */
            String fdUrl = ".";

            if (dest_deail.equals("CN")) {
        	   fdUrl = "hris.F.Global.F43DeptDayWorkConditionSV";
			}


            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }
            /**             * END: ������ �б�ó��             */

			if (year.equals("") || month.equals("")) {
				yymmdd = DataUtil.getCurrentDate();
			} else {
				yymmdd = year + month + "01";
			}


			String E_RETURN = "";
	        //String E_MESSAGE 	= "�μ� ������ �������µ� �����Ͽ����ϴ�.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;

			F42DeptMonthWorkConditionRFC func = null;
			BetweenDateRFC betweenDatefunc = null;
			Vector F43DeptDayTitle_vt = null;
			Vector F43DeptDayData_vt = null;
			Vector detailDataAll_vt = null;

	        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));

	        if(sMenuCode.equals("ESS_HRA_DAIL_STATE")){                            //�����λ����� > ��û > �μ�����
	        	if(!checkTimeAuthorization(req, res)) return;
	        }else{                                                               //�μ��λ�����
//	    	 @����༺ �߰�
	        	if ( user.e_authorization.equals("E")) {
	        		if(!checkTimeAuthorization(req, res)) return;
	        	}
	        }


			if (!deptId.equals("")) {
				func = new F42DeptMonthWorkConditionRFC();
				F43DeptDayTitle_vt = new Vector();
				F43DeptDayData_vt = new Vector();

				Logger.debug.println(this, "#####	deptId	:	[" + deptId + "]");
				Logger.debug.println(this, "#####	yymmdd	:	[" + yymmdd.substring(0, 6) + "]");
				Logger.debug.println(this, "#####	checkYN	:	[" + checkYN + "]");

				Vector ret = func.getDeptMonthWorkCondition(deptId, "", yymmdd.substring(0, 6),"2", checkYN,user.sapType,area); // �ϰ� '2' set!
				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F43DeptDayTitle_vt = (Vector) ret.get(2);
				F43DeptDayData_vt = (Vector) ret.get(3);

				String BEGDA = "";
				String ENDDA = "";
				String startdate = "01";
				String lastdate = "";
				String year2 = yymmdd.substring(0, 6);

				if (yymmdd.equals("") || yymmdd.equals(null)) {
					lastdate = DataUtil.getLastDay(DataUtil.getCurrentYear(), DataUtil.getCurrentMonth());
				} else {
					lastdate = DataUtil.getLastDay(yymmdd.substring(0,4), yymmdd.substring(4,6));
				}

				BEGDA = year2 + startdate;
				ENDDA = year2 + lastdate;

				Logger.debug.println(this, "#####	BEGDA	:	[" + BEGDA + "]");
				Logger.debug.println(this, "#####	ENDDA	:	[" + ENDDA + "]");

				// days
				betweenDatefunc = new BetweenDateRFC();
				detailDataAll_vt = betweenDatefunc.BetweenDate(BEGDA, ENDDA);

				for (int i = 0 ; i < detailDataAll_vt.size() ; i ++) {
					BetweenDateData time = (BetweenDateData)detailDataAll_vt.get(i);
					//Logger.debug.println(this, "#####	day Result	:	[" + time.CAL_DATE.substring(8) + "]);
				}

				// execute data
				for (int i = 0; i < F43DeptDayTitle_vt.size(); i++) {

					F43DeptDayTitleWorkConditionData tTitle = (F43DeptDayTitleWorkConditionData) F43DeptDayTitle_vt.get(i);

					HashMap<String, String> ldata = tTitle.MAP;

					for (int j = 0; j < F43DeptDayData_vt.size(); j++) {

						F43DeptDayDataWorkConditionData tData = (F43DeptDayDataWorkConditionData) F43DeptDayData_vt.get(j);

						if (tTitle.PERNR.equals(tData.PERNR)) {

							String tmp = "";

							if (tData.DAYS.equals("0.00")||tData.DAYS.equals("0")) {
								if (tData.HOURS.equals("0.00") || tData.HOURS.equals("0")) {
									tmp = "";
								} else {
									tmp = WebUtil.printNumFormat(Double.parseDouble(tData.HOURS),2);
								}
							} else {
								tmp = ":" + WebUtil.printNumFormat(Double.parseDouble(tData.DAYS),2);
							}
							Logger.debug.println(this, "#####	tmp	:	[" + tmp + "]");

							if (ldata.containsKey(tData.BEGDA)) {
								String tVal = ldata.get(tData.BEGDA);
								tVal += "<br>" + tData.FLAG + tmp;
								ldata.put(tData.BEGDA, tVal);

							} else {
								ldata.put(tData.BEGDA, tData.FLAG + tmp);
							}
						}
					}
				}
			}

			//Logger.debug.println(this, "#####	E_RETURN	:	[" + E_RETURN + "]");

			// RFC ȣ�� ������.
			// if (E_RETURN != null && E_RETURN.equals("S")) {
			req.setAttribute("E_BUKRS", E_BUKRS);
			req.setAttribute("checkYn", checkYN);
			req.setAttribute("detailDataAll_vt", detailDataAll_vt);
			req.setAttribute("F43DeptDayTitle_vt", F43DeptDayTitle_vt);
			req.setAttribute("E_YYYYMON", yymmdd);
			req.setAttribute("subView", subView);
        	Logger.debug.println(this, " subView = " + subView);

			if (excelDown.equals("ED")){ // ���������� ���.

    	        //Case of Europe(Poland, Germany) and USA
                /*
                 * e_area :	46 (Poland)
                 *         		01 (Germany)
                 *				10 (USA)
                */
				dest = WebUtil.JspURL + "F/F43DeptDayWorkConditionExcel_"+dest_deail+".jsp";
			} else {
				dest = WebUtil.JspURL + "F/F43DeptDayWorkCondition_"+dest_deail+".jsp";
			}

			// RFC ȣ�� ���н�.
			// } else {
			// String msg = E_MESSAGE;
			// String url = "history.back();";
			// req.setAttribute("msg", msg);
			// req.setAttribute("url", url);
			// dest = WebUtil.JspURL + "common/msg.jsp";
			// }

			Logger.debug.println(this, "#####	dest= " + dest);

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
