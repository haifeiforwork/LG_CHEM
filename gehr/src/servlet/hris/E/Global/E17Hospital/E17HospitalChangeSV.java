/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Benefit Management
/*   Program Name 	: Medical Fee
/*   Program ID   		: E17HospitalChangeSV
/*   Description  		: �Ƿ�� ��û ������ �ϴ� Class
/*   Note         		:
/*   Creation    		: 2002-01-08 �輺��
/*   Update       		: 2005-02-23 ������
/*                  		: 2005-12-27 @v1.1 [C2005121301000001097] �ſ�ī��/���ݱ����߰�
/*   Update				: 2009-05-18 jungin @v1.2 [C20090514_56175] ���谡�� ���� 'ZINSU' �ʵ� �߰�.
/********************************************************************************/

package servlet.hris.E.Global.E17Hospital;

import hris.E.Global.E17Hospital.E17HospitalDetailData1;
import hris.E.Global.E17Hospital.rfc.E17HospitalCodeRFC;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC01;
import hris.E.Global.E17Hospital.rfc.E17HospitalFmemberRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.CurrencyChangeRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.rfc.RepeatCheckRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.StringUtil;
import com.sns.jdf.util.WebUtil;

public class E17HospitalChangeSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "11"; // ���� ����Ÿ��(�Ƿ��)
	private String UPMU_NAME = "Medical Fee";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res)	throws GeneralException {

		try {
			HttpSession session = req.getSession(false);

			final WebUserData user = WebUtil.getSessionUser(req);

			String dest 		= "";

			final Box box = WebUtil.getBox(req);

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

			String jobid = box.get("jobid","first");

			String PERNR = getPERNR(box, user); //��û����� ���
			box.put("PERNR",PERNR);

			String ZINSU = box.get("ZINSU");

			Vector E17HospitalData_vt	= null;

			String AINF_SEQN = box.get("AINF_SEQN");

			//Logger.debug.println(this, "[#####]	AINF_SEQN	:	[" + AINF_SEQN + "]");

			final E17HospitalDetailRFC e17Rfc = new E17HospitalDetailRFC();
			E17HospitalCodeRFC e17Code = new E17HospitalCodeRFC();
			E17HospitalFmemberRFC e17member = new E17HospitalFmemberRFC();
			E17HospitalDetailData1 e17SickData = null;
			Vector vcResult = null;

			e17Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
			vcResult = e17Rfc.getMediDetail(PERNR, ZINSU, AINF_SEQN, "1");

			e17SickData = (E17HospitalDetailData1) vcResult.get(0);
			String wtem = e17SickData.WAERS;

			Logger.debug.println(this, "vcResult="+vcResult);

			// �븮 ��û �߰�
			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e17SickData.PERNR);
			req.setAttribute("PersonData", phonenumdata);

			req.setAttribute("ZINSU", ZINSU);

			//--2016.11.18------start--
			E17HospitalDetailRFC01 rfc01=new E17HospitalDetailRFC01();
			final Vector E17HdataFile_vt = rfc01.getMediDetail01(e17SickData.PERNR, AINF_SEQN, "M", "1");
			req.setAttribute("E17HdataFile_vt", E17HdataFile_vt);
			//--2016.11.18--------end--

			if (jobid.equals("first")) { // ����ó�� ��û ȭ�鿡 ���°��.

			    req.setAttribute("isUpdate", true); //��� ���� ����
			    req.setAttribute( "pageKind", "change"); // change

			    Vector mediCodeList = e17Code.getMediCode();
				Vector memberList = e17member.getCodeVector(PERNR);

				req.setAttribute("mediCodeList", mediCodeList);
				req.setAttribute("memberList", memberList);
				req.setAttribute("wtem", wtem);
			    req.setAttribute("resultData", e17SickData);

			    req.setAttribute("PERNR", PERNR);

				detailApporval(req, res, e17Rfc);

				double COMP_sum = 0.0;

				// �������׸� ���Ϳ� ������꼭 ������ �����͸� ��ġ ��Ŵ
				req.setAttribute("last_RCPT_NUMB", "");
				req.setAttribute("e17SickData", e17SickData);
				req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
				req.setAttribute("COMP_sum", Double.toString(COMP_sum));

				printJspPage(req, res, WebUtil.JspURL + "E/E17Hospital/E17HospitalBuild_Global.jsp");

			} else if (jobid.equals("change")) {

				/* ���� ��û �κ� */
				dest = changeApproval(req, box, E17HospitalDetailData1.class, e17Rfc, new ChangeFunction<E17HospitalDetailData1>(){

					public String porcess(E17HospitalDetailData1 inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        inputData.PLIMIT			= box.get("PLIMIT");
                    	inputData.CERT_BETG	= box.get("EXPENSE");

                    	if( StringUtil.isNull(inputData.PAAMT_BALANCE) ){
                    		inputData.PAAMT_BALANCE = "0";
                    	}

                    	inputData.PAMT 		    = Double.toString(Double.parseDouble(inputData.PAAMT_BALANCE)+Double.parseDouble(inputData.CERT_BETG_C));
                    	inputData.PERNR_D		= user.empNo;
                    	inputData.ZPERNR 		= user.empNo;

                    	String liness = box.get("LLINESS");
        				if(liness.length()<=70){
        					inputData.LLINESS1= liness.substring(0,liness.length()) ;
        				}
        				if(liness.length()>70 && liness.length()<= 140){
        					inputData.LLINESS1 = liness.substring(0,70) ;
        					inputData.LLINESS2 = liness.substring(70,liness.length()) ;
        				}
        				if(liness.length()>140){
        					inputData.LLINESS1 = liness.substring(0,70) ;
        					inputData.LLINESS2 = liness.substring(70,140) ;
        					inputData.LLINESS3 = liness.substring(140,liness.length()) ;
        				}

        				//inputData.AINF_SEQN 	= AINF_SEQN;
                    	box.put("ZINSU", inputData.ZINSU);
                    	box.put("I_GTYPE", "3");
                    	box.put("BEGDA", inputData.BEGDA);
                    	box.put("WAERS", inputData.WAERS);

                    	/* ���� ��û RFC ȣ�� */
                    	E17HospitalDetailRFC changeRFC = new E17HospitalDetailRFC();

                		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req, E17HdataFile_vt);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                       // Logger.debug.println(this, "====e17Rfc.getReturn().isSuccess()======== : " +  e17Rfc.getReturn().isSuccess() );
                       // Logger.debug.println(this, "====e17Rfc.getReturn().isSuccess()======== : " +  e17Rfc.getReturn() );

                        return inputData.AINF_SEQN;

                        /* ������ �ۼ� �κ� �� */
                    }
                });

				 printJspPage(req, res, dest);

			} else {
				throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}

			Logger.debug.println(this, " destributed = " + dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
}
