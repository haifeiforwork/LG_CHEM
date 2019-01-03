/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 부서근태 신청                                                 */
/*   Program ID   : G066ApprovalRotationSV                                      */
/*   Description  : 부서근태 신청 부서장 ,담당자 ,담당부서장 결재/반려            */
/*   Note         : 없음                                                        */
/*   Creation     : 2009-03-02  김종서                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.D.D12Rotation.D12RotationBuildData;
import hris.D.D12Rotation.rfc.D12RotationBuildRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;


public class G066ApprovalRotationSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="36";            // 결재 업무타입(근태)
    private String UPMU_NAME ="부서근태";            // 결재 업무명(근태)

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }


	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");

        	HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");

            String dest         = "";
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());


            D12RotationBuildRFC     rfc    = new D12RotationBuildRFC();

            Vector main_vt1 = new Vector();
            Vector<D12RotationBuildData> main_vt2 = new Vector();
            Vector main_vt3 = new Vector();
            Vector ret = new Vector();

            final D12RotationBuildRFC d12RotationBuildRFC = new D12RotationBuildRFC();
            d12RotationBuildRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            d12RotationBuildRFC.getDetailApproval(box.get("AINF_SEQN"));

            ret =d12RotationBuildRFC.getDetail(box.get("AINF_SEQN"));

            main_vt1 = (Vector)ret.get(0);
            main_vt2 = (Vector)ret.get(1);
            main_vt3 = (Vector)ret.get(2);

            final Vector<D12RotationBuildData>  D12RotationBuildData_vt = (Vector)ret.get(1);


            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */

                dest = accept(req, box, "", main_vt2, d12RotationBuildRFC,new ApprovalFunction<Vector<D12RotationBuildData>>(){
                    public boolean porcess(Vector <D12RotationBuildData>inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 개발자 영역 시작 */
                    	d12RotationBuildRFC.accept(box.get("AINF_SEQN"));

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, "", main_vt2, d12RotationBuildRFC,new ApprovalFunction<Vector<D12RotationBuildData>>(){
                    public boolean porcess(Vector <D12RotationBuildData>inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                        /* 개발자 영역 시작 */
                    	d12RotationBuildRFC.reject(box.get("AINF_SEQN"));

                        return true;
                    }
                });
            }   else {
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
