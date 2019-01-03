/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  :                                                */
/*   2Depth Name  :                                                 */
/*   Program Name :                                      */
/*   Program ID   : MailAutoLoginSV.java                                    */
/*   Description  :                          */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
/********************************************************************************/
package servlet.hris;

import com.sns.jdf.*;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.LoginResultData;
import hris.common.WebUserData;
import hris.common.rfc.GetPasswordRFC;
import hris.common.util.DocumentInfo;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MailAutoLoginSV extends EHRBaseServlet
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

        HttpSession session = req.getSession();
        if (session != null) {
           // session.invalidate();
        } // end if

        WebUserData user = new WebUserData();

        Box box = WebUtil.getBox(req);
        String SSNO_id    =   box.get("SSNO");
        box.copyToEntity(user);
        user.empNo = SSNO_id;
        String originEmpNo = null;
        String secretEmpNo = user.SSNO;

        String msg = ""; //[CSR ID:] ehr시스템웹취약성진단 수정

        String jobid        =   box.get("jobid");
        if (jobid == null || jobid.equals("")) {
            jobid = "connect";
        } // end if

        String AINF_SEQN    =   box.getString("AINF_SEQN");
        originEmpNo = DataUtil.convertEmpNo(user.SSNO);

        Logger.debug.println(this, "MailAutoLoginSV user.SSNO  : " + user.SSNO+"   originEmpNo : "+SSNO_id+" AINF_SEQN  : " + AINF_SEQN);
        if (jobid.equals("connect")) {
            try {
                //String detailPage = makeDetailPageURL(AINF_SEQN ,SSNO_id);

                //if (detailPage == null ||  detailPage.equals("")) {
                    //throw new GeneralException(" 해당 문서에 접근 할 수 없습니다! .");
                //} else {
                    dest = WebUtil.JspURL +"maillogin.jsp";
                    //@v1.1 ep portal로 인해변경
                    //String url = "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url="+detailPage;
                    //  String url = "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url="+detailPage+"&portlet_EHRApprovalMenu_1isEditAble=false&portlet_EHRApprovalMenu_1AINF_SEQN="+AINF_SEQN;
                    // 2013-10-08-G포탈 오픈으로 인해 변경
                    //운영
                     //String url = "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url="+ WebUtil.ServletURL + "hris.G.G000ApprovalDocMapSV&portlet_EHRApprovalMenu_1isEditAble=false&portlet_EHRApprovalMenu_1AINF_SEQN="+AINF_SEQN;
                    //개발
                    //String url = "http://epdev.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url="+ WebUtil.ServletURL + "hris.G.G000ApprovalDocMapSV&portlet_EHRApprovalMenu_1isEditAble=false&portlet_EHRApprovalMenu_1AINF_SEQN="+AINF_SEQN;
                    //http://devehr.lgchem.com:8081/servlet/servlet.hris.EPLoginSV?SServer=gportal.lgchem.com&returnUrl=Y&menuCode=9999&AINF_SEQN=0002124489

                    Config conf           = new Configuration();
                    //개발
                    //String url = "http://devehr.lgchem.com:8081/servlet/servlet.hris.EPLoginSV?SServer=gwpdev.lgchem.com&returnUrl=Y&menuCode=9999&AINF_SEQN="+AINF_SEQN;
                     //운영
                    //String url = "http://"+conf.getString("portal.serverUrl")+"/portal/main/portalMain.do?mainFrameUrl=http://"+conf.getString("com.sns.jdf.mail.ResponseURL")+WebUtil.ServletURL + "hris.EPLoginSV?AINF_SEQN="+AINF_SEQN; //20160728 이지은D (박인철 B 요청)메일 링크 내 로그인 화면 안나오게 자동 로그인 되도록 수정
                    String url = "http://"+conf.getString("com.sns.jdf.mail.ResponseURL")+WebUtil.ServletURL + "hris.ESBApprovalAutoLoginSV?AINF_SEQN="+AINF_SEQN;
//                String url = "http://"+conf.getString("portal.serverUrl")+"/portal/main/portalMain.do?mainFrameUrl=http://"+conf.getString("com.sns.jdf.mail.ResponseURL")+WebUtil.ServletURL + "hris.ESBApprovalAutoLoginSV?AINF_SEQN="+AINF_SEQN;
                    //개발
                    //String url = "http://"+conf.getString("portal.serverUrl")+"/ikep-webapp/portal/main/portalMain.do?mainFrameUrl=http://devehr.lgchem.com:8081"+ WebUtil.ServletURL + "hris.EPLoginSV?AINF_SEQN="+AINF_SEQN;

                     Logger.debug.println(this, "######### mailautologin url TEST : " + url);
                     //Logger.debug.println(this, "######### mailautologin returnUrl : " + detailPage);
                     //req.setAttribute("returnUrl",detailPage);
                    req.setAttribute("url",url);
                    req.setAttribute("AINF_SEQN",AINF_SEQN);
                    dest =  WebUtil.JspURL +"common/goMailurl.jsp";

                //} // end if
            } catch (Exception ex) {
                String url = "history.back(-1);";
                req.setAttribute("url", url);
                req.setAttribute("msg", ex.getMessage());
                dest =  WebUtil.JspURL +"common/msg.jsp";
            } // end try
        } else {
            req.setAttribute("msg", g.getMessage("MSG.COMMON.0085"));//[CSR ID:] ehr시스템웹취약성진단 수정
            String url = "history.back(-1);";
            req.setAttribute("url", url);
            dest = WebUtil.JspURL +"common/msg.jsp";
        } // end if

        Logger.debug.println(this ,dest);
        printJspPage(req, res, dest);
    }

    private String convertRealToTest(String empNo) throws ConfigurationException
    {
        Config conf  = new Configuration();
        String convertEmpNo = conf.getString("com.sns.jdf.eloffice." + DataUtil.fixZero(empNo, 8));
        if (convertEmpNo == null || convertEmpNo.equals("")) {
            convertEmpNo = empNo;
        } // end if
        return convertEmpNo;
    }

    private String makeDetailPageURL(String AINF_SEQN ,String empNo) throws GeneralException
    {
        // 현재 결재자 구분
        DocumentInfo docInfo = new DocumentInfo(AINF_SEQN ,empNo ,false);
        if (!docInfo.isHaveAuth()) {
            Logger.info.println(this ,empNo + "는 " + AINF_SEQN + " 문서에 접근할 수 없습니다");
            return null;
        } // end if

        return WebUtil.makeGotoUrl(docInfo.getUPMU_TYPE() ,docInfo.getType() ,AINF_SEQN);
    }

    //[CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정
    private LoginResultData getLoginYN(WebUserData user, SAPType sapType) throws GeneralException{
        GetPasswordRFC rfc = new GetPasswordRFC();
        rfc.setSapType(sapType);
        return rfc.getLoginYN(StringUtils.upperCase(user.empNo), user.webUserPwd);
    }

}