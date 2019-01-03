/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Time Management
/*   Program Name 	: Duty
/*   Program ID   		: D19DutyBuildSV
/*   Description  		: 직반(Duty)신청을 하는 Class
/*   Note         		:
/*   Creation     		: 2002-01-15 박영락
/*   Update       		: 2005-03-07 윤정현
/*                  		: 2007-10-09 huang peng xiao
/*                  		: 2008-06-18 김정인 @v1.0 신청시 직반금액(BETRG/WAERS/LGART) 필수 필드
/********************************************************************************/

package servlet.hris.D.D19Duty;

import java.lang.reflect.Field;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D19Duty.D19DutyData;
import hris.D.D19Duty.D19DutyDetailData;
import hris.D.D19Duty.rfc.D19DutyEntryRFC;
import hris.D.D19Duty.rfc.D19DutyRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

public class D19DutyCheckSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "07";
	private String UPMU_NAME = "Duty";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res)	throws GeneralException {

		try {
			UPMU_TYPE = "07";

			HttpSession session = req.getSession(false);
			final WebUserData user = WebUtil.getSessionUser(req);
            final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //신청대상자 사번

			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
			req.setAttribute("PersonData", phonenumdata);

			//Vector D19DutyData_vt = new Vector();
			//D19DutyData d19Data = new D19DutyData();
			//d19Data = (D19DutyData) Utils.indexOf(D19DutyData_vt, 0) ;

			if (jobid.equals("check")) {

				String DUTY_DATE = box.getString("DUTY_DATE");
				Logger.debug.println(this, "#####	PERNR		:	[ " + PERNR  + " ]");

				D19DutyEntryRFC rfc = new D19DutyEntryRFC();
				Vector ret = rfc.getDutyEntry(PERNR, DUTY_DATE);

				D19DutyData d19Duty = (D19DutyData) ret.get(0);

				Vector s_vt = (Vector) ret.get(1);

				res.getWriter().print(parseToJson(d19Duty, s_vt));

				return;

			} else {
				throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}
			//Logger.debug.println(this, "#####	destributed = " + dest);
			//printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}

	}

	private String parseToJson(D19DutyData duty, Vector s_vt) throws IllegalArgumentException, IllegalAccessException {
		Class c = duty.getClass();
		Field[] f = c.getDeclaredFields();
		StringBuffer str = new StringBuffer("");
		str.append("{");
		for (int i = 0; i < f.length; i++) {
			str.append("\"");
			str.append(f[i].getName());
			str.append("\":\"");
			str.append(f[i].get(duty));
			str.append("\"");
			if (i == f.length - 1)
				break;
			str.append(",");
		}
		str.append(",\"sels\":[");
		for (int i = 0; i < s_vt.size(); i++) {
			Object data = s_vt.get(i);
			Class dc = data.getClass();
			Field[] df = dc.getDeclaredFields();
			str.append("{");
			for (int j = 0; j < df.length; j++) {
				str.append("\"");
				str.append(df[j].getName());
				str.append("\":\"");
				str.append(df[j].get(data));
				str.append("\"");
				if (j == df.length - 1)
					break;
				str.append(",");
			}
			str.append("}");
			if (i == s_vt.size() - 1)
				break;
			str.append(",");
		}
		str.append("]");
		str.append("}");

		//return str.toString();
		return AppUtil.escape(str.toString());
	}
}
