/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진 신청                                               */
/*   Program ID   : E15GeneralBuildSV                                           */
/*   Description  : 종합검진을 신청할 수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*   				  : 2017-03-23  eunha [CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청
/********************************************************************************/

package servlet.hris.E.E15General;

import java.util.Vector;
import javax.servlet.http.*;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.rfc.*;
import hris.A.A16Appl.*;
import hris.A.A16Appl.rfc.*;
import hris.E.E15General.rfc.E15SexyFlagRFC;
import hris.E.E15General.E15GeneralData;
import hris.E.E15General.E15GeneralFlagData;
import hris.E.E15General.rfc.*;
import hris.E.E17Hospital.rfc.E17CompanyCoupleRFC;

public class E15GeneralBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="04";    // 결재 업무타입(종합검진)
    private String UPMU_NAME = "종합검진";

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

            //CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 start
            /*String GUEN_CODE = box.get("GUEN_CODE");
            String HOSP_CODE = box.get("HOSP_CODE");
            String EZAM_DATE = box.get("EZAM_DATE");
            String ZCONFIRM = box.get("ZCONFIRM");*/
            String GUEN_CODE = box.get("sGUEN_CODE",box.get("GUEN_CODE"));
            String HOSP_CODE = box.get("sHOSP_CODE",box.get("HOSP_CODE"));
            String EZAM_DATE = box.get("sEZAM_DATE",box.get("EZAM_DATE"));
            String ZCONFIRM = box.get("sZCONFIRM",box.get("ZCONFIRM"));
            String RequestPageName = box.get("RequestPageName");
            //CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 end

            if( GUEN_CODE.equals("")||GUEN_CODE== null ){
                GUEN_CODE = "0001";
            }
            box.put("GUEN_CODE", GUEN_CODE);
            box.put("PERNR", PERNR);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR, "X"); //getPersonInfo(PERNR);

            if( jobid.equals("first") ) {

            	//결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                String year       = DataUtil.getCurrentYear();
                Vector general_vt = new Vector();

                req.setAttribute("PERNR", PERNR);
                req.setAttribute("PersonData" , phonenumdata );

                E15SexyFlagRFC     func2    = new E15SexyFlagRFC();
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

                E17CompanyCoupleRFC  cc_rfc           = new E17CompanyCoupleRFC();
                String      CompanyCoupleYN = cc_rfc.getData(PERNR);

                rfc.setDetailInput(user.empNo, "", ""); // set DetailInput


                Vector appl_vt = func1.getAppList(key);

                Logger.debug.println(" === appl_vt =======]]]" + appl_vt.toString());

                if( appl_vt.size() > 0 ) {
                    appl_vt = SortUtil.sort( appl_vt, "BEGDA", "asc" );    // 최종 데이터의 정보를 체크하기위해서 Sort 함

                    for( int i = 0 ; i < appl_vt.size() ; i++ ) {
                        A16ApplListData adata = (A16ApplListData)appl_vt.get(i);
                        general_vt = rfc.getGeneralListAinf( PERNR, adata.AINF_SEQN, user.empNo );
                        for( int j = 0 ; j < general_vt.size() ; j++ ) {
                            E15GeneralData edata = (E15GeneralData)general_vt.get(j);

                            //                          2002.11.11. 확정일자 없이 결재가 완료된경우 재신청 가능하다.
                            if( (edata.CONF_DATE.equals("0000-00-00")||edata.CONF_DATE.equals("")) && edata.APPR_STAT.equals("A") ) {
                                if( edata.GUEN_CODE.equals("0001") ) {
                                    flagdata.ME_FLAG="";
                                    flagdata.ME_CODE="";
                                } else if( edata.GUEN_CODE.equals("0002") ) {
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

                Logger.debug.println(this, " [flagdata =]" + flagdata.toString());  // 강재영   데이터 컬럼 값 확인. E_M_FLAG : 남성    / E_F_FLAG  : 여성 .
                //Logger.debug.println(this, " [GUEN_CODE =]" + GUEN_CODE);
                //배우자면 무조건 신청가능하게
                if(gdata.E_M_FLAG.equals("N") && GUEN_CODE.equals("0001") ) {
               // if(gdata.M_FLAG.equals("N")) {
                	if (GUEN_CODE.equals("DELETE")){
                        Logger.debug.println(this, "Data Not Found 11111");
                        String msg = g.getMessage("MSG.E.E15.0001"); //"올해 종합검진 대상자가 아닙니다.";
                        String url = "";
                        if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        	url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                        }
                        //String url = "history.back(-2);";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        dest = WebUtil.JspURL+"common/msg.jsp";
                	}else{
                    Logger.debug.println(this, "Data Not Found 222222");
                    String msg = g.getMessage("MSG.E.E15.0001"); //"올해 종합검진 대상자가 아닙니다.";
                    String url = "history.back();";
                    url = "location.href = '" +WebUtil.ServletURL+"hris.E.E15General.E15GeneralListSV"+ "';";

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                	}
                } else {

                    AreaCodeRFC func = new AreaCodeRFC();
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

                    	Vector E15HospCodeData_opt  = (new HospCodeRFC()).getHospCode(PERNR);
                    	Vector getGuenCodeVt  = (new GuenCodeRFC()).getGuenCode();
                    	Vector E15StmcData_opt  = (new E15StmcCodeRFC()).getStmcCode(PERNR,HOSP_CODE);
                    	Vector E15SeltData_opt  = (new E15SeltCodeRFC()).getSeltCode(PERNR,HOSP_CODE);

                    	SortUtil.sort_num(E15SeltData_opt,"GRUP_NUMB,HOSP_CODE", "asc");

                        req.setAttribute("GUEN_CODE",  GUEN_CODE);
                        req.setAttribute("HOSP_CODE",  HOSP_CODE);
                        req.setAttribute("EZAM_DATE",  EZAM_DATE);
                        req.setAttribute("ZCONFIRM",  ZCONFIRM);
                        //req.setAttribute("e15general",  gdata);
                        req.setAttribute("E15General",  gdata);
                        //req.setAttribute("resultData",  gdata);
                        req.setAttribute("AreaEntity",  AreaEntity);
                        req.setAttribute("E15GeneralFlagData",  flagdata);
                        req.setAttribute("CompanyCoupleYN",  CompanyCoupleYN);
                        req.setAttribute("E15HospCodeData_opt",  E15HospCodeData_opt);
                        req.setAttribute("getGuenCodeVt",  getGuenCodeVt);
                        req.setAttribute("E15StmcData_opt",  E15StmcData_opt);
                        req.setAttribute("E15SeltData_opt",  E15SeltData_opt);

                        //Logger.debug.println(" resultData =======]]]" + gdata.toString());
                        //Logger.debug.println(" E15GeneralFlagData =======]]]" + flagdata.toString());
                        Logger.debug.println(" E15HospCodeData_opt =======]]]" + E15HospCodeData_opt.toString());

                        dest = WebUtil.JspURL+"E/E15General/E15GeneralBuild.jsp";
                    }
                }
            } else if( jobid.equals("create") ) {

            	/* 실제 신청 부분 */
                dest = requestApproval(req, box, E15GeneralData.class, new RequestFunction<E15GeneralData>() {
                    public String porcess(E15GeneralData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                    	//사내부부 신청 시 배우자 신청 불가
                    	E17CompanyCoupleRFC  cc_rfc           = new E17CompanyCoupleRFC();
                        String      CompanyCoupleYN = cc_rfc.getData(box.get("PERNR"));

                        if(CompanyCoupleYN.equals("Y")&&box.get("GUEN_CODE").equals("0002")){
                       	   throw new GeneralException(g.getMessage("MSG.E.E15.0003")); // "사내부부의 경우 배우자 종합검진 신청이 불가합니다.";
                       }

                        /* 결재 신청 RFC 호출 */
                        E15GeneralListRFC e15Rfc = new E15GeneralListRFC();
                        e15Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                        inputData.ZPERNR    = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.UNAME     = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.AEDTM     = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                       	//Logger.debug.println(this,"====inputData==="+ inputData.toString());

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

                String msg2 = "";
                String url = "";

                //dest = WebUtil.JspURL+"common/msg.jsp";

                //@v1.0
                String F_FLAG       = box.get("F_FLAG");
                String F_FLAG_REQYN = box.get("F_FLAG_REQYN");

                if (GUEN_CODE.equals("0001") && F_FLAG.equals("Y") && F_FLAG_REQYN.equals("Y") ) { //배우자신청은 원래종합검진신청화면으로
                	//CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 start
                	//url = "location.href = '" + WebUtil.ServletURL+"hris.E.E38Cancer.E38CancerBuildSV?GUEN_CODE=0002&PERNR="+PERNR+"&HOSP_CODE="+data.HOSP_CODE+"&EZAM_DATE="+data.EZAM_DATE+"&ZCONFIRM="+data.ZCONFIRM+"';";
                    url = "location.href = '" + WebUtil.ServletURL+"hris.E.E15General.E15GeneralBuildSV?sGUEN_CODE=0002&PERNR="+PERNR+"&sHOSP_CODE="+box.get("HOSP_CODE")+"&sEZAM_DATE="+box.get("EZAM_DATE")+"&sZCONFIRM="+box.get("ZCONFIRM")+"';";
                  //CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 end
                    msg2 = "배우자는 다시 항목 입력후 신청 버튼을 클릭하여야 신청됩니다.";
                    req.setAttribute("url", url);
                    req.setAttribute("msg2", msg2);
                }

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }
}
