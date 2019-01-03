/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 암검진                                                    */
/*   Program Name : 암검진 신청                                               */
/*   Program ID   : E38CancerBuildSV                                           */
/*   Description  : 암검진을 신청할 수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2013-06-21  lsa  C20130620_53407                 */
/*   Update       :                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E38Cancer;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.db.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.A.A16Appl.*;
import hris.A.A16Appl.rfc.*;
import hris.E.E38Cancer.E38CancerData;
import hris.E.E38Cancer.E38CancerFlagData;
import hris.E.E38Cancer.rfc.*;

public class E38CancerBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="39";    // 결재 업무타입(암검진)
    private String UPMU_NAME = "추가암검진(7종암)";

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
            box.put("GUEN_CODE", GUEN_CODE);
            box.put("PERNR", PERNR);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR, "X");  //phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);

            //Logger.debug.println(this, " [phonenumdata =]" + phonenumdata.toString());

            if( jobid.equals("first") ) {

            	//결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                String year       = DataUtil.getCurrentYear();
                Vector general_vt = new Vector();

                req.setAttribute("PERNR", PERNR);
                req.setAttribute("PersonData" , phonenumdata );

                E38CancerSexyFlagRFC     func2    = new E38CancerSexyFlagRFC();
                E38CancerData     gdata    = (E38CancerData)func2.getSexyFlag(PERNR, year);
                E38CancerListRFC  rfc      = new E38CancerListRFC();
                E38CancerFlagData flagdata = new E38CancerFlagData();

                A16ApplListRFC      func1   = new A16ApplListRFC();
                A16ApplListKey      key     = new A16ApplListKey();

                key.I_BEGDA     = DataUtil.getCurrentYear()+"0101";
                key.I_ENDDA     = DataUtil.getCurrentYear()+"1231";
                key.I_PERNR     = PERNR;
                key.I_STAT_TYPE = "";
                key.I_UPMU_TYPE = "39";

                rfc.setDetailInput(user.empNo, "", ""); // set DetailInput

                Vector appl_vt = func1.getAppList(key);

                if( appl_vt.size() > 0 ) {
                    appl_vt = SortUtil.sort( appl_vt, "BEGDA", "asc" );    // 최종 데이터의 정보를 체크하기위해서 Sort 함

                    for( int i = 0 ; i < appl_vt.size() ; i++ ) {
                        A16ApplListData adata = (A16ApplListData)appl_vt.get(i);

                        general_vt = rfc.getGeneralListAinf( PERNR, adata.AINF_SEQN ,user.empNo);

                        for( int j = 0 ; j < general_vt.size() ; j++ ) {
                            E38CancerData edata = (E38CancerData)general_vt.get(j);

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

                Logger.debug.println(this, " [gdata =]" + gdata.toString());
                if(  gdata.E_M_FLAG.equals("N")) {
                	if (GUEN_CODE.equals("DELETE")){
                        Logger.debug.println(this, "Data Not Found");
                        String msg = g.getMessage("MSG.E.E38.0001"); //"올해 암검진 대상자가 아닙니다.";
                        String url = "";
                        if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        	url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                        }
                        //String url = "history.back(-2);";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        Logger.debug.println(this, " [gdata =444444444]"  );
                	}else{
                    Logger.debug.println(this, "Data Not Found");
                    String msg = g.getMessage("MSG.E.E38.0001"); //"올해 암검진 대상자가 아닙니다.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                	}
                } else {

                	E38CancerAreaCodeRFC func = new E38CancerAreaCodeRFC();
                    Vector Area_vt = func.getAreaCode(PERNR);
                    CodeEntity AreaEntity = (CodeEntity)Area_vt.get(0);

                    if( Area_vt == null || Area_vt.size()==0){
                        Logger.debug.println(this, "Data Not Found");
                        String msg = g.getMessage("MSG.E.E15.0002"); //"검진지역이 등록되어 있지 않습니다.";
                        String url = "history.back();";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } else {

                    	Vector E38CancerHospCodeData_opt  = (new E38CancerHospCodeRFC()).getHospCode(PERNR);
                    	Vector E38CancerStmcData_opt  = (new E38CancerStmcCodeRFC()).getStmcCode(PERNR,HOSP_CODE);
                    	Vector E38CancerSeltData_opt  = (new E38CancerSeltCodeRFC()).getSeltCode(PERNR,HOSP_CODE);

                        req.setAttribute("GUEN_CODE",  GUEN_CODE);
                        req.setAttribute("HOSP_CODE",  HOSP_CODE);
                        req.setAttribute("EZAM_DATE",  EZAM_DATE);
                        req.setAttribute("ZCONFIRM",  ZCONFIRM);
                        req.setAttribute("E38Cancer",  gdata);
                        req.setAttribute("Area_vt",  Area_vt);
                        req.setAttribute("AreaEntity",  AreaEntity);
                        req.setAttribute("E38CancerFlagData",  flagdata);
                        req.setAttribute("E38CancerHospCodeData_opt",  E38CancerHospCodeData_opt);
                        req.setAttribute("E38CancerStmcData_opt",  E38CancerStmcData_opt);
                        req.setAttribute("E38CancerSeltData_opt",  E38CancerSeltData_opt);

                        Logger.debug.println(this, " E38CancerFlagData ]]]" + phonenumdata.toString());

                        dest = WebUtil.JspURL+"E/E38Cancer/E38CancerBuild.jsp";
                        //dest = WebUtil.JspURL+"E/E38Cancer/E38Cancertest.jsp";
                        //dest = WebUtil.JspURL+"E/E15General/E15GeneralBuild.jsp";
                    }
                }
            } else if( jobid.equals("create") ) {

            	/* 실제 신청 부분 */
                dest = requestApproval(req, box, E38CancerData.class, new RequestFunction<E38CancerData>() {
                    public String porcess(E38CancerData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        E38CancerListRFC e38Rfc = new E38CancerListRFC();
                        e38Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                        inputData.ZPERNR    = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.UNAME     = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.AEDTM     = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                       	//Logger.debug.println(this,"====inputData==="+ inputData.toString());

        				box.put("I_GTYPE", "2");  // insert

                        //rfc.build(PERNR, ainf_seqn, E38Cancer_vt);
                        String AINF_SEQN = e38Rfc.build(Utils.asVector(inputData), box, req);

                        if(!e38Rfc.getReturn().isSuccess()) {
                        	 throw new GeneralException(e38Rfc.getReturn().MSGTX);
                        }

                        return AINF_SEQN;

                        /* 개발자 작성 부분 끝 */
                    }
                });

              /* String msg2 = "";
                String url = "";

                //dest = WebUtil.JspURL+"common/msg.jsp";

                //@v1.0
                String F_FLAG       = box.get("F_FLAG");
                String F_FLAG_REQYN = box.get("F_FLAG_REQYN");

                if (GUEN_CODE.equals("0001") && F_FLAG.equals("Y") && F_FLAG_REQYN.equals("Y") ) { //배우자신청은 원래종합검진신청화면으로
                    //url = "location.href = '" + WebUtil.ServletURL+"hris.E.E38Cancer.E38CancerBuildSV?GUEN_CODE=0002&PERNR="+PERNR+"&HOSP_CODE="+data.HOSP_CODE+"&EZAM_DATE="+data.EZAM_DATE+"&ZCONFIRM="+data.ZCONFIRM+"';";
                    url = "location.href = '" + WebUtil.ServletURL+"hris.E.E38Cancer.E38CancerBuildSV?GUEN_CODE=0002&PERNR="+PERNR+"&HOSP_CODE="+box.get("HOSP_CODE")+"&EZAM_DATE="+box.get("EZAM_DATE")+"&ZCONFIRM="+box.get("ZCONFIRM")+"';";
                    msg2 = "배우자는 다시 항목 입력후 신청 버튼을 클릭하여야 신청됩니다.";
                    req.setAttribute("url", url);
                    req.setAttribute("msg2", msg2);
                }*/

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
        	 throw new GeneralException(e);
        }

    }
}
