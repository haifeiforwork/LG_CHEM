/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ؽ�û                                                    */
/*   Program Name : �������ؽŰ�                                              */
/*   Program ID   : E19ReportDetailSV                                           */
/*   Description  : �������ؽŰ��� ��ȸ �Ҽ� �ֵ��� �ϴ� Class                */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  �輺��                                          */
/*   Update       : 2005-02-28  ������                                          */
/*   Update       : 2005-03-02  �̽���(retPage �߰�)                            */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Disaster;

import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.E19DisasterData;
import hris.E.E19Disaster.rfc.E19DisaCodeRFC;
import hris.E.E19Disaster.rfc.E19DisaRelaRFC;
import hris.E.E19Disaster.rfc.E19DisaResnRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.DocumentInfo;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E19ReportDetailSV extends EHRBaseServlet
{
    private String UPMU_TYPE ="09";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            String dest  = "";
            Box box = WebUtil.getBox(req);

            String PERNR     = box.get("PERNR");
            String ainf_seqn = box.get("AINF_SEQN");

            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if
            Logger.debug.println(this, "[PERNR] = "+PERNR);
            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

//          ���� ���ư� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            // ���� ���� ��ư
            String retPage = box.get("retPage");
            String I_APGUB = box.get("I_APGUB");//'1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
            if (I_APGUB.equals("2")) {
            	retPage =  g.getServlet() +"hris.G.G002ApprovalIngDetailSV?"+StringUtils.substringAfter(retPage, "?");
            }else if (I_APGUB.equals("1")) {
            	retPage =  g.getServlet() +"hris.G.G000ApprovalDetailSV?"+StringUtils.substringAfter(retPage, "?");
            }else if (I_APGUB.equals("3")) {
            	retPage =  g.getServlet() +"hris.G.G003ApprovalFinishDetailSV?"+StringUtils.substringAfter(retPage, "?");
            }
            req.setAttribute("retPage", retPage);


//          ������
            E19CongcondData     e19CongcondData = new E19CongcondData();

            box.copyToEntity(e19CongcondData);

            e19CongcondData.PERNR = PERNR;
            e19CongcondData.AINF_SEQN = ainf_seqn;
            req.setAttribute("e19CongcondData", e19CongcondData);
            Logger.debug.println(this, e19CongcondData.toString());

            Vector E19DisasterData_vt = new Vector();

            // �������ؽŰ�
            int rowcount_report = box.getInt("RowCount_report");
            for( int i = 0; i < rowcount_report; i++) {
                E19DisasterData e19DisasterData = new E19DisasterData();
                String          idx             = Integer.toString(i);

                e19DisasterData.DISA_RESN  = box.get("DISA_RESN"+idx);    // ���س����ڵ�
                e19DisasterData.DISA_CODE  = box.get("DISA_CODE"+idx);    // ���ر����ڵ�
                e19DisasterData.DREL_CODE  = box.get("DREL_CODE"+idx);    // ���ش���� �����ڵ�
                e19DisasterData.DISA_RATE  = box.get("DISA_RATE"+idx);    // ������
                e19DisasterData.CONG_DATE  = box.get("CONG_DATE"+idx);    // �����߻���
                e19DisasterData.DISA_DESC1 = box.get("DISA_DESC1"+idx);   // ���س���1
                e19DisasterData.DISA_DESC2 = box.get("DISA_DESC2"+idx);   // ���س���2
                e19DisasterData.DISA_DESC3 = box.get("DISA_DESC3"+idx);   // ���س���3
                e19DisasterData.DISA_DESC4 = box.get("DISA_DESC4"+idx);   // ���س���4
                e19DisasterData.DISA_DESC5 = box.get("DISA_DESC5"+idx);   // ���س���5
                e19DisasterData.EREL_NAME  = box.get("EREL_NAME"+idx);    // ������󼺸�
                e19DisasterData.INDX_NUMB  = box.get("INDX_NUMB"+idx);    // ����
                e19DisasterData.PERNR      = box.get("PERNR"+idx);        // ���
                e19DisasterData.REGNO      = box.get("REGNO"+idx);        // �ѱ���Ϲ�ȣ
                e19DisasterData.STRAS      = box.get("STRAS"+idx);        // �ּ�
                e19DisasterData.AINF_SEQN  = box.get("AINF_SEQN"+idx);    // �������� �Ϸù�ȣ

                e19DisasterData.DREL_NAME = getDREL_NAME(e19DisasterData.DISA_CODE,e19DisasterData.DREL_CODE,user.companyCode); // ���ش���� �����ڵ��
                e19DisasterData.DISA_NAME = getDISA_NAME(e19DisasterData.DISA_CODE,user.companyCode);      // ���������ڵ��
                e19DisasterData.RESN_NAME = getRESN_NAME(e19DisasterData.DISA_RESN,user.companyCode);      // �������������ڵ��20030910 CYH

                E19DisasterData_vt.addElement(e19DisasterData);
            }
            Logger.debug.println(this, E19DisasterData_vt.toString());
            req.setAttribute( "E19DisasterData_vt", E19DisasterData_vt );

            dest = WebUtil.JspURL+"E/E19Disaster/E19ReportDetail.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
    }

    private String getDREL_NAME(String DISA_CODE, String DREL_CODE, String companyCode) throws GeneralException{
        Vector vt = (new E19DisaRelaRFC()).getDisaRela(companyCode);
        String ret = "";

        for( int i = 0 ; i < vt.size() ; i++ ){
            E19DisasterData data = (E19DisasterData)vt.get(i);
            if( DISA_CODE.equals(data.DISA_CODE) && DREL_CODE.equals(data.DREL_CODE)){
                ret = data.DREL_NAME;
            }
        }
        return ret;
    }

    private String getDISA_NAME(String DISA_CODE, String companyCode) throws GeneralException{
        Vector vt = (new E19DisaCodeRFC()).getDisaCode(companyCode);
        String ret = "";
        for( int i = 0 ; i < vt.size() ; i++ ){
            com.sns.jdf.util.CodeEntity data = (com.sns.jdf.util.CodeEntity)vt.get(i);
            if( DISA_CODE.equals(data.code) ){
                ret = data.value;
            }
        }
        return ret;
    }

    private String getRESN_NAME(String DISA_RESN, String companyCode) throws GeneralException{
        Vector vt = (new E19DisaResnRFC()).getDisaResn(companyCode);
        String ret = "";

        for( int i = 0 ; i < vt.size() ; i++ ){
            com.sns.jdf.util.CodeEntity data = (com.sns.jdf.util.CodeEntity)vt.get(i);
            if( DISA_RESN.equals(data.code) ){
                ret = data.value;
            }
        }
        return ret;
    }
}
