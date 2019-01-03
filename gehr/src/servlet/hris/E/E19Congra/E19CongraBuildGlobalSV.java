/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name		: Benefit Management
/*   Program Name	: Celebration & Condolence
/*   Program ID		: E19CongraBuildSV
/*   Description 		: �������� ��û�� �� �ֵ��� �ϴ� Class
/*   Note				: ����
/*   Creation			: 2001-12-19  �輺��
/*   Update				: 2005-02-14  �̽���
/*                  	    : 2005-03-07  ������
/*                         : 2006-06-20  @v1.1     üũ�����߰�
/*   Update       		: 2007-10-23  li hui
/*  						: 2008-11-03  ������  @v1.2  [C20081031_51421] �������� ���谡�� ���� ��û ���� ����.(LG CCI����)
/* 						: 2012-03-22 @v1.3  [C20120319_72347]
 * 							: 2012-03-28   @v1.3  [C20120328_77486]
 *	 						��2013-03-19 lixinxin  @v1.4   CSR��C20130315_92423
 * 							: 2013-03-22 lixinxin  @v1.5  [CSR:C20130321_96652]
 * 							��2013-03-25 lixinxin  @v1.6  [CSR:C20130325_98054 ]
 * 							��2014-03-10 dongxiaomian  @v1.7  [C20140304_97739]
 */
/********************************************************************************/
package servlet.hris.E.E19Congra;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E19Congra.E19CongcondData2;
import hris.E.E19Congra.E19CongcondGlobalData;
import hris.E.E19Congra.rfc.E19CongraRFC;
import hris.E.E19Congra.rfc.E19CongraRequestGlobalRFC;
import hris.common.AccountData;
import hris.common.AppLineData;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.PersonData;
import hris.common.PhoneNumData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.db.AppLineDB;
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.rfc.PhoneNumRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E19CongraBuildGlobalSV extends ApprovalBaseServlet {

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


		try {

            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);
            String dest;

            String jobid = box.get("jobid", "first");
			//Logger.debug.println("##### getRemoteAddr	:	" + req.getRemoteAddr());
			//Logger.debug.println("##### getRemoteHost	:	" + req.getRemoteHost());
			HttpSession session = req.getSession(false);

			final String PERNR = getPERNR(box, user); //��û����� ���


            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
             req.setAttribute("PersonData" , phonenumdata );

			if (jobid.equals("first")) {

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

				if (phonenumdata.E_RECON.equals("")) {
					// ����
					getApprovalInfo(req, PERNR);
				} else {
					// ������ �����϶��� �������� �Ϸ��� ��¥�� I_DATE �� �־��ش�. 2005.04.15 �߰�
                    String reday = DataUtil.removeStructur(phonenumdata.E_REDAY, "-");
                    getApprovalInfo(req, PERNR,DataUtil.addDays(reday, -1));
				}

				E19CongraRFC rfc_congra = new E19CongraRFC();
				//CodeEntity codeEntity = new CodeEntity();

				// ���� ����
				Vector famyCode = rfc_congra.getEntryCode(PERNR, "", "");
				Vector famyCode1 = (Vector) famyCode.get(0);
				CodeEntity famyCode2	= (CodeEntity) famyCode1.get(0);
				String famy = famyCode2.code;

				// ���� ����
				Vector famy_Code = rfc_congra.getEntryCode(PERNR, "", famy);
				Vector famy_Code1 = (Vector) famy_Code.get(1);
				E19CongcondData2 famy_Code2 = (E19CongcondData2) famy_Code1.get(0);
				String famy_Code3 = famy_Code2.FAMY_CODE;
//				2013-03-19 lixinxin  @v1.4  CSR��C20130315_92423
				//Vector e19CongraData = rfc_congra.getCongraDetail(PERNR, "5", "", "", "");
				Vector<E19CongcondGlobalData> ve19CongraData = rfc_congra.getCongraDetail(PERNR, "5", "", "", "","");

				E19CongcondGlobalData e19CongraData = Utils.indexOf(ve19CongraData, 0, E19CongcondGlobalData.class);
//				2013-03-19 lixinxin  @v1.4  CSR��C20130315_92423

				//Vector famyCode3 = rfc_congra.getEntryCode(PERNR, "", famy);
				//String uname = rfc_congra.getName(PERNR, "", "");

				// 2003.02.20 - �������� �ߺ���û�� .jsp���� �������ؼ� �߰���.
				// e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList(PERNR);

				AccountData AccountData_hidden = new AccountData();
				DataUtil.fixNull(AccountData_hidden);

				//req.setAttribute("uname", uname);
				req.setAttribute("PERNR", PERNR);
				req.setAttribute("famyCode", famyCode);
				//req.setAttribute("famyCode3", famyCode3);
				req.setAttribute("e19CongraData", e19CongraData);
				req.setAttribute("AccountData_hidden", AccountData_hidden);
				// req.setAttribute("e19CongraDupCheck_vt", e19CongraDupCheck_vt);


				SimpleDateFormat sdf = new SimpleDateFormat("MMdd");
				String cutSysTime=sdf.format(new Date());
				int now= Integer.parseInt(cutSysTime);
				if(now>=321 && now<=325){
					dest = WebUtil.JspURL + "E/E19Congra/Temporary.jsp";
				}else{
					dest = WebUtil.JspURL + "E/E19Congra/E19CongraBuild_Global.jsp";
				}

            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, E19CongcondGlobalData.class, new RequestFunction<E19CongcondGlobalData>() {
                    public String porcess(E19CongcondGlobalData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {



                        /* ���� ��û RFC ȣ�� */
                    	E19CongraRequestGlobalRFC e19CongraRequestGlobalRFC = new E19CongraRequestGlobalRFC();
                    	e19CongraRequestGlobalRFC.setRequestInput(user.empNo, UPMU_TYPE);

                        String AINF_SEQN = e19CongraRequestGlobalRFC.build(PERNR,  inputData.CELTY,
                    			inputData.FAMSA, inputData.FAMY_CODE,
                    			inputData.CELDT,  Utils.asVector(inputData), box, req);


                        if(!e19CongraRequestGlobalRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e19CongraRequestGlobalRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
            } else {
                throw new GeneralException("���θ��(jobid)�� �ùٸ��� �ʽ��ϴ�. ");
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}