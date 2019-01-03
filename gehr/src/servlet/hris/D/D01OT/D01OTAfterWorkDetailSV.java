/********************************************************************************/
/*                                                                              																*/
/*   System Name  	: MSS                                                         													*/
/*   1Depth Name  	: MY HR 정보                                                  															*/
/*   2Depth Name  	: 초과근무 사후신청                                           															*/
/*   Program Name 	: 초과근무 사후신청 조회                                      														*/
/*   Program ID   		: D01OTAfterWorkDetailSV                                      											*/
/*   Description  		: 초과근무 조회 및 삭제를 할 수 있도록 하는 Class             											*/
/*   Note         		:                                                             														*/
/*   Creation     		: 2018-06-12  강동민                                          														*/
/*   Update       		: 									                                          										*/
/*                                                                              																*/
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTAfterWorkTimeDATA;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTAfterWorkTimeListRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;
import hris.D.D01OT.rfc.D01OTAFRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTAfterWorkDetailSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "44";

    private String UPMU_NAME = "초과근무 사후신청";

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
            /**************    Start: 국가별 분기처리       **********************************************************/
	        	if (! user.area.equals(Area.KR)){ 	// 해외화면으로
	        		printJspPage( req,res, WebUtil.ServletURL+"hris.D.D01OT.D01OTDetailGlobalSV");
	        		return;
	        	}
	        /**************    END: 국가별 분기처리         **********************************************************/

            String dest  = "";
            String jobid = "";

            Box box 	= WebUtil.getBox(req);
            jobid 		= box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            //final D01OTRFC  rfc       = new D01OTRFC();
            final D01OTAFRFC  rfc       = new D01OTAFRFC();

            Vector   D01OTData_vt  = null;
            final String   ainf_seqn   = box.get("AINF_SEQN");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn);
            D01OTData_vt = rfc.getDetail( ainf_seqn, "" );

            final D01OTData firstData = (D01OTData)Utils.indexOf(D01OTData_vt,0);

            // 대리 신청 추가
            if(firstData!=null){

            	// 시작 : 2018.05.17 [WorkTime52] 유정우 - 실근무시간 현황표 추가
                try {
                    /**
                     * 실근무시간 현황표 추가여부
                     *     S(사무직 현황표 추가)
                     *     H(현장직 현황표 추가)
                     *     -(기존 초과근무 현황표 유지)
                     *     X(해당 없음)
                     *
                     * -------------------------------------------------------------------------
                     *           문서 구분          | 결재할 문서 | 결재중 문서 | 결재완료 문서
                     *                              | I_APGUB = 1 | I_APGUB = 2 | I_APGUB = 3
                     * -------------------------------------------------------------------------
                     *         | 사무직(S) | 신청자 |  X          |  S          |  S
                     *         |-----------|        |-------------------------------------------
                     *  신청자 | 현장직(H) |  화면  |  X          |  -          |  -
                     *   사원  |----------------------------------------------------------------
                     *   구분  | 사무직(S) | 결재자 |  S          |  S          |  S
                     *         |-----------|        |-------------------------------------------
                     *         | 현장직(H) |  화면  |  H          |  H          |  H
                     * -------------------------------------------------------------------------
                     *
                     * 결재자 입장에서는 모든 문서 화면에 현황표 추가
                     * 신청자 입장에서는 결재중이거나 결재완료된 문서 화면에 현황표 추가
                     */
                    if (!"1".equals(I_APGUB) || !user.empNo.equals(firstData.PERNR)) {
                        final String WORK_DATE = StringUtils.defaultString(firstData.WORK_DATE).replaceAll("[^\\d]", "");
                        final String I_DATUM = "X".equals(firstData.VTKEN) ? DataUtil.addDays(WORK_DATE, -1, "yyyyMMdd") : WORK_DATE;

                        // 신청자 사원 구분 조회 : S(사무직) or H(현장직)
                        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                            {
                                put("I_PERNR", firstData.PERNR);
                                put("I_DATUM", I_DATUM);
                            }
                        });

                        Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063"));
                        final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB")); // 실근무시간 현황 조회에 필요한 사원 구분(사무직 or 현장직) 데이터를 조회하지 못하였습니다.
                        req.setAttribute("EMPGUB", EMPGUB);
                        req.setAttribute("TPGUB", EXPORT.get("E_TPGUB"));
                        req.setAttribute("MM", Integer.parseInt(DataUtil.getCurrentMonth()));

                        if ("S".equals(EMPGUB) || ("H".equals(EMPGUB) && !user.empNo.equals(firstData.PERNR))) {
                            // 신청자 실근무시간 현황 조회
                            rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                {
                                    put("I_EMPGUB", EMPGUB);
                                    put("I_PERNR", firstData.PERNR);
                                    put("I_DATUM", WORK_DATE);
                                    if ("H".equals(EMPGUB)) put("I_VTKEN", firstData.VTKEN);
                                }
                            });

                            WebUtil.setAttributes(req, (Map<String, Object>) getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0064")).get("ES_EMPGUB_" + EMPGUB)); // 실근무시간 현황 데이터를 조회하지 못하였습니다.
                        }

                    }

                } catch (Exception e) {
                    req.setAttribute("msg", e.getMessage());
                    req.setAttribute("url", "history.back()");

                    printJspPage(req, res, WebUtil.JspURL + "common/msg.jsp");
                    return;
                }
                // 종료 : 2018.05.17 [WorkTime52] 유정우 - 실근무시간 현황표 추가




	            PersonInfoRFC numfunc = new PersonInfoRFC();
	            PersonData phonenumdata;
	            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
	            req.setAttribute("PersonData" , phonenumdata );
            }
            //-----------------------------------------------------------------------------------------------------------------------------
            final	String PERNR	= firstData.PERNR;
            // 사원 구분 조회(사무직:S / 현장직:H) => [변경 :2018-06-07 : A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)
            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                {
                    put("I_PERNR" , PERNR);
                }
            });
            final String EMPGUB 	= ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB")); 	//(사무직:S / 현장직:H)
            final String TPGUB 	= ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		//A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)

            String GTYPE	= "1";	//처리구분( 1 =상세 , 2 =결재의뢰, 3 =수정, 4 = 삭제 )
            String MODE 	= "";
            String DATE		= firstData.WORK_DATE;
            String VTKEN	= firstData.VTKEN;
            String curdate = DataUtil.getCurrentDate();
            //-----------------------------------------------------------------------------------------------------------------------------
            /**************    jobid : first       **********************************************************/
            if( jobid.equals("first") ) {

                req.setAttribute("D01OTData_vt", D01OTData_vt);

                if (!detailApporval(req, res, rfc))                    return;


                // 실근무시간 조회[info Table]
                D01OTRealWrokListRFC	realworkfunc	= new D01OTRealWrokListRFC();
                D01OTAfterWorkTimeListRFC rfcaf	= new D01OTAfterWorkTimeListRFC();

                final D01OTRealWorkDATA WorkData 		= realworkfunc.getResult(EMPGUB, PERNR, DATE, VTKEN, ainf_seqn, "");
                final D01OTAfterWorkTimeDATA AfterData 	= rfcaf.getResult(GTYPE, PERNR, DATE, VTKEN, ainf_seqn, curdate, "");

                if(realworkfunc.getReturn().isSuccess()) {
                	req.setAttribute("WorkData" , WorkData ); // 나중에
                } else {
                	Logger.debug.println(this, "실근무시간 조회 에러!!");
                }

                if(rfcaf.getReturn().isSuccess()) {
                	req.setAttribute("AfterData" , AfterData ); // 나중에
                } else {
                	Logger.debug.println(this, "AF 실근무시간 조회 에러!!");
                }


                req.setAttribute("EMPGUB"		, EMPGUB);
                req.setAttribute("TPGUB"		, TPGUB);
	            req.setAttribute("DATUM"		, DATE);

                dest = WebUtil.JspURL+"D/D01OT/D01OTAfterWorkDetail.jsp";

            /**************    jobid : delete       **********************************************************/
            } else if( jobid.equals("delete") ) {

                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	rfc.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = rfc.delete( ainf_seqn, firstData.PERNR );

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

            /**************    jobid : Else       **********************************************************/
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
    }

    /**
     * RFC 실행 결과로 얻어온 data에서 EXPORT 또는 TABLES data를 추출하여 반환
     *
     * @param rfcResultData
     * @param target
     * @param message
     * @return
     * @throws GeneralException
     */
    private Map<String, Object> getData(Map<String, Object> rfcResultData, String target, String message) throws GeneralException {

        if (!RfcDataHandler.isSuccess(rfcResultData)) {
            throw new GeneralException(message);
        }

        return (Map<String, Object>) rfcResultData.get(target);
   }

}