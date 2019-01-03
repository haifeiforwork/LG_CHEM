/********************************************************************************/
/*                                                                                                                                                            */
/*   System Name  : MSS                                                                                                                        */
/*   1Depth Name  : MY HR 정보                                                                                       */
/*   2Depth Name  : 경력증명서 신청                                                                                 */
/*   Program Name : 경력증명서 신청 조회                                                                         */
/*   Program ID   : A19CareerDetailSV                                                                                                  */
/*   Description  : 경력증명서 신청을 조회할 수 있도록 하는 Class                                                       */
/*   Note         :                                                                                                                                       */
/*   Creation     : 2006-04-11  김대영                                                                                */
/*   Update       :                                                                                                                                     */
/*                                                                                                                                                            */
/********************************************************************************/

package	servlet.hris.A.A19Career;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A09CareerDetailData;
import hris.A.A15Certi.rfc.A15CertiPrintRFC;
import hris.A.A19Career.A19CareerData;
import hris.A.A19Career.rfc.A19CareerRFC;
import hris.A.rfc.A09CareerDetailRFC;
import hris.G.rfc.BizPlaceDataRFC;
import hris.G.rfc.StellRFC;
import hris.common.MappingPernrData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.rfc.MappingPernrRFC;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

public class A19CareerDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="34";
    private String UPMU_NAME = "경력증명서";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
            String AINF_SEQN = box.get("AINF_SEQN");

            /* 자격 정보 조회 */
            final A19CareerRFC a19CareerRFC = new A19CareerRFC();
            a19CareerRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<A19CareerData> resultList = a19CareerRFC.getDetail(); //결과 데이타

            A19CareerData resultData = Utils.indexOf(resultList, 0);


            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

                req.setAttribute("resultData", resultData);

                if (!detailApporval(req, res, a19CareerRFC))
                    return;

                ApprovalHeader approvalHeader = (ApprovalHeader) req.getAttribute("approvalHeader");

                // 사업장 주소 가져오기
                Vector vcBizPlaceCodeEntity =  (new BizPlaceDataRFC()).getBizPlacesCodeEntity(approvalHeader.PERNR ,"16");
                req.setAttribute("vcBizPlaceCodeEntity", vcBizPlaceCodeEntity);

                if("X".equals(approvalHeader.ACCPFL)) {
                    // 직무 코드 가져오기
                    Vector vcStellCodeEntity = (new StellRFC()).getStellCodeEntity();
                    req.setAttribute("vcStellCodeEntity", vcStellCodeEntity);

                    printJspPage(req, res, WebUtil.JspURL + "G/G064ApprovalCareer.jsp");
                } else {
                    printJspPage(req, res, WebUtil.JspURL + "A/A19Career/A19CareerDetail.jsp");
                }


            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, a19CareerRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        A19CareerRFC deleteRFC = new A19CareerRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, a19CareerRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else if( jobid.equals("print_certi") ) {               //새창띠움(빈페이지)


                req.setAttribute("AINF_SEQN", AINF_SEQN);
                req.setAttribute("PERNR" ,       resultData.PERNR );
                req.setAttribute("MENU" ,      "CAREER");
                req.setAttribute("GUEN_TYPE" ,  box.get("PRINT_GUBUN"));

                req.setAttribute("print_page_name", WebUtil.ServletURL+"hris.A.A19Career.A19CareerDetailSV?AINF_SEQN="+AINF_SEQN+"&jobid=print_certi_print");

                printJspPage(req, res, WebUtil.JspURL + "common/printFrame_Acerti.jsp");
            } else if( jobid.equals("print_certi_print") ) {



                A15CertiPrintRFC rfc_print = new A15CertiPrintRFC();
//              프린트는 1회로 출력을 제한한다.
                // func.updateFlag(a19CareerData.PERNR, AINF_SEQN);
// 프린트는 1회로 출력을 제한한다.
                Map<String, Object> ret         = rfc_print.getDetail("2", resultData.PERNR, AINF_SEQN, "1");
                Vector T_RESULT    = (Vector) ret.get("T_RESULT");
                String E_JUSO_TEXT = (String) ret.get("E_JUSO_TEXT");
                String E_KR_REPRES = (String) ret.get("E_KR_REPRES");

                PersonData phonenumdata;
                PersonInfoRFC numfunc			=	new PersonInfoRFC();
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(resultData.PERNR, "X");

                //이동발령 신청시 개인 경력사항

                MappingPernrRFC mapfunc = null ;
                MappingPernrData mapData = new MappingPernrData();
                Vector mapData_vt    = new Vector() ;
                Vector careerData_vt = new Vector() ;
                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( resultData.PERNR ) ;

                Vector             a09CareerDetailData_vt = new Vector();
                A09CareerDetailRFC func1                  = null;

                if ( mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리
                    A09CareerDetailData data = new A09CareerDetailData();

                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);

                        func1         = new A09CareerDetailRFC() ;
                        careerData_vt = func1.getCareerDetail( mapData.PERNR  , "") ;

                        for( int j = 0 ; j < careerData_vt.size() ; j++ ) {
                            data = (A09CareerDetailData)careerData_vt.get(j);
                            a09CareerDetailData_vt.addElement(data);
                        }
                    }
                } else {
                    func1                  = new A09CareerDetailRFC();
                    a09CareerDetailData_vt = func1.getCareerDetail(resultData.PERNR , "");
                }

                Logger.debug.println(this, "a09CareerDetailData_vt : "+ a09CareerDetailData_vt.toString());
                req.setAttribute("a09CareerDetailData_vt", a09CareerDetailData_vt);
                //              이동발령 신청시 개인 경력사항

                req.setAttribute("a19CareerData", resultData);
                req.setAttribute("PersInfoData" ,phonenumdata );
                req.setAttribute("T_RESULT",    T_RESULT);
                req.setAttribute("E_JUSO_TEXT", E_JUSO_TEXT);
                req.setAttribute("E_KR_REPRES", E_KR_REPRES);


                String dest;
                if (box.get("PRINT_GUBUN").equals("2")) {
                    dest = WebUtil.JspURL+"A/A19Career/A19CareerPrintCareer02.jsp";
                } else {
                    dest = WebUtil.JspURL+"A/A19Career/A19CareerPrintCareer01.jsp";
                }

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
