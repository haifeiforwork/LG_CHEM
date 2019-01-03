/********************************************************************************/
/*                                                                              */
/*   System Name  : GHR                                                         */
/*   1Depth Name  : Application                                                  */
/*   2Depth Name  : Benefit Management                                          */
/*   Program Name : Language Fee                                                */
/*   Program ID   : A12SupportBuildSV                                           */
/*   Description  : 语言费申请                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2011-08-12 liukuo @v1.1 [C20110728_35671] Family 有关家属医疗费逻辑条件增加申请   */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.Global.E23Language;

import hris.A.rfc.A04FamilyDetailRFC;
import hris.E.Global.E23Language.E23LanguageData;
import hris.E.Global.E23Language.rfc.E23LanguageRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E23LanguageBuildSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "13";     // 결재 업무타입(어학비-주재원)
    private String UPMU_NAME = "Language Fee";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res) 	throws GeneralException {

		try {
			HttpSession session = req.getSession(false);

			final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR = getPERNR(box, user); //신청대상자 사번

			//Logger.debug.println(this, "[jobid] = " + jobid + " [user] : "+ user.toString());

			box.put("PERNR",PERNR);
			req.setAttribute("PERNR", PERNR);

			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);

			req.setAttribute("PersonData", phonenumdata);

			if (jobid.equals("first")) { // first time page

				//결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

				// 증권계좌 리스트를 구성한다.
				E23LanguageRFC rfc_lang = new E23LanguageRFC();
				Vector languageCode = rfc_lang.getLanguageDetail(PERNR, "5", "01", "");

				String uname = rfc_lang.getLanguageName(PERNR, "1", "01", "");
				req.setAttribute("uname", uname);

				if (languageCode.size() == 0) {
					String msg = g.getMessage("MSG.E.E23.0001");   //증권계좌 정보가 존재하지 않습니다.
					String url = "history.back();";
					req.setAttribute("msg", msg);
					req.setAttribute("url", url);
					dest = WebUtil.JspURL + "common/msg.jsp";
				} else {
					Logger.debug.println(this, "증권계좌 리스트 : " + languageCode.toString());
					Vector adata_vt = rfc_lang.getLanguageDetail1(PERNR, "5", "01", "","");
					String p_waers = (String)adata_vt.get(1);
					req.setAttribute("p_waers", p_waers);
					if (adata_vt.size() > 0) {
						E23LanguageData adata = (E23LanguageData) adata_vt.get(0);
						//Logger.debug.println(this, "이전데이터" + adata.toString());

						//req.setAttribute("E23LanguageData", adata);
						req.setAttribute("resultData", adata);

						//添加查询家属信息的内容 2011-08-12 liukuo   @v1.1 [C20110728_35671]
						Vector             a04FamilyDetailData_vt= new Vector();
						A04FamilyDetailRFC func1                  = new A04FamilyDetailRFC();
				        //a04FamilyDetailData_vt = func1.getFamilyDetail(PERNR) ;
						box.put("I_PERNR", PERNR);
				        a04FamilyDetailData_vt = func1.getFamilyDetail(box) ;

				        Logger.debug.println(this, "====a04FamilyDetailData_vt ========= : " + a04FamilyDetailData_vt.toString());  // 데이터 확인 .필

				        req.setAttribute("a04FamilyDetailData_vt", a04FamilyDetailData_vt);
					}

					req.setAttribute("languageCode", languageCode);
					req.setAttribute("perType",  (Vector)Utils.indexOf(languageCode, 0) );
					req.setAttribute("famiCode", (Vector)Utils.indexOf(languageCode, 1) );

					//update 20120511 row 1 by lixinxin
					req.setAttribute("objps_ost", "objps_ost");

					dest = WebUtil.JspURL + "E/E23Language/E23LanguageBuild.jsp";
				}

			} else if (jobid.equals("create")) { //

				/* 실제 신청 부분 */
                dest = requestApproval(req, box, E23LanguageData.class, new RequestFunction<E23LanguageData>() {
                    public String porcess(E23LanguageData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                    	E23LanguageRFC e23Rfc = new E23LanguageRFC();
                    	e23Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                    	if(inputData.WAERS1==null||inputData.WAERS1.equals("")){
                    		inputData.WAERS1 = box.get("WAERS9");
        				}

                    	if(inputData.ZMONTH_TOT== null || inputData.ZMONTH_TOT.trim().equals("")){
                    		inputData.ZMONTH_TOT = "0";
        				}

                    	inputData.ZMONTH_TOT = Integer.toString(Integer.parseInt(inputData.COUR_PRID)+Integer.parseInt(inputData.ZMONTH_TOT));

                    	box.put("PERS_GUBN", inputData.PERS_GUBN);
                    	box.put("OBJPS", inputData.OBJPS);
                    	box.put("FAMI_CODE", inputData.FAMI_CODE);
                    	box.put("I_GTYPE", "2");

                        String AINF_SEQN = e23Rfc.build(Utils.asVector(inputData), box, req);

                        //Logger.debug.println(this, "====e23Rfc.getReturn().isSuccess()======== : " +  e23Rfc.getReturn().isSuccess() );
                        //Logger.debug.println(this, "====e23Rfc.getReturn().isSuccess()======== : " +  e23Rfc.getReturn() );

                        if(!e23Rfc.getReturn().isSuccess()) {
                        	 throw new GeneralException(e23Rfc.getReturn().MSGTX);
                        }

                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });


			} else {
				throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}
			//Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
