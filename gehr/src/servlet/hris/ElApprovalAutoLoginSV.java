/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  : Work Center
/*   2Depth Name  : ���ڰ��� > ������ȸ
/*   Program Name : ELOFFICE�� ���ڰ����� ���CLICK�� ����
/*   Program ID   : ElApprovalAutoLoginSV.java
/*   Description  : ���ڰ���(������/�����߹������� ����)
/*   Note         : ����
/*   Creation     :  
/*   Update       : 2006-05-17  @v1.1 requestName:���ڰ����ĺ������� ���ư������� ó���� ���� ���� 
/*                : 2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
/********************************************************************************/
package servlet.hris;

import com.sns.jdf.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.DocumentInfo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
public class ElApprovalAutoLoginSV extends EHRBaseServlet
{

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            performTask(req, res);
        }catch(GeneralException e){
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection conn = null;
        boolean isCommit = false;
        String dest;

        try{
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            } // end if

            WebUserData user = new WebUserData();

            Box box = WebUtil.getBox(req);
            String msg = ""; //[CSR ID:] ehr�ý�������༺���� ����

            String empNo    =   box.getString("SSNO");
            if (empNo == null || empNo.equals("")) {
                empNo    =   box.getString("selUserName");
            } // end if

            String SServer      = box.getString("SSERVER");
            String AINF_SEQN    = box.getString("AINF_SEQN");
            boolean isNotApp   = box.getBoolean("isNotApp");

            empNo = DataUtil.convertEmpNo(empNo);
            empNo = convertRealToTest(empNo);

            Logger.debug.println( this ," emppNo = " + empNo  + "\t SServer = " +  SServer +
                    "\t AINF_SEQN = " + AINF_SEQN);

            //@v1.1 06.05.17 ���ڰ���frame���� ��� �������� ���� 
            String returnPage = box.getString("listurl").replace('$' ,'&').replace('&' ,'|');
            if (returnPage == null ||  returnPage.equals("")) 
                returnPage = req.getHeader("referer").replace('&' ,'|');  
                
            String detailPage = makeDetailPageURL(AINF_SEQN ,empNo ,returnPage ,isNotApp);
                        Logger.debug.println(this ,"returnPage:"+returnPage);

            if (detailPage == null ||  detailPage.equals("")) {
                //String msg = " �ش� ������ ���� �� �� �����ϴ�.";
                msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                String url = "history.back(-1);";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest =  WebUtil.JspURL +"common/msg.jsp";
            } else {
                try{
                    PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
                    PersonData personData   = new PersonData();
                    personData = (PersonData)personInfoRFC.getPersonInfo(empNo, "X");
                    if( personData.E_BUKRS == null|| personData.E_BUKRS.equals("") ) {

                        //String msg = "�����ȣ�� Ȯ���Ͽ� �ֽʽÿ�.";
                        msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                        String url = "histroy.back(-1);";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        dest =  WebUtil.JspURL +"common/msg.jsp";
                    } else {

                        Config conf           = new Configuration();
                        user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                        user.login_stat       = "Y";

                        personInfoRFC.setSessionUserData(personData, user);

                        WebUtil.setLang(WebUtil.getLangFromCookie(req), req, user);

                        
                        user.loginPlace       = "ElOffice";
                        user.empNo            = empNo;
                        user.SServer          = SServer;
                        

                        // Logger.debug.println(this ,user);
                        // ����� ���� �׷� ����
                        // user.e_authorization = "ALL";
                        //conn = DBUtil.getTransaction("HRIS");
                        //user.user_group =   (new CommonCodeDB(conn)).getAuthGroup(user.e_authorization);   
                        
                        //@v1.0 �޴����� db�� oracle���� sap�� �̰�
                        /*SysAuthGroupRFC rfc_Auth         = new SysAuthGroupRFC();
                        user.user_group = rfc_Auth.getAuthGroup(user.e_authorization);*/

                        isCommit = true;

                        DataUtil.fixNull(user);
                        session = req.getSession(true);

                        int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                        session.setMaxInactiveInterval(maxSessionTime);
                        session.setAttribute("user",user);

                        Logger.debug.println(this ,detailPage);
                        req.setAttribute("url","location.href = '" + detailPage +  "';");

                        dest =  WebUtil.JspURL +"common/msg.jsp";

                    } // end if
                }catch(Exception ex){
                    Logger.err.println(this,"Data Not Found");
                    //String msg = "���� �� ������ �߻��Ͽ����ϴ�.";
                    msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                    String url = "histroy.back(-1);";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest =  WebUtil.JspURL +"common/msg.jsp";
                } // end try & catch
            } // end if
            printJspPage(req, res, dest);
        }catch(Exception ConfigurationException){
            throw new GeneralException(ConfigurationException);
        } finally {
            //DBUtil.close(conn ,isCommit);
        } // end try
    }


    private String convertRealToTest(String empNo) throws ConfigurationException
    {
        Config conf  = new Configuration();
        String convertEmpNo;

        if (conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP")) {
            convertEmpNo = conf.getString("com.sns.jdf.eloffice." + DataUtil.fixZero(empNo, 8));
            if (convertEmpNo == null || convertEmpNo.equals("")) {
                throw new ConfigurationException("��� ���� ����");
            } // end if
        } else {
            convertEmpNo = empNo;
        } // end if

        return convertEmpNo;
    }

    private String makeDetailPageURL(String AINF_SEQN ,String empNo ,String requestName,boolean isNotApp) throws GeneralException
    {

        StringBuffer detailPage = new StringBuffer(256);
        // ���� ������ ����
        DocumentInfo docInfo = new DocumentInfo(AINF_SEQN ,empNo ,isNotApp);
        if (!docInfo.isHaveAuth()) {
            Logger.info.println(this ,empNo + "�� " + AINF_SEQN + " ������ ������ �� �����ϴ�");
            return null;
        } // end if

        /*return WebUtil.makeGotoUrl(docInfo.getUPMU_TYPE() ,docInfo.getType() ,AINF_SEQN ,requestName);*/
        return WebUtil.approvalMappingURL(docInfo, AINF_SEQN, requestName);
    }
}