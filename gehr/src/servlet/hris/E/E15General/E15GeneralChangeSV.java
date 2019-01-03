/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���հ���                                                    */
/*   Program Name : ���հ��� ����                                               */
/*   Program ID   : E15GeneralChangeSV                                          */
/*   Description  : ���հ��� ��û�� ������ �� �ֵ��� �ϴ� Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  ������                                          */
/*   Update       : 2005-02-16  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E15General;

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
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.rfc.PersonInfoRFC;
import hris.A.A16Appl.*;
import hris.A.A16Appl.rfc.*;
import hris.E.E15General.E15GeneralData;
import hris.E.E15General.E15GeneralFlagData;
import hris.E.E15General.rfc.*;

public class E15GeneralChangeSV extends ApprovalBaseServlet {

	private String UPMU_TYPE ="04";    // ���� ����Ÿ��(���հ���)
    private String UPMU_NAME = "���հ���";

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

            E15GeneralListRFC  e15Rfc      = new E15GeneralListRFC();
            e15Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            Vector  E15General_vt = e15Rfc.getGeneralList( PERNR, AINF_SEQN );

            E15GeneralData e15GeneralData = (E15GeneralData)E15General_vt.get(0);

           // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(e15GeneralData.PERNR);

            if( jobid.equals("first") ) {    //����ó�� ���� ȭ�鿡 ���°��.

                String year       = DataUtil.getCurrentYear();
                Vector general_vt = new Vector();

                E15GeneralFlagData flagdata = new E15GeneralFlagData();
                E15SexyFlagRFC     func2    = new E15SexyFlagRFC();
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
                    appl_vt = SortUtil.sort( appl_vt, "BEGDA", "asc" );    // ���� �������� ������ üũ�ϱ����ؼ� Sort ��

                    for( int i = 0 ; i < appl_vt.size() ; i++ ) {
                        A16ApplListData adata = (A16ApplListData)appl_vt.get(i);
                        if( !AINF_SEQN.equals(adata.AINF_SEQN) ) {
                            general_vt = e15Rfc.getGeneralListAinf( e15GeneralData.PERNR, adata.AINF_SEQN,user.empNo );
                            for( int j = 0 ; j < general_vt.size() ; j++ ) {
                                E15GeneralData edata = (E15GeneralData)general_vt.get(j);

                                //                          2002.11.11. Ȯ������ ���� ���簡 �Ϸ�Ȱ�� ���û �����ϴ�.
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
                    }
                }

                Logger.debug.println(this, "E15General_vt : " + E15General_vt.toString());

                Logger.debug.println(this, "flagdata : " + flagdata.toString());
                Logger.debug.println(this, "gdata : " + gdata.toString());

            	Vector E15HospCodeData_opt  = (new HospCodeRFC()).getHospCode(e15GeneralData.PERNR);
            	Vector getGuenCodeVt  = (new GuenCodeRFC()).getGuenCode();
            	Vector E15StmcData_opt  = (new E15StmcCodeRFC()).getStmcCode(e15GeneralData.PERNR, e15GeneralData.HOSP_CODE);
            	Vector E15SeltData_opt  = (new E15SeltCodeRFC()).getSeltCode(e15GeneralData.PERNR, e15GeneralData.HOSP_CODE);

            	SortUtil.sort_num(E15SeltData_opt,"GRUP_NUMB,HOSP_CODE", "asc");

                req.setAttribute("isUpdate", true); //��� ���� ����

                //req.setAttribute("E15General_vt", E15General_vt);
                req.setAttribute("resultData", e15GeneralData);

                req.setAttribute("PERNR", e15GeneralData.PERNR);
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("E15GeneralFlagData", flagdata);
                req.setAttribute("E15GeneralData", gdata);

                req.setAttribute("E15HospCodeData_opt",  E15HospCodeData_opt);
                req.setAttribute("E15StmcData_opt",  E15StmcData_opt);
                req.setAttribute("getGuenCodeVt",  getGuenCodeVt);
                req.setAttribute("E15SeltData_opt",  E15SeltData_opt);

                detailApporval(req, res, e15Rfc);

				printJspPage(req, res, WebUtil.JspURL + "E/E15General/E15GeneralChange.jsp");

            } else if( jobid.equals("change") ) {

            	/* ���� ��û �κ� */
				dest = changeApproval(req, box, E15GeneralData.class, e15Rfc, new ChangeFunction<E15GeneralData>(){

					public String porcess(E15GeneralData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						inputData.PERNR  = inputData.PERNR;
        				inputData.ZPERNR = inputData.ZPERNR;    // ��û�� ���(�븮��û, ���� ��û)
        				inputData.UNAME  = user.empNo;          // ������ ���(�븮��û, ���� ��û)
    	                inputData.AEDTM  = DataUtil.getCurrentDate();  // ������(���糯¥)

                    	box.put("I_GTYPE", "3");

                    	/* ���� ��û RFC ȣ�� */
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

                        /* ������ �ۼ� �κ� �� */
                    }
                });

				 printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            //Logger.debug.println(this, "destributed = " + dest);
           // printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }
}
