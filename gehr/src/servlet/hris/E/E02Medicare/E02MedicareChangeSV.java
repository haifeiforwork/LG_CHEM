/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ǰ����� ��߱�                                             */
/*   Program Name : �ǰ����� ��߱�/�߰��߱�/������׺��� ��û ����             */
/*   Program ID   : E02MedicareChangeSV                                         */
/*   Description  : �ǰ������� ����/��߱� ������ �� �� �ֵ��� �ϴ� Class       */
/*   Note         :                                                             */
/*   Creation     : 2002-01-29  �ڿ���                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E02Medicare;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import servlet.hris.A.A17Licence.A17LicenceBuildSV;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.db.*;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E02Medicare.E02MedicareData;
import hris.E.E02Medicare.rfc.*;

public class E02MedicareChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="21";
    private String UPMU_NAME = "�ǰ����� ��߱�";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }


    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********���� ��.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            final E02MedicareRFC e02MedicareRFC = new E02MedicareRFC();
            e02MedicareRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<E02MedicareData> resultList = e02MedicareRFC.getDetail(); //��� ����Ÿ
            E02MedicareData resultData = Utils.indexOf(resultList, 0);



            if( jobid.equals("first") ) {
            	Logger.debug.println("resultData----------------------------------------------------"+resultData);
            	req.setAttribute("resultData", resultData);
                req.setAttribute("isUpdate", true); //��� ���� ����
                req.setAttribute("targetName_vt" , new E02MedicareTargetNameRFC().getName(resultData.PERNR) );
                req.setAttribute("e02MedicareIssue_vt" ,  new E02MedicareIssueRFC().getIssue() );
                req.setAttribute("e02MedicareReIssue_vt" ,  new E02MedicareReIssueRFC().getReIssue() );
                req.setAttribute("e02MedicareREQ_vt" ,   new E02MedicareREQRFC().getRequest() );
                req.setAttribute("e02MedicareEnroll_vt" ,   new E02MedicareEnrollRFC().getEnroll() );

                detailApporval(req, res, e02MedicareRFC);

                printJspPage(req, res, WebUtil.JspURL + "E/E02Medicare/E02MedicareBuild.jsp");

            } else if( jobid.equals("change") ) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, E02MedicareData.class, e02MedicareRFC, new ChangeFunction<E02MedicareData>(){

                    public String porcess(E02MedicareData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {


                        /* ���� ��û RFC ȣ�� */
                    	E02MedicareRFC changeRFC = new E02MedicareRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });

                printJspPage(req, res, dest);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}