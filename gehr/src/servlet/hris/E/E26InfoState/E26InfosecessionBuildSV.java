/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인포멀가입현황                                              */
/*   Program Name : 인포멀가입현황                                              */
/*   Program ID   : E26InfosecessionBuildSV                                     */
/*   Description  : 인포멀탈퇴 신청을 할수 있는 class                           */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E26InfoState;

import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.rfc.*;

import hris.E.E25Infojoin.*;
import hris.E.E25Infojoin.rfc.*;
import hris.E.E26InfoState.E26InfoStateData;
import hris.E.E26InfoState.rfc.*;

public class E26InfosecessionBuildSV extends ApprovalBaseServlet {

    private String UPMU_NAME = "인포멀 탈퇴";

    private String UPMU_TYPE = "27";     // 결재 업무타입(인포멀 가입)


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


            String PERNR = getPERNR(box, user); //신청대상자 사번
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
            Logger.debug.println("E26InfosecessionBuildSV..................................");
            if( jobid.equals("first")) {
           	 	getApprovalInfo(req, PERNR);
               E26InfoStateData e26InfoStateData  = new E26InfoStateData();
               box.copyToEntity(e26InfoStateData);
               e26InfoStateData.PERNR = PERNR;

               req.setAttribute("E26InfoStateData", e26InfoStateData);
               dest = WebUtil.JspURL+"E/E26InfoState/E26InfosecessionBuild.jsp";

            }else   if(jobid.equals("create")) {
            	Logger.debug.println("create..................................");
                dest = requestApproval(req, box, E26InfoStateData.class, new RequestFunction<E26InfoStateData>() {
                    public String porcess(E26InfoStateData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {
                    	Logger.debug.println("data.BETRG00000-------------------"+inputData.BETRG);

                    	  if(box.get("PERN_NUMB").trim()==null ||box.get("PERN_NUMB").trim().equals("00000000")|| box.get("PERN_NUMB").trim().equals("") ){
                    		  throw new GeneralException("간사가 지정되어 있지 않습니다.");

                          }

                        /* 결재 신청 RFC 호출 */
                    	  E26InfosecessionRFC e26InfosecessionRFC = new E26InfosecessionRFC();
                    	  e26InfosecessionRFC.setRequestInput(user.empNo, UPMU_TYPE);
                    	  String AINF_SEQN = e26InfosecessionRFC.build(Utils.asVector(inputData), box, req);

                        if(!e26InfosecessionRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e26InfosecessionRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}

