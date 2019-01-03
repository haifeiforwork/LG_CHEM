/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ��û                                                        		*/
/*   2Depth Name  : ����                                                        		*/
/*   Program Name : �ް� ����                                                   		*/
/*   Program ID   : D03VocationChangeSV                                         */
/*   Description  : �ް� ���� �Ҽ� �ֵ��� �ϴ� Class                            	*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  �赵��                                          		*/
/*   Update       : 2005-03-04  �����                                          		*/
/*   Update       : 2013-09-03  LSA  @CSR1  �������� ������� �����ް��ϼ�   �̻���(��, 6�� �̻��� �����ް��� ��������� ����)  */
/*   Update       : 2014-02-04  C20140106_63914 : �����ް� ���� �߰�   			*/
/*   Update       : 2014-02-19  C20140219 : �����ް� ������� �������� ��� �ް��ϼ��� ��������Է��� ����   */
/*                : 2014-08-24   [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��   */
/*                : 2016-10-10 FD-038 GEHR�����۾�-KSC 							*/
/*                : 2017-08-21 [CSR ID:3462893] �ܿ����� ���� ������û�� �� 		*/
/*						//@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel */
/*                : 2017-05-17 ��ȯ�� [WorkTime52] �����ް� �߰� �� 				*/
/********************************************************************************/
package servlet.hris.D.D03Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03CondolHolidaysData;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.D03WorkPeriodData;
import hris.D.D03Vocation.rfc.D03CondolHolidaysRFC;
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
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.AuthCheckNTMRFC;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="18";            // ���� ����Ÿ��(�ް���û)

	private String UPMU_NAME = "Leave";

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
            /**         * Start: ������ �б�ó�� 
             * //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel */
           if (user.area.equals(Area.KR) ) {
			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE) || user.area.equals(Area.US)|| user.area.equals(Area.MX)) { // PL ������, DE ���� �� ����ȭ������
        	   printJspPage(req, res, WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationChangeEurpSV" );
		       	return;
			} else{
				printJspPage(req, res, WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationChangeGlobalSV" );
		       	return;
			}
            /**             * END: ������ �б�ó��             */

            String dest = "";

            final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());


            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            //**********���� ���� (20050304:�����)**********
            final String          ainf_seqn           = box.get("AINF_SEQN");
            final D03VocationRFC  rfc                 = new D03VocationRFC();
            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn); // ���������

            D03VocationData d03VocationData     = new D03VocationData();

            Vector          d03VocationData_vt  = null;
            D03VocationData  tempData    = new D03VocationData();
            d03VocationData_vt = rfc.getVocation( tempData.PERNR, ainf_seqn );
            tempData   = (D03VocationData)Utils.indexOf(d03VocationData_vt, 0);
            //�ް���û ��ȸ
            Logger.debug.println(this, "�ް���û ��ȸ : " + d03VocationData_vt.toString());

            // �븮 ��û �߰�
            PersonInfoRFC numfunc         = new PersonInfoRFC();
            PersonData phonenumdata    = null;

            phonenumdata  = (PersonData)numfunc.getPersonInfo(tempData.PERNR, "X" );
            req.setAttribute("PersonData" , phonenumdata );

            //**********���� ��.****************************

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.

                req.setAttribute("isUpdate", true); //[����]��� ���� ����   <- �����ʿ��� �ݵ�� �ʿ���

                // �ް���û ��ȸ
                d03VocationData_vt = rfc.getVocation( tempData.PERNR, ainf_seqn );
                d03VocationData    = (D03VocationData)d03VocationData_vt.get(0);
                Logger.debug.println(this, "�ް���û ��ȸ : " + d03VocationData_vt.toString());
                
                // �����ް� ����üũ
                AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
            	String E_AUTH = authCheckNTMRFC.getAuth(tempData.PERNR, "S_ESS");
            	req.setAttribute("E_AUTH", E_AUTH);
            	
                // �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
                D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();
                
                if("Y".equals(E_AUTH)) {	//�繫��
                	String vocaType = (d03VocationData.AWART.equals("0111") 
                						|| d03VocationData.AWART.equals("0112") 
                						|| d03VocationData.AWART.equals("0113")) ? "B" : "A";
                	D03RemainVocationOfficeRFC  rfcRemain = new D03RemainVocationOfficeRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(tempData.PERNR, d03VocationData.APPL_TO, vocaType);
                } else {
                	D03RemainVocationRFC rfcRemain             = new D03RemainVocationRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(tempData.PERNR, d03VocationData.APPL_TO);
                }
                
                //@csr1�����ް��ΰ�� �����ϼ�,������ �ѱ�� ���� �߰�
                Vector D03CondolHolidaysData_dis = ( new D03CondolHolidaysRFC() ).getCongDisplay(tempData.PERNR ,"1",DataUtil.getCurrentDate(),"","");

                String CONG_DATE = "";
                String HOLI_CONT = "";

                for( int i = 0 ; i < D03CondolHolidaysData_dis.size() ; i++ ) {
                    D03CondolHolidaysData data = (D03CondolHolidaysData)D03CondolHolidaysData_dis.get(i);

                    if ( data.AINF_SEQN.equals(d03VocationData.A002_SEQN)){
                    	HOLI_CONT = data.HOLI_CONT;
                    	CONG_DATE = data.CONG_DATE;
                    }
                }

                Logger.debug.println(this, "d03VocationData.A002_SEQN : "+ d03VocationData.A002_SEQN );
                Logger.debug.println(this, "CONG_DATE : "+ CONG_DATE );
                Logger.debug.println(this, "HOLI_CONT : "+ HOLI_CONT );
                req.setAttribute("d03RemainVocationData", d03RemainVocationData);
                req.setAttribute("d03VocationData_vt",    d03VocationData_vt);
                req.setAttribute("CONG_DATE",        CONG_DATE); //@csr1
                req.setAttribute("HOLI_CONT",        HOLI_CONT); //@csr1


                D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = null;
                OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList( tempData.PERNR, UPMU_TYPE ,user.area);
                Logger.debug.println(this, "OTHDDupCheckData_vt : "+ OTHDDupCheckData_vt.toString());
                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

                detailApporval(req, res, rfc);

                dest = WebUtil.JspURL+"D/D03Vocation/D03VocationBuild.jsp";

            } else if( jobid.equals("change") ) {       //

            	final D03VocationData firstData = tempData;
                // ���� ���� �κ� /
                dest = changeApproval(req, box, D03VocationData.class, rfc, new ChangeFunction<D03VocationData>(){
                    public String porcess(D03VocationData d03VocationData, ApprovalHeader approvalHeader,
                    		Vector<ApprovalLineData> approvalLine)
                			throws GeneralException {


                Vector d03VocationData_vt = new Vector();

                /////////////////////////////////////////////////////////////////////////////
                // �ް���û ����..
                d03VocationData.AINF_SEQN   = ainf_seqn;                // �������� �Ϸù�ȣ
                d03VocationData.BEGDA       = box.get("BEGDA");         // ��û��
                d03VocationData.AWART       = box.get("AWART");         // �ٹ�/�޹� ����
                d03VocationData.REASON      = box.get("REASON");          // ��û ����
                d03VocationData.APPL_FROM   = box.get("APPL_FROM");     // ��û������
                d03VocationData.APPL_TO     = box.get("APPL_TO");       // ��û������
                d03VocationData.BEGUZ       = box.get("BEGUZ");         // ���۽ð�
                d03VocationData.ENDUZ       = box.get("ENDUZ");         // ����ð�
                d03VocationData.DEDUCT_DATE = box.get("DEDUCT_DATE");   // �����ϼ�
                //**********���� ���� (20050223:�����)**********
                d03VocationData.PERNR       = firstData.PERNR;           // �����ȣ
                d03VocationData.ZPERNR      = user.empNo;           // �����ȣ
                d03VocationData.UNAME       = user.empNo;               //��û�� ��� ����(�븮��û ,���� ��û)
                d03VocationData.AEDTM       = DataUtil.getCurrentDate();
                d03VocationData.CONG_CODE   = box.get("CONG_CODE");   // ��������                 // ������(���糯¥)
                d03VocationData.OVTM_CODE    = box.get("OVTM_CODE");   // �����ڵ�CSR ID:1546748
                d03VocationData.OVTM_NAME    = box.get("OVTM_NAME");   // �����ڵ�CSR ID:1546748
                //**********���� ��.****************************

                String message = checkData(box, d03VocationData, user , firstData, req);


                //------------------------------------ ���� �ٹ� ���� üũ ------------------------------------//

                if( !message.equals("") ){      //�޼����� �ִ°��
                    d03VocationData_vt.addElement(d03VocationData);



                    String  P_A024_SEQN   = box.get("P_A024_SEQN");         // ������û����SEQN
                    Logger.debug.println(this, "������������");
                    req.setAttribute("jobid", jobid);
                    req.setAttribute("message", message);
                    req.setAttribute("msg2", message);
                    req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                    req.setAttribute("P_A024_SEQN", P_A024_SEQN);

                    D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                    Vector OTHDDupCheckData_vt = func2.getCheckList( firstData.PERNR, UPMU_TYPE ,user.area);
                    req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

                    detailApporval(req, res, rfc);

                    req.setAttribute("approvalLine", approvalLine); //����� �������

                    req.setAttribute("isUpdate", true); //[����]��� ���� ����   <- �����ʿ��� �ݵ�� �ʿ���
//                    String url =  WebUtil.JspURL+"D/D03Vocation/D03VocationBuild_KR.jsp";
//                    printJspPage(req,res,url);


                    return null;

                } else { //����

                    //**********���� ���� (20050223:�����)**********
                    String msg  = null;
                    String msg2 = null;

	                // * ���� ��û RFC ȣ�� * /
	                rfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

	               // Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

	                String  P_A024_SEQN   = box.get("P_A024_SEQN");         // ������û����SEQN
	                String new_ainf_seqn = rfc.build(firstData.PERNR, d03VocationData, P_A024_SEQN, box, req);//ainf_seqn, bankflag,

	                if(!rfc.getReturn().isSuccess()) {
	                    /*req.setAttribute("msg", rfc.getReturn().MSGTX);   //���� �޼��� ó�� - �ӽ�
	                    return null;*/
	                	throw new GeneralException(rfc.getReturn().MSGTX);
	                }

	                return approvalHeader.AINF_SEQN;
	                // * ������ �ۼ� �κ� �� */
                }

            }});
/*
                    if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {

                        Logger.debug.println( this, " D03Vocation appDB.c hange :AppLineData_vt "+AppLineData_vt.toString() );
                        // ���� ������ ����Ʈ
                        Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                        appDB.change(AppLineData_vt);
                        Vector          ret             = new Vector();
                        ret =  rfc.change( firstData.PERNR, ainf_seqn , d03VocationData,P_A024_SEQN );
	                    //C20111025_86242 üũ�޼��� �߰�
	                    String E_RETURN    = (String)ret.get(0);
	                    String E_MESSAGE = (String)ret.get(1);

	                    Logger.debug.println(this, "E_RETURN : " +E_RETURN );
	                    Logger.debug.println(this, "E_MESSAGE : " +E_MESSAGE );
	                    if ( E_RETURN.equals("") ) {
	                        con.commit();

	                        msg = "msg002";

	                        AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
	                        AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);
	                       Logger.debug.println(this ,oldAppLine);
	                        Logger.debug.println(this ,newAppLine);

	                        if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

	                            // ������ ����� �� ������ ,ElOffice ���� ���̽�
	                            phonenumdata    =   (PersonData)numfunc.getPersonInfo(firstData.PERNR);

	                            // �̸��� ������
	                            Properties ptMailBody = new Properties();
	                            ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
	                            ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
	                            ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);      // �� ������ ���
	                            ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ�
	                            ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (��)��û�� ���
	                            ptMailBody.setProperty("UPMU_NAME" ,"�ް�");                    // ���� �̸�
	                            ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);                 // ��û�� ����

	                            //                          �� ����
	                            StringBuffer sbSubject = new StringBuffer(512);

	                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
	                            sbSubject.append( ptMailBody.getProperty("ename") + "���� ��û�� �����ϼ̽��ϴ�.");
	                            ptMailBody.setProperty("subject" ,sbSubject.toString());

	                            ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

	                            MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
	                            // ���� ������ �� ����
	                            if (!maTe.process()) {
	                                msg2 = msg2 + " ���� " + maTe.getMessage();
	                            } // end if

	                            // �� ����
	                            sbSubject = new StringBuffer(512);
	                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
	                            sbSubject.append(ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�.");

	                            ptMailBody.setProperty("subject" ,sbSubject.toString());
	                            ptMailBody.remove("FileName");
	                            ptMailBody.setProperty("to_empNo" ,newAppLine.APPL_APPU_NUMB);

	                            maTe = new MailSendToEloffic(ptMailBody);
	                            // �ű� ������ �� ����
	                            if (!maTe.process()) {
	                                msg2 = msg2 +" \\n ��û " + maTe.getMessage();
	                            } // end if

	                            // ElOffice �������̽�
	                            try {
	                                DraftDocForEloffice ddfe = new DraftDocForEloffice();
	                                ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);

	                                Logger.debug.println(this, "makeDocForChange AINF_SEQN:"+ainf_seqn+"oldAppLine.APPL_PERNR = " + oldAppLine.APPL_PERNR);
	                                Vector vcElofficInterfaceData = new Vector();
	                                vcElofficInterfaceData.add(eof);

	                                ElofficInterfaceData eofD = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
	                                vcElofficInterfaceData.add(eofD);

	                                req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
	                                dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
	                            } catch (Exception e) {
	                                dest = WebUtil.JspURL+"common/msg.jsp";
	                                msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
	                            } // end try
	                        } else {
	                            msg = "msg002";
	                            dest = WebUtil.JspURL+"common/msg.jsp";
	                        } // end if

	                    } else {

	                    	con.rollback();
	                        msg = E_MESSAGE;

	                    	d03VocationData.PERNR       = firstData.PERNR;
	                        d03VocationData_vt.addElement(d03VocationData);

	                        D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
	                        Vector OTHDDupCheckData_vt = func2.getCheckList( firstData.PERNR, UPMU_TYPE );

	                        Logger.debug.println(this, "SAP ���� üũ�� ������������"+E_MESSAGE);
	                        req.setAttribute("jobid", jobid);
	                        req.setAttribute("message", msg);
	                        req.setAttribute("d03VocationData_vt", d03VocationData_vt);
	                        req.setAttribute("d03WorkPeriodData_vt", d03WorkPeriodData_vt);
	                        req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
	                        req.setAttribute("AppLineData_vt"      , AppLineData_vt);

	                        req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

	                        dest = WebUtil.JspURL+"D/D03Vocation/D03VocationChange.jsp";
	                 }
                    } else {
                        msg = "msg005";
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if

                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationDetailSV?AINF_SEQN="+ainf_seqn+"" +
                    "&RequestPageName=" + RequestPageName + "';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("msg2", msg2);
                    req.setAttribute("url", url);
                    //**********���� ���� (20050223:�����)**********
*/

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, "destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }







    protected String checkData(Box box, D03VocationData d03VocationData, WebUserData user , D03VocationData firstData, HttpServletRequest req) throws GeneralException {

        String  dateFrom           = "";
        String  dateTo             = "";
        String  message            = "";
        double  remain_date        = 0.0;
        double  vacation_day       = 0.0;       // �޹��ϼ�
        long    beg_time           = 0;
        long    end_time           = 0;
        long    work_time          = 0;

        try{
        //rfc                   = new D03VocationRFC();
        //d03VocationData       = new D03VocationData();
        D03WorkPeriodRFC      rfcWork               = new D03WorkPeriodRFC();
        D03WorkPeriodData     d03WorkPeriodData     = new D03WorkPeriodData();

        // �����ް� ����üũ
        AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
    	String E_AUTH = authCheckNTMRFC.getAuth(firstData.PERNR, "S_ESS");
    	
        // �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
        D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();
        
        if("Y".equals(E_AUTH)) {	//�繫��
        	String vocaType = (d03VocationData.AWART.equals("0111") 
								|| d03VocationData.AWART.equals("0112") 
								|| d03VocationData.AWART.equals("0113")) ? "B" : "A";
        	D03RemainVocationOfficeRFC  rfcRemain = new D03RemainVocationOfficeRFC();
        	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(firstData.PERNR, d03VocationData.APPL_TO, vocaType);
        } else {					//������
        	D03RemainVocationRFC  rfcRemain = new D03RemainVocationRFC();
        	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(firstData.PERNR, d03VocationData.APPL_TO);
        }

//        d03VocationData.REMAIN_DATE = d03RemainVocationData.E_REMAIN;                            //box.get("REMAIN_DATE");   // �ܿ��ް��ϼ�
        d03VocationData.REMAIN_DATE = d03RemainVocationData.ZKVRB;                            //box.get("REMAIN_DATE");   // �ܿ��ް��ϼ�

        //------------------------------------ ���� �ٹ� ���� üũ ------------------------------------//
        dateFrom    = box.get("APPL_FROM");
        dateTo      = box.get("APPL_TO");

        //@@@ ������,�����ϼ� üũ�����߰�
        String   HOLI_CONT    = WebUtil.nvl( box.get("HOLI_CONT"),"0");   //  �����ϼ�
        String   CONG_DATE    = WebUtil.nvl(box.get("CONG_DATE"),"");   //  ��������

//        remain_date = Double.parseDouble(d03RemainVocationData.E_REMAIN);              //Double.parseDouble(box.get("REMAIN_DATE"));
        //[CSR ID:3462893] �ܿ����� ���� ������û�� �� start
        //remain_date = Double.parseDouble(d03RemainVocationData.ZKVRB);              //Double.parseDouble(box.get("REMAIN_DATE"));
        remain_date = Double.parseDouble(box.get("REMAIN_DATE"));
        //[CSR ID:3462893] �ܿ����� ���� ������û�� �� end

        Vector d03WorkPeriodData_vt = rfcWork.getWorkPeriod( firstData.PERNR, dateFrom, dateTo );
        Logger.debug.println(this, "���� �Ⱓ �۾� ������ : " + d03WorkPeriodData_vt.toString());

        //--2002.09.06. ���̳ʽ� �ް��� ������ ��츦 üũ�ϰ� �Ѱ踦 ���Ѵ�. ------------------------------------//
        D03MinusRestRFC func_minus = new D03MinusRestRFC();
        String          minusRest  = func_minus.check(firstData.PERNR, user.companyCode, dateFrom);
        double          minus      = Double.parseDouble(minusRest);
        if( minus < 0.0 ) {
            minus = minus * (-1);
        }
/*
        //              LG����ȭ�� ����, ����, ����ް� ��û�� ���̳ʽ��ް� �����Ѵ�.---------------------------------------
        if( user.companyCode.equals("N100") ) {
            remain_date = remain_date + minus;
            //              LGȭ���̸鼭 ����ް� ��û�� ���̳ʽ��ް� �����Ѵ�.---------------------------------------
        } else*/
        if( user.companyCode.equals("C100") && d03VocationData.AWART.equals("0122") ) {
            remain_date = remain_date + minus;
        }

        Logger.debug.println(this, "remain_date : " + remain_date);
        //--2002.09.06. ���̳ʽ� �ް��� ������ ��츦 üũ�ϰ� �Ѱ踦 ���Ѵ�. ------------------------------------//

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


        if( d03VocationData.AWART.equals("0110") || d03VocationData.AWART.equals("0111") ) {        // �����ް�..
            int count     = 0;
            int day_count = 0;

            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                //                      ��û�Ⱓ ���ڼ��� ���Ѵ�.
                day_count++;

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

            if( count == day_count ) {
                if( count > remain_date ) {
                    message = "�ް���û�ϼ��� �ܿ��ް��ϼ����� �����ϴ�.";

                    //[CSR ID:2942508] �����ް� ��û �˾� ��û
                    if(currMon.equals("12")){
                    	message="�ް��Ⱓ�� '"+currDate.substring(2, 4)+".12.21 ������ ���, '"+nextMon.substring(2, 4)+"�� �ű� ������ �����Ǿ�� \\n��û �����մϴ�.(����������:'"+currDate.substring(2, 4)+".12.21)";
                    }
                } else if( count == 0 ) {
                    message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                }
                d03VocationData.DEDUCT_DATE = Double.toString(count);   // �����ް��϶��� �����ϼ��� �ٽ� ����Ѵ�.
            } else {
                message = "�����ް��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
            }

        } else if( d03VocationData.AWART.equals("0120") || d03VocationData.AWART.equals("0121")
        			|| d03VocationData.AWART.equals("0112") || d03VocationData.AWART.equals("0113")) { // ���Ϲ���..
            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

            // �ٹ��ð� ���
            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

            work_time = end_time - beg_time;
            if( work_time > 40000 ) {
                //vacation_day++;
                //if( vacation_day > remain_date ) {
                if ( remain_date < 0.5 ) {  //0.5�ϸ� ���Ҿ ��û�����ϵ���
                    message = "�ް���û�ϼ��� �ܿ��ް��ϼ����� �����ϴ�.";

                    //[CSR ID:2942508] �����ް� ��û �˾� ��û
                    if(currMon.equals("12")){
                    	message="�ް��Ⱓ�� '"+currDate.substring(2, 4)+".12.21 ������ ���, '"+nextMon.substring(2, 4)+"�� �ű� ������ �����Ǿ�� \\n��û �����մϴ�.(����������:'"+currDate.substring(2, 4)+".12.21)";
                    }
                }
            } else {
                message = "�����ް��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
            }

        } else if( d03VocationData.AWART.equals("0122") ) {     // ����ް�..
            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

            // �ٹ��ð� ���
            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

            work_time = end_time - beg_time;

            //------------------��ġ����ٹ������� üũ�ϰ� ��ġ����ٹ����̸� ��û�� ���´�.(2002.05.29)
            D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
            String           shiftCheck = func_shift.check(firstData.PERNR, dateFrom);
            if( shiftCheck.equals("1") ) {
                message = "�ް� ��û���� ���ϱٹ������� ��ġ�������� ����ް��� ��û�Ҽ� �����ϴ�.";
            } else {
                //------------------��ġ����ٹ������� üũ�ϰ� ��ġ����ٹ����̸� ��û�� ���´�.
                if( work_time >= 40000 ) {
                    vacation_day++;

                    if( vacation_day > remain_date ) {
                        message = "�ް���û�ϼ��� �ܿ��ް��ϼ����� �����ϴ�.";

                        //[CSR ID:2942508] �����ް� ��û �˾� ��û
                        if(currMon.equals("12")){
                        	message="�ް��Ⱓ�� '"+currDate.substring(2, 4)+".12.21 ������ ���, '"+nextMon.substring(2, 4)+"�� �ű� ������ �����Ǿ�� \\n��û �����մϴ�.(����������:'"+currDate.substring(2, 4)+".12.21)";
                        }
                    }
                } else {
                    message = "����ް��� �ٹ������� �ִ� ����Ͽ��� ��û�����մϴ�.";
                }
            }

        } else if( d03VocationData.AWART.equals("0130") ||d03VocationData.AWART.equals("0370")) { // �����ް�, [CSR ID : 1225704] 0370:�ڳ���깫��
            int count = 0;
            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                // �ٹ��ð� ���
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;


            	//  2013.12.17
            	//<�����ް� �ϼ� ����>
            	//      1���� : �������� (������, �Ͽ���)
            	//      2���� : �ٹ������� OFF(��, ������� ����)
            	//	�繫���� ������� ���������̹Ƿ� �ް��ϼ�üũ�����ԵǾ�� ��
            	// C20140106_63914
            	D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
            	String           shiftCheck = func_shift.check(firstData.PERNR, dateFrom);

                if( work_time >= 40000 ) {
                    count++;
                }else if ( shiftCheck.equals("D") &&   d03WorkPeriodData.DAY.equals("6")&& Integer.parseInt(HOLI_CONT)>=6 && d03WorkPeriodData.CHK_0340.equals("")){
                   //@CSR1  �������� ������� �����ް��ϼ�   �̻���(��, 6�� �̻��� �����ް��� ��������� ����)
                	//   CSR ID : C20140219  CHK_0340:"" :�Ϲ� ,�����ִ°�� ������ ..
               	   count++;
                	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT+"count:"+count);
                }

                // �޹��ϼ� ���
                if( work_time >= 40000 ) {
                    vacation_day++;
                }else if ( shiftCheck.equals("D") &&   d03WorkPeriodData.DAY.equals("6")&& Integer.parseInt(HOLI_CONT)>=6 && d03WorkPeriodData.CHK_0340.equals("")){
                    //@CSR1  �������� ������� �����ް��ϼ�   �̻���(��, 6�� �̻��� �����ް��� ��������� ����)
                	//   CSR ID : C20140219  CHK_0340:"" :�Ϲ� ,�����ִ°�� ������ ..
                	vacation_day++;
                 	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT+"vacation_day:"+vacation_day);
                }
            }
            String date = DataUtil.getCurrentDate();
            int day9001 =0;
            if (Integer.parseInt(date) >= 20120802) { //20120802�� ���� �ڳ����� ���� �ް� 1�� ��3��
            	day9001=3;
            }else{
            	day9001=1;
            }
            if( d03VocationData.CONG_CODE.equals("9001") && count >day9001 ) {
                message = "�����ް�:�ڳ����(����)��  "+day9001+"�� ���Ϸ� ��û �����մϴ�.";
            } else if( d03VocationData.CONG_CODE.equals("9002") && count > 2 ) {
                message = "�����ް�:�ڳ����(����)�� 2�� ���Ϸ� ��û �����մϴ�.";
            } else if( count > 6 ) {
                message = "�����ް��� 6�� ���Ϸ� ��û �����մϴ�.";
            } else if( count == 0 &&  DataUtil.getDay( DataUtil.removeStructur(d03WorkPeriodData.BEGDA,"-") ) != 7  ) {
                message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
            }
            if (!CONG_DATE.equals("") && count> Integer.parseInt(HOLI_CONT)){ //@@@
            	message = "�����߻����� �����Ͽ� ��û�ؾ� �ϸ�, ������ �����ް��ϼ��� �ʰ��� �� �����ϴ�.";

            }

            Logger.debug.println( this, "count: "+count+"HOLI_CONT:"+HOLI_CONT+"CONG_DATE:"+CONG_DATE);

        } else if( d03VocationData.AWART.equals("0140") ) { // �ϰ��ް�..
            //                  2003.01.02. - �ϰ��ް� ����ϼ��� ��������.
            D03VacationUsedRFC    rfcVacation           = new D03VacationUsedRFC();
            double                E_ABRTG               = Double.parseDouble( rfcVacation.getE_ABRTG(firstData.PERNR) );
            //----------------------------------------------------------------------------------------------------

            int count = 0;
            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                // �ٹ��ð� ���
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;
                if( work_time >= 40000 ) {
                    count++;
                }

                // �޹��ϼ� ���
                if( work_time >= 40000 ) {
                    vacation_day++;
                }
            }
            if( (count + E_ABRTG) > 5 ) {
                message = "�ϰ��ް��� 5�� ���Ϸ� ��û �����մϴ�. ���� ����� �ϰ��ް� �ϼ��� " + WebUtil.printNumFormat(E_ABRTG) + "�� �Դϴ�.";
            } else if( count == 0 ) {
                message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
            }
        } else if( d03VocationData.AWART.equals("0170") ) { // ���ϰ���..
            int count = 0;
            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                // �ٹ��ð� ���
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;
                if( work_time >= 40000 ) {
                    count++;
                }

                // �޹��ϼ� ���
                if( work_time >= 40000 ) {
                    vacation_day++;
                }
            }
            if( count == 0 ) {
                message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
            }

        } else if( d03VocationData.AWART.equals("0180") ) { // �ð�����..
            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

            // �ٹ��ð� ���
            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

            work_time = end_time - beg_time;
            if( work_time < 40000 ) {
                message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
            }

            // �޹��ϼ� ���
            if( work_time >= 40000 ) {
                vacation_day++;
            }

            //              2002.07.08. �����ް� ���� �߰�
        } else if( d03VocationData.AWART.equals("0150") ) { // �����ް�..
            //                  ����ѵ��� �����ް� ���Ͱ� �����Ҷ��� ��û�����ϵ��� üũ�Ѵ�.
            D03MinusRestRFC func_0150 = new D03MinusRestRFC();
            String          e_anzhl   = func_0150.getE_ANZHL(firstData.PERNR, dateFrom);
            double          d_anzhl   = Double.parseDouble(e_anzhl);

            if( d_anzhl > 0.0 ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // �ٹ��ð� ���
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;
                if( work_time < 40000 ) {
                    message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                }

                // �޹��ϼ� ���
                if( work_time >= 40000 ) {
                    vacation_day++;
                }
            } else {
                message = "�ܿ�(����) �ް��� �����ϴ�.";
            }

            //              2002.08.17. LG����ȭ�� ���Ϻ�ٹ� ��û �߰�
        } else if( d03VocationData.AWART.equals("0340") ) {        // ���Ϻ�ٹ�..
            String chk_0340 = "";
            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                //                      �����̸鼭 �ٹ������� �������� ���Ϻ�ٹ� ��û �����ϴ�. CHK_0340 = 'Y'�� ���
                chk_0340 = d03WorkPeriodData.CHK_0340;

                if( !chk_0340.equals("Y") ) {
                    message = "���Ϻ�ٹ��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
                } else {
                    vacation_day++;
                }
            }

            //              2002.09.03. LG����ȭ�� �ٹ����� ��û �߰�
        } else if( d03VocationData.AWART.equals("0360") ) {        // �ٹ�����..
            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

            // �ٹ��ð� ���
            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

            work_time = end_time - beg_time;
            if( work_time < 40000 ) {
                message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
            }

            // �޹��ϼ� ���
            if( work_time >= 40000 ) {
                vacation_day++;
            }
        }

        Logger.debug.println(this, "��������");
        Logger.debug.println( this, d03WorkPeriodData_vt.toString() );

        req.setAttribute("d03WorkPeriodData_vt", d03WorkPeriodData_vt);
        req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
        req.setAttribute("CONG_DATE", CONG_DATE); //@@@
        req.setAttribute("HOLI_CONT", HOLI_CONT);  //@@@
        // ����� �޹��ϼ�(��ȸȭ�鿡 �����ֱ����� �ϼ��� �����Ѵ� - �ϴ���)�� �����Ѵ�.
        d03VocationData.PBEZ4 = Double.toString(vacation_day);

//      [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��
        D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
        Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult( firstData.PERNR, UPMU_TYPE, dateFrom, dateTo);
        String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
        String e_message = OTHDDupCheckData_new_vt.get(1).toString();

        if( e_flag.equals("Y")){//Y�� �ߺ�, N�� OK
        	message = e_message;
        }

	    } catch(Exception e) {
	        throw new GeneralException(e);

	    } finally {
	    }
        return message;
    }
}
