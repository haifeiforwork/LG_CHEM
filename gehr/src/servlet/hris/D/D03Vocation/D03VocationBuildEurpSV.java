/********************************************************************************/
/*   System Name  	: g-HR                                                         						
/*   1Depth Name  	: Application                                                 								
/*   2Depth Name  	: Time Management                                                        									
/*   Program Name 	: Leave                                                   									
/*   Program ID   		: D03VocationBuildEurpSV.java                                          					
/*   Description  		: �ް��� ��û�� �� �ֵ��� �ϴ� Class [������]                         					
/*   Note         		:                                                             							
/*   Creation     		: 2010-07-26 yji         
/*   Update				: 2010-10-08 jungin	@v1.0 �̱����� ���������� �߰�. (�ڹٽ�ũ��Ʈ�� ���� ������ �и�)    
 * 							@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel                							
 */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import java.io.PrintWriter;
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

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03CheckDataRFC;
import hris.D.D03Vocation.rfc.D03CheckTimeRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationGlobalRFC;
import hris.D.D03Vocation.rfc.D03VocationGlobalRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.D18HolidayCheckRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtilEurp;

public class D03VocationBuildEurpSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="02";   // ���� ����Ÿ��(�ް���û)
	private String UPMU_NAME = "Leave";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
	protected void performTask(final HttpServletRequest req, final HttpServletResponse res)
			throws GeneralException {
		
//		Connection con = null;

		try {
			req.setCharacterEncoding("utf-8");		
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest 	  			= "";
			 
			final Box box = WebUtil.getBox(req);

			final String jobid = box.get("jobid", "first");

			final String PERNR =  getPERNR(box, user); //box.get("PERNR", user.empNo);
			
			Logger.debug.println(this, "#####	JOBID		:	[" + jobid + "] / PERNR	:	[" + PERNR + "]");
			
			//**********************************************************
			//�ް������� ���� selectbox �����ڵ�.(value1)		2008-02-20.		
			final String UPMU_CODE = box.get("TMP_UPMU_CODE", UPMU_TYPE);
			
			if (!jobid.equals("first")) {
				UPMU_TYPE = UPMU_CODE;
				Logger.debug.println(this, "#####	JOBID	 :	[" + jobid + "] / UPMU_TYPE	 :	[" + UPMU_TYPE + "]");
			}
			//**********************************************************

			// �븮 ��û �߰�
//			PhoneNumRFC numfunc = new PhoneNumRFC();
//			PhoneNumData phonenumdata;
//			phonenumdata = (PhoneNumData) numfunc.getPhoneNum(PERNR);
//			req.setAttribute("PhoneNumData", phonenumdata);
			
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR, "X");
            req.setAttribute("PersonData" , phonenumdata );

			Vector d03VocationData_vt = new Vector();
			D03VocationData d03VocationData = new D03VocationData();
			
	        //Case of Europe(Poland, Germany) and USA
            /*
             * e_area :	46 (Poland)
             *         		01 (Germany) 
             *				10 (USA) 
            */
			if (user.e_area.equals("46")) {
				d03VocationData.AWART = "UW";		// default �����ް�
				
			} else if (user.e_area.equals("01")) {
				d03VocationData.AWART = "0100";		// default �����ް�
				
			} else if (user.e_area.equals("10")||user.e_area.equals("32")) {//@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel
				d03VocationData.AWART = "0100X";	// default �����ް�
			}
			
			d03VocationData.DEDUCT_DATE 		= "1";
			d03VocationData.PERNR 				= PERNR;
			
			DataUtil.fixNull(d03VocationData);

			// ������ �ܿ��ް��ϼ� ��ȸ
			D03RemainVocationGlobalRFC rfcRemain = new D03RemainVocationGlobalRFC();
			Vector D03RemainVocationData_vt = null;
	
			Logger.debug.println(this, "#####	AWART	 :	[" + d03VocationData.AWART + "]");
			
			D03RemainVocationData_vt = rfcRemain.getRemainVocation(PERNR, "", d03VocationData.AWART);
			d03VocationData.ANZHL_BAL = ((D03RemainVocationData) Utils.indexOf(D03RemainVocationData_vt, 0)).ANZHL_BAL;
			D03RemainVocationData d03RemainVocationData  =((D03RemainVocationData) Utils.indexOf(D03RemainVocationData_vt,0));

			Logger.debug.println(this, "#####	ANZHL_BAL	 :	[" + d03VocationData.ANZHL_BAL + "]");

			d03VocationData_vt.addElement(d03VocationData);
			req.setAttribute("d03VocationData_vt", d03VocationData_vt);

			//checkData
			D03CheckDataRFC crfc=  new D03CheckDataRFC();
			
			String checkmess	= crfc.checks(PERNR);
			String E_BUKRS = user.companyCode;
			
			req.setAttribute("checkmess", checkmess);
			req.setAttribute("E_BUKRS", E_BUKRS);
			
			if (jobid.equals("first")) {

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);    //<-- �ݵ�� �߰�
                
				req.setAttribute("jobid", jobid);	
				req.setAttribute("PERNR", PERNR);
                req.setAttribute("d03RemainVocationData",  d03RemainVocationData);

				// ���� ��û�Ǿ��ִ� �ް��� ��ȸ
				// ******************************************************************************************
				D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
				Vector OTHDDupCheckData_vt = null;
				OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(PERNR, UPMU_TYPE, user.area);

				req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
				//Logger.debug.println(this, "OTHDDupCheckData_vt : " + OTHDDupCheckData_vt.toString());
				// ******************************************************************************************
				
    	        //Case of Europe(Poland, Germany) and USA
                /*
                 * e_area :	46 (Poland)
                 *         		01 (Germany) 
                 *				10 (USA) 
                */
				if (user.e_area.equals("46")) {
					dest = WebUtil.JspURL + "D/D03Vocation/D03VocationBuild_PL.jsp";
					
				} else if (user.e_area.equals("01")) {
					dest = WebUtil.JspURL + "D/D03Vocation/D03VocationBuild_DE.jsp";
				
				} else if (user.e_area.equals("10")||user.e_area.equals("32")) {//@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel
					dest = WebUtil.JspURL + "D/D03Vocation/D03VocationBuild_US.jsp";
				}

			} else if (jobid.equals("check")) {	//��¥ üũ.
									
					String AWART			= req.getParameter("AWART");			// �ް�����
					String APPL_FROM 	= req.getParameter("APPL_FROM");		// ������
					String APPL_TO 		= req.getParameter("APPL_TO");			// ������
					
					String BEGUZ 			= req.getParameter("BEGUZ");			// ���۽ð�
					String ENDUZ 			= req.getParameter("ENDUZ");			// ����ð�
					
					if (BEGUZ == null || BEGUZ.equals("")) { 
						BEGUZ = "0000";
					}
					if (ENDUZ == null || ENDUZ.equals("")) {
						ENDUZ = "0000";
					}
					
	    	        //Case of Europe(Poland, Germany) and USA
	                /*
	                 * e_area :	46 (Poland)
	                 *         		01 (Germany) 
	                 *				10 (USA) 
	                */
					if (user.e_area.equals("46")) {
						BEGUZ = "000000";	
						ENDUZ = "000000";	
					
					} else if (user.e_area.equals("01") || user.e_area.equals("10")||user.e_area.equals("32")) {		// ����, �̱��� ��� ������ �����Ƿ� �ð����� �ʿ��ϴ�. (��/��/�� 6�ڸ�)  /@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel
						BEGUZ = BEGUZ + "00";
						ENDUZ = ENDUZ + "00";		
					}
					
					req.setCharacterEncoding("utf-8");
					
					D18HolidayCheckRFC rfcCheck = new D18HolidayCheckRFC();
					Vector checkData = rfcCheck.getRemainVocation(PERNR, AWART, APPL_FROM, APPL_TO, BEGUZ, ENDUZ);
				
					String function	  = (String) checkData.get(0);
					String function1 = (String) checkData.get(1);
					String function2 = (String) checkData.get(2);
					String function3 = (String) checkData.get(3);

					if (!rfcCheck.getReturn().isSuccess()) 					{
						function = rfcCheck.getReturn().MSGTY ;
						function1 = rfcCheck.getReturn().MSGTX ;
					}
					D01OTCheckGlobalRFC rfc2 = new D01OTCheckGlobalRFC();
					
					String flag = rfc2.check1(PERNR, APPL_FROM, UPMU_TYPE);
	
					res.setCharacterEncoding("utf-8");
					PrintWriter out = res.getWriter();
					out.println(function + "," + function1 + "," + function2 + "," + function3 + "," + flag);
					
					Logger.debug.println("#####	1) function		:	 [" + function + "]");
					Logger.debug.println("#####	2) function1	:	 [" + function1 + "]");
					Logger.debug.println("#####	3) function2	:	 [" + function2 + "]");
					Logger.debug.println("#####	4) function3	:	 [" + function3 + "]");
					Logger.debug.println("#####	5) flag	:	[" + flag + "]");
					
					return;
				
			} else if (jobid.equals("getApp")) {		//������ ����.
				
				req.setCharacterEncoding("utf-8");
				
				String E_ABRTG	= req.getParameter("E_ABRTG");
				String AWART		= req.getParameter("AWART"); 
				String sPERNR 		= req.getParameter("PERNR");	
				
				Vector AppLineData_vt = null;
				AppLineData_vt = AppUtilEurp.getAppVector1(sPERNR, UPMU_TYPE, E_ABRTG, AWART);
				String app = hris.common.util.AppUtilEurp.getAppBuild((Vector) AppLineData_vt);
				app = AppUtilEurp.escape(app);

				res.setCharacterEncoding("utf-8");
				res.getWriter().print(app);
				return;

			} else if (jobid.equals("getQuotaBalance")) {	//Quota Balance ����.
				
				req.setCharacterEncoding("utf-8");
				
				String  AWART = req.getParameter("AWART");
				String sPERNR 			= req.getParameter("PERNR");	
				
				Logger.debug.println(this, "#####	JOBID	 :	[" + jobid + "] / AWART	 :	[" + AWART + "]");
				
				//AbsenceType�� ��ȸ�� �� Quota�� �� ��ȸ�Ѵ�. ������ �ܿ��ް��ϼ� ��ȸ RFC ȣ��
//				D03RemainVocationRFCEurp rfcRemain2 = new D03RemainVocationRFCEurp();
				D03RemainVocationGlobalRFC rfcRemain2 = new D03RemainVocationGlobalRFC();
				
				D03RemainVocationData_vt = rfcRemain2.getRemainVocation(sPERNR, "", AWART);
				D03RemainVocationData remainVO = ((D03RemainVocationData) Utils.indexOf(D03RemainVocationData_vt,0));
				String ANZHL_BAL = remainVO.ANZHL_BAL;
				ANZHL_BAL = AppUtilEurp.escape(ANZHL_BAL);
				
				Logger.debug.println(this, "#####	JOBID	 :	[" + jobid + "] / ANZHL_BAL	:	[" + ANZHL_BAL + "]");
				
				res.setCharacterEncoding("utf-8");
				res.getWriter().print(ANZHL_BAL + "," + remainVO.ANZHL_GEN+ "," + remainVO.ANZHL_USE);
				return;
				
			} else if (jobid.equals("checkTime")) {
				
				String BEGUZ = req.getParameter("BEGUZ");
				String ENDUZ = req.getParameter("ENDUZ");
				
				D03CheckTimeRFC rfc = new D03CheckTimeRFC();
				
				String E_FLAG = rfc.check(BEGUZ, ENDUZ);
				
				E_FLAG = AppUtilEurp.escape(E_FLAG);
				
				Logger.debug.println("#####	E_FLAG	 :	[" + E_FLAG + "]");
				
				res.getWriter().print(E_FLAG);		
				return;
				
			} else if (jobid.equals("checkDay")) {  //------------���±Ⱓ�Ϸ�Ȱ��� ��û�ϴ�  check (li hui)-------------
				
				String sPERNR = req.getParameter("PERNR");
				String BEGDA = req.getParameter("APPL_FROM");	
				
				D01OTCheckGlobalRFC rfc = new D01OTCheckGlobalRFC();
				String flag = rfc.check1(sPERNR, BEGDA, UPMU_TYPE);
				
				Logger.debug.println("#####	flag	 :	[" + flag + "]");
				
				res.getWriter().print(flag);
				return;
				
// ***************************************************************				
				
			} else if (jobid.equals("create")) {

        	    dest = requestApproval(req, box,  D03VocationData.class, new RequestFunction<D03VocationData>() {
	                        public String porcess(D03VocationData d03VocationData, Vector<ApprovalLineData> approvalLine) 
                    		throws GeneralException {
	                        
				D03VocationGlobalRFC rfc = new D03VocationGlobalRFC();
				d03VocationData = new D03VocationData();
				
				Vector d03VocationData_vt = new Vector();
				String AINF_SEQN = "";
				String message = "";
				
    	        //Case of Europe(Poland, Germany) and USA
                /*
                 * e_area :	46 (Poland)
                 *         		01 (Germany) 
                 *				10 (USA) 
                */
				if (user.e_area.equals("46")) {
					
					d03VocationData.PERNR = PERNR; 										// �����ȣ
					d03VocationData.BEGDA 			= box.get("BEGDA"); 			// ��û��
					d03VocationData.AWART 			= box.get("AWART1"); 			// �ٹ�/�޹� ����
					d03VocationData.APPL_REAS  	= box.get("APPL_REAS"); 		// ��û ����
					d03VocationData.APPL_FROM		= box.get("APPL_FROM"); 		// ��û������
					d03VocationData.APPL_TO 		= box.get("APPL_TO"); 			// ��û������
					d03VocationData.ANZHL_BAL 		= box.get("ANZHL_BAL");
					d03VocationData.ABSN_DATE 	= box.get("P_STDAZ2");
					d03VocationData.ABRTG 			= box.get("E_ABRTG");
					d03VocationData.ZPERNR 			= user.empNo; 					// ��û�� 
					d03VocationData.UNAME 			= user.empNo; 					// ��û��
					d03VocationData.AEDTM 			= DataUtil.getCurrentDate(); // ������(���糯¥)
				
				} else if (user.e_area.equals("01") || user.e_area.equals("10")||user.e_area.equals("32")) {//@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel

					d03VocationData.PERNR = PERNR; 										// �����ȣ
					d03VocationData.BEGDA 			= box.get("BEGDA"); 			// ��û��
					d03VocationData.AWART 			= box.get("AWART1"); 			// �ٹ�/�޹� ����
					d03VocationData.APPL_REAS  	= box.get("APPL_REAS"); 		// ��û ����
					d03VocationData.APPL_FROM		= box.get("APPL_FROM"); 		// ��û������
					d03VocationData.APPL_TO 		= box.get("APPL_TO"); 			// ��û������
					d03VocationData.BEGUZ 			= box.get("BEGUZ"); 			// ���۽ð�
					d03VocationData.ENDUZ 			= box.get("ENDUZ"); 			// ����ð�
					d03VocationData.ANZHL_BAL 		= box.get("ANZHL_BAL");
					d03VocationData.ABSN_DATE 	= box.get("P_STDAZ2");
					d03VocationData.ABRTG 			= box.get("E_ABRTG");
					d03VocationData.STDAZ 			= box.get("I_STDAZ");
					d03VocationData.ZPERNR 			= user.empNo; 					// ��û�� 
					d03VocationData.UNAME 			= user.empNo; 					// ��û��
					d03VocationData.AEDTM 			= DataUtil.getCurrentDate(); // ������(���糯¥)
				}

				if (!message.equals("")) { // �޼����� �ִ°��
					d03VocationData_vt.addElement(d03VocationData);

					
					D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
					Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR, UPMU_TYPE, user.area);

					Logger.debug.println(this, "#####	������������");
					req.setAttribute("jobid", jobid);
					req.setAttribute("message", message);
					req.setAttribute("d03VocationData_vt", d03VocationData_vt);
					req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                    getApprovalInfo(req, PERNR);    //<-- �ݵ�� �߰�

                    req.setAttribute("approvalLine", approvalLine); //����� �������

	    	        //Case of Europe(Poland, Germany) and USA
	                /*
	                 * e_area :	46 (Poland)
	                 *         		01 (Germany) 
	                 *				10 (USA) 
	                
					if (user.e_area.equals("46")) {
						dest = WebUtil.JspURL + "D/D03Vocation/D03VocationBuildPl.jsp";
						
					} else if (user.e_area.equals("01")) {
						dest = WebUtil.JspURL + "D/D03Vocation/D03VocationBuildDe.jsp";
					
					} else if (user.e_area.equals("10")) {
						dest = WebUtil.JspURL + "D/D03Vocation/D03VocationBuildUsa.jsp";
					}*/
					return null;
					
				} else { // ����


					d03VocationData.AINF_SEQN2 = box.get("AINF_SEQN2");
					//d03VocationData.STDAZ = box.get("I_STDAZ");
					Logger.debug.println(this, "#####	��������");
					
					
					Logger.debug.println(this, "#####	d03VocationData	 :	[" + d03VocationData + "]");

					
					// ��û ����

					//Logger.debug.println(this, "#####	PERNR	 :	[" + PERNR + "]");
					//Logger.debug.println(this, "#####	AINF_SEQN	 :	[" + AINF_SEQN + "]");
					//Logger.debug.println(this, "#####	d03VocationData	 :	[" + d03VocationData + "]");

                    rfc.setRequestInput(user.empNo, UPMU_TYPE);
                    AINF_SEQN = rfc.build(PERNR, d03VocationData, box, req);
					
                    if(!rfc.getReturn().isSuccess()) {
                        throw new GeneralException(rfc.getReturn().MSGTX);
                    }

		/*
                    
                    String msg	= "msg001";
                    String msg2	= "";
					String url = "location.href = '"
							+ WebUtil.ServletURL
							+ "hris.D.D03Vocation.D03VocationDetailEurpSV?AINF_SEQN="
							+ AINF_SEQN  + "&PERNR=" + PERNR + "&UPMU_CODE=" + UPMU_CODE + "';";
					
					Logger.debug.println(this, "#####	url = " + url);
					
					req.setAttribute("msg", msg);
					req.setAttribute("msg2", msg2);
					req.setAttribute("url", url);*/
				}
				return AINF_SEQN;
	                        }});
			} else {
				throw new BusinessException("#####	���θ��(jobid)�� �ùٸ��� �ʽ��ϴ�.");
			}
			
			Logger.debug.println(this, "#####	dest = " + dest);
			
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			
		}
		
	}
	
	private void doWithData(D03VocationData data) {
		if (!data.BEGDA.equals(""))
			data.BEGDA = data.BEGDA.substring(0, 4) + data.BEGDA.substring(5, 7) + data.BEGDA.substring(8);	
		if (!data.APPL_FROM.equals(""))
			data.APPL_FROM = data.APPL_FROM.substring(0, 4) + data.APPL_FROM.substring(5, 7) + data.APPL_FROM.substring(8);		
		if (!data.APPL_TO.equals(""))
			data.APPL_TO = data.APPL_TO.substring(0, 4) + data.APPL_TO.substring(5, 7) + data.APPL_TO.substring(8);	
		if (!data.BEGUZ.equals(""))
			data.BEGUZ = data.BEGUZ.substring(0, 2) + data.BEGUZ.substring(3) + "00";	
		if (!data.ENDUZ.equals(""))
			data.ENDUZ = data.ENDUZ.substring(0, 2) + data.ENDUZ.substring(3) + "00";
	}
	
}
