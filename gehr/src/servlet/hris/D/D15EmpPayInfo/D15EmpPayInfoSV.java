/*
 * @(#)D13ScheduleChangeSV.java    2009. 03. 20
 *
 * Copyright 2007 Hyundai Marine, Inc. All rights reserved
 * Hyundai Marine PROPRIETARY/CONFIDENTIAL
 */
package servlet.hris.D.D15EmpPayInfo;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D12Rotation.D12RotationSearchData;
import hris.D.D12Rotation.rfc.SearchDeptNameRotDeptTimeRFC;
import hris.D.D15EmpPayInfo.D15EmpPayInfoData;
import hris.D.D15EmpPayInfo.D15EmpPayTypeData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayInfoRFC;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayTypeRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

/**
 * D15EmpPayInfoSV.java
 * ����������� ����
 *
 * @author ������   
 * @version 1.0, 2009/03/30
 */

public class D15EmpPayInfoSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		
		try{
			WebUserData user = WebUtil.getSessionUser(req);
			
			String dest = "";//����θ�
			
			Box box = WebUtil.getBox(req);
            String jobid   = box.get("jobid", "search");
            String I_DATE   = box.get("I_DATE", DataUtil.getCurrentDate());

            String searchType   = box.get("I_GBN", "ORGEH");
            String searchData   = box.get("I_SEARCHDATA", user.e_orgeh);


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
	        /*Logger.debug(sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin);
	        if(sMenuCode.equals("1405")){                            //�����λ����� > ��û > �μ�����
		       if (!user.e_timeadmin.equals("Y")) {
	                String msg = "msg015";
	                req.setAttribute("msg", msg);
	                dest = WebUtil.JspURL+"common/caution.jsp";
	                printJspPage(req, res, dest);
				   return;
	            }
	        }else{*/
	//	      @����༺ �߰�
			if ( user.e_authorization.equals("E")) {
				if(!user.e_timeadmin.equals("Y")){  //���� ������ �켱
					Logger.debug.println(this, "E Authorization!!");
					String msg = "msg015";
					req.setAttribute("msg", msg);
					dest = WebUtil.JspURL+"common/caution.jsp";
					printJspPage(req, res, dest);
					return;
				}
			}
//	        }
            
            if( jobid.equals("search") ) {

				String deptNm   = box.get("txt_deptNm");
				String i_orgeh   = box.get("I_ORGEH");
				searchType = "RECENT".equals(searchType) ? "RECENT" : "ORGEH";
				if(searchType.equals("ORGEH")||searchType.equals("RECENT")){
					i_orgeh = searchData;
				}

				if (!deptNm.equals("")&&!i_orgeh.equals("")){
					//�ֱٰ˻�������� ������
					D12RotationSearchData d12SearchData = new D12RotationSearchData();
					SearchDeptNameRotDeptTimeRFC func = null;
					Vector DeptName_vt  = null;
					Vector search_vt    = new Vector();

					func       		= new SearchDeptNameRotDeptTimeRFC();
					DeptName_vt  	= new Vector();

					d12SearchData.SPERNR = user.empNo  ;    //��� ��ȣ
					d12SearchData.OBJID = i_orgeh  ;    //������Ʈ ID
					d12SearchData.STEXT =deptNm  ;    //������Ʈ �̸�
					d12SearchData.EPERNR =user.empNo  ;    //��� ��ȣ
					d12SearchData.ENAME = ""  ;    //�����
					d12SearchData.OBJTXT = deptNm  ;     //��� �Ǵ� �������� ���˵� �̸�
					search_vt.addElement(d12SearchData);
					Vector Searchret 		= func.setDept(user.empNo, "","",search_vt); //���� Set!!!
					Logger.debug.println("\n===SAVE=====search_vt "+search_vt.toString() );
					//�ֱٰ˻����
				}

            	D15EmpPayInfoRFC empPayInfoRfc = new D15EmpPayInfoRFC();

				Vector<D15EmpPayInfoData> payList = empPayInfoRfc.getPayList(I_DATE, searchData, searchType);
				RFCReturnEntity rfcReturn = empPayInfoRfc.getReturn();

				if(rfcReturn.isSuccess()) {
					Vector<D15EmpPayInfoData> saveList = empPayInfoRfc.getSaveList(I_DATE, searchData, searchType);

					D15EmpPayTypeRFC empPayTypeRfc = new D15EmpPayTypeRFC();

					Map<String, Vector<D15EmpPayTypeData>> payTypeMap = new HashMap();
					for(D15EmpPayInfoData row : payList) {
						Vector<D15EmpPayTypeData> payType = empPayTypeRfc.getEmpPayType(I_DATE, row.PERNR);
						payTypeMap.put(row.PERNR, payType) ;
					}

					req.setAttribute("payList", payList);
					req.setAttribute("saveList", saveList);
					req.setAttribute("payTypeMap", payTypeMap);
					/*req.setAttribute("deptNm", deptNm);*/


					req.setAttribute("I_DATE", I_DATE);
					req.setAttribute("I_GBN", searchType);
					req.setAttribute("I_SEARCHDATA", searchData);

					printJspPage(req, res, WebUtil.JspURL + "D/D15EmpPayInfo/D15EmpPayInfo.jsp");
				} else {
					moveCautionPage(req, res, rfcReturn.getMessage(), null);
				}


            }else if(jobid.equals("save")){
				Vector<D15EmpPayInfoData> saveList = box.getVector(D15EmpPayInfoData.class);
				/*for(D15EmpPayInfoData row : saveList) {
					if(StringUtils.isNotEmpty(row.BETRG)) row.BETRG = DataUtil.changeGlobalAmount(row.BETRG, "KRW");
				}*/
				Logger.debug("============ " + box.createEntity(D15EmpPayInfoData.class));

            	D15EmpPayInfoRFC empPayInfoRfc = new D15EmpPayInfoRFC();
				RFCReturnEntity rfcReturn = empPayInfoRfc.saveEmpPayInfo(I_DATE, searchData, saveList, searchType);

				if(rfcReturn.isSuccess()) {
					moveMsgPage(req, res, "msg008",
							"location.href = '" + WebUtil.ServletURL+"hris.D.D15EmpPayInfo.D15EmpPayInfoSV?I_DATE="+I_DATE+"&I_GBN="+searchType+ "&I_SEARCHDATA="+searchData+"';");
            	} else {
					moveMsgPage(req, res, rfcReturn.getMessage(), "history.back(); ");
            	}
            	
            }else if(jobid.equals("del")){

				String[] deleteCheck = req.getParameterValues("deleteCheck");

				Vector<D15EmpPayInfoData> deleteList = new Vector<D15EmpPayInfoData>();
				if(deleteCheck != null) {
					for(String index : deleteCheck) {
						D15EmpPayInfoData data = new D15EmpPayInfoData();

						data.PERNR = box.get("PERNR_" + index);
						data.ENAME = box.get("ENAME_" + index);
						data.BEGDA = box.get("BEGDA_" + index);
						data.LGART = box.get("LGART_" + index);
						data.ANZHL = box.get("ANZHL_" + index);
						data.BETRG = box.get("BETRG_" + index);

						deleteList.add(data);
					}
				}

				D15EmpPayInfoRFC empPayInfoRfc = new D15EmpPayInfoRFC();
				RFCReturnEntity rfcReturn = empPayInfoRfc.deleteEmpPayInfo(deleteList);

				if(rfcReturn.isSuccess()) {
					moveMsgPage(req, res, "msg003",
							"location.href = '" + WebUtil.ServletURL+"hris.D.D15EmpPayInfo.D15EmpPayInfoSV?I_DATE="+I_DATE+"&I_GBN="+searchType+ "&I_SEARCHDATA="+searchData+"';");
				} else {
					moveMsgPage(req, res, rfcReturn.getMessage(), "history.back(); ");
				}

            }else{
            	throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            
		}catch(Exception e) {
            throw new GeneralException(e);
        }

	}

}
