/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Time Management
/*   Program Name 	: Overtime
/*   Program ID   		: D01OTBuildSV
/*   Description  		: �ʰ��ٹ�(OT/Ư��)��û�� �ϴ� Class
/*   Note         		:
/*   Creation     		: 2002-01-15 �ڿ���
/*   Update       		: 2005-03-07 ������
/*   Update       		: 2007-09-12 huang peng xiao
 * 							: 2008-05-27 ������ [C20080514_66017] @v1.0 PhoneNumData
 * 							: 2008-11-26 ������ [C20081125_62978] @v1.1 DAGU���� OT��û �����ð� üũ
 *							: 2011-02-24 liukuo @v2.1 [C20110221_28931] LGCC NJ
 *							: 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170*/
/*                         : 2016-09-21 ���ձ��� - ���ö                      */
/*                         : 2017-03-20 ������  [CSR ID:3303691]  ���Ľ�û���� �����߰�                      */
/*					        : 2017-04-03 ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ����*/
/*					        : 2017-04-19 ������  [CSR ID:3359686]   ���� ���� 5������*/
/*					        : 2017-08-24 ������  ���³�� ��������							*/
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.sql.Connection;
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

import hris.D.D01OT.D01OTCheckData;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D010TOvertimeGlobalRFC;
import hris.D.D01OT.rfc.D01OTCheck1RFC;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTGetMonthRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTReasonRFC;
import hris.D.Global.D02ConductDisplayMonthData;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.Global.D02ConductDisplayMonthRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

public class D01OTBuildGlobalSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="01";
    private String UPMU_NAME = "OverTime";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
	protected void performTask(final HttpServletRequest req, final HttpServletResponse res)
			throws GeneralException {
		Connection con = null;

		try {
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest	= "";

			final Box box = WebUtil.getBox(req);

			final String jobid = box.get("jobid", "first");
            boolean isUpdate= box.getBoolean("isUpdate");
            if(isUpdate!=true)isUpdate=false;

			final String PERNR = getPERNR(box, user); //��û����� ���     <==box.get("PERNR", user.empNo);

			//Logger.debug.println(this, "#####	box	:	[ " + box.toString() + " ]");
			//Logger.debug.println(this, "#####	user	:	[ " + user.toString() + " ]");
			//Logger.debug.println(this, "#####	jobid	:	[ " + jobid + " ]	/	PERNR :	[ " + PERNR + " ]");

			// �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            final D01OTCheckGlobalRFC checkGlobalRfc = new D01OTCheckGlobalRFC();

//			 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170 start
			D01OTReasonRFC rfc_reasontype = new D01OTReasonRFC();
			Vector d01OTReasonData_vt = rfc_reasontype.getTypeCode(PERNR);
			Logger.debug.println(this, "d01OTReasonData_vt" + d01OTReasonData_vt.toString());
			req.setAttribute("reasonCode", d01OTReasonData_vt);
//			2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170 end

            req.setAttribute("PersonData" , phonenumdata );

			req.setAttribute("E_BUKRS", phonenumdata.E_BUKRS);

			req.setAttribute("E_JIKKB", phonenumdata.E_JIKKB);
            req.setAttribute("PERNR" , PERNR );
			req.setAttribute("ZMODN",PERNR);	//GHR���� build.JSP�ܿ� pernr�� �־�ξ �׳� �־��
			req.setAttribute("FTKLA",PERNR);	// Change.jsp���� servlet���� �Ѱܹ���.

            req.setAttribute("committed", "N"); // check already response 2017/1/3 ksc

			if (jobid.equals("first")) {

				Vector D01OTData_vt = new Vector();
				D01OTData data = new D01OTData();

				box.copyToEntity(data);
				data.PERNR = PERNR;
				DataUtil.fixNull(data);

				D01OTData_vt.addElement(data); // ������ Ŭ���̾�Ʈ�� �ǵ�����.
				req.setAttribute("D01OTData_vt", D01OTData_vt);

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);    //<-- �ݵ�� �߰�

				req.setAttribute("jobid", jobid);

				D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
				Vector OTHDDupCheckData_vt = null;
				OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(PERNR,UPMU_TYPE, user.area);

//				 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170 start
				req.setAttribute("d01OTReasonData_vt", d01OTReasonData_vt);
				// 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170 end

				req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
//				Logger.debug.println(this, "OTHDDupCheckData_vt : " + OTHDDupCheckData_vt.toString());

				dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_Global.jsp";

			} else if (jobid.equals("getApp")) {

				String BEGDA	= req.getParameter("WORK_DATE");
				String STDAZ	= req.getParameter("STDAZ");
				String beforeSTDAZ	= req.getParameter("beforeSTDAZ");
				String BEGUZ	= req.getParameter("BEGDA");
				String PERNR1	= req.getParameter("PERNR");

				Logger.debug.println("#####	BEGDA		:	[ " + BEGDA	+ " ]");
				Logger.debug.println("#####	BEGUZ		:	[ " + BEGUZ	+ " ]");
				Logger.debug.println("#####	STDAZ		:	[ " + STDAZ	+ " ]");
				//*******************************************************************************
				// DAGU���� ���� E_ANZHL üũ.	2008-11-26		������		[C20081125_62978] @v1.1
				String IFlag		= "N";		// ��û�ô� 'N', �����ô� 'Y'

				D010TOvertimeGlobalRFC rfc = new D010TOvertimeGlobalRFC();
				String E_ANZHL = rfc.check(PERNR, BEGDA, IFlag); // �ѿ���ð�; SAP�� G180, G450�� ��� ���ϱٷνð��� �����ԵǾ�����.(2017/1/12Ȯ��)

				Vector AppLineData_vt = null;
				String hours = String.valueOf(Double.parseDouble(E_ANZHL)
//						- (isUpdate ? Double.parseDouble(beforeSTDAZ) : 0) // ������ �����ð��� ���ش�.2017/1/13 ksc // JSP���� ó��
						+ Double.parseDouble(STDAZ));

				//get work days -- liukuo add 2011.3.4
				//String workDays ="2";
//				String v_beguz = BEGUZ.substring(0,4)+BEGUZ.substring(5,7)+BEGUZ.substring(8,10);
				String v_beguz = BEGUZ;
				String ret_val = rfc.getWorkDays(PERNR, BEGDA,v_beguz);
				String workDays = String.valueOf(ret_val );
				//  get monthly overtime ours -- liukuo add 2011.3.4
				//--------------------start--------------------/
				Vector temp_vt = new Vector();   //temp Vector 1
//	          Vector detailData_vt = new Vector();  //temp Vector 2

	            Vector dayDetial_vt = new Vector();
			    Vector monthTotal_vt = new Vector();
			    String E_RETURN = "";
			    String E_MESSAGE = "";

			    //2017-08-24 ������  ���³�� �������� start
			    D01OTGetMonthRFC d01OTGetMonthRFC = new D01OTGetMonthRFC();
			    String E_MONTH = d01OTGetMonthRFC.getMonth(PERNR,BEGDA);
			    D02ConductDisplayMonthRFC monthfunc= new D02ConductDisplayMonthRFC();
	            //temp_vt = monthfunc.getMonAndDay(user.empNo, BEGDA.substring(0,4), BEGDA.substring(4,6));
			    temp_vt = monthfunc.getMonAndDay(PERNR, E_MONTH.substring(0,4), E_MONTH.substring(4,6));
				//2017-08-24 ������  ���³�� �������� end

			    E_RETURN  = temp_vt.get(0).toString();

	            D02ConductDisplayMonthData monthlyData = new D02ConductDisplayMonthData();

	            if(E_RETURN.trim().equals("S")){
	              E_MESSAGE = temp_vt.get(1).toString();
	              dayDetial_vt = (Vector)temp_vt.get(2);
	              monthTotal_vt = (Vector)temp_vt.get(3);
	              monthlyData = (D02ConductDisplayMonthData)monthTotal_vt.get(0);
	            }else{
	            	 dayDetial_vt = new Vector();
	    		     monthTotal_vt = new Vector();
	    		     monthlyData = new D02ConductDisplayMonthData();
	            }
	            String workHours = String.valueOf(Double.parseDouble(monthlyData.OT_WOR) +  Double.parseDouble(STDAZ));
	            String offHours = String.valueOf(Double.parseDouble(monthlyData.OT_OFF) +  Double.parseDouble(STDAZ));
	            String holHours = String.valueOf(Double.parseDouble(monthlyData.OT_HOL) +  Double.parseDouble(STDAZ));
               //--------------------end--------------------/

				Logger.debug.println("#####	E_ANZHL		:	[ " + E_ANZHL	+ " ]");
				Logger.debug.println("#####	hours			:	[ " + hours		+ " ]");
//				Logger.debug.println("#####	OT_WOR		:	[ " + monthlyData.OT_WOR	+ " ]");
//				Logger.debug.println("#####	OT_OFF		:	[ " + monthlyData.OT_OFF		+ " ]");
//				Logger.debug.println("#####	OT_HOL		:	[ " + monthlyData.OT_HOL		+ " ]");
				Logger.debug.println("#####	workHours	:	[ " + workHours	+ " ]");
				Logger.debug.println("#####	offHours		:	[ " + offHours		+ " ]");
				Logger.debug.println("#####	holHours		:	[ " + holHours		+ " ]");
				Logger.debug.println("#####	workDays	:	[ " + workDays		+ " ]");
				//*******************************************************************************
				//2017-04-03 ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� START
				Logger.debug.println("#####	isUpdate	:	[ " + box.getString("isUpdate")		+ " ]");
				if(box.getString("isUpdate").equals("true")){
				    checkGlobalRfc.checkOvertimeTp46Hours(req, PERNR,  "M" ,box.getString("AINF_SEQN"), box.getString("WORK_DATE"),  box.getString("STDAZ") );
				}else {
					checkGlobalRfc.checkOvertimeTp46Hours(req, PERNR,  "R", "",  box.getString("WORK_DATE"),  box.getString("STDAZ") );
				}
			    String dateTk46Flag = checkGlobalRfc.getReturn().MSGTY;
				//2017-04-03 ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� END


				AppLineData_vt = AppUtil.getAppVector(PERNR1, UPMU_TYPE, BEGDA,hours);
				String app = hris.common.util.AppUtil.getAppBuild((Vector) AppLineData_vt.get(0));
				app = AppUtil.escape(app);
				app += "||||";
				app += (String) AppLineData_vt.get(1);
				app += "||||";
				app += hours;
				app += "||||";
				app += workHours;
				app += "||||";
				app += offHours;
				app += "||||";
				app += holHours;
				app += "||||";
				app += workDays;
				app += "||||";
				app += dateTk46Flag;

				res.getWriter().print(app);
				return;


			} else if (jobid.equals("check")) {

				D01OTCheckGlobalRFC rfc = new D01OTCheckGlobalRFC();
				Vector check_vt = rfc.check(PERNR, box.getString("WORK_DATE"));

				String ENDZT	= WebUtil.printTime(((D01OTCheckData) check_vt.get(0)).ENDZT);
				String BEGZT	= WebUtil.printTime(((D01OTCheckData) check_vt.get(0)).BEGZT);
				String ZMODN	= ((D01OTCheckData) check_vt.get(0)).ZMODN;
				String FTKLA	= ((D01OTCheckData) check_vt.get(0)).FTKLA;

				//-------- ���±Ⱓ�Ϸ�Ȱ��� ��û�ϴ�  check (li hui)-----------------------------
				String upmu_type = "01";
				String flag = rfc.check1(PERNR, box.getString("WORK_DATE"),upmu_type);

				//**********  �������, ���� ��� ���� ��ȸ *******************
                getApprovalInfo(req, PERNR);
				//[CSR ID:3303691]  ���Ľ�û���� �����߰� START
				checkGlobalRfc.check2(req, PERNR,  box.getString("WORK_DATE"),  box.getString("BEGUZ"),  UPMU_TYPE,  "" );
				String dateCheckFlag = checkGlobalRfc.getReturn().MSGTY;
				//[CSR ID:3303691]  ���Ľ�û���� �����߰� END
				Logger.debug.println("#####	flag	:	[ " + flag + " ]");
				String msg = ENDZT + "," + BEGZT + "," + ZMODN + "," + FTKLA + "," + flag + "," + dateCheckFlag;
				res.getWriter().print(msg);
				return;


				/*
				 * Vector D01OTData_vt = new Vector(); D01OTData data = new
				 * D01OTData();
				 *
				 * box.copyToEntity(data); data.PERNR = PERNR;
				 * DataUtil.fixNull(data);
				 *
				 * D01OTData_vt.addElement(data); //������ Ŭ���̾�Ʈ�� �ǵ�����.
				 *
				 * D01OTCheckRFC func = new D01OTCheckRFC(); Vector
				 * D01OTCheck_vt = func.check( PERNR, data.WORK_DATE,
				 * data.WORK_DATE, data.BEGUZ, data.ENDUZ );
				 * Logger.debug.println(this, "D01OTCheck_vt : " +
				 * D01OTCheck_vt); // 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ�
				 * ��û ������ �����ϱ����ؼ� ������. String message = "";
				 *
				 * D01OTCheckData checkData =
				 * (D01OTCheckData)D01OTCheck_vt.get(0);
				 *
				 * if( !checkData.ERRORTEXTS.equals("") &&
				 * checkData.STDAZ.equals("0") ) { //�����޽����� �ְ�, �Ѱ������ �� �� ���� ���
				 * message = "�ٹ������� �ߺ��Ǿ����ϴ�."; } else if(
				 * checkData.ERRORTEXTS.equals("") ) { //�����޽����� ����, �������̰ų� �Ѱ������
				 * �� ���. if( checkData.BEGUZ.equals(data.BEGUZ) &&
				 * checkData.ENDUZ.equals(data.ENDUZ) ) { message = ""; } else {
				 * message = "�ٹ������� �ߺ��Ǿ� ��û�ð��� �����Ͽ����ϴ�."; data.BEGUZ =
				 * checkData.BEGUZ; //�Ѱ������ �ð������� �缳�����ش�. data.ENDUZ =
				 * checkData.ENDUZ; data.STDAZ = checkData.STDAZ; } } //
				 * 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.
				 *
				 * //���������� �ǵ�����. Vector AppLineData_vt = new Vector(); int
				 * rowcount = box.getInt("RowCount"); for( int i = 0; i <
				 * rowcount; i++) { AppLineData appLine = new AppLineData();
				 * String idx = Integer.toString(i); // ������ �ڷ� �Է�(Web)
				 * box.copyToEntity(appLine ,i);
				 *
				 * AppLineData_vt.addElement(appLine); }
				 *
				 * D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC(); Vector
				 * OTHDDupCheckData_vt = func2.getCheckList( PERNR, UPMU_TYPE );
				 * req.setAttribute("message", message);
				 * req.setAttribute("jobid", jobid);
				 * req.setAttribute("D01OTData_vt", D01OTData_vt);
				 * req.setAttribute("AppLineData_vt", AppLineData_vt);
				 * req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
				 *
				 * dest = WebUtil.JspURL+"D/D01OT/D01OTBuild.jsp";
				 */


			} else if (jobid.equals("create")) {

			    dest = requestApproval(req, box,  D01OTData.class, new RequestFunction<D01OTData>() {
			                        public String porcess(D01OTData data, Vector<ApprovalLineData> approvalLine) throws GeneralException {

//				NumberGetNextRFC seqn = new NumberGetNextRFC();
				D01OTRFC rfc = new D01OTRFC();

//				Vector AppLineData_vt = new Vector();
				Vector D01OTData_vt = new Vector();

				box.copyToEntity(data);
				data.PERNR		= PERNR;
				data.ZPERNR	= user.empNo; 						// ��û�� ���(�븮��û, ���� ��û)
				data.PERNR_D	= PERNR;
				if(data.ZREASON==null	|| data.ZREASON.equals("") ){
					data.ZREASON	= data.REASON;
				}
				data.UNAME	= user.empNo; 						// ��û�� ���(�븮��û, ���� ��û)
				data.AEDTM	= DataUtil.getCurrentDate(); 		// ������(���糯¥)

				DataUtil.fixNull(data);

				// check whether overtime overlaps leave time
				doWithData(data);
				{
					D01OTCheck1RFC chk = new D01OTCheck1RFC();

					chk.check(PERNR, data.WORK_DATE, data.BEGUZ,data.ENDUZ);
					String msg2	= chk.getReturn().MSGTY;
					String msg	= "";
					String url	= "";

					if (!chk.getReturn().isSuccess()) {
						req.setAttribute("msg", msg);
						req.setAttribute("msg2", chk.getReturn().MSGTX);
//						req.setAttribute("url", url);

						//dest = WebUtil.JspURL + "common/msg.jsp";

						//printJspPage(req, res, dest);
						throw new GeneralException(rfc.getReturn().MSGTX);
					}
					//[CSR ID:3303691]  ���Ľ�û���� �����߰� START

					checkGlobalRfc.check2(req, PERNR,   data.WORK_DATE,  data.BEGUZ,  UPMU_TYPE,  "" );
					if ("E".equals(checkGlobalRfc.getReturn().MSGTY)) {
						throw new GeneralException(g.getMessage("MSG.D.D01.0106"));//���� ���ں��� ��û�����մϴ�.
					}
					//[CSR ID:3303691]  ���Ľ�û���� �����߰� END

					//2017-04-03 ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� START
					checkGlobalRfc.checkOvertimeTp46Hours(req, PERNR,  "R","",  data.WORK_DATE,  data.STDAZ );
					if ("E".equals(checkGlobalRfc.getReturn().MSGTY)) {
						throw new GeneralException(g.getMessage("MSG.D.D01.0105"));//���ϴ� ������ ���±Ⱓ �� OT ���� ��û�ü���  46�ð� �ʰ��Ͽ����� Ȯ���Ͻñ� �ٶ��ϴ�.
					}
					//2017-04-03 ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� END

				    //[CSR ID:3359686]   ���� ���� 5������ START
	                checkGlobalRfc.checkApprovalPeriod(req, PERNR, "R",data.WORK_DATE,   UPMU_TYPE,  "" );
	                if ("E".equals(checkGlobalRfc.getReturn().MSGTY)) {
	                	req.setAttribute("alertMsg2",  g.getMessage("MSG.D.D01.0107"));

					}
	                 //[CSR ID:3359686]   ���� ���� 5������ end



				}
				// check end

				D01OTData_vt.addElement(data);
				Logger.debug.println(this, data.toString());

				// D01OTCheckRFC func = new D01OTCheckRFC();
				// Vector D01OTCheck_vt = func.check(PERNR, data.WORK_DATE);

				// 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.
				String message = "";
				// D01OTCheckData checkData = (D01OTCheckData) D01OTCheck_vt
				// .get(0);

				// if (!checkData.ERRORTEXTS.equals("")
				// && checkData.STDAZ.equals("0")) { // �����޽����� �ְ�, �Ѱ������
				// // �� �� ���� ���
				// message = "�ٹ������� �ߺ��Ǿ����ϴ�. �ٽ� ��û���ֽʽÿ�.";
				// } else if (checkData.ERRORTEXTS.equals("")) { // �����޽����� ����,
				// // �������̰ų� �Ѱ������
				// // �� ���.
				// if (checkData.BEGUZ.equals(data.BEGUZ)
				// && checkData.ENDUZ.equals(data.ENDUZ)) {
				// message = "";
				// } else {
				// message = "�ٹ������� �ߺ��Ǿ� ��û�ð��� �����Ͽ����ϴ�.";
				// data.BEGUZ = checkData.BEGUZ; // �Ѱ������ �ð������� �缳�����ش�.
				// data.ENDUZ = checkData.ENDUZ;
				// data.STDAZ = checkData.STDAZ;
				// }
				// }
				// 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.

				if (!message.equals("")) { // �޼����� �ִ°��

					D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
					Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR,UPMU_TYPE, user.area);

					Logger.debug.println(this, "#####	������������");
					req.setAttribute("jobid", jobid);
					req.setAttribute("message", message);
					req.setAttribute("D01OTData_vt", D01OTData_vt);
					req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
//                    getApprovalInfo(req, PERNR);    //<-- �ݵ�� �߰�

                    req.setAttribute("approvalLine", approvalLine); //����� �������

					printJspPage(req, res, WebUtil.JspURL+"D/D01OT/D01OTBuild_Global.jsp");
                    req.setAttribute("committed", "Y");
					return null;

				} else { // ����

					//String ainf_seqn = seqn.getNumberGetNext();
					String date = DataUtil.getCurrentDate();
					data.PERNR = PERNR;
					Logger.debug.println(this, "#####	��������");
                    rfc.setRequestInput(user.empNo, UPMU_TYPE);
					String ainf_seqn = rfc.build(PERNR, D01OTData_vt, box, req);
					 if(!rfc.getReturn().isSuccess() || ainf_seqn==null) {
                         throw new GeneralException(rfc.getReturn().MSGTX);
                     };

/*
					int rowcount = box.getInt("RowCount");
					for (int i = 0; i < rowcount; i++) {
						AppLineData appLine = new AppLineData();
						String idx = Integer.toString(i);

						// ������ �ڷ� �Է�(Web)
						box.copyToEntity(appLine, i);
					}

					Logger.debug.println(this, "#####	����������");
					Logger.debug.println(this, D01OTData_vt.toString());
					Logger.debug.println(this, "#####	��������	:	" + AppLineData_vt.toString());

					con = DBUtil.getTransaction();

					AppLineDB appDB = new AppLineDB(con);
					appDB.create(AppLineData_vt);

					rfc.build(ainf_seqn, PERNR, D01OTData_vt);
					con.commit();

					// ���� ������ ��� ,
					AppLineData appLine = (AppLineData) AppLineData_vt.get(0);

					Properties ptMailBody = new Properties();
					ptMailBody.setProperty("SServer", user.SServer); 						// ElOffice ���� ����
					ptMailBody.setProperty("from_empNo", user.empNo); 					// �� �߼��� ���
					ptMailBody.setProperty("to_empNo", appLine.APPL_APPU_NUMB); 	// ������� ���
					ptMailBody.setProperty("ename", phonenumdata.E_ENAME); 		// (��)��û�ڸ�
					ptMailBody.setProperty("empno", phonenumdata.E_PERNR); 			// (��)��û�� ���
					ptMailBody.setProperty("UPMU_NAME", UPMU_NAME); 					// ���� �̸�
					ptMailBody.setProperty("AINF_SEQN", ainf_seqn); 						// ��û�� ����

					// �� ����
					StringBuffer sbSubject = new StringBuffer(512);

					sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
					sbSubject.append(ptMailBody.getProperty("ename") + " applied.");

					ptMailBody.setProperty("subject", sbSubject.toString());
					//Logger.debug.println(this, "D01OTBuildSV ���� ptMailBody : " + ptMailBody.toString());

					String msg = "msg001";
					String msg2 = "";
*/
					/*
					MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

					if (!maTe.process()) {
						msg2 = maTe.getMessage();
					} // end if
					*/
/*
					try {
						DraftDocForEloffice ddfe = new DraftDocForEloffice();

						ElofficInterfaceData eof = ddfe.makeDocContents(
								ainf_seqn, user.SServer, ptMailBody
										.getProperty("UPMU_NAME"));

						Vector vcElofficInterfaceData = new Vector();
						vcElofficInterfaceData.add(eof);
						req.setAttribute("vcElofficInterfaceData",
								vcElofficInterfaceData);
						dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
					} catch (Exception e) {
						dest = WebUtil.JspURL + "common/msg.jsp";
						msg2 = msg2 + "\\n" + " Eloffic Connection Failed.";
					} // end try
					req.setAttribute("msg", msg);
					req.setAttribute("msg2", msg2);
					String url = "location.href = '" + WebUtil.ServletURL
							+ "hris.D.D01OT.D01OTDetailSV?AINF_SEQN="
							+ ainf_seqn + "&PERNR=" + PERNR + "';";
					req.setAttribute("url", url);
*/
					return ainf_seqn;
				}
		      }
            });
			  //[CSR ID:3359686]   ���� ���� 5������ START
			    if(req.getAttribute("alertMsg2")!=null) req.setAttribute("msg2", req.getAttribute("msg2").equals("")  ? req.getAttribute("alertMsg2"): req.getAttribute("msg2")+ "\\n" +req.getAttribute("alertMsg2"));
			  //[CSR ID:3359686]   ���� ���� 5������ END

			} else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}
			Logger.debug.println(this, "#####	destributed = " + dest);
            if (req.getAttribute("committed").equals("N")){
            	printJspPage(req, res, dest);
            }

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
//			DBUtil.close(con);
		}
	}

	public D01OTData doWithData(D01OTData data) {
		if (!data.BEGDA.equals("") && data.BEGDA.length()==10)
			data.BEGDA = data.BEGDA.substring(0, 4)
					+ data.BEGDA.substring(5, 7) + data.BEGDA.substring(8);
// 2016.09.26 pangmin G180 add begin
		if (!data.WORK_DATE.equals("") && data.WORK_DATE.length()==10)
			data.WORK_DATE = data.WORK_DATE.substring(0, 4)
					+ data.WORK_DATE.substring(5, 7)
					+ data.WORK_DATE.substring(8);
// 2016.09.26 pangmin G180 add begin

		data.BEGUZ = toTimeFormat(data.BEGUZ);
		data.ENDUZ = toTimeFormat(data.ENDUZ);
		data.PBEG1 = toTimeFormat(data.PBEG1);
		data.PEND1 = toTimeFormat(data.PEND1);
		data.PBEG2 = toTimeFormat(data.PBEG2);
		data.PEND2 = toTimeFormat(data.PEND2);
		if (data.PBEG1.equals("000000") && data.PEND1.equals("000000") || data.PBEG1.equals("00:00") && data.PEND1.equals("00:00") ) {
			data.PBEG1=null;
			data.PEND1=null;
		}
		if (data.PBEG2.equals("000000") && data.PEND2.equals("000000") || data.PBEG2.equals("00:00") && data.PEND2.equals("00:00") ) {
			data.PBEG2=null;
			data.PEND2=null;
		}
		return data;
	}

	public String toTimeFormat(String timeString) {
		String result = timeString;
		if (timeString.equals("") || timeString==null) return "";

		if (!timeString.equals("")&& timeString.length()==4)
			result = timeString.substring(0, 2) +timeString.substring(2)					+ "00";

		if (!timeString.equals("")&& timeString.length()==5)
			result = timeString.substring(0, 2) +timeString.substring(3)					+ "00";

		if (!timeString.equals("") && timeString.length()==8)
			result = timeString.substring(0, 2) + timeString.substring(3,5) + timeString.substring(6,8);

		return result;
	}
}