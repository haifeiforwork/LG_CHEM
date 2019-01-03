package  servlet.hris.D.D12Rotation;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.D.D12Rotation.D12RotationBuild2Data;
import hris.D.D12Rotation.D12RotationBuildData;
import hris.D.D12Rotation.D12RotationSearchData;
import hris.D.D12Rotation.D12ZHRA003TData;
import hris.D.D12Rotation.D12ZHRA112TData;
import hris.D.D12Rotation.rfc.D12DayOffReqRFC;
import hris.D.D12Rotation.rfc.D12RotationBuildRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotDeptTimeRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * D12RotationBuildSV.java
 * �μ��������°��� ��û Class
 *
 * @author ������
 * @version 1.0, 2009/02/24
 * @version 1.0, 2013/12/03 ���Ϲ߼ۿ������� CSR ID:9992
 */

public class D12RotationBuildSV extends ApprovalBaseServlet {
	private static String UPMU_TYPE ="36";   // ���� ����Ÿ��(����)
    private static String UPMU_NAME = "�μ�����";

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

            String dest    = "";

            final Box box = WebUtil.getBox(req);

            String t_year = box.get("t_year");
            String t_month = box.get("t_month");

            String i_from = box.get("S_DATE");
            String i_to = box.get("E_DATE");
            String i_orgeh = box.get("hdn_deptId");
            String i_orgeh_nm = box.get("hdn_deptNm");
            String i_pernr = "";

            String i_gbn = box.get("I_GBN","ORGEH");
            String i_searchdata   = box.get("I_SEARCHDATA");
            String txt_searchNm = box.get("txt_searchNm");


            if(i_gbn.equals("ORGEH")){
            	i_orgeh = i_searchdata;
            }else if(i_gbn.equals("PERNR")){
            	i_pernr = i_searchdata;
            }

            if(txt_searchNm == null){
            	txt_searchNm = "";
            }

            if (i_pernr == null || i_pernr.equals("")) {
            	i_pernr = user.empNo;
            }

	        /*************************************************************
	         * @$ ���������� marco257
	         * ���ǿ� �ִ� e_timeadmin = Y �� ����� �μ� ���� ������ ����.
	         * user.e_authorization.equals("E") ���� !user.e_timeadmin.equals("Y")�� ����
	         *
	         * @ sMenuCode �ڵ� �߰�
	         * �μ����� ������ �ִ� ����� MSS������ �ִ� ����� üũ�ϱ� ���� �߰�
	         * 1406 : �μ����� ������ �ִ� �޴��ڵ�(e_timeadmin ���� üũ)
	         * 1184 : �μ��λ������� -> ������� -> ���� -> �������� ����ǥ�� ������ �ִ»��
	         * �߰�: �޴� �ڵ尡 ������� ���� ������ �켱�Ѵ�.
	         *  (e_timeadmin ���� üũ���� )
	         **************************************************************/

	        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));

	        Logger.debug(sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin);

        	if(!checkTimeAuthorization(req, res)) return;

            String jobid   = box.get("jobid","first");

            //�������ڰ� ������� �������ڸ� default���Ѵ�.
            if( t_year == null || t_year.equals("") ) {
            	t_year = DataUtil.getCurrentDate().substring(0, 4);
            }
            if( t_month == null || t_month.equals("") ) {
            	t_month = DataUtil.getCurrentDate().substring(4, 6);
            }
            String i_month = t_year+t_month;

            //��ȸ�Ⱓ�� ������� �������ڸ� default�� �Ѵ�
            if(i_from == null || i_from.equals("")){
            	i_from = DataUtil.getCurrentDate();
            }
            if(i_to == null || i_to.equals("")){
            	i_to = DataUtil.getCurrentDate();
            }

            if( i_orgeh == null || i_orgeh.equals("") ) {
            	i_orgeh = user.e_orgeh;
            }

            D12RotationBuildRFC     rfcRotataionBuild    = new D12RotationBuildRFC();

            Vector main_vt1 = new Vector();
            Vector main_vt2 = new Vector();
            Vector main_vt3 = new Vector();
            Vector ret = new Vector();

            final D12ZHRA112TData d12ZHRA112TData  = new D12ZHRA112TData();
        	Utils.setFieldValue(d12ZHRA112TData, "FROMDA", i_from) ;  //���ο�û ������
        	Utils.setFieldValue(d12ZHRA112TData, "MANDT", user.clientNo) ;  //Ŭ���̾�Ʈ
        	Utils.setFieldValue(d12ZHRA112TData, "ORGEH", i_orgeh) ;  //���� ����
        	Utils.setFieldValue(d12ZHRA112TData, "TODA", i_to) ; //���ο�û ������

            int rowcount = box.getInt("RowCount");


            if( jobid.equals("first") || jobid.equals("print")) {                 //����ó�� ���� ȭ�鿡 ���°��.
            	//��ٰ����� ���� ����Ʈ�� �о� ��ü ��� ����Ʈ�� jsp�� �����Ѵ�.

                String PERNR = getPERNR(box, user); //��û����� ���

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

            	if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
            		ret = rfcRotataionBuild.getDetailForOrgeh(i_month, i_orgeh);
            	}else if(i_gbn.equals("PERNR")){
            		ret = rfcRotataionBuild.getDetailForPernr(i_month, i_pernr);
            	}

                main_vt1 = (Vector)ret.get(0);
                main_vt2 = (Vector)ret.get(1);
                main_vt3 = (Vector)ret.get(2);
                String E_RETURN    = (String)ret.get(3);
                String E_MESSAGE = (String)ret.get(4);
                String E_STEXT = (String)ret.get(8);


                if ( !E_RETURN.equals("E") ) {

                	//�ֱٰ˻�������� ������
                	D12RotationSearchData d12SearchData = new D12RotationSearchData();
                	SearchDeptNameRotDeptTimeRFC func = null;
        	        Vector DeptName_vt  = null;
                    Vector search_vt    = new Vector();

    	        	func       		= new SearchDeptNameRotDeptTimeRFC();
    	        	DeptName_vt  	= new Vector();

    	            d12SearchData.SPERNR =  user.empNo  ;    //��� ��ȣ
    	            d12SearchData.OBJID = i_orgeh  ;    //������Ʈ ID
    	            d12SearchData.STEXT =E_STEXT  ;    //������Ʈ �̸�
    	            d12SearchData.EPERNR = i_pernr  ;    //��� ��ȣ
    	            d12SearchData.ENAME = ""  ;    //����ID
    	            d12SearchData.OBJTXT = E_STEXT  ;     //��� �Ǵ� �������� ���˵� �̸�
    	            search_vt.addElement(d12SearchData);
    	            Vector Searchret 		= func.setDept(user.empNo, "","",search_vt); //���� Set!!!
    	            //�ֱٰ˻����

                    Vector main_vt3_temp = new Vector();
                    for(int i=0; i<main_vt3.size(); i++){
                    	D12RotationBuild2Data dataStat = (D12RotationBuild2Data)main_vt3.get(i);
                    	dataStat.APPR_STAT_CHK = "true";
                    	for(int j=0; j<main_vt2.size(); j++){
                    		D12RotationBuildData dataResult = (D12RotationBuildData)main_vt2.get(j);
                    		if(dataResult.BEGDA.equals(dataStat.BEGDA)){
                    			if(dataStat.APPR_STAT.equals("A")&&!dataResult.APPR_STAT.equals("A")){
                    				dataStat.APPR_STAT_CHK = "false";
                		    	}
                    		}
                    	}
                    	main_vt3_temp.addElement(dataStat);
                    }
                    main_vt3 = main_vt3_temp;

	                req.setAttribute("jobid",            jobid);
	                req.setAttribute("hdn_deptId",   i_orgeh);
	                req.setAttribute("hdn_deptNm",   i_orgeh_nm);
	                req.setAttribute("txt_searchNm",   txt_searchNm);
	                req.setAttribute("E_STEXT",   E_STEXT);
	                req.setAttribute("t_year",        t_year);
	                req.setAttribute("t_month",        t_month);
	                req.setAttribute("main_vt1",       main_vt1);
	                req.setAttribute("main_vt2",       main_vt2);
	                req.setAttribute("main_vt3",       main_vt3);
	                req.setAttribute("rowCount"  ,   Integer.toString(main_vt1.size())   );
	                req.setAttribute("I_SEARCHDATA"  ,   i_searchdata   );

	                if(jobid.equals("first")){
	                	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationBuild.jsp?I_SEARCHDATA="+i_searchdata;
	                }else{
	                	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationBuild_print.jsp?I_SEARCHDATA="+i_searchdata;
	                }
                } else {
                    String msg = E_MESSAGE;
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D12Rotation.D12RotationBuildSV?hdn_deptId="+i_orgeh+"&hdn_deptNm="+i_orgeh_nm+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }

            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, D12ZHRA112TData.class, new RequestFunction<D12ZHRA112TData>() {
                    public String porcess(D12ZHRA112TData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                    	D12RotationBuildRFC d12RotationBuildRFC = new D12RotationBuildRFC();
                    	d12RotationBuildRFC.setRequestInput(user.empNo, UPMU_TYPE);

                    	inputData = d12ZHRA112TData;

                        String AINF_SEQN = d12RotationBuildRFC.build(inputData, box, req);
                        if(!d12RotationBuildRFC.getReturn().isSuccess()) {
                            throw new GeneralException(d12RotationBuildRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
