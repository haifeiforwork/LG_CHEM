/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name		: Benefit Management
/*   Program Name	: Celebration & Condolence
/*   Program ID		: E19CongraChangeSV
/*   Description 		: �������� ������ �� �ֵ��� �ϴ� Class
/*   Note         		: ����
/*   Creation     		: 2001-12-19  �輺��
/*   Update       		: 2005-02-14  �̽���
/*                  		: 2005-02-24  ������
/*   Update       		: 2008-11-03  ������  @v1.2  [C20081031_51421] �������� ���谡�� ���� ��û ���� ����.(LG CCI����)
/********************************************************************************/

package servlet.hris.E.E19Congra;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.E.E19Congra.E19CongcondGlobalData;
import hris.E.E19Congra.rfc.E19CongraRFC;
import hris.E.E19Congra.rfc.E19CongraRequestGlobalRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.Vector;

public class E19CongraChangeGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE	= "06";	// ���� ����Ÿ��(������)

	private String UPMU_NAME	= "Celebration & Condolence";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		Connection con = null;

		try {
			final WebUserData user = WebUtil.getSessionUser(req);
			 final Box box = WebUtil.getBox(req);


			 String dest;

	            String jobid = box.get("jobid", "first");
	            String AINF_SEQN = box.get("AINF_SEQN");

	            //**********���� ��.****************************

	            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����



	            /* �ڰ� ���� ��ȸ */
	            final E19CongraRequestGlobalRFC e19CongraRequestGlobalRFC = new E19CongraRequestGlobalRFC();
	            e19CongraRequestGlobalRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

	            Vector<E19CongcondGlobalData> resultList = e19CongraRequestGlobalRFC.getDetail(); //��� ����Ÿ
	            E19CongcondGlobalData e19CongcondData = Utils.indexOf(resultList, 0);

				 final String PERNR =e19CongcondData.PERNR;

	            PersonInfoRFC numfunc = new PersonInfoRFC();
	            final PersonData phonenumdata;
	            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
	             req.setAttribute("PersonData" , phonenumdata );
				req.setAttribute("PERNR", PERNR);
				E19CongraRFC rfc_congra = new E19CongraRFC();
				Vector famyCode = rfc_congra.getEntryCode(PERNR, "", "0001");
	            Vector  Code_vt0 = (Vector) Utils.indexOf(famyCode, 0);
	            Vector  Code_vt3  = (Vector) Utils.indexOf(famyCode, 3);

	            if( jobid.equals("first") ) {  //����ó�� ���� ȭ�鿡 ���°��.
	                req.setAttribute("e19CongraData", e19CongcondData);

	                req.setAttribute("isUpdate", true); //��� ���� ����
					req.setAttribute("famyCode", famyCode);
	                req.setAttribute("Code_vt0", Code_vt0);
	                req.setAttribute("Code_vt3", Code_vt3);
	                detailApporval(req, res, e19CongraRequestGlobalRFC);

	                printJspPage(req, res, WebUtil.JspURL + "E/E19Congra/E19CongraBuild_Global.jsp");

	            } else if( jobid.equals("change") ) {

	                /* ���� ��û �κ� */
	                dest = changeApproval(req, box, E19CongcondGlobalData.class, e19CongraRequestGlobalRFC, new ChangeFunction<E19CongcondGlobalData>(){

	                    public String porcess(E19CongcondGlobalData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {


	                        /* ���� ��û RFC ȣ�� */
	                    	E19CongraRequestGlobalRFC changeRFC = new E19CongraRequestGlobalRFC();
	                    	changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

	                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

	                        changeRFC.build(inputData.PERNR,  inputData.CELTY,
	                    			inputData.FAMSA, inputData.FAMY_CODE,
	                    			inputData.CELDT,  Utils.asVector(inputData), box, req);

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

	        } catch(Exception e) {
	            throw new GeneralException(e);
	        }
		}
	}


