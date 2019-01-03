/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Time Management
/*   Program Name 	: Duty
/*   Program ID   		: D19DutyChangeSV
/*   Description 		: ����(Duty)�� ���� �� �� �ֵ��� �ϴ� Class
/*   Note        		:
/*   Creation     		: 2002-01-21 �ڿ���
/*   Update       		: 2005-03-07 ������
/*   Update				: 2007-10-09 huang peng xiao
/*                  		: 2008-06-18 ������ @v1.0 ��û�� ���ݱݾ�(BETRG/WAERS/LGART) �ʼ� �ʵ�
/********************************************************************************/

package servlet.hris.D.D19Duty;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D19Duty.D19DutyData;
import hris.D.D19Duty.rfc.D19DutyRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class D19DutyChangeSV extends ApprovalBaseServlet {

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

			HttpSession session = req.getSession(false);
			final WebUserData user = (WebUserData) session.getAttribute("user");
			final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR =  box.get("PERNR", user.empNo); //getPERNR(box, user); //��û����� ���

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
			String AINF_SEQN = box.get("AINF_SEQN");

			D19DutyRFC d19Rfc = new D19DutyRFC();
			d19Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput
			D19DutyData firstData = new D19DutyData();

			Vector D01OTData_vt = null;
			UPMU_TYPE = box.get("UPMU");

			Logger.debug.println(this, "#####	UPMU_TYPE	:	[ " + UPMU_TYPE + " ]");

			D01OTData_vt = d19Rfc.getDetail(AINF_SEQN, PERNR);
			firstData = (D19DutyData) D01OTData_vt.get(0);

			// �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

			if (jobid.equals("first")) {
				D19DutyData d19Data  = ( D19DutyData )D01OTData_vt.get(0);

				req.setAttribute("isUpdate", true); //��� ���� ����
				req.setAttribute("resultData", d19Data);

				detailApporval(req, res, d19Rfc);

				printJspPage(req, res, WebUtil.JspURL + "D/D19Duty/D19DutyChange.jsp");

			} else if (jobid.equals("change")) {

				/* ���� ��û �κ� */
				dest = changeApproval(req, box, D19DutyData.class, d19Rfc, new ChangeFunction<D19DutyData>(){

					public String porcess(D19DutyData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						inputData.PERNR  = inputData.PERNR;
        				inputData.ZPERNR = inputData.ZPERNR;    // ��û�� ���(�븮��û, ���� ��û)
        				inputData.UNAME  = user.empNo;          // ������ ���(�븮��û, ���� ��û)
    	                inputData.AEDTM  = DataUtil.getCurrentDate();  // ������(���糯¥)

    	              //**************************************************************************************
    					//��û�� ���ݱݾ�(BETRG/WAERS/LGART) �ʼ� �ʵ�.		2008-06-18		������
    					Logger.debug.println("#####	BETRG	:	[ "	+	box.getString("BETRG")  + " ]");
    					Logger.debug.println("#####	WAERS	:	[ "	+	box.getString("WAERS") + " ]");

    					inputData.BETRG 	= box.getString("BETRG");
    					inputData.WAERS 	= box.getString("WAERS");
    					//**************************************************************************************

                    	box.put("I_GTYPE", "3");

                    	/* ���� ��û RFC ȣ�� */
                    	D19DutyRFC changeRFC = new D19DutyRFC();
                		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(inputData, box, req);
                        //rfc.change(ainf_seqn, firstData.PERNR, D01OTData_vt);

                    	Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn().isSuccess() );
                        Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn() );

                        if(!changeRFC.getReturn().isSuccess()) {
                        	 throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }
                        return inputData.AINF_SEQN;

                        /* ������ �ۼ� �κ� �� */
                    }
                });

				 printJspPage(req, res, dest);

			} else {
				 throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}

		} catch (Exception e) {
			throw new GeneralException(e);
		}

	}
}
