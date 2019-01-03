/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  		*/
/*   2Depth Name  : �ް�                                                        		*/
/*   Program Name : �ް� ��û (����Ͽ�����û)                                  	*/
/*   Program ID   : D03VocationMBBuildSV                                        */
/*   Description  : �ް��� ��û�� �� �ֵ��� �ϴ� Class                          	*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �赵��                                          		*/
/*   Update       : 2005-02-16  ������                                          		*/
/*   Update       : 2013-09-03  LSA  @CSR1  �������� ������� �����ް��ϼ�   �̻���(��, 6�� �̻��� �����ް��� ��������� ����)  */
/*   Update       : 2014-02-04  C20140106_63914 : �����ް� ���� �߰�   */
/*   Update       : 2014-02-19  C20140219 : �����ް� ������� �������� ��� �ް��ϼ��� ��������Է��� ����   */
/*                : 2014-08-24  [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��    */
/*                : 2015-12-18  [CSR ID:2942508] �����ް� ��û �˾� ��û     		*/
/*                : 2016-09-21  GEHR �����۾�									*/
/*				  : 2017-04-10  eunha [CSR ID:3351729] ������� �ͻ���� �߰� ������ �ް���û Error*/
/*				  : 2017-07-20  eunha [CSR ID:3438118] flexible time �ý��� ��û	*/
/* 						//@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel	 
/*				  : 2018-05-16  ��ȯ�� [WorkTime52] �����ް� �߰� ��				*/
/*																				*/
/********************************************************************************/

package servlet.hris.D.D03Vocation ;

import java.io.PrintWriter;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;

import com.common.RFCReturnEntity;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D16OTHDDupCheckData2;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.D03WorkPeriodData;
import hris.D.D03Vocation.rfc.D03MinusRestRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationOfficeRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.D.D03Vocation.rfc.D03ShiftCheckRFC;
import hris.D.D03Vocation.rfc.D03VacationUsedRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.D.D03Vocation.rfc.D03WorkPeriodRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.D16OTHDDupCheckRFC2;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.AuthCheckNTMRFC;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="18";   // ���� ����Ÿ��(�ް���û)

    private String UPMU_NAME = "�ް�";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";

            /***********     Start:   **********************************************************/

            		String fdUrl = ".";

        	        //Case of Europe(Poland, Germany) and USA
                    /*
                     * e_area :	46 (Poland)
                     *         		01 (Germany)
                     *				10 (USA)
                     *             //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel 
                    */
		           if (user.area.equals(Area.DE) || user.area.equals(Area.US)|| user.area.equals(Area.PL)|| user.area.equals(Area.MX)){
		               fdUrl = "hris.D.D03Vocation.D03VocationBuildEurpSV";
		           }else if(!user.area.equals(Area.KR)){
		               fdUrl = "hris.D.D03Vocation.D03VocationBuildGlobalSV";
		           }

		           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );

		            if( !".".equals(fdUrl )){
		            	printJspPage(req, res, WebUtil.ServletURL+ fdUrl);
				       	return;
		           }

            /**************    END:  *********************************************************/

		            /* //��û ������
		            applyHolidayDate          ��û��
		            applyHolidayType          �ٹ�/�޹� ����
		            applyHolidayType          �ٹ�/�޹� ����
		            applyHolidayReason        ��û����
		            applyHolidayFromDate      ��û������
		            applyHolidayToDate        ��û������
		            applyHolidayFromTime      ��û�ð�
		            applyHolidayToTime        ����ð�
		            applyHolidayRemainDate    �ܿ��ް��ϼ�

		            0110 �����ް�
					0120  �����ް�(����)
					0121  �����ް�(�Ĺ�)
					-------------------------
					0340 ���Ϻ�ٹ� - LG����ȭ��
					0360 �ٹ����� - LG����ȭ��
					--------------------------
					0140  �ϰ��ް�
					0130  �����ް�
					0170  ���ϰ���
					0180  �ð�����
					0150  �����ް� - ����
					0190  �𼺺�ȣ�ް� - ���� (20140728 ����� �߰�)
				    */

		    final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            final String PERNR =  getPERNR(box, user); //box.get("PERNR",  user.empNo);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();

            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR, "X" );
            req.setAttribute("PersonData" , phonenumdata );

            Vector  d03VocationData_vt = new Vector();
            D03VocationData  d03VocationData = new D03VocationData();

            d03VocationData.AWART         = "0110";   // default �����ް�
            d03VocationData.DEDUCT_DATE   = "1";
            d03VocationData.PERNR = PERNR;
            DataUtil.fixNull(d03VocationData);

            d03VocationData_vt.addElement(d03VocationData);
            req.setAttribute("d03VocationData_vt",  d03VocationData_vt);
            
            // �����ް� ����üũ
            AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
        	String E_AUTH = authCheckNTMRFC.getAuth(PERNR, "S_ESS");
        	req.setAttribute("E_AUTH", E_AUTH);

            if( jobid.equals("first") ) {            //����ó�� ��û ȭ�鿡 ���°��.


                getApprovalInfo(req, PERNR);    //<--�ʼ�

                D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();
                if("Y".equals(E_AUTH)) {	//�繫��
                	D03RemainVocationOfficeRFC  rfcRemain             = new D03RemainVocationOfficeRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, DataUtil.getCurrentDate(), "A");
                } else {					//������
                	// �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
                	D03RemainVocationRFC  rfcRemain             = new D03RemainVocationRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, DataUtil.getCurrentDate());
                }


                req.setAttribute("jobid",                 jobid);
                req.setAttribute("d03RemainVocationData", d03RemainVocationData);

                D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = null;
                OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList( PERNR, UPMU_TYPE, user.area );
//                Logger.debug.println(this, "OTHDDupCheckData_vt : "+ OTHDDupCheckData_vt.toString());
                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

                dest = WebUtil.JspURL+"D/D03Vocation/D03VocationBuild.jsp";


			} else if (jobid.equals("check")) {	//��¥ üũ.

			    D03RemainVocationData dataRemain = new D03RemainVocationData();
			    RFCReturnEntity rfcReturns = new RFCReturnEntity();
			    
			    String APPL_FROM  = req.getParameter("APPL_FROM");
			    APPL_FROM = (APPL_FROM == null) ? DataUtil.getCurrentDate() : APPL_FROM;
			    String mode = req.getParameter("MODE");

			    if("Y".equals(E_AUTH)) {	//�繫��
			    	D03RemainVocationOfficeRFC  rfcRemain             = new D03RemainVocationOfficeRFC();
			    	dataRemain = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, APPL_FROM, mode);
			    	rfcReturns = rfcRemain.getReturn();
			    } else {					//������
			    	D03RemainVocationRFC  rfcRemain  =new D03RemainVocationRFC();
			    	dataRemain = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, APPL_FROM);
			    	rfcReturns = rfcRemain.getReturn();
			    }

			    PrintWriter out = res.getWriter();

				if (!rfcReturns.isSuccess()) {

					String flag = rfcReturns.MSGTY ;
					String msg = rfcReturns.MSGTX ;

					out.println(flag + "," + msg); // fail

				}else{

					String remainDays = dataRemain.OCCUR.equals("0")?"0" : WebUtil.printNumFormat(Double.toString(NumberUtils.toDouble(dataRemain.ABWTG)  / NumberUtils.toDouble(dataRemain.OCCUR) * 100.0),2);

					dataRemain.E_REMAIN =  (dataRemain.E_REMAIN.equals("0") ||  dataRemain.E_REMAIN.equals("")) ? "0" : WebUtil.printNumFormat(dataRemain.E_REMAIN,2) ;
					dataRemain.ZKVRB = (dataRemain.ZKVRB.equals("0") ||  dataRemain.ZKVRB.equals("")) ? "0" : WebUtil.printNumFormat(dataRemain.ZKVRB,1) ;
					dataRemain.OCCUR =  (dataRemain.OCCUR.equals("0") ||  dataRemain.OCCUR.equals("")) ? "0" : WebUtil.printNumFormat(dataRemain.OCCUR,2) ;
					dataRemain.ABWTG = (dataRemain.ABWTG.equals("0") ||  dataRemain.ABWTG.equals("")) ? "0" : WebUtil.printNumFormat(dataRemain.ABWTG,2);

					out.println(remainDays + "," + dataRemain.E_REMAIN + "," + dataRemain.ZKVRB + "," + dataRemain.OCCUR + "," + dataRemain.ABWTG+ "," + dataRemain.ZKVRBTX);

					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	0) remainDays		 	 :	[ " + remainDays + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	1) dataRemain.E_REMAIN 	 :	[ " + dataRemain.E_REMAIN  + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	2) dataRemain.ZKVRB 	 :	[ " + dataRemain.ZKVRB  + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	3) dataRemain.OCCUR		 :	[ " + dataRemain.OCCUR + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	4) dataRemain.ABWTG		 :	[ " + dataRemain.ABWTG + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	5) dataRemain.ZKVRBTX	 :	[ " + dataRemain.ZKVRBTX + " ]");
				}

				return;

            } else if( jobid.equals("create") ) {


        	    dest = requestApproval(req, box,  D03VocationData.class, new RequestFunction<D03VocationData>() {
        	                        public String porcess(D03VocationData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

        	        //D03VocationData d03VocationData   = new D03VocationData();
        	        D03VocationRFC    rfc               = new D03VocationRFC();
        	        Vector d03VocationData_vt = new Vector();

	                //------------------------------------  üũ ------------------------------------//

	                String message = checkData( box,  user,  PERNR,  phonenumdata, inputData, req );
	                String AINF_SEQN = null;

        	        //req.setAttribute("d03VocationData_vt", d03VocationData_vt);

//                    Logger.debug.println(this, "########## d03VocationData : " + inputData);

	                if( !message.equals("") ){
	                    String  P_A024_SEQN   = box.get("P_A024_SEQN");         // SEQN

	                    Logger.debug.println(this, "66666:"+message);
	                    req.setAttribute("jobid", jobid);
	                    req.setAttribute("message", message);
	                    req.setAttribute("P_A024_SEQN", P_A024_SEQN);

	                    Logger.debug.println(this, "4 : "  );
//	                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationDetailSV?AINF_SEQN="+AINF_SEQN+"';";
//	                    req.setAttribute("url", url);

                    	//d03VocationData.PERNR       = PERNR;
                        //d03VocationData_vt.addElement(d03VocationData);
	                    
	                    // �����ް� ����üũ
	                    AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
	                	String E_AUTH = authCheckNTMRFC.getAuth(PERNR, "S_ESS");
	                	req.setAttribute("E_AUTH", E_AUTH);

	                    // �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
	                    D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();
	                    if("Y".equals(E_AUTH)) {	//�繫��
	                    	D03RemainVocationOfficeRFC  rfcRemain             = new D03RemainVocationOfficeRFC();
	                    	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, DataUtil.getCurrentDate(), "A");
	                    } else {					//������
	                    	// �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
	                    	D03RemainVocationRFC  rfcRemain             = new D03RemainVocationRFC();
	                    	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, DataUtil.getCurrentDate());
	                    }
/*
                        D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                        Vector OTHDDupCheckData_vt = func2.getCheckList( PERNR, UPMU_TYPE , user.area);

                        req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                        */
                        req.setAttribute("d03RemainVocationData", d03RemainVocationData);
	                    //
	                    getApprovalInfo(req, PERNR);    //<--
                        req.setAttribute("approvalLine", approvalLine); //����� �������

	                    printJspPage(req, res, WebUtil.JspURL+"D/D03Vocation/D03VocationBuild.jsp");

	                    return null;

	                } else { //

        	            d03VocationData_vt.addElement(inputData);
        	            inputData.PERNR     = PERNR;
	                    //@v1.0
	                    String  P_A024_SEQN   = box.get("P_A024_SEQN");         // SEQN

	                    Logger.debug.println(this, "22222");
	                    //Logger.debug.println( this, d03WorkPeriodData_vt.toString() );
	                    Vector          ret             = new Vector();
	                    Logger.debug.println(this, " rfc.build before" );

                        rfc.setRequestInput(user.empNo, UPMU_TYPE);
	                    AINF_SEQN =  rfc.build( PERNR, inputData, P_A024_SEQN, box, req );

	                    if(!rfc.getReturn().isSuccess() || AINF_SEQN==null) {
                            throw new GeneralException(rfc.getReturn().MSGTX);
                        };



                        /*
	                        Logger.debug.println(this, "SAP"+E_MESSAGE);
	                        req.setAttribute("jobid", jobid);
	                        req.setAttribute("message", msg);
	                        req.setAttribute("d03VocationData_vt", d03VocationData_vt);
	                        req.setAttribute("d03WorkPeriodData_vt", d03WorkPeriodData_vt);
	                        req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
	                        req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
	                        req.setAttribute("CONG_DATE", CONG_DATE);
	                        req.setAttribute("HOLI_CONT", HOLI_CONT);
	                        req.setAttribute("P_A024_SEQN", P_A024_SEQN);
	                        dest = WebUtil.JspURL+"D/D03Vocation/D03VocationBuild.jsp";
                        */
	                }
	                return AINF_SEQN;
                }});
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            if(  req.getAttribute("message")==null || req.getAttribute("message").equals("")){
	            Logger.debug.println(this, " destributed = " + dest);
	            printJspPage(req, res, dest);
            }
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }

    }




    /**********************************************************************************
     *
     * @return String message ; Success="", fail:msg
     * @throws GeneralException
     */
    protected String checkData(Box box, WebUserData user, String PERNR, PersonData phonenumdata,
    		D03VocationData d03VocationData, HttpServletRequest req) throws GeneralException {

        //req.setAttribute("PersonData" , phonenumdata );

    	try{
	        D03WorkPeriodRFC  rfcWork           = new D03WorkPeriodRFC();
	        D03WorkPeriodData d03WorkPeriodData = new D03WorkPeriodData();
	        
	        // �����ް� ����üũ
            AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
        	String E_AUTH = authCheckNTMRFC.getAuth(PERNR, "S_ESS");

	        //�ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
	        D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();

	        String  AINF_SEQN          = "";

	        String  dateFrom     = "";
	        String  dateTo       = "";
	        String  message      = "";
	        double  remain_date  = 0.0;
	        double  vacation_day = 0.0;  //�޹��ϼ�
	        long    beg_time     = 0;
	        long    end_time     = 0;
	        long    work_time    = 0;

//	        DataUtil.getDay(DataUtil.removeStructur(null);  // general exception ���������ڵ�(test)
	        //@@ dataó�� �ؾ���
	        String   CONG_DATE    = WebUtil.nvl(box.get("CONG_DATE"));   // @CSR1 ��������
	        String   HOLI_CONT    = WebUtil.nvl(box.get("HOLI_CONT"),"0");   // @CSR1 �����ϼ�

	        /////////////////////////////////////////////////////////////////////////////
	        // �ް���û ����..
	        d03VocationData.BEGDA       = box.get("BEGDA");        // ��û��
	        d03VocationData.AWART       = box.get("AWART");        // �ٹ�/�޹� ����
	        d03VocationData.REASON      = box.get("REASON");      // ��û ����
	        d03VocationData.APPL_FROM   = box.get("APPL_FROM");     // ��û������
	        d03VocationData.APPL_TO     = box.get("APPL_TO");     // ��û������
	        d03VocationData.BEGUZ       = box.get("BEGUZ");        // ���۽ð�
	        d03VocationData.ENDUZ       = box.get("ENDUZ");       // ����ð�
	        d03VocationData.DEDUCT_DATE = box.get("DEDUCT_DATE");  // �����ϼ�
	        //**********�����κ� ���� (20050223:�����)**********
	        d03VocationData.ZPERNR       = user.empNo;                  //��û�� ��� ����(�븮��û ,���� ��û)
	        d03VocationData.UNAME        = user.empNo;                  //��û�� ��� ����(�븮��û ,���� ��û)
	        d03VocationData.AEDTM        = DataUtil.getCurrentDate();  // ������(���糯¥)
	        d03VocationData.CONG_CODE    = box.get("CONG_CODE");    // ��������
	        d03VocationData.OVTM_CODE    = box.get("OVTM_CODE");   /// �����ڵ�CSR ID:1546748
	        d03VocationData.OVTM_NAME    = box.get("OVTM_NAME");    // �����ڵ�CSR ID:1546748
	        //**********���� �κ� ��..****************************

	        if("Y".equals(E_AUTH)) {	//�繫��
	        	String vocaType = (d03VocationData.AWART.equals("0111") 
									|| d03VocationData.AWART.equals("0112") 
									|| d03VocationData.AWART.equals("0113")) ? "B" : "A";
            	D03RemainVocationOfficeRFC  rfcRemain             = new D03RemainVocationOfficeRFC();
            	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, d03VocationData.APPL_FROM, vocaType);
            } else {					//������
            	D03RemainVocationRFC  rfcRemain             = new D03RemainVocationRFC();
            	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, d03VocationData.APPL_FROM);
            }

	        //** 2016.11.01 rfcRemain.ZKVRB -> rfcRemain.ZKVRB �ܿ��ް��ϼ� **//

	        if (d03RemainVocationData.ZKVRB==null || d03RemainVocationData.ZKVRB.equals(""))
	        	d03RemainVocationData.ZKVRB="0";

	        d03VocationData.REMAIN_DATE = d03RemainVocationData.ZKVRB;   //box.get("REMAIN_DATE");   // �ܿ��ް��ϼ�

	        //------------------------------------ ���� �ٹ� ���� üũ -----------------------------------//
	        dateFrom    = box.get("APPL_FROM");
	        dateTo      = box.get("APPL_TO");
	        Logger.debug.println(this, "  pernr:"+PERNR+"d03VocationData.APPL_FROM:"+d03VocationData.APPL_FROM+"RemainVocation : " + d03RemainVocationData.toString());

	        remain_date = Double.parseDouble(box.get("REMAIN_DATE")); //==>d03RemainVocationData.E_REMIAN�� ������ //Double.parseDouble(d03RemainVocationData.ZKVRB);  //

	        Vector d03WorkPeriodData_vt = rfcWork.getWorkPeriod( PERNR, dateFrom, dateTo );
	        if (d03WorkPeriodData_vt.size()==0 || rfcWork.getReturn().isSuccess()==false){
	        	return "���� �۾� �����ٿ� ������ �ֽ��ϴ�. �λ����ڿ��� ���ǹٶ��ϴ�.";
	        }
	        Logger.debug.println(this, "���� �Ⱓ �۾� ������ : " + d03WorkPeriodData_vt.toString());

	        //--2002.09.06.  ���̳ʽ� �ް��� ������ ��츦 üũ�ϰ� �Ѱ踦 ���Ѵ�
	        D03MinusRestRFC func_minus = new D03MinusRestRFC();
	        String          minusRest  = func_minus.check(PERNR, user.companyCode, dateFrom);
	        double          minus      = Double.parseDouble(minusRest);
	        if( minus < 0.0 ) {
	            minus = minus * (-1);
	        }
/*
	        // LG����ȭ�� ����, ����, ����ް� ��û�� ���̳ʽ��ް� �����Ѵ�.----
	        if( user.companyCode.equals("N100") ) {
	            remain_date = remain_date + minus;
	        // LGȭ���̸鼭 ����ް� ��û�� ���̳ʽ��ް� �����Ѵ�.-----------------------------------
	        } else */
	        if( user.companyCode.equals("C100") && d03VocationData.AWART.equals("0122") ) {
	            remain_date = remain_date + minus;
	        }

	        Logger.debug.println( "minusRest : " + minusRest);
	        Logger.debug.println( "minus : " + minus);
	        Logger.debug.println( "remain_date : " + remain_date);
            //--2002.09.06. ���̳ʽ� �ް��� ������ ��츦 üũ�ϰ� �Ѱ踦 ���Ѵ�. --------------------------//

            // ��¥ ������ sap�� ��Ģ�� ������. //
            /* �����ް� : �ް� �ܿ��ϼ����� ���� �ϼ��� ��û�Ҽ� ����.
             ��û �Ⱓ�� �ٹ� �ϼ�(����ϰ� ���� ����)�� ����ؼ� �����ϼ��� ���Ѵ�.
             ���Ϲ��� : ���Ͽ��� ��û����
             ����ް� : ����Ͽ��� ��û�����ϸ�, �繫���� ��츸 ��û�����ϴ�.
             �����ް� : 6�� ���Ϸ� ��û�����ϴ�.
             �ϰ��ް� : 5�� ���Ϸ� ��û�����ϴ�.
             ���ϰ��� : �Ⱓ ���� ���� ��û�����ϴ�.
             �ð����� : �ٹ������� �����ϴ� ������ ��û�����ϴ�.
             �޹��ϼ��� ���ϱٹ������� ����Ϸ� ���Ѵ�.                            */

	        /////////[CSR ID:2942508] �����ް� ��û �˾� ��û///////////////////////////////////////////////////////////////
	        String currDate =  DataUtil.getCurrentDate();
	        String currMon = DataUtil.getCurrentMonth();
	        String nextMon = DataUtil.getAfterMonth(currDate, 1);
	        //Logger.debug.println(this, "@@@~~~~~@@@ : "+ currDate+", "+currMon+", "+nextMon+", "+currDate.substring(2, 4));
	        /////////[CSR ID:2942508]�����ް� ��û �˾� ��û//////////////////////////////////////////////////////////

	        if( d03VocationData.AWART.equals("0110") || d03VocationData.AWART.equals("0111") ) { // �����ް�..
	            int count     = 0;
	            int request_days = 0;

	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	             // ��û�Ⱓ ���ڼ��� ���Ѵ�.
	                request_days++;

	                // �ٹ��ð� ���
	                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	                work_time = end_time - beg_time;
	                if( work_time > 40000 ) {
	                    count++;
	                }

	             // �޹��ϼ� ���
	                if( work_time >= 40000 ) {
	                    vacation_day++;
	                }
	            }

	            if( count == request_days ) {
	                if( count > remain_date ) {
	    	        	Logger.debug.println(this, "count > remain_date :" + count+","+remain_date );
	                    message = g.getMessage("MSG.D.D03.0056");//�ް���û�ϼ��� �ܿ��ް��ϼ����� �����ϴ�.";

	                    //[CSR ID:2942508]  �����ް� ��û �˾� ��û - �����ް� ����
	                    if(currMon.equals("12") && d03VocationData.AWART.equals("0110")){
	                    	String arg[]= {currDate.substring(2, 4), nextMon.substring(2, 4) } ;
	                    	message=g.getMessage("MSG.D.D03.0057", arg);
	                    	//"�ް��Ⱓ�� '"+currDate.substring(2, 4)+".12.21 ������ ���, '"+nextMon.substring(2, 4)+"�� �ű� ������ �����Ǿ�� \\n��û �����մϴ�.(����������:'"+currDate.substring(2, 4)+".12.21)";
	                    }
	                } else if( count == 0 ) {
	                    message = g.getMessage("MSG.D.D03.0055");//"��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
	                }
	                d03VocationData.DEDUCT_DATE = Double.toString(count);   // �����ް��϶��� �����ϼ��� �ٽ� ����Ѵ�.
	            } else {
	                message = g.getMessage("MSG.D.D03.0058");//"�����ް��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
	            }

	        } else if( d03VocationData.AWART.equals("0120") || d03VocationData.AWART.equals("0121") 
	        			|| d03VocationData.AWART.equals("0112") || d03VocationData.AWART.equals("0113") ) { //  ���Ϲ���..
	            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	            //  �ٹ��ð� ���
	            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	            work_time = end_time - beg_time;
	            if( work_time > 40000 ) {
	                //vacation_day++;
	                //if( vacation_day > remain_date ) {
	                if ( remain_date < 0.5 ) {   //0.5�ϸ� ���Ҿ ��û�����ϵ���
	    	        	Logger.debug.println(this, "remain_date < 0.5 :" + remain_date );
	                    message = g.getMessage("MSG.D.D03.0056");//�ް���û�ϼ��� �ܿ��ް��ϼ����� �����ϴ�.";

	                  //[CSR ID:2942508] �����ް� ��û �˾� ��û - �����ް� ����
	                    if(currMon.equals("12") && (d03VocationData.AWART.equals("0120") || d03VocationData.AWART.equals("0121"))){
	                    	String arg[]= {currDate.substring(2, 4), nextMon.substring(2, 4) } ;
	                    	message=g.getMessage("MSG.D.D03.0057", arg);
	                    	//message="�ް��Ⱓ�� '"+currDate.substring(2, 4)+".12.21 ������ ���, '"+nextMon.substring(2, 4)+"�� �ű� ������ �����Ǿ�� \\n��û �����մϴ�.(����������:'"+currDate.substring(2, 4)+".12.21)";
	                    }
	                }
	            } else {
	                message = g.getMessage("MSG.D.D03.0072");//"�����ް��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
	            }
	            Logger.debug.println(this, "d03VocationData.BEGUZ : " + Long.parseLong(d03VocationData.BEGUZ));
	            Logger.debug.println(this, "d03VocationData.ENDUZ : " + Long.parseLong(d03VocationData.ENDUZ));
                // [��CSR ID:C20130130_63372]�����ް� ��û �����û
                //21:���λ��,22:�繫��
                //1. ����(����):0120 ����ð��� 14:00 ���� �Ұ�
                //2. ����(�Ĺ�):0121 ���۽ð��� 13:00 ���� �Ұ�

	            if (Integer.parseInt(DataUtil.removeStructur(d03VocationData.APPL_FROM,"-"))<Integer.parseInt("20170801")){ //[CSR ID:3438118] flexible time �ý��� ��û 20170720 eunha
	             if( phonenumdata.E_PERSK.equals("21")||phonenumdata.E_PERSK.equals("22") ) {
	                if( d03VocationData.AWART.equals("0120") &&  Long.parseLong(d03VocationData.ENDUZ) > 140000  ) {
	                	message = g.getMessage("MSG.D.D03.0059");//"�����ް�(����) ����ð��� 14:00 ���ķ� �Է��� �� �����ϴ�.";
	                }
	                if( d03VocationData.AWART.equals("0121") && Long.parseLong(d03VocationData.BEGUZ) < 130000  ) {
	                	message = g.getMessage("MSG.D.D03.0060");//"�����ް�(�Ĺ�) ���۽ð��� 13:00 �������� �Է��� �� �����ϴ�.";
	                }
	             }
	            } //[CSR ID:3438118] flexible time �ý��� ��û 20170720 eunha

	          //[CSR ID:3351729] ������� �ͻ���� �߰� ������ �ް���û Error start
	          //��������׷� 39 ����� 40 �����(���) ����(����) �̰� �ְ��ٷ����̸� �ް��������ڰ� �������ں��� �۾ƾ� �Ѵ�.
	            if( phonenumdata.E_PERSK.equals("39")||phonenumdata.E_PERSK.equals("40") ) {
	                if( d03VocationData.AWART.equals("0120") &&  beg_time <=90000  ) {
	                	if(Long.parseLong(d03VocationData.BEGUZ) >= Long.parseLong(d03VocationData.ENDUZ) ){
	                		message = g.getMessage("MSG.D.D03.0027");//���۽ð��� Ȯ���ϼ���.
	                	}
	                }
	            }
	          //[CSR ID:3351729] ������� �ͻ���� �߰� ������ �ް���û Error end
	        	Logger.debug.println(this, "message : " + message);
	        } else if( d03VocationData.AWART.equals("0122") ) {     // ����ް�..
	            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	            // �ٹ��ð� ���
	            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	            work_time = end_time - beg_time;

	            //------------------��ġ����ٹ������� üũ�ϰ� ��ġ����ٹ����̸� ��û�� ���´�.
	            D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
	            String           shiftCheck = func_shift.check(PERNR, dateFrom);
	            if( shiftCheck.equals("1") ) {
	                message = g.getMessage("MSG.D.D03.0061");// "
	            } else {
	                //------------------��ġ����ٹ������� üũ�ϰ� ��ġ����ٹ����̸� ��û�� ���´�.
	                if( work_time >= 40000 ) {
	                    vacation_day++;

	                    if( vacation_day > vacation_day ) {

		    	        	Logger.debug.println(this, "vacation_day > vacation_day :" + vacation_day +">"+vacation_day );
		    	        	message = g.getMessage("MSG.D.D03.0056");//"�ް���û�ϼ��� �ܿ��ް��ϼ����� �����ϴ�.";

	                      //[CSR ID:2942508] �����ް� ��û �˾� ��û
	                        if(currMon.equals("12")){
		                    	String arg[]= {currDate.substring(2, 4), nextMon.substring(2, 4) } ;
		                    	message=g.getMessage("MSG.D.D03.0057", arg);
	                        	//�ް��Ⱓ�� '"+currDate.substring(2, 4)+".12.21 ������ ���, '"+nextMon.substring(2, 4)+"�� �ű� ������ �����Ǿ�� \\n��û �����մϴ�.(����������:'"+currDate.substring(2, 4)+".12.21)";
	                        }
	                    }
	                } else {
	                    message = g.getMessage("MSG.D.D03.0062");//"����ް��� �ٹ������� �ִ� ����Ͽ��� ��û�����մϴ�.";
	                }
	            }

	        } else if( d03VocationData.AWART.equals("0130")||d03VocationData.AWART.equals("0370") ) { // �����ް�, [CSR ID : 1225704] 0370:�ڳ���깫��
	            int count = 0;

	        	Logger.debug.println(this, "d03VocationData.CONG_CODE:" + d03VocationData.CONG_CODE);

	        	//  2013.12.17
            	//<�����ް� �ϼ� ����>
            	//      1���� : �������� (������, �Ͽ���)
            	//      2���� : �ٹ������� OFF(��, ������� ����)
            	//	�繫���� ������� ���������̹Ƿ� �ް��ϼ�üũ�����ԵǾ�� ��
	        	D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
	        	String           shiftCheck = func_shift.check(PERNR, dateFrom);

	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	                //  �ٹ��ð� ���
	                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	                work_time = end_time - beg_time;
	            	Logger.debug.println(this, "beg_time:" +beg_time+" end_time:"+end_time+"work_time:"+work_time+"count:"+count);
	                if( work_time >= 40000 ) {
	                    count++;
                    	Logger.debug.println(this, "? work_time >= 4000 : count :" +work_time +"count:"+count);
	                }else if ( shiftCheck.equals("D")   &&   d03WorkPeriodData.DAY.equals("6")&& Integer.parseInt(HOLI_CONT)>=6
	                			&& d03WorkPeriodData.CHK_0340.equals("")){
                        //@CSR1  �������� ������� �����ް��ϼ�   �̻���(��, 6�� �̻��� �����ް��� ��������� ����)
                    	//CSR ID : C20140219  CHK_0340:"" :�Ϲ� ,�����ִ°�� ������ ..
                    	//shiftCheck: D �� �������� �ƴ� �ϱ���
	                        	count++;
	                        	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT+"count:"+count);
	                }
	                // �޹��ϼ� ���
	            	// C20140106_63914
	                if( work_time >= 40000 ) {
	                    vacation_day++;
	                }else if ( shiftCheck.equals("D")   &&   d03WorkPeriodData.DAY.equals("6")&& Integer.parseInt(HOLI_CONT)>=6
	                			&& d03WorkPeriodData.CHK_0340.equals("")){
                        //@CSR1  �������� ������� �����ް��ϼ�   �̻���(��, 6�� �̻��� �����ް��� ��������� ����)
                    	//CSR ID : C20140219  CHK_0340:"" :�Ϲ� ,�����ִ°�� ������ ..
                    	//shiftCheck: D �� �������� �ƴ� �ϱ���
	                	vacation_day++;
	                	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT+"vacation_day:"+vacation_day);
	                }

	            }

	        	Logger.debug.println(this, "count:" + count);
	        	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT);
	        	Logger.debug.println(this, "CONG_DATE:" + CONG_DATE);
	        	Logger.debug.println(this, "d03VocationData.CONG_CODE:" + d03VocationData.CONG_CODE);
	            String date = DataUtil.getCurrentDate();
	            int day9001 =0;
	            if (Integer.parseInt(date) >= 20120802) { //20120802�� ���� �ڳ����� ���� �ް� 1�� ��3��
	            	day9001=3;
	            }else{
	            	day9001=1;
	            }
	            if( d03VocationData.CONG_CODE.equals("9001") && count > day9001 ) {
	                message =  g.getMessage("MSG.D.D03.0063", Integer.toString(day9001));// �����ް�:�ڳ����(����)�� "+day9001+"�� ���Ϸ� ��û �����մϴ�.";
	            } else if( d03VocationData.CONG_CODE.equals("9002") && count > 2 ) {
	                    message = g.getMessage("MSG.D.D03.0064");//""�����ް�:�ڳ����(����)�� 2�� ���Ϸ� ��û �����մϴ�.";
	            } else if( count > 6 ) {
	                    message = g.getMessage("MSG.D.D03.0065");//"�����ް��� 6�� ���Ϸ� ��û �����մϴ�.";
	            } else if( count == 0 &&  DataUtil.getDay( DataUtil.removeStructur(d03WorkPeriodData.BEGDA,"-") ) != 7  ) {
	                message = g.getMessage("MSG.D.D03.0066");//"��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
	            }
	             //@@@
	            if ( (count> Integer.parseInt(HOLI_CONT) ) &&  !CONG_DATE.equals("")){

	            	message = g.getMessage("MSG.D.D03.0067", HOLI_CONT);//�����߻����� �����Ͽ� ��û�ؾ� �ϸ�, ������ �����ް��ϼ�"+HOLI_CONT+"���� �ʰ��� �� �����ϴ�.";
	            }

	        } else if( d03VocationData.AWART.equals("0140") ) { //
	            // 2003.01.02. - �ϰ��ް� ����ϼ��� ��������.
	            D03VacationUsedRFC    rfcVacation           = new D03VacationUsedRFC();
	            double                E_ABRTG               = Double.parseDouble( rfcVacation.getE_ABRTG(PERNR) );
	            //----------------------------------------------------------------------------------------------------

	            int count = 0;
	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	                //
	                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	                work_time = end_time - beg_time;
	                if( work_time >= 40000 ) {
	                    count++;
	                }

	                //
	                if( work_time >= 40000 ) {
	                    vacation_day++;
	                }
	            }
	            if( (count + E_ABRTG) > 5 ) {
	                message = g.getMessage("MSG.D.D03.0068", WebUtil.printNumFormat(E_ABRTG));//"
	            } else if( count == 0 ) {
	                message = g.getMessage("MSG.D.D03.0069");//
	            }

	        } else if( d03VocationData.AWART.equals("0170") ) { //
	            int count = 0;
	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	                //
	                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	                work_time = end_time - beg_time;
	                if( work_time >= 40000 ) {
	                    count++;
	                }

	                //
	                if( work_time >= 40000 ) {
	                    vacation_day++;
	                }
	            }
	            if( count == 0 ) {
	                message = g.getMessage("MSG.D.D03.0066");//
	            }

	        } else if( d03VocationData.AWART.equals("0180") ||d03VocationData.AWART.equals("0190")) { //
	            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	            // �ٹ��ð� ���
	            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	            work_time = end_time - beg_time;
	            if( work_time < 40000 ) {
	                message = g.getMessage("MSG.D.D03.0066");//
	            }

	         // �޹��ϼ� ���
	            if( work_time >= 40000 ) {
	                vacation_day++;
	            }

	            // 2002.07.08. �����ް� ���� �߰�
	        } else if( d03VocationData.AWART.equals("0150") ) {  // �����ް�..
	        	// ����ѵ��� �����ް� ���Ͱ� �����Ҷ��� ��û�����ϵ��� üũ�Ѵ�.
	            D03MinusRestRFC func_0150 = new D03MinusRestRFC();
	            String          e_anzhl   = func_0150.getE_ANZHL(PERNR, dateFrom);
	            double          d_anzhl   = Double.parseDouble(e_anzhl);

	            if( d_anzhl > 0.0 ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	             // �ٹ��ð� ���
	                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	                work_time = end_time - beg_time;
	                if( work_time < 40000 ) {
	                    message = g.getMessage("MSG.D.D03.0066");//"��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
	                }

	                // �޹��ϼ� ���
	                if( work_time >= 40000 ) {
	                    vacation_day++;
	                }
	            } else {
	                message =g.getMessage("MSG.D.D03.0070");// "�ܿ�(����) �ް��� �����ϴ�.";
	            }

	            //  2002.08.17. LG����ȭ�� ���Ϻ�ٹ� ��û �߰�
	        } else if( d03VocationData.AWART.equals("0340") ) {   // ���Ϻ�ٹ�..
	            String chk_0340 = "";
	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	            //  �����̸鼭 �ٹ������� �������� ���Ϻ�ٹ� ��û �����ϴ�. CHK_0340 = 'Y'�� ���
	                chk_0340 = d03WorkPeriodData.CHK_0340;

	                if( !chk_0340.equals("Y") ) {
	                    message = g.getMessage("MSG.D.D03.0071");// "���Ϻ�ٹ��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
	                } else {
	                    vacation_day++;
	                }
	            }

	            // 2002.09.03. LG����ȭ�� �ٹ����� ��û �߰�
	        } else if( d03VocationData.AWART.equals("0360") ) {   // �ٹ�����..
	            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	            // �ٹ��ð� ���
	            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	            work_time = end_time - beg_time;
	            if( work_time < 40000 ) {
	                message = g.getMessage("MSG.D.D03.0055");// "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
	            }

	            // �޹��ϼ� ���
	            if( work_time >= 40000 ) {
	                vacation_day++;
	            }
	        }

	//       [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��
	        D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
	        Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult( PERNR, UPMU_TYPE, dateFrom, dateTo);
	        String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
	        String e_message = OTHDDupCheckData_new_vt.get(1).toString();

	        if( e_flag.equals("Y")){//Y�� �ߺ�, N�� OK
	        	message = e_message;
	        }

	        // ����� �޹��ϼ�(��ȸȭ�鿡 �����ֱ����� �ϼ��� �����Ѵ� - �ϴ���)�� �����Ѵ�.
	        d03VocationData.PBEZ4 = Double.toString(vacation_day);

	        req.setAttribute("d03WorkPeriodData_vt", d03WorkPeriodData_vt);
	        req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
	        req.setAttribute("CONG_DATE", CONG_DATE); //@@@
	        req.setAttribute("HOLI_CONT", HOLI_CONT);//@@@


            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
            Vector OTHDDupCheckData_vt = func2.getCheckList( PERNR, UPMU_TYPE , user.area);
            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);


            //**************** �ߺ�üũ- ����Ϸ�ƾ���� ������ start (ksc)********************
            for( int i = 0 ; i < OTHDDupCheckData_vt.size() ; i++ ) {
                D16OTHDDupCheckData2 dup_Data = (D16OTHDDupCheckData2)OTHDDupCheckData_vt.get(i);

	        	String s_BEGUZ1 = "";
	        	String s_ENDUZ1 = "";
                int s_BEGUZ = 0;
                int s_ENDUZ = 0;

                dup_Data.APPL_FROM = DataUtil.removeStructur(dup_Data.APPL_FROM,"-");
                dup_Data.APPL_TO = DataUtil.removeStructur(dup_Data.APPL_TO,"-");

	        	if (dup_Data.BEGUZ.equals("")){
//	        		Logger.debug.println(" jmk test 11 c_Data.BEGUZ-->"+i+":"+c_Data.BEGUZ);
	        	    s_BEGUZ1 = "";
	        	    s_BEGUZ = 0;
	        	}else{
//	        		Logger.debug.println(" jmk test 22 c_Data.BEGUZ-->"+i+":"+c_Data.BEGUZ);
//	        		Logger.debug.println(" jmk test 22 c_Data.BEGUZ.substring(0,2)-->"+i+":"+c_Data.BEGUZ.substring(0,2));
//	        		Logger.debug.println(" jmk test 22 c_Data.BEGUZ.substring(3,5)-->"+i+":"+c_Data.BEGUZ.substring(3,5));
                    s_BEGUZ1 = dup_Data.BEGUZ.substring(0,2) + dup_Data.BEGUZ.substring(3,5);
                    s_BEGUZ = Integer.parseInt(s_BEGUZ1);
	            }
//	        	Logger.debug.println(" jmk test 33 c_Data.ENDUZ-->"+i+":"+c_Data.ENDUZ);
	        	if (dup_Data.ENDUZ.equals("")){
//	        		Logger.debug.println(" jmk test 44 c_Data.ENDUZ-->"+i+":"+c_Data.ENDUZ);
	        	    s_ENDUZ1 = "";
	        	    s_ENDUZ = 0;
	        	}else{
//	        		Logger.debug.println(" jmk test 55 c_Data.ENDUZ-->"+i+":"+c_Data.ENDUZ);
	                s_ENDUZ1 = dup_Data.ENDUZ.substring(0,2) + dup_Data.ENDUZ.substring(3,5);
                    s_ENDUZ = Integer.parseInt(s_ENDUZ1);
                }

	        	String c_APPL_FROM = "";
                String c_APPL_TO  = "";
                String c_BEGUZ = "";
                String c_ENDUZ = "";
                String c_AWART = "";

                int i_BEGUZ = 0;
	            int i_ENDUZ = 0;

	            c_APPL_FROM = DataUtil.removeStructur(d03VocationData.APPL_FROM,"-");
	            c_APPL_TO   = DataUtil.removeStructur(d03VocationData.APPL_TO,"-");
	            c_AWART     = d03VocationData.AWART;

	            c_BEGUZ     = DataUtil.removeStructur(d03VocationData.BEGUZ,":");
	            if (c_BEGUZ.equals("")) {
	            	i_BEGUZ     = 0;
	            }else{
	            	c_BEGUZ     = c_BEGUZ.substring(0, 4);
	            	i_BEGUZ     = Integer.parseInt(c_BEGUZ);
	            }
	            c_ENDUZ = DataUtil.removeStructur(d03VocationData.ENDUZ,":");
	            if ( c_ENDUZ.equals("")) {
	            	i_ENDUZ     = 0;
	            }else{
	            	 c_ENDUZ     = c_ENDUZ.substring(0, 4);
	            	 i_ENDUZ     = Integer.parseInt(c_ENDUZ);
	            }

//	            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 APPL_FROM:+++++++++++++++++++++++>"+c_Data.APPL_FROM );
//	            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 APPL_TO:+++++++++++++++++++++++++>"+c_Data.APPL_TO );
//	            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 c_APPL_FROM:+++++++++++++++++++++>"+c_APPL_FROM );
//	            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 c_APPL_TO:+++++++++++++++++++++++>"+c_APPL_TO );

	            if(c_AWART.equals( "0120" )||c_AWART.equals( "0121" ) ||c_AWART.equals( "0112" )||c_AWART.equals( "0113")) { //if 1 : ���� ��û�Ѱ� �������
	                // �����ް�(����), �����ް�(�Ĺ�), �ð������� ���
	            	if( dup_Data.APPL_FROM.equals(c_APPL_FROM) &&dup_Data.APPL_TO.equals(c_APPL_TO)) {//if 2 : ��¥���� ���
	            		if( s_BEGUZ != 0 || s_ENDUZ != 0 ) { //if 3 : ���� ��û�� �ǵ� �� ������ ���, ����(from to �ð� ���� �ִ� ���)	                    
	                        if( s_BEGUZ1.equals(c_BEGUZ)&& s_ENDUZ1.equals(c_ENDUZ)) {//�ð� ���� ���
	                        	  message = g.getMessage("MSG.D.D03.0011");//"���� �����û�� �Ǿ� �����Ƿ� ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
	                              return message;
	                        }else if( (s_BEGUZ <= i_BEGUZ && s_ENDUZ > i_BEGUZ) ||
	                        		  ( s_BEGUZ < i_ENDUZ &&  s_ENDUZ >= i_ENDUZ) ||
	                        		  ( s_BEGUZ >= i_BEGUZ && s_ENDUZ <= i_ENDUZ) ) {//�ð��� �������� �ߺ��� ���
	                        	  message =g.getMessage("MSG.D.D03.0012");//"�̹� �����û�� �ð��� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
	                              return message;
	                        }
	                    }else{// if 3 : ���� ��û�� �ǵ��� ���� �ް��� ���-����
	                    	message =g.getMessage("MSG.D.D03.0012");//"�̹� �����û�� �ð��� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
                            return message;
	                    }
	                }else if( ( Integer.parseInt(dup_Data.APPL_FROM)  <= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  > Integer.parseInt(c_APPL_FROM)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  <  Integer.parseInt(c_APPL_TO)   && Integer.parseInt(dup_Data.APPL_TO) >= Integer.parseInt(c_APPL_TO)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  >= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  <= Integer.parseInt(c_APPL_TO))){
	                	//��¥�� �ٸ��� from-to�� ��ġ�� ���
	                	message =g.getMessage("MSG.D.D03.0012");//"�̹� �����û�� �ð��� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
                        return message;
	                }
	            } //if 1 ������ ��� ��
	            
                else { //���� �ް��� ���
                    if( dup_Data.APPL_FROM.equals(c_APPL_FROM) && dup_Data.APPL_TO.equals(c_APPL_TO)) { //if 2 : ��¥���� ���
                    	message = g.getMessage("MSG.D.D03.0011");//"���� �����û�� �Ǿ� �����Ƿ� ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
                        return message;
                    } else if( ( Integer.parseInt(dup_Data.APPL_FROM)  <= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  > Integer.parseInt(c_APPL_FROM)) ||
                    		   ( Integer.parseInt(dup_Data.APPL_FROM)  <  Integer.parseInt(c_APPL_TO)   && Integer.parseInt(dup_Data.APPL_TO) >= Integer.parseInt(c_APPL_TO)) ||
                    		   ( Integer.parseInt(dup_Data.APPL_FROM)  >= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  <= Integer.parseInt(c_APPL_TO)) ) {
                    	message = g.getMessage("MSG.D.D03.0012");//"�̹� �����û�� ��¥�� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
                        return message;
                    } //if 3
                } //if 2

            }
            //**************** ����Ϸ�ƾ end ********************


	        return message;

	    } catch(Exception e) {
	        throw new GeneralException(e);

	    } finally {
	    }
    }

}

