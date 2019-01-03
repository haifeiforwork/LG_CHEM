/********************************************************************************/
/*                                                                              																*/
/*   System Name  	: MSS                                                         													*/
/*   1Depth Name  	: MY HR ����                                                  															*/
/*   2Depth Name  	: �ʰ��ٹ� ���Ľ�û                                           															*/
/*   Program Name 	: �ʰ��ٹ� ���Ľ�û ��ȸ                                      														*/
/*   Program ID   		: D01OTAfterWorkDetailSV                                      											*/
/*   Description  		: �ʰ��ٹ� ��ȸ �� ������ �� �� �ֵ��� �ϴ� Class             											*/
/*   Note         		:                                                             														*/
/*   Creation     		: 2018-06-12  ������                                          														*/
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

    private String UPMU_NAME = "�ʰ��ٹ� ���Ľ�û";

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
            /**************    Start: ������ �б�ó��       **********************************************************/
	        	if (! user.area.equals(Area.KR)){ 	// �ؿ�ȭ������
	        		printJspPage( req,res, WebUtil.ServletURL+"hris.D.D01OT.D01OTDetailGlobalSV");
	        		return;
	        	}
	        /**************    END: ������ �б�ó��         **********************************************************/

            String dest  = "";
            String jobid = "";

            Box box 	= WebUtil.getBox(req);
            jobid 		= box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            //final D01OTRFC  rfc       = new D01OTRFC();
            final D01OTAFRFC  rfc       = new D01OTAFRFC();

            Vector   D01OTData_vt  = null;
            final String   ainf_seqn   = box.get("AINF_SEQN");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn);
            D01OTData_vt = rfc.getDetail( ainf_seqn, "" );

            final D01OTData firstData = (D01OTData)Utils.indexOf(D01OTData_vt,0);

            // �븮 ��û �߰�
            if(firstData!=null){

            	// ���� : 2018.05.17 [WorkTime52] ������ - �Ǳٹ��ð� ��Ȳǥ �߰�
                try {
                    /**
                     * �Ǳٹ��ð� ��Ȳǥ �߰�����
                     *     S(�繫�� ��Ȳǥ �߰�)
                     *     H(������ ��Ȳǥ �߰�)
                     *     -(���� �ʰ��ٹ� ��Ȳǥ ����)
                     *     X(�ش� ����)
                     *
                     * -------------------------------------------------------------------------
                     *           ���� ����          | ������ ���� | ������ ���� | ����Ϸ� ����
                     *                              | I_APGUB = 1 | I_APGUB = 2 | I_APGUB = 3
                     * -------------------------------------------------------------------------
                     *         | �繫��(S) | ��û�� |  X          |  S          |  S
                     *         |-----------|        |-------------------------------------------
                     *  ��û�� | ������(H) |  ȭ��  |  X          |  -          |  -
                     *   ���  |----------------------------------------------------------------
                     *   ����  | �繫��(S) | ������ |  S          |  S          |  S
                     *         |-----------|        |-------------------------------------------
                     *         | ������(H) |  ȭ��  |  H          |  H          |  H
                     * -------------------------------------------------------------------------
                     *
                     * ������ ���忡���� ��� ���� ȭ�鿡 ��Ȳǥ �߰�
                     * ��û�� ���忡���� �������̰ų� ����Ϸ�� ���� ȭ�鿡 ��Ȳǥ �߰�
                     */
                    if (!"1".equals(I_APGUB) || !user.empNo.equals(firstData.PERNR)) {
                        final String WORK_DATE = StringUtils.defaultString(firstData.WORK_DATE).replaceAll("[^\\d]", "");
                        final String I_DATUM = "X".equals(firstData.VTKEN) ? DataUtil.addDays(WORK_DATE, -1, "yyyyMMdd") : WORK_DATE;

                        // ��û�� ��� ���� ��ȸ : S(�繫��) or H(������)
                        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                            {
                                put("I_PERNR", firstData.PERNR);
                                put("I_DATUM", I_DATUM);
                            }
                        });

                        Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063"));
                        final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB")); // �Ǳٹ��ð� ��Ȳ ��ȸ�� �ʿ��� ��� ����(�繫�� or ������) �����͸� ��ȸ���� ���Ͽ����ϴ�.
                        req.setAttribute("EMPGUB", EMPGUB);
                        req.setAttribute("TPGUB", EXPORT.get("E_TPGUB"));
                        req.setAttribute("MM", Integer.parseInt(DataUtil.getCurrentMonth()));

                        if ("S".equals(EMPGUB) || ("H".equals(EMPGUB) && !user.empNo.equals(firstData.PERNR))) {
                            // ��û�� �Ǳٹ��ð� ��Ȳ ��ȸ
                            rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                {
                                    put("I_EMPGUB", EMPGUB);
                                    put("I_PERNR", firstData.PERNR);
                                    put("I_DATUM", WORK_DATE);
                                    if ("H".equals(EMPGUB)) put("I_VTKEN", firstData.VTKEN);
                                }
                            });

                            WebUtil.setAttributes(req, (Map<String, Object>) getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0064")).get("ES_EMPGUB_" + EMPGUB)); // �Ǳٹ��ð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.
                        }

                    }

                } catch (Exception e) {
                    req.setAttribute("msg", e.getMessage());
                    req.setAttribute("url", "history.back()");

                    printJspPage(req, res, WebUtil.JspURL + "common/msg.jsp");
                    return;
                }
                // ���� : 2018.05.17 [WorkTime52] ������ - �Ǳٹ��ð� ��Ȳǥ �߰�




	            PersonInfoRFC numfunc = new PersonInfoRFC();
	            PersonData phonenumdata;
	            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
	            req.setAttribute("PersonData" , phonenumdata );
            }
            //-----------------------------------------------------------------------------------------------------------------------------
            final	String PERNR	= firstData.PERNR;
            // ��� ���� ��ȸ(�繫��:S / ������:H) => [���� :2018-06-07 : A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)
            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                {
                    put("I_PERNR" , PERNR);
                }
            });
            final String EMPGUB 	= ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB")); 	//(�繫��:S / ������:H)
            final String TPGUB 	= ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		//A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)

            String GTYPE	= "1";	//ó������( 1 =�� , 2 =�����Ƿ�, 3 =����, 4 = ���� )
            String MODE 	= "";
            String DATE		= firstData.WORK_DATE;
            String VTKEN	= firstData.VTKEN;
            String curdate = DataUtil.getCurrentDate();
            //-----------------------------------------------------------------------------------------------------------------------------
            /**************    jobid : first       **********************************************************/
            if( jobid.equals("first") ) {

                req.setAttribute("D01OTData_vt", D01OTData_vt);

                if (!detailApporval(req, res, rfc))                    return;


                // �Ǳٹ��ð� ��ȸ[info Table]
                D01OTRealWrokListRFC	realworkfunc	= new D01OTRealWrokListRFC();
                D01OTAfterWorkTimeListRFC rfcaf	= new D01OTAfterWorkTimeListRFC();

                final D01OTRealWorkDATA WorkData 		= realworkfunc.getResult(EMPGUB, PERNR, DATE, VTKEN, ainf_seqn, "");
                final D01OTAfterWorkTimeDATA AfterData 	= rfcaf.getResult(GTYPE, PERNR, DATE, VTKEN, ainf_seqn, curdate, "");

                if(realworkfunc.getReturn().isSuccess()) {
                	req.setAttribute("WorkData" , WorkData ); // ���߿�
                } else {
                	Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                }

                if(rfcaf.getReturn().isSuccess()) {
                	req.setAttribute("AfterData" , AfterData ); // ���߿�
                } else {
                	Logger.debug.println(this, "AF �Ǳٹ��ð� ��ȸ ����!!");
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
     * RFC ���� ����� ���� data���� EXPORT �Ǵ� TABLES data�� �����Ͽ� ��ȯ
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