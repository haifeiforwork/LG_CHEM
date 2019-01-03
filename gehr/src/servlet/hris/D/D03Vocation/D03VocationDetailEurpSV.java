/********************************************************************************/
/*   System Name  	: g-HR
/*   1Depth Name  	: Application
/*   2Depth Name  	: Time Management
/*   Program Name 	: Leave
/*   Program ID   		: D03VocationDetailEurpSV.java
/*   Description  		: 휴가 조회/삭제 할수 있도록 하는 Class [유럽용]
/*   Note         		:
/*   Creation     		: 2010-07-29 yji
/*   Update				: 2010-10-08 jungin	@v1.0 미국법인 리턴페이지 추가. (자바스크립트를 위한 페이지 분리)
 * 							@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
 */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationGlobalRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationDetailEurpSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="02";            // 결재 업무타입(휴가신청)

	private String UPMU_NAME = "Leave";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
	protected void performTask(final HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		//Connection con = null;

		try {
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest 	  			= "";
			String jobid   			= "";
			String UPMU_CODE 	= "";

            final Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");
            

			//********************************************
			//휴가유형에 따른 selectbox 업무코드.(value1)		2008-02-20.
			UPMU_CODE = box.get("TMP_UPMU_CODE", UPMU_TYPE);
			//********************************************

			final String AINF_SEQN = box.get("AINF_SEQN");


			//Logger.debug.println(this, "#####	USER	 :	[" + user.toString() + "]");
			Logger.debug.println(this, "#####	UPMU_TYPE	 :	[" + UPMU_TYPE + "]");

			final D03VocationRFC rfc = new D03VocationRFC();
			
			Vector d03VocationData_vt = null;

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            
			// 휴가신청 조회
			d03VocationData_vt = rfc.getVocation(user.empNo, AINF_SEQN);
			final String PERNR =  rfc.getApprovalHeader().PERNR; // getPERNR(box, user); //box.get("PERNR", user.empNo);//
			final D03VocationData firstData = (D03VocationData) d03VocationData_vt.get(0);
			//Logger.debug.println(this, "#####	d03VocationData_vt	:	" + d03VocationData_vt.toString());
			Logger.debug.println(this, "#####	JOBID	 :	[" + jobid + "] / PERNR	 :	[" + PERNR + "]");

            // 대리 신청 추가
            PersonInfoRFC numfunc         = new PersonInfoRFC();
            PersonData phonenumdata    = null;
            phonenumdata  = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );
            
			String P_STDAZ = box.get("P_STDAZ");
			String I_STDAZ = box.get("I_STDAZ");

			if (jobid.equals("first")) {	// 휴가신청 상세조회

				req.setAttribute("d03VocationData_vt", d03VocationData_vt);

				// 개인의 잔여휴가일수 조회
				D03RemainVocationGlobalRFC rfcRemain = new D03RemainVocationGlobalRFC();
				Vector D03RemainVocationData_vt = null;
				D03RemainVocationData_vt = rfcRemain.getRemainVocation(firstData.PERNR, firstData.APPL_TO, firstData.AWART);
				firstData.ANZHL_BAL = ((D03RemainVocationData) D03RemainVocationData_vt.get(0)).ANZHL_BAL;
				D03RemainVocationData d03RemainVocationData  =((D03RemainVocationData) D03RemainVocationData_vt.get(0));
				req.setAttribute("d03RemainVocationData", d03RemainVocationData);

                if (!detailApporval(req, res, rfc))                    return;
    	        //Case of Europe(Poland, Germany) and USA
                /*
                 * e_area :	46 (Poland)
                 *         		01 (Germany)
                 *				10 (USA)
                */
				if (user.e_area.equals("46")) {
					dest = WebUtil.JspURL
							+ "D/D03Vocation/D03VocationDetail_PL.jsp?I_STDAZ=" + I_STDAZ + "&P_STDAZ=" + P_STDAZ + "";

				} else if (user.e_area.equals("01")) {
					dest = WebUtil.JspURL
							+ "D/D03Vocation/D03VocationDetail_DE.jsp?I_STDAZ=" + I_STDAZ + "&P_STDAZ=" + P_STDAZ + "";

				} else if (user.e_area.equals("10")||user.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
					dest = WebUtil.JspURL
							+ "D/D03Vocation/D03VocationDetail_US.jsp?I_STDAZ=" + I_STDAZ + "&P_STDAZ=" + P_STDAZ + "";
				}


                /////////////////////////////////////////////////////////////////////////////
                // 휴가신청 삭제..
                /////////////////////////////////////////////////////////////////////////////
                
				
			} else if (jobid.equals("delete")) {	// 휴가신청 삭제

                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	//D01OTRFC deleteRFC = new D01OTRFC();
                        rfc.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = rfc.delete(  firstData.PERNR, AINF_SEQN );

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });
                
			} else {
				throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}

			Logger.debug.println(this, "#####	dest = " + dest);

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			
		}
	}

}
