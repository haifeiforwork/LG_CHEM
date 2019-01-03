/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ��������                                                    */
/*   Program Name : �������� ��û                                               */
/*   Program ID   : D19EduTripBuild.java                                        */
/*   Description  : ���������û�� �ϴ� Class                                   */
/*   Note         :                                                             */
/*   Creation     : 2010-31-31 lsa                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D19EduTrip;

import hris.D.D19EduTrip.D19EduTripData;
import hris.D.D19EduTrip.rfc.D19DupCheckRFC;
import hris.D.D19EduTrip.rfc.D19EduTripRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

/**
 * D19EduTripBuildSV.java
 * ����, ���带 ��û�� �� �ֵ��� �ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/03
 */
public class D19EduTripBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="35";            // ���� ����Ÿ��(����, �����û)

	private String UPMU_NAME = "����/���� ��û";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
	  protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest = "";
            String jobid = box.get("jobid", "first");
            final String PERNR = getPERNR(box, user); //��û����� ���

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.

                //�������, ���� ��� ���� ��ȸ

                getApprovalInfo(req, PERNR);
                dest = WebUtil.JspURL+"D/D19EduTrip/D19EduTripBuild.jsp";
                req.setAttribute("jobid", jobid);
                req.setAttribute("message", "");

            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, D19EduTripData.class, new RequestFunction<D19EduTripData>() {
                    public String porcess(D19EduTripData inputData,Vector<ApprovalLineData> approvalLine) throws GeneralException {
                        //------------------------------------ �ߺ� üũ ------------------------------------//
                        /* ���� ��û RFC ȣ�� */
                    	D19EduTripRFC d19EduTripRFC = new D19EduTripRFC();
                    	d19EduTripRFC.setRequestInput(user.empNo, UPMU_TYPE);
                    	//�ߺ�üũ
                    	checkDup(inputData);
                        String AINF_SEQN = d19EduTripRFC.build(Utils.asVector(inputData), box, req);

                        if(!d19EduTripRFC.getReturn().isSuccess()) {
                        	 throw new GeneralException(d19EduTripRFC.getReturn().MSGTX);
                        }
                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
              }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);


        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
	}

	    /**
	     * @return
	     * @throws GeneralException
	     */
	    public static boolean checkDup(D19EduTripData eduTripData)
	            throws GeneralException {
	        D19DupCheckRFC d19DupCheckRFC = new D19DupCheckRFC();
	        RFCReturnEntity returnEntity = d19DupCheckRFC.check(eduTripData);
            if(returnEntity.MSGTY.equals("E")) {
            	    throw new GeneralException(d19DupCheckRFC.getReturn().MSGTX);
            	}
	        return true;
	    }

}
