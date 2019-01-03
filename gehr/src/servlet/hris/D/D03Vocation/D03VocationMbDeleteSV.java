/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ��û                                                                                                                 */
/*   2Depth Name  : ����                                                                                                                */
/*   Program Name : �ް�����                                                                                                          */
/*   Program ID   : D03VocationDetailSV                                         */
/*   Description  : �ް� ��ȸ/���� �Ҽ� �ֵ��� �ϴ� Class                              */
/*   Note         :                                                             */
/*   Creation     : 2011-05-04  JMK                                             */
/*                     2017-06-29 eunha  [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�*/
/********************************************************************************/
package servlet.hris.D.D03Vocation;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.common.*;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import org.jdom.Document;
import org.jdom.Element;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

public class D03VocationMbDeleteSV extends MobileAutoLoginSV {

    private String UPMU_TYPE ="18";            // ���� ����Ÿ��(�ް���û)

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{

            Logger.debug.println("D03VocationMbDeleteSV start++++++++++++++++++++++++++++++++++++++" );

        	//�α���ó��
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);

            String empNo     = box.get("empNo"); //���
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);

            // ����ó�� �����
            String returnXml = apprItem(req,res);

            // ����� ���� xmlStirng��  �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);

            // 3.return URL�� ȣ���Ѵ�.
            dest = WebUtil.JspURL+"common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res,dest );

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }
    /**
     * ��û ����� XML���·� �����´�.
     * @return
     */
    public String apprItem( HttpServletRequest req, HttpServletResponse res){

    	Connection con = null;
    	Element envelope = null;

        String xmlString = "";
        String itemsName = "apprResult";
        String errorCode = "";
        String errorMsg = "";

       //���հ��翬�� �����
    	MobileReturnData retunMsgEL = new MobileReturnData();

        try{
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");

            String dest         = "";

            Box box = WebUtil.getBox(req);

            String   AINF_SEQN = box.get("apprDocID");
            String   empNo     = box.get("empNo"); //���
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);

            // 1.Envelop XML�� �����Ѵ�.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML�� �����Ѵ�.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE �� �����Ѵ�.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.������� �����Ѵ�.
            Element items = XmlUtil.createItems(itemsName);

            D03VocationRFC  rfc                 = new D03VocationRFC();
            D03VocationData tempData            = new D03VocationData();
            Vector          d03VocationData_vt  = null;
            Logger.debug.println(this, "�ް���û ��ȸ :user.empNo====> " + user.empNo);
            Logger.debug.println(this, "�ް���û ��ȸ :AINF_SEQN====> " + AINF_SEQN);

            String I_APGUB = "2";   //(String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            //�ް���û ��ȸ
            d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );

            if (d03VocationData_vt.size() < 1){
            	 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = "������ ������ �������� �ʽ��ϴ�." ;
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }
            Logger.debug.println(this, "�ް���û ��ȸ : " + d03VocationData_vt.toString());

            //�������� ��ȸ �� �������� Check
            /*DocumentInfo docinfo = new DocumentInfo(AINF_SEQN ,user.empNo);
            if (!docinfo.isModefy()) {*/
            if(!"X".equals(rfc.getApprovalHeader().MODFL)) {
            	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = "���� �� ���� �Ұ��� �����Դϴ�." ;
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }

            // �븮 ��û �߰�
            tempData           = (D03VocationData)d03VocationData_vt.get(0);
            PersonInfoRFC numfunc         = new PersonInfoRFC();
            PersonData phonenumdata    = null;
            phonenumdata  = (PersonData)numfunc.getPersonInfo(tempData.PERNR);

            /////////////////////////////////////////////////////////////////////////////.
            rfc     = new D03VocationRFC();
            /*���� ���� ����� */
            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            Vector<D03VocationData> resultList = rfc.getVocation(AINF_SEQN, user.empNo);
            D03VocationData resultData = Utils.indexOf(resultList, 0);
            Vector<ApprovalLineData> approvalLineList = rfc.getApprovalLine();
            ApprovalHeader approvalHeader = rfc.getApprovalHeader();

            //���� ���ɽ�
            if("X".equals(approvalHeader.MODFL)) {
                D03VocationRFC deleteRfc = new D03VocationRFC();
                deleteRfc.setDeleteInput(user.empNo, UPMU_TYPE, AINF_SEQN);
                deleteRfc.delete( AINF_SEQN, user.empNo );

                /* ���� ������ */
                if(deleteRfc.getReturn().isSuccess()) {
//������ ����� �� ������ ,ElOffice ���� ���̽�
                    phonenumdata    =   (PersonData)numfunc.getPersonInfo(tempData.PERNR);
                    Properties ptMailBody = new Properties();

                    ApprovalLineData firstApprovalLine = Utils.indexOf(approvalLineList, 0);

                    ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                    ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                    ptMailBody.setProperty("to_empNo" ,firstApprovalLine.APPU_NUMB);     // �� ������ ���
                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ�
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (��)��û�� ���
                    ptMailBody.setProperty("UPMU_NAME" ,"�ʰ��ٹ�");                    // ���� �̸�
                    ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����

                    //�� ����
                    StringBuffer sbSubject = new StringBuffer(512);

                    // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                    //sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    //sbSubject.append( ptMailBody.getProperty("ename") + "���� ��û�� �����ϼ̽��ϴ�.");
                      sbSubject.append("[HR] ��������뺸(" + ptMailBody.getProperty("UPMU_NAME") + ") ");
                    // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end

                    ptMailBody.setProperty("subject" ,sbSubject.toString());    // �� ���� ����

                    ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    String msg2 = null;
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(AINF_SEQN ,user.SServer ,ptMailBody.getProperty("UPMU_NAME")
                                ,tempData.PERNR ,firstApprovalLine.APPU_NUMB);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);

                        //���հ��� ����
                        MobileCommonSV mc = new MobileCommonSV() ;
                        retunMsgEL = mc.ElofficInterface( vcElofficInterfaceData, user);
                        //���հ��� �������� ���� �߻��� ������ return
                        if (!retunMsgEL.CODE.equals("0")){
                            errorCode = MobileCodeErrVO.ERROR_CODE_400+""+retunMsgEL.CODE;
                            errorMsg  = retunMsgEL.VALUE ;
                            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                            return xmlString;
                        }

                    } catch (Exception e) {
                        msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                        /*errorCode = MobileCodeErrVO.ERROR_CODE_400;*/
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_400+  msg2;
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    } // end try
                } else {
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "������ ���� �Ͽ����ϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }
            } else {
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�̹� ���εǾ� ���� �Ұ� �մϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }

/*

            Vector  AppLineData_vt  = new Vector();
            Vector  AppLineData_vt1 = new Vector();
            AppLineData_vt1 = AppUtil.getAppDetailVt(AINF_SEQN);

            // �������� ����..
            AppLineData  appLine = new AppLineData();
            appLine.APPL_MANDT     = user.clientNo;
            appLine.APPL_BUKRS     = user.companyCode;
            appLine.APPL_PERNR     = tempData.PERNR;
            appLine.APPL_UPMU_TYPE = UPMU_TYPE;
            appLine.APPL_AINF_SEQN = AINF_SEQN;

// 2002.07.25.---------------------------------------------------------------------------
//          ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
//          ����
            int nRowCount = AppLineData_vt1.size();
	        Logger.debug.println( this, "######### nRowCount : "+nRowCount );

            for( int i = 0; i < nRowCount; i++) {
                AppLineData app = new AppLineData();
                app = (AppLineData)AppLineData_vt1.get(i);
                app.APPL_APPU_NUMB = app.APPL_PERNR;

                AppLineData_vt.addElement(app);
            }
            Logger.debug.println(this, "AppLineData_vt : " + AppLineData_vt.toString());
//              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
// 2002.07.25.---------------------------------------------------------------------------

            //�ް����� ����ó
            con             = DBUtil.getTransaction();
            AppLineDB appDB = new AppLineDB(con);
            if( appDB.canUpdate(appLine) ) {
                appDB.delete(appLine);
                rfc.delete( user.empNo, AINF_SEQN );
                con.commit();

                /*//**********���� ���� (20050223:�����)**********
                // ��û�� ������ ���� ������.
                appLine = (AppLineData)AppLineData_vt.get(0);

                //������ ����� �� ������ ,ElOffice ���� ���̽�
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(tempData.PERNR);
                Properties ptMailBody = new Properties();

                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);     // �� ������ ���
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (��)��û�� ���
                ptMailBody.setProperty("UPMU_NAME" ,"�ް�");                    // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����

                //�� ����
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append( ptMailBody.getProperty("ename") + "���� ��û�� �����ϼ̽��ϴ�.");
                ptMailBody.setProperty("subject" ,sbSubject.toString());    // �� ���� ����

                ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                String msg2 = null;
                if (!maTe.process()) {
                    msg2 = maTe.getMessage();
                } // end if

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    ElofficInterfaceData eof = ddfe.makeDocForRemove(AINF_SEQN ,user.SServer ,ptMailBody.getProperty("UPMU_NAME")
                            ,tempData.PERNR ,appLine.APPL_APPU_NUMB);

                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);

                    //���հ��� ����
                	MobileCommonSV mc = new MobileCommonSV() ;
                    retunMsgEL = mc.ElofficInterface( vcElofficInterfaceData, user);
                    //���հ��� �������� ���� �߻��� ������ return
                    if (!retunMsgEL.CODE.equals("0")){
    	  	            errorCode = MobileCodeErrVO.ERROR_CODE_400+""+retunMsgEL.CODE;
                        errorMsg  = retunMsgEL.VALUE ;
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    }

                } catch (Exception e) {
                	msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                    errorCode = MobileCodeErrVO.ERROR_CODE_400;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_400+  msg2;
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                } // end try

            } else {
            	 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�̹� ���εǾ� ���� �Ұ� �մϴ�.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }*/

           // �����ΰ�� �����ڵ忡 0�� �����Ѵ�.
	        XmlUtil.addChildElement(items, "returnDesc", "");
	        XmlUtil.addChildElement(items, "returnCode", "0");

	        // XML�� �����Ѵ�.
	        XmlUtil.addChildElement(waitResponse, items);
	        XmlUtil.addChildElement(body, waitResponse);
	        XmlUtil.addChildElement(envelope, body);

	        // ���������� XML Document�� XML String�� ��ȯ�Ѵ�.
	        xmlString = XmlUtil.convertString(new Document(envelope));

        } catch(Exception e) {
        	errorCode = MobileCodeErrVO.ERROR_CODE_500;
            errorMsg  = MobileCodeErrVO.ERROR_MSG_500+  e.getMessage();
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            Logger.error(e);
            return xmlString;

        } finally {
            DBUtil.close(con);
        }
        return xmlString;
    }
}