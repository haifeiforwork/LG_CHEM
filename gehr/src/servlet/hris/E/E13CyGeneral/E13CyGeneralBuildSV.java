/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 이월종합검진                                                    */
/*   Program Name : 이월종합검진 신청                                               */
/*   Program ID   : E13CyGeneralBuildSV                                           */
/*   Description  : 이월종합검진을 신청할 수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E13CyGeneral;

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
import hris.common.util.*;
import hris.common.rfc.*;
import hris.A.A16Appl.*;
import hris.A.A16Appl.rfc.*;
import hris.E.E15General.E15GeneralData;
import hris.E.E15General.E15GeneralFlagData;
import hris.E.E13CyGeneral.rfc.*;
import hris.E.E15General.rfc.*;

public class E13CyGeneralBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="04";    // 결재 업무타입(이월종합검진)
    private String UPMU_NAME = "이월종합검진";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
        	final WebUserData user = WebUtil.getSessionUser(req);
            final Box box = WebUtil.getBox(req);

            String dest  = "";
            String jobid =box.get("jobid", "first");
            String PERNR = getPERNR(box, user); //신청대상자 사번;

            String GUEN_CODE = box.get("GUEN_CODE");
            String HOSP_CODE = box.get("HOSP_CODE");
            String EZAM_DATE = box.get("EZAM_DATE");
            String ZCONFIRM = box.get("ZCONFIRM");
            String RequestPageName = box.get("RequestPageName");

            if(GUEN_CODE== null || GUEN_CODE.equals("")  ){
                GUEN_CODE = "0001";
            }

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR, "X");  //getPersonInfo(PERNR);

            Logger.debug.println(this, " [phonenumdata =]" + phonenumdata.toString());

            if( jobid.equals("first") ) {

            	//결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                String year       = DataUtil.getCurrentYear();
                Vector general_vt = new Vector();

                req.setAttribute("PERNR", PERNR);
                req.setAttribute("PersonData" , phonenumdata );

                E13CySexyFlagRFC     func2    = new E13CySexyFlagRFC();
                E15GeneralData     gdata    = (E15GeneralData)func2.getSexyFlag(PERNR, year);
                E15GeneralListRFC  rfc      = new E15GeneralListRFC();
                E15GeneralFlagData flagdata = new E15GeneralFlagData();

                A16ApplListRFC      func1   = new A16ApplListRFC();
                A16ApplListKey      key     = new A16ApplListKey();

                key.I_BEGDA     = DataUtil.getCurrentYear()+"0101";
                key.I_ENDDA     = DataUtil.getCurrentYear()+"1231";
                key.I_PERNR     = PERNR;
                key.I_STAT_TYPE = "";
                key.I_UPMU_TYPE = "04";

                Vector appl_vt = func1.getAppList(key);

                //Logger.debug.println(" === appl_vt =======]]]" + appl_vt.toString());

                rfc.setDetailInput(user.empNo, "", ""); // set DetailInput

                if( appl_vt.size() > 0 ) {
                    appl_vt = SortUtil.sort( appl_vt, "BEGDA", "asc" );    // 최종 데이터의 정보를 체크하기위해서 Sort 함

                    for( int i = 0 ; i < appl_vt.size() ; i++ ) {
                        A16ApplListData adata = (A16ApplListData)appl_vt.get(i);
                        general_vt = rfc.getGeneralListAinf( PERNR, adata.AINF_SEQN,user.empNo );
                        for( int j = 0 ; j < general_vt.size() ; j++ ) {
                            E15GeneralData edata = (E15GeneralData)general_vt.get(j);

                            Logger.debug.println(" === edata =======]]]" + edata.toString());

                            //                          2002.11.11. 확정일자 없이 결재가 완료된경우 재신청 가능하다.
                            if( (edata.CONF_DATE.equals("0000-00-00")||edata.CONF_DATE.equals("")) && edata.APPR_STAT.equals("A") ) {
                                if( edata.GUEN_CODE.equals("0001") ) {
                                    flagdata.ME_FLAG="";
                                    flagdata.ME_CODE="";
                                } else if  (edata.GUEN_CODE.equals("0002") ) {
                                    flagdata.WI_FLAG="";
                                    flagdata.WI_CODE="";
                                }
                            } else {
                                if( edata.GUEN_CODE.equals("0001") ) {
                                    flagdata.ME_FLAG="Y";
                                    flagdata.ME_CODE="0001";
                                } else if( edata.GUEN_CODE.equals("0002") ) {
                                    flagdata.WI_FLAG="Y";
                                    flagdata.WI_CODE="0002";
                                }
                            }
                        }
                    }
                }

                //Logger.debug.println(this, " [gdata =]" + gdata.toString());
                if(gdata.E_M_FLAG.equals("N")) {
                	if (GUEN_CODE.equals("DELETE")){
                        Logger.debug.println(this, "Data Not Found");
                        String msg = g.getMessage("MSG.E.E13.0001"); //"올해 이월종합검진 대상자가 아닙니다.";
                        String url = "";
                        if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        	url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                        }
                        //String url = "history.back(-2);";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        dest = WebUtil.JspURL+"common/msg.jsp";
                	}else{
                    Logger.debug.println(this, "Data Not Found");
                    String msg = g.getMessage("MSG.E.E13.0001"); //"올해 이월종합검진 대상자가 아닙니다.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                	}
                } else {

                    AreaCodeRFC func = new AreaCodeRFC();
                    Vector Area_vt = func.getAreaCode(PERNR);
                    CodeEntity AreaEntity = (CodeEntity)Area_vt.get(0); // (CodeEntity)Utils.indexOf(Area_vt, 0);

                    if( Area_vt == null || Area_vt.size()==0){
                        Logger.debug.println(this, "Data Not Found");
                        String msg = g.getMessage("MSG.E.E15.0002"); //"검진지역이 등록되어 있지 않습니다.";
                        String url = "history.back();";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } else {

                    	Vector E13CyHospCodeData_opt  = (new E13CyHospCodeRFC()).getHospCode(PERNR);
                    	Vector E13CyStmcData_opt  = (new E13CyStmcCodeRFC()).getStmcCode(PERNR,HOSP_CODE);
                    	Vector E13CySeltData_opt  = (new E13CySeltCodeRFC()).getSeltCode(PERNR,HOSP_CODE);

                    	E13CySeltData_opt  = SortUtil.sort_num(E13CySeltData_opt,"GRUP_NUMB,HOSP_CODE", "asc");

                        req.setAttribute("GUEN_CODE",  GUEN_CODE);
                        req.setAttribute("HOSP_CODE",  HOSP_CODE);
                        req.setAttribute("EZAM_DATE",  EZAM_DATE);
                        req.setAttribute("ZCONFIRM",  ZCONFIRM);
                        req.setAttribute("E15General",  gdata);
                        req.setAttribute("AreaEntity",  AreaEntity);
                        req.setAttribute("E15GeneralFlagData",  flagdata);

                        req.setAttribute("AreaEntity",  AreaEntity);
                        req.setAttribute("E13CyHospCodeData_opt",  E13CyHospCodeData_opt);
                        req.setAttribute("E13CyStmcData_opt",  E13CyStmcData_opt);
                        req.setAttribute("E13CySeltData_opt",  E13CySeltData_opt);

                        //Logger.debug.println(this, " E15GeneralFlagData ]]]" + phonenumdata.toString());
                        //Logger.debug.println(" resultData =======]]]" + gdata.toString());
                        Logger.debug.println(" E13CyHospCodeData_opt =======]]]" + E13CyHospCodeData_opt.toString());
                        Logger.debug.println(" E15GeneralFlagData =======]]]" + flagdata.toString());

                        dest = WebUtil.JspURL+"E/E13CyGeneral/E13CyGeneralBuild.jsp";
                    }
                }
            } else if( jobid.equals("create") ) {

            	/* 실제 신청 부분 */
                dest = requestApproval(req, box, E15GeneralData.class, new RequestFunction<E15GeneralData>() {
                    public String porcess(E15GeneralData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        E15GeneralListRFC e15Rfc = new E15GeneralListRFC();
                        e15Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                        inputData.ZPERNR    = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.UNAME     = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.AEDTM     = DataUtil.getCurrentDate();  // 변경일(현재날짜)

        				box.put("I_GTYPE", "2");  // insert

                        //e15Rfc.build(PERNR, ainf_seqn, E15General_vt);
                        String AINF_SEQN = e15Rfc.build(Utils.asVector(inputData), box, req);

                        if(!e15Rfc.getReturn().isSuccess()) {
                        	 throw new GeneralException(e15Rfc.getReturn().MSGTX);
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

        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }
}
