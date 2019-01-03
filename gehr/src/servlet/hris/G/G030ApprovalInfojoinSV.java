/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : ������ ���� ��û                                            */
/*   Program ID   : G026ApprovalCertiSV                                         */
/*   Description  : ������ ���� ���� ����/�ݷ�                                  */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E25Infojoin.E25InfoJoinData;
import hris.E.E25Infojoin.E25InfoSettData;
import hris.E.E25Infojoin.rfc.E25InfoJoinRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ApprovalFunction;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;


public class G030ApprovalInfojoinSV extends ApprovalBaseServlet
{
    private String UPMU_NAME = "������ ����";

    private String UPMU_TYPE = "19";     // ���� ����Ÿ��(������ ����)


    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            final WebUserData user = WebUtil.getSessionUser(req);


           String dest  = "";

           final Box box = WebUtil.getBox(req);

           String  AINF_SEQN  = box.get("AINF_SEQN");

           String jobid = box.get("jobid");
           /* ���� �ݷ� �� */

           final E25InfoJoinRFC e25InfoJoinRFC = new E25InfoJoinRFC();
           e25InfoJoinRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
           final E25InfoJoinData e25InfoJoinData = Utils.indexOf(e25InfoJoinRFC.getDetail(), 0); //��� ����Ÿ

           /* ���� �� */
           if("A".equals(jobid)) {
               /* ������ ���� �� */
               dest = accept(req, box, "T_ZHRA019T", e25InfoJoinData, e25InfoJoinRFC, new ApprovalFunction<E25InfoJoinData>() {
                   public boolean porcess(E25InfoJoinData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                       /* ������ ���� ���� */
                     //  if(approvalHeader.isEditManagerArea()) {
                           box.copyToEntity(inputData);  //����ڰ� �Է��� ����Ÿ�� ������Ʈ
                           inputData.BETRG   =   DataUtil.changeGlobalAmount(inputData.BETRG, user.area);

                      // }
                       inputData.UNAME     = user.empNo;
                       inputData.AEDTM     = DataUtil.getCurrentDate();
                       return true;
                   }
               });

           /* �ݷ��� */
           } else if("R".equals(jobid)) {
               dest = reject(req, box, null, e25InfoJoinData, e25InfoJoinRFC, null);
           }  else if("C".equals(jobid)) {
               dest = cancel(req, box, null, e25InfoJoinData, e25InfoJoinRFC, null);
           } else {
               throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
           }

           Logger.debug.println(this, " destributed = " + dest);
           printJspPage(req, res, dest);

       } catch(Exception e) {
           Logger.err.println(DataUtil.getStackTrace(e));
           throw new GeneralException(e);
       }
   }
}

