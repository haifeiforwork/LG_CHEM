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
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

public class D19DutyBuildSV extends ApprovalBaseServlet {

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
			String PERNR = getPERNR(box, user); //신청대상자 사번

			String UPMU = box.getString("UPMU");
			if (UPMU != null && !UPMU.equals("")) {
				UPMU_TYPE = UPMU;
			}

			Logger.debug.println(this, "#####	user.companyCode		:	[ " + user.companyCode + " ]");

			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
			req.setAttribute("PersonData", phonenumdata);

			Vector D19DutyData_vt = new Vector();
			D19DutyData d19Data = new D19DutyData();
			d19Data = (D19DutyData) Utils.indexOf(D19DutyData_vt, 0) ;

			if (jobid.equals("first")) {
				// add G370.		2011-01-19		liukuo		@v1.1 [C20110118_09919]
				if( !user.companyCode.equals("G110") && !user.companyCode.equals("G170")
						&& !user.companyCode.equals("G130") && !user.companyCode.equals("G280") && !user.companyCode.equals("G370")){
					dest = WebUtil.JspURL + "D/D19Duty/DutyNotice.jsp";
				}else{
					//결재라인, 결재 헤더 정보 조회
	                getApprovalInfo(req, PERNR);

					req.setAttribute("resultData", d19Data);
					req.setAttribute("PERNR", PERNR);

					dest = WebUtil.JspURL + "D/D19Duty/D19DutyBuild.jsp";
				}


			} else if (jobid.equals("check")) {

				String DUTY_DATE = box.getString("DUTY_DATE");
				Logger.debug.println(this, "#####	DUTY_DATE		:	[ " + DUTY_DATE + " ]");
				Logger.debug.println(this, "#####	PERNR		:	[ " + PERNR + " ]");

				D19DutyEntryRFC rfc = new D19DutyEntryRFC();
				Vector ret = rfc.getDutyEntry(PERNR, DUTY_DATE);

				D19DutyData d19Duty = (D19DutyData) ret.get(0);

				Vector s_vt = (Vector) ret.get(1);

				res.getWriter().print(parseToJson(d19Duty, s_vt));

				return;

			} else if (jobid.equals("changeApp")) {

				//Vector AppLineData_vt = null;
				//AppLineData_vt = AppUtil.getAppVector(PERNR, UPMU_TYPE);

				String upmu_type = box.getString("UPMU");

				 //-------- 근태기간완료된것을 신청하는  check (li hui)----------------------
				String DUTY_DATE = box.getString("DUTY_DATE");

				Logger.debug.println(this, "#####	DUTY_DATE		:	[ " + DUTY_DATE + " ]");
				Logger.debug.println(this, "#####	upmu_type		:	[ " + upmu_type + " ]");

				D01OTCheckGlobalRFC rfc2 = new D01OTCheckGlobalRFC();
				String flag = rfc2.check1(PERNR, DUTY_DATE, upmu_type);
				Logger.debug.println(this, "#####	flag	:	[ " + flag + " ]");

		        //res.getWriter().print(AppUtil.escape(hris.common.util.AppUtil.getAppBuild(AppLineData_vt)) + "," + flag);
		        res.getWriter().print(flag);

				return;

			} else if (jobid.equals("create")) {

				/* 실제 신청 부분 */
                dest = requestApproval(req, box, D19DutyData.class, new RequestFunction<D19DutyData>() {
                    public String porcess(D19DutyData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                    	//D19DutyEntryRFC e19Rfc = new D19DutyEntryRFC();
                    	D19DutyRFC e19Rfc = new D19DutyRFC();
                    	e19Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                        //inputData.PERNR 		    = PERNR;
                        inputData.ZPERNR 		= user.empNo; 							// 신청자 사번(대리신청, 본인 신청)
                        inputData.PERNR_D 		= user.empNo;
                        inputData.UNAME 		= user.empNo; 							// 신청자 사번(대리신청, 본인 신청)
                        inputData.AEDTM 		= DataUtil.getCurrentDate(); 			// 변경일(현재날짜)

        				//*************************************************************************************************************
        				//신청시 직반금액(BETRG/WAERS/LGART) 필수 필드.		2008-06-18		김정인
                     	Logger.debug.println("#####	DUTY_DATE		:	[ "	+	box.getString("DUTY_DATE") + " ]");
                     	Logger.debug.println("#####	DUTY_REQ		:	[ "	+	box.getString("DUTY_REQ")   + " ]");
                     	Logger.debug.println("#####	box .PERNR		:	[ "	+	box.getString("PERNR")   + " ]");
                     	Logger.debug.println("#####	inputData.PERNR		:	[ "	+	inputData.PERNR   + " ]");

        				D19DutyEntryRFC rfc2 = new D19DutyEntryRFC();
        				Vector ret = rfc2.getDutyEntry(inputData.PERNR, box.getString("DUTY_DATE"));

                    	Vector d19Duty = (Vector) Utils.indexOf(ret, 1);// (Vector) ret.get(1); (Vector) Utils.indexOf(ret, 1)

        				String LGART = "";

        		        for(int i=0; i<d19Duty.size(); i++){

        		        	D19DutyDetailData data1 = (D19DutyDetailData)d19Duty.get(i);

        		        	if(data1.DUTY.equals(box.getString("DUTY_REQ")) ){
        		        		LGART = data1.LGART;
        		        		//Logger.debug.println("#####	[RFC].data.LGART	:	[ " + data1.LGART + " ]");
        		        	}
        		        }

        		        inputData.LGART     	= LGART;
        		        inputData.DUTY_REQ	= box.getString("DUTY_REQ");

        				//*************************************************************************************************************

        				box.put("I_GTYPE", "2");  // insert

        				//String Message = e19Rfc.build(ainf_seqn, PERNR, D01OTData_vt);
                        String AINF_SEQN = e19Rfc.build(inputData, box, req);

                     	//Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  e19Rfc.getReturn().isSuccess() );
                       // Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  e19Rfc.getReturn() );

                        if(!e19Rfc.getReturn().isSuccess()) {
                        	 throw new GeneralException(e19Rfc.getReturn().MSGTX);
                        }

                        return AINF_SEQN;

                        /* 개발자 작성 부분 끝 */
                    }
                });

			} else {
				throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}
			printJspPage(req, res, dest);

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
