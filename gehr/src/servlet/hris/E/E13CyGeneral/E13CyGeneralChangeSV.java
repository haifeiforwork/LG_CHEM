/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 이월종합검진                                                    */
/*   Program Name : 이월종합검진 수정                                               */
/*   Program ID   : E13CyGeneralChangeSV                                          */
/*   Description  : 이월종합검진 신청을 수정할 수 있도록 하는 Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  이형석                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E13CyGeneral;

import java.sql.*;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import hris.A.A16Appl.*;
import hris.A.A16Appl.rfc.*;
import hris.E.E15General.E15GeneralData;
import hris.E.E15General.E15GeneralFlagData;
import hris.E.E13CyGeneral.rfc.*;
import hris.E.E15General.rfc.*;

public class E13CyGeneralChangeSV extends ApprovalBaseServlet {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

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

        	HttpSession session = req.getSession(false);
        	final WebUserData user = WebUtil.getSessionUser(req);

			final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR =  box.get("PERNR", user.empNo); //getPERNR(box, user); //신청대상자 사번

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
			String AINF_SEQN = box.get("AINF_SEQN");

            E15GeneralListRFC  e15Rfc      = new E15GeneralListRFC();
            e15Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            Vector  E15General_vt = e15Rfc.getGeneralList( PERNR, AINF_SEQN );
            //E15GeneralData E15GeneralData = (E15GeneralData)E15General_vt.get(0);
            E15GeneralData e15GeneralData = (E15GeneralData)E15General_vt.get(0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(e15GeneralData.PERNR);


            if( jobid.equals("first") ) {    //제일처음 수정 화면에 들어온경우.

                String year       = DataUtil.getCurrentYear();
                Vector general_vt = new Vector();

                E15GeneralFlagData flagdata = new E15GeneralFlagData();
                E13CySexyFlagRFC     func2    = new E13CySexyFlagRFC();
                E15GeneralData     gdata    = (E15GeneralData)func2.getSexyFlag(e15GeneralData.PERNR, year);

                A16ApplListRFC      func1   = new A16ApplListRFC();
                A16ApplListKey      key     = new A16ApplListKey();

                key.I_BEGDA     = DataUtil.getCurrentYear()+"0101";
                key.I_ENDDA     = DataUtil.getCurrentYear()+"1231";
                key.I_PERNR     = PERNR;
                key.I_STAT_TYPE = "";
                key.I_UPMU_TYPE = "04";

                Vector appl_vt = func1.getAppList(key);

                if( appl_vt.size() > 0 ) {
                    appl_vt = SortUtil.sort( appl_vt, "BEGDA", "asc" );    // 최종 데이터의 정보를 체크하기위해서 Sort 함

                    for( int i = 0 ; i < appl_vt.size() ; i++ ) {
                        A16ApplListData adata = (A16ApplListData)appl_vt.get(i);
                        if( !AINF_SEQN.equals(adata.AINF_SEQN) ) {
                            general_vt = e15Rfc.getGeneralListAinf( e15GeneralData.PERNR, adata.AINF_SEQN,user.empNo );
                        }
                    }
                    for( int j = 0 ; j < general_vt.size() ; j++ ) {
                        E15GeneralData edata = (E15GeneralData)general_vt.get(j);

                        //                          2002.11.11. 확정일자 없이 결재가 완료된경우 재신청 가능하다.
                        if( ( edata.CONF_DATE.equals("0000-00-00") || edata.CONF_DATE.equals("") ) && edata.APPR_STAT.equals("A") ) {
                            if( edata.GUEN_CODE.equals("0001") ) {
                                flagdata.ME_FLAG="";
                                flagdata.ME_CODE="";
                            } else if( edata.GUEN_CODE.equals("0002") ) {
                                flagdata.WI_FLAG="";
                                flagdata.WI_CODE="";
                            }
                        } else {
                            if( edata.GUEN_CODE.equals("0001") ){
                                flagdata.ME_FLAG="Y";
                                flagdata.ME_CODE="0001";
                            } else if( edata.GUEN_CODE.equals("0002") ) {
                                flagdata.WI_FLAG="Y";
                                flagdata.WI_CODE="0002";
                            }
                        }
                    }
                }

                Vector E13CyHospCodeData_opt  = (new E13CyHospCodeRFC()).getHospCode(e15GeneralData.PERNR);
            	Vector E13CyStmcData_opt  = (new E13CyStmcCodeRFC()).getStmcCode(e15GeneralData.PERNR, e15GeneralData.HOSP_CODE);
            	Vector E13CySeltData_opt  = (new E13CySeltCodeRFC()).getSeltCode(e15GeneralData.PERNR, e15GeneralData.HOSP_CODE);

            	E13CySeltData_opt  = SortUtil.sort_num(E13CySeltData_opt,"GRUP_NUMB,HOSP_CODE", "asc");

                Logger.debug.println(this, "E15General_vt : " + E15General_vt.toString());

                req.setAttribute("isUpdate", true); //등록 수정 여부
                //req.setAttribute("E15General_vt", E15General_vt);
                req.setAttribute("resultData", e15GeneralData);

                req.setAttribute("PERNR", e15GeneralData.PERNR);
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("E15GeneralFlagData", flagdata);
                req.setAttribute("E15GeneralData", gdata);

                req.setAttribute("E13CyHospCodeData_opt",  E13CyHospCodeData_opt);
                req.setAttribute("E13CyStmcData_opt",  E13CyStmcData_opt);
                req.setAttribute("E13CySeltData_opt",  E13CySeltData_opt);

                detailApporval(req, res, e15Rfc);
                printJspPage(req, res, WebUtil.JspURL + "E/E13CyGeneral/E13CyGeneralChange.jsp");

            } else if( jobid.equals("change") ) {

            	/* 실제 신청 부분 */
				dest = changeApproval(req, box, E15GeneralData.class, e15Rfc, new ChangeFunction<E15GeneralData>(){

					public String porcess(E15GeneralData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						inputData.PERNR  = inputData.PERNR;
        				inputData.ZPERNR = inputData.ZPERNR;    // 신청자 사번(대리신청, 본인 신청)
        				inputData.UNAME  = user.empNo;          // 수정자 사번(대리신청, 본인 신청)
    	                inputData.AEDTM  = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                    	box.put("I_GTYPE", "3");

                    	/* 결재 신청 RFC 호출 */
                    	E15GeneralListRFC changeRFC = new E15GeneralListRFC();
                		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);
                        //e15Rfc.change( PERNR, ainf_seqn, General_vt );

                    	//Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn().isSuccess() );
                        //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn() );

                        if(!changeRFC.getReturn().isSuccess()) {
                        	 throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }
                        return inputData.AINF_SEQN;

                        /* 개발자 작성 부분 끝 */
                    }
                });

				 printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            //printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }
}
