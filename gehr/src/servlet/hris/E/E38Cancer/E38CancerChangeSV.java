/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ϰ���                                                    */
/*   Program Name : �ϰ��� ����                                               */
/*   Program ID   : E38CancerChangeSV                                          */
/*   Description  : �ϰ��� ��û�� ������ �� �ֵ��� �ϴ� Class                 */
/*   Note         :                                                             */
/*   Creation     : 2013-06-21  lsa  C20130620_53407                 */
/*   Update       :                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E38Cancer;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A16Appl.A16ApplListData;
import hris.A.A16Appl.A16ApplListKey;
import hris.A.A16Appl.rfc.A16ApplListRFC;
import hris.E.E38Cancer.E38CancerData;
import hris.E.E38Cancer.E38CancerFlagData;
import hris.E.E38Cancer.rfc.E38CancerHospCodeRFC;
import hris.E.E38Cancer.rfc.E38CancerListRFC;
import hris.E.E38Cancer.rfc.E38CancerSeltCodeRFC;
import hris.E.E38Cancer.rfc.E38CancerSexyFlagRFC;
import hris.E.E38Cancer.rfc.E38CancerStmcCodeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.Vector;

public class E38CancerChangeSV extends ApprovalBaseServlet {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private String UPMU_TYPE ="39";     // ���� ����Ÿ��(�ϰ���)
	private String UPMU_NAME = "�߰��ϰ���(7����)";
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
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //��û����� ���

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
			String AINF_SEQN = box.get("AINF_SEQN");

            E38CancerListRFC  e38Rfc = new E38CancerListRFC();
            e38Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            Vector  E38Cancer_vt = e38Rfc.getGeneralList( PERNR, AINF_SEQN );
            E38CancerData E38CancerData = (E38CancerData)E38Cancer_vt.get(0);

           // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(E38CancerData.PERNR);

            if( jobid.equals("first") ) {    //����ó�� ���� ȭ�鿡 ���°��.

                String year       = DataUtil.getCurrentYear();
                Vector general_vt = new Vector();

                E38CancerFlagData flagdata = new E38CancerFlagData();
                E38CancerSexyFlagRFC     func2    = new E38CancerSexyFlagRFC();
                E38CancerData     gdata    = (E38CancerData)func2.getSexyFlag(E38CancerData.PERNR, year);

                A16ApplListRFC      func1   = new A16ApplListRFC();
                A16ApplListKey      key     = new A16ApplListKey();

                key.I_BEGDA     = DataUtil.getCurrentYear()+"0101";
                key.I_ENDDA     = DataUtil.getCurrentYear()+"1231";
                key.I_PERNR     = E38CancerData.PERNR;
                key.I_STAT_TYPE = "";
                key.I_UPMU_TYPE = "39";

                Vector appl_vt = func1.getAppList(key);

                if( appl_vt.size() > 0 ) {
                    appl_vt = SortUtil.sort( appl_vt, "BEGDA", "asc" );    // ���� �������� ������ üũ�ϱ����ؼ� Sort ��

                    for( int i = 0 ; i < appl_vt.size() ; i++ ) {
                        A16ApplListData adata = (A16ApplListData)appl_vt.get(i);
                        if( !AINF_SEQN.equals(adata.AINF_SEQN) ) {
                            general_vt = e38Rfc.getGeneralListAinf( E38CancerData.PERNR, adata.AINF_SEQN,user.empNo );
                        }
                    }
                    for( int j = 0 ; j < general_vt.size() ; j++ ) {
                        E38CancerData edata = (E38CancerData)general_vt.get(j);

                        // 2002.11.11. Ȯ������ ���� ���簡 �Ϸ�Ȱ�� ���û �����ϴ�.
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

                Logger.debug.println(this, "E38Cancer_vt : " + E38Cancer_vt.toString());

                Vector E38CancerHospCodeData_opt  = (new E38CancerHospCodeRFC()).getHospCode(E38CancerData.PERNR);
            	Vector E38CancerStmcData_opt  = (new E38CancerStmcCodeRFC()).getStmcCode(E38CancerData.PERNR, E38CancerData.HOSP_CODE);
            	Vector E38CancerSeltData_opt  = (new E38CancerSeltCodeRFC()).getSeltCode(E38CancerData.PERNR, E38CancerData.HOSP_CODE);

            	req.setAttribute("isUpdate", true); //��� ���� ����
                //req.setAttribute("E38Cancer_vt", E38Cancer_vt);
                req.setAttribute("resultData", E38CancerData);

                req.setAttribute("PERNR", E38CancerData.PERNR);
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("E38CancerFlagData", flagdata);
                req.setAttribute("E38CancerData", gdata);

                req.setAttribute("E38CancerHospCodeData_opt", E38CancerHospCodeData_opt);
                req.setAttribute("E38CancerStmcData_opt", E38CancerStmcData_opt);
                req.setAttribute("E38CancerSeltData_opt", E38CancerSeltData_opt);

                detailApporval(req, res, e38Rfc);
                printJspPage(req, res, WebUtil.JspURL + "E/E38Cancer/E38CancerChange.jsp");


            } else if( jobid.equals("change") ) {

            	/* ���� ��û �κ� */
				dest = changeApproval(req, box, E38CancerData.class, e38Rfc, new ChangeFunction<E38CancerData>(){

					public String porcess(E38CancerData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						inputData.PERNR  = inputData.PERNR;
        				inputData.ZPERNR = inputData.ZPERNR;    // ��û�� ���(�븮��û, ���� ��û)
        				inputData.UNAME  = user.empNo;          // ������ ���(�븮��û, ���� ��û)
    	                inputData.AEDTM  = DataUtil.getCurrentDate();  // ������(���糯¥)

                    	box.put("I_GTYPE", "3");

                    	/* ���� ��û RFC ȣ�� */
                    	E38CancerListRFC changeRFC = new E38CancerListRFC();
                		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);
                        //e15Rfc.change( PERNR, ainf_seqn, General_vt );

                    	//Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn().isSuccess() );
                        //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn() );

                        if(!changeRFC.getReturn().isSuccess()) {
                        	 throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }
                        return inputData.AINF_SEQN;

                        /* ������ �ۼ� �κ� �� */
                    }
                });

				 printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
