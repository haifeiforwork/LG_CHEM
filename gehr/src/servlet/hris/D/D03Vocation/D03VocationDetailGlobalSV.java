/********************************************************************************/
/*                                                                              */
/*   System Name  	: MSS                                                         */
/*   1Depth Name  	: ��û                                                        */
/*   2Depth Name  	: ����                                                        */
/*   Program Name 	: �ް� ��                                                   */
/*   Program ID   		: D03VocationDetailSV                                         */
/*   Description  		: �ް� ��ȸ/���� �Ҽ� �ֵ��� �ϴ� Class                       */
/*   Note         		:                                                             */
/*   Creation     		: 2002-01-04  �赵��                                          */
/*   Update       		: 2005-03-04  �����                                          */
/*   Update       		: 2008-01-11  ������                                          							*/
/*                           �����ް� Ÿ���� ȥ��,���� ��� ��û����ڸ� ����.                       */
/*   Update       		: 2008-02-20  ������                                          							*/
/*                      	   �ް������� ���� selectbox �����ڵ带 �����´�.                        	*/
/*                          : 2017-04-17 ������ [CSR ID:3359686]   ���� ���� 5������        */
/********************************************************************************/
package servlet.hris.D.D03Vocation;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationGlobalRFC;
import hris.D.D03Vocation.rfc.D03VocationGlobalRFC;
import hris.D.rfc.D17HolidayTypeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationDetailGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "02"; // ���� ����Ÿ��(�ް���û)

	private String UPMU_NAME = "Leave";

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
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest 	  			= "";
			String jobid   			= "";
			String UPMU_CODE 	= "";

            /**         * Start: ������ �б�ó�� */
            String fdUrl = ".";
            if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL ������, DE ���� �� ����ȭ������
        	   fdUrl = "hris.D.D03Vocation.D03VocationDetailEurpSV";
			}

           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );

            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl );
		       	return;
           }
            /**             * END: ������ �б�ó��             */

			final Box box = WebUtil.getBox(req);

			jobid = box.get("jobid", "first");


			//********************************************
			//�ް������� ���� selectbox �����ڵ�.(value1)		2008-02-20.
			UPMU_CODE =  box.get("TMP_UPMU_CODE", UPMU_TYPE);
			//********************************************

			final String AINF_SEQN = box.get("AINF_SEQN");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����


			Logger.debug.println(this, "USER	 :	[ " + user.toString() + " ]");
			Logger.debug.println(this, "	UPMU_TYPE	 :	[ " + UPMU_TYPE + " ]");
			Logger.debug.println(this, "	I_APGUB	 :	[ " + I_APGUB + " ]");

			//*********���� ���� (20050304:�����)**********
			final D03VocationGlobalRFC rfc = new D03VocationGlobalRFC();
			// D03VocationData d03VocationData = new D03VocationData();

			Vector d03VocationData_vt = null;
			// final String PERNR =  box.get("PERNR", user.empNo); // 2016/11/30 �ۼ��ڷ� ���ͼ� ó���ȵ�.


            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

			// �ް���û ��ȸ
			d03VocationData_vt = rfc.getVocation(user.empNo, AINF_SEQN);
			final String PERNR =  rfc.getApprovalHeader().PERNR; //getPERNR(box, user); //
			final D03VocationData firstData = (D03VocationData) d03VocationData_vt.get(0);
			Logger.debug.println(this, "JOBID	 :	[ " + jobid + " ]	/	PERNR	 :	[ " + PERNR + " ]");
			Logger.debug.println(this, "JOBID	 :	[ " + jobid + " ]	d03VocationData_vt	 :	[ " + d03VocationData_vt.toString() + " ]");

			// �븮 ��û �߰�
//			PhoneNumRFC numfunc = new PhoneNumRFC();
//			PhoneNumData phonenumdata = null;
//			phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);
//			req.setAttribute("PhoneNumData", phonenumdata);

            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

			String P_STDAZ = box.get("P_STDAZ");
			String I_STDAZ = box.get("I_STDAZ");

			// **********���� ��.****************************

			if (jobid.equals("first")) {

				// ������ �ܿ��ް��ϼ� ��ȸ
				D03RemainVocationGlobalRFC rfcRemain = new D03RemainVocationGlobalRFC();
				Vector D03RemainVocationData_vt = null;
//				D03RemainVocationData_vt = rfcRemain.getRemainVocation(firstData.PERNR, firstData.BEGDA, firstData.AWART);
				D03RemainVocationData_vt = rfcRemain.getRemainVocation(firstData.PERNR, firstData.APPL_TO, firstData.AWART);
				firstData.ANZHL_BAL = ((D03RemainVocationData) D03RemainVocationData_vt.get(0)).ANZHL_BAL;
				D03RemainVocationData d03RemainVocationData  =((D03RemainVocationData) D03RemainVocationData_vt.get(0));

				req.setAttribute("d03VocationData_vt", d03VocationData_vt);
				req.setAttribute("d03RemainVocationData", d03RemainVocationData);



                //-------- ���±Ⱓ�Ϸ�Ȱ���  check (li hui)----------------------
				D01OTCheckGlobalRFC rfc2 = new D01OTCheckGlobalRFC();
				String upmu_type = "02";		//---�ް� ����Ÿ�� -- D03VocationBuild ���� �ް�����Ÿ�Ժ��� �ٸ�
				Vector holidayVT = new D17HolidayTypeRFC().getHolidayType(firstData.PERNR);

			        for (int i = 0; i < Utils.getSize(holidayVT); i++) {
			            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity) holidayVT.get(i);
			            if (firstData.AWART.equals(ck.code)) {
			            	upmu_type = ck.value1;
			            }
			        }

	                //[CSR ID:3359686]   ���� ���� 5������ START
	                rfc2.checkApprovalPeriod(req,firstData.PERNR,"A", firstData.APPL_FROM,   upmu_type,  firstData.AWART );
	                req.setAttribute("E_7OVER_NOT_APPROVAL", rfc2.getReturn().MSGTY);
	                //[CSR ID:3359686]   ���� ���� 5������  END


				String flag = rfc2.check1(firstData.PERNR, firstData.APPL_FROM,upmu_type);

				Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	flag	 :	[ " + flag + " ]  upmu_type: "+ upmu_type);

				req.setAttribute("flag" ,flag );

                if (!detailApporval(req, res, rfc))                    return;
				dest = WebUtil.JspURL
						+ "D/D03Vocation/D03VocationDetail_Global.jsp?I_STDAZ=" + I_STDAZ + "&P_STDAZ=" + P_STDAZ + "";

			} else if (jobid.equals("delete")) {

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

				// �ް���û ����
				//rfc = new D03VocationGlobalRFC();

				// ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
				// 2002.07.25.---------------------------------------------------------------------------
/*
				con = DBUtil.getTransaction();

				AppLineDB appDB = new AppLineDB(con);

				if (appDB.canUpdate(appLine)) {

					appDB.delete(appLine);

					rfc.delete(firstData.PERNR, AINF_SEQN);
					con.commit();

					// **********���� ���� (20050223:�����)**********
					// ��û�� ������ ���� ������.
					appLine = (AppLineData) AppLineData_vt.get(0);

					// ������ ����� �� ������ ,ElOffice ���� ���̽�
					phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);
					Properties ptMailBody = new Properties();

					ptMailBody.setProperty("SServer", user.SServer); 							// ElOffice ���� ����
					ptMailBody.setProperty("from_empNo", user.empNo); 						// �� �߼��� ���
					ptMailBody.setProperty("to_empNo", appLine.APPL_APPU_NUMB); 		// �� ������ ���
					ptMailBody.setProperty("ename", phonenumdata.E_ENAME); 			// (��)��û�ڸ�
					ptMailBody.setProperty("empno", phonenumdata.E_PERNR); 				// (��)��û�� ���
					ptMailBody.setProperty("UPMU_NAME", "Leave"); 							// ���� �̸�
					ptMailBody.setProperty("AINF_SEQN", AINF_SEQN); 						// ��û�� ����

					// �� ����
					StringBuffer sbSubject = new StringBuffer(512);

					sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
					sbSubject.append(ptMailBody.getProperty("ename")
											+ " deleted an application of "
											+ ptMailBody.getProperty("UPMU_NAME") + ".");


					ptMailBody.setProperty("subject", sbSubject.toString());
					ptMailBody.setProperty("FileName", "NoticeMail5.html");

					String msg2 = null;


					try {
						DraftDocForEloffice ddfe = new DraftDocForEloffice();
						ElofficInterfaceData eof = ddfe.makeDocForRemove(
								AINF_SEQN, user.SServer, ptMailBody
										.getProperty("UPMU_NAME"),
								firstData.PERNR, appLine.APPL_APPU_NUMB);

						Vector vcElofficInterfaceData = new Vector();
						vcElofficInterfaceData.add(eof);
						req.setAttribute("vcElofficInterfaceData",
								vcElofficInterfaceData);
						dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
					} catch (Exception e) {
						dest = WebUtil.JspURL + "common/msg.jsp";
						msg2 = msg2 + "\\n" + " Eloffic Connection Failed.";
					} // end try

					String msg = "msg003";
					String url;

					// ���� ������ ������ �������� �̵��ϱ� ���� ����
					if (RequestPageName != null && !RequestPageName.equals("")) {
						url = "location.href = '"
								+ RequestPageName.replace('|', '&') + "';";
					} else {
						url = "location.href = '" + WebUtil.ServletURL
								+ "hris.D.D03Vocation.D03VocationBuildSV';";
					} // end if
					// **********���� ��.****************************

					req.setAttribute("msg", msg);
					req.setAttribute("url", url);

				} else {
					String msg = "msg005";
					String url = "location.href = '"
							+ WebUtil.ServletURL
							+ "hris.D.D03Vocation.D03VocationDetailSV?AINF_SEQN="
							+ AINF_SEQN + "&PERNR=" + PERNR + "';";
					req.setAttribute("msg", msg);
					req.setAttribute("url", url);
					dest = WebUtil.JspURL + "common/msg.jsp";
				}
				*/

			} else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}

			Logger.debug.println(this, "JOBID	 :	[ " + jobid + " ]	destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			DBUtil.close(con);
		}
	}
}