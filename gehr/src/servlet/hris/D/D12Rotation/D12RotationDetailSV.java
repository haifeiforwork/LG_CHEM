/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 월간부서근태 조회                                                */
/*   Program ID   : D12RotaionDetailSV                                         */
/*   Description  : 월간부서근태마감 조회/삭제 할수 있도록 하는 Class                       */
/*   Note         :                                                             */
/*   Creation     : 2009-03-02  김종서                                          */
/*   Update       :                                           */
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D12Rotation;

import hris.D.D12Rotation.D12RotationBuild2Data;
import hris.D.D12Rotation.D12RotationBuildData;
import hris.D.D12Rotation.rfc.D12RotationBuildRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

public class D12RotationDetailSV extends ApprovalBaseServlet {

    private static String UPMU_TYPE ="36";            // 결재 업무타입(근태)
    private static String UPMU_NAME ="부서근태";            // 결재 업무명(근태)

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
            Box box = WebUtil.getBox(req);


            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
            String deptNm		= "";
            deptNm = box.get("hdn_deptNm",user.e_orgtx);


            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());



            final D12RotationBuildRFC d12RotationBuildRFC = new D12RotationBuildRFC();
            final D12RotationBuildRFC d12RotationBuildRFC1 = new D12RotationBuildRFC();
            Logger.debug.println(this, "setDetailInput--------------------");
            d12RotationBuildRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            d12RotationBuildRFC.getDetailApproval(box.get("AINF_SEQN"));

            Vector main_vt1 = new Vector();
            Vector main_vt2 = new Vector();
            Vector main_vt3 = new Vector();
            Vector ret = new Vector();

            ret =d12RotationBuildRFC1.getDetail(box.get("AINF_SEQN"));
            Logger.debug.println(this, "jobid--------------------"+jobid);

            if( jobid.equals("first") ) {

                main_vt1 = (Vector)ret.get(0);
                main_vt2 = (Vector)ret.get(1);
                main_vt3 = (Vector)ret.get(2);
                String E_RETURN    = (String)ret.get(3);
                String E_MESSAGE = (String)ret.get(4);
                String E_FROMDA    = (String)ret.get(5);
                String E_TODA = (String)ret.get(6);
                String E_ORGEH    = (String)ret.get(7);
                String E_STEXT = (String)ret.get(8);


                if (! E_RETURN.equals("E") ) {

                    Logger.debug.println(this, "first====main_vt1 : " + main_vt1.toString() );
                    Logger.debug.println(this, "first====main_vt2 : " + main_vt2.toString() );
                    Logger.debug.println(this, "first====main_vt3 : " + main_vt3.toString() );

                    Vector main_vt3_temp = new Vector();
                    for(int i=0; i<main_vt3.size(); i++){
                    	D12RotationBuild2Data dataStat = (D12RotationBuild2Data)main_vt3.get(i);
                    	dataStat.APPR_STAT_CHK = "true";
                    	for(int j=0; j<main_vt2.size(); j++){
                    		D12RotationBuildData dataResult = (D12RotationBuildData)main_vt2.get(j);
                    		if(dataResult.BEGDA.equals(dataStat.BEGDA)){
                    			if(dataStat.APPR_STAT.equals("A")&&!dataResult.APPR_STAT.equals("A")){
                    				dataStat.APPR_STAT_CHK = "false";
                		    	}
                    		}
                    	}
                    	main_vt3_temp.addElement(dataStat);
                    }
                    main_vt3 = main_vt3_temp;
                    Logger.debug.println(this, "final====main_vt3 : " + main_vt3.toString() );
	                req.setAttribute("jobid",            jobid);
	                req.setAttribute("deptNm", deptNm);
	                req.setAttribute("main_vt1",       main_vt1);
	                req.setAttribute("main_vt2",       main_vt2);
	                req.setAttribute("main_vt3",       main_vt3);
	                req.setAttribute("E_FROMDA",       E_FROMDA); //승인요청 시작일
	                req.setAttribute("E_TODA",       E_TODA); //승인요청 종료일
	                req.setAttribute("E_ORGEH",       E_ORGEH);//신청된 부서코드
	                req.setAttribute("E_STEXT",       E_STEXT);//신청된 부서명
	                req.setAttribute("rowCount"  ,   Integer.toString(main_vt1.size())   );


                if (!detailApporval(req, res, d12RotationBuildRFC))     return;

                printJspPage(req, res, WebUtil.JspURL+"D/D12Rotation/D12RotationDetail2.jsp");
                } else {
                    String msg = E_MESSAGE;
                    req.setAttribute("msg", msg);
                    printJspPage(req, res, WebUtil.JspURL+"common/msg.jsp");
                }
             } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.
                	Logger.debug.println("delete------------------");
                    String dest = deleteApproval(req, box, d12RotationBuildRFC, new DeleteFunction() {
                        public boolean porcess() throws GeneralException {

                        	D12RotationBuildRFC deleteRFC = new D12RotationBuildRFC();
                            deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, d12RotationBuildRFC.getApprovalHeader().AINF_SEQN);

                            RFCReturnEntity returnEntity = deleteRFC.delete();

                            if(!returnEntity.isSuccess()) {
                                throw new GeneralException(returnEntity.MSGTX);
                            }

                            return true;
                        }
                    });

                    printJspPage(req, res, dest);

             } else {
                 throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
             }


         } catch (Exception e) {
             Logger.error(e);
             throw new GeneralException(e);
         }
     }

 }

