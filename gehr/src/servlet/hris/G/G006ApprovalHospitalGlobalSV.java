/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: HR Approval Box
/*   2Depth Name  	: Requested Document
/*   Program Name 	: Medical Fee Approval
/*   Program ID   		: G006ApprovalHospitalSV
/*   Description  		: �Ƿ�� ��û �μ���, �����, ���μ��� ����/�ݷ� Class
/*   Note         		:
/*   Creation    		: 2005-03-14 �̽���
/*   Update       		: 2005-10-28 LSA	 @v1.1 [C2005102601000000764] �ڳ��� ��쿡 300�����ѵ�üũ������ ���� �־� �߰���
/*   Update				: 2009-05-22 jungin @v1.2 [C20090514_56175] ���谡�� ���� 'ZINSU' �ʵ� �߰�.
/********************************************************************************/

package servlet.hris.G;

import hris.E.Global.E17Hospital.E17HospitalDetailData1;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC;

import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.CurrencyChangeRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G006ApprovalHospitalGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "11"; // ���� ����Ÿ��(�Ƿ��)
	private String UPMU_NAME = "Medical Fee";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);

            final WebUserData user  = (WebUserData)session.getAttribute("user");
            final Box box = WebUtil.getBox(req);

            String dest	= "";
            String ZINSU = "";

            String jobid	= box.get("jobid");
            String PERNR = box.get("PERNR", user.empNo);// getPERNR(box, user); //��û����� ���
			//box.put("PERNR", PERNR);
            //Logger.debug.println(this, "#####	PERNR222**===" + PERNR );
            String AINF_SEQN  = box.get("AINF_SEQN");

            final E17HospitalDetailRFC e17Rfc = new E17HospitalDetailRFC();
			E17HospitalDetailData1 e17SickData = null;
			Vector vcResult = null;

			e17Rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
			vcResult = e17Rfc.getMediDetail(PERNR, ZINSU, AINF_SEQN, "1");

			 //Logger.debug.println(this, "#####	vcResult**===" + vcResult );

			e17SickData = (E17HospitalDetailData1) vcResult.get(0);

			/* ���� �� */
            if("A".equals(jobid)) {

                /* ������ ���� �� */
                dest = accept(req, box, "T_ZHR0038T", e17SickData, e17Rfc, new ApprovalFunction<E17HospitalDetailData1>() {
                    public boolean porcess(E17HospitalDetailData1 inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* ������ ���� ���� */
                        //if(approvalHeader.isEditManagerArea()) {

                            box.copyToEntity(inputData);  //����ڰ� �Է��� ����Ÿ�� ������Ʈ
                            inputData.UNAME			= user.empNo;
                            inputData.AEDTM   		= DataUtil.getCurrentDate();

                            CurrencyChangeRFC rfc2 = new CurrencyChangeRFC();

                            inputData.CERT_BETG_C = rfc2.getCurrencyChange(inputData.WAERS, inputData.WAERS1, inputData.CERT_BETG);
                            inputData.PAMT	= Double.toString(Double.parseDouble(inputData.PAMT) + Double.parseDouble(inputData.CERT_BETG_C));

                            //Logger.debug.println(this, "#####	inputData PERNR**===" + inputData.PERNR );
                            //Logger.debug.println(this, "#####	inputData**===" + inputData );

                        //}

                        return true;
                    }
                });
            /* �ݷ��� */
            } else if("R".equals(jobid)) {

            	dest = reject(req, box, null, e17SickData, e17Rfc, null);

            } else if("C".equals(jobid)) {

            	dest = cancel(req, box, null, e17SickData, e17Rfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            //Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            //Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }

	}
}