/********************************************************************************/
/*   System Name   : e-HR                                                                                                                         */
/*   1Depth Name   : HR ������                                                                                                                */
/*   2Depth Name   : ���� �Ϸ� ����                                                                                                        */
/*   Program Name : ��� ���� ��û                                                                                                        */
/*   Program ID      : G065ApprovalFinishCareerSV                                                                                       */
/*   Description       : ��� ���� ��û ���� �Ϸ�                                                                                       */
/*   Note                : ����                                                                                                                         */
/*   Creation          : 2006-04-17  ��뿵                                                                                                   */
/*   Update       :                                                                                                                                       */
/*                                                                                                                                                            */
/********************************************************************************/

package servlet.hris.G;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D12Rotation.D12RotationBuild2Data;
import hris.D.D12Rotation.D12RotationBuildData;
import hris.D.D12Rotation.rfc.D12AINFInfoRFC;
import hris.D.D12Rotation.rfc.D12RotationBuildRFC;
import hris.common.PersInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class G067ApprovalFinishRotationSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	
        
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest         = "";
            String jobid        = "";
            String deptNm		= "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "search";
            }
            deptNm = box.get("hdn_deptNm");
            if(deptNm.equals("")){
            	deptNm = user.e_orgtx;
            }
            
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            
            String          AINF_SEQN           = box.get("AINF_SEQN");
            D12RotationBuildRFC     rfc    = new D12RotationBuildRFC();
            
            
            Vector main_vt1 = new Vector();
            Vector main_vt2 = new Vector();
            Vector main_vt3 = new Vector();
            Vector ret = new Vector();
            

            
            PersonInfoRFC numfunc         = new PersonInfoRFC();
            PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(user.empNo, "X");
            
            req.setAttribute("PersonData" , phonenumdata );

            //���� ���ư� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            //**********���� ��.****************************
//          ���� ��û�� ����
            D12AINFInfoRFC ainf_info_rfc = new D12AINFInfoRFC();
            Vector ainf_info_vc = ainf_info_rfc.getAINFInfo(AINF_SEQN);
            Vector ainf_vc = (Vector) ainf_info_vc.get(0);
            D12RotationBuild2Data ainf_info  = (D12RotationBuild2Data)ainf_vc.get(0);
            
            if( jobid.equals("search") ) {
            	PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                PersInfoData        pid     = (PersInfoData) piRfc.getApproval(ainf_info.PERNR).get(0);
                req.setAttribute("PersInfoData" ,pid );//��û�� ����
            	
            	ret = rfc.getDetail(AINF_SEQN);
                
                main_vt1 = (Vector)ret.get(0);
                main_vt2 = (Vector)ret.get(1);
                main_vt3 = (Vector)ret.get(2);
                String E_RETURN    = (String)ret.get(3);
                String E_MESSAGE = (String)ret.get(4);
                String E_FROMDA    = (String)ret.get(5);
                String E_TODA = (String)ret.get(6);
                String E_ORGEH    = (String)ret.get(7);
                String E_STEXT = (String)ret.get(8);
                String E_BIGO = (String)ret.get(9);
                
                //�����ڸ���Ʈ
                Vector AppLineData_vt = AppUtil.getAppDetailVt(AINF_SEQN);
                if ( E_RETURN.equals("") ) {
	                
                    Logger.debug.println(this, "first====main_vt1 : " + main_vt1.toString() );
                    Logger.debug.println(this, "first====main_vt2 : " + main_vt2.toString() );
                    Logger.debug.println(this, "first====main_vt3 : " + main_vt3.toString() );
	                
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
	                req.setAttribute("deptNm", deptNm);
	                req.setAttribute("AppLineData_vt", AppLineData_vt);
	                req.setAttribute("main_vt1",       main_vt1);
	                req.setAttribute("main_vt2",       main_vt2);
	                req.setAttribute("main_vt3",       main_vt3);
	                req.setAttribute("AINF_SEQN",       AINF_SEQN);
	                req.setAttribute("E_FROMDA",       E_FROMDA); //���ο�û ������
	                req.setAttribute("E_TODA",       E_TODA); //���ο�û ������
	                req.setAttribute("E_ORGEH",       E_ORGEH);//��û�� �μ��ڵ�
	                req.setAttribute("E_STEXT",       E_STEXT);//��û�� �μ���
	                req.setAttribute("E_BIGO",       E_BIGO);//����
	                req.setAttribute("rowCount"  ,   Integer.toString(main_vt1.size())   ); 
	                
	                dest = WebUtil.JspURL+"G/G067ApprovalFinishRotation.jsp";
                } else { 
                    String msg = E_MESSAGE;
                    req.setAttribute("msg", msg); 
                    dest = WebUtil.JspURL+"common/msg.jsp";              
                }
            } 
            /*
            else if( jobid.equals("print_certi") ) {               //��â���(��������)
                 
                req.setAttribute("print_page_name", WebUtil.ServletURL+"hris.G.G065ApprovalFinishCareerSV?AINF_SEQN="+AINF_SEQN+"&jobid=print_certi_print&PRINT_GUBUN="+PRINT_GUBUN);
                dest = WebUtil.JspURL+"common/printFrame_Acerti.jsp";

            } else if( jobid.equals("print_certi_print") ) {

                A19CareerRFC func = new A19CareerRFC();
                              
                A15CertiPrintRFC rfc_print = new A15CertiPrintRFC();
                
                vcA19CareerData = func.getDetail( user.empNo, AINF_SEQN);

                Logger.debug.println(this,"dddd:"+ vcA19CareerData);
                a19CareerData      = (A19CareerData)vcA19CareerData.get(0);
//              ����Ʈ�� 1ȸ�� ����� �����Ѵ�.
                func.updateFlag(a19CareerData.PERNR, AINF_SEQN);
// ����Ʈ�� 1ȸ�� ����� �����Ѵ�.
                Vector ret         = rfc_print.getDetail(a19CareerData.PERNR, AINF_SEQN,"2");
                
                Vector T_RESULT    = (Vector)ret.get(0);
                String E_JUSO_TEXT = (String)ret.get(1);
                String E_KR_REPRES = (String)ret.get(2);
                
                PersonData     phonenumdata;
                PersonInfoRFC		 numfunc			=	new PersonInfoRFC();
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(a19CareerData.PERNR);
               
                //�̵��߷� ��û�� ���� ��»��� 

                MappingPernrRFC  mapfunc = null ;
                MappingPernrData mapData = new MappingPernrData();
                Vector mapData_vt    = new Vector() ;
                Vector careerData_vt = new Vector() ;                
                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( a19CareerData.PERNR ) ;

                Vector             a09CareerDetailData_vt = new Vector();
                A09CareerDetailRFC func1                  = null;
                if ( mapData_vt != null && mapData_vt.size() > 0 ) {  // ���Ի��� ó��
                    A09CareerDetailData data = new A09CareerDetailData();

                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);

                        func1         = new A09CareerDetailRFC() ;
                        careerData_vt = func1.getCareerDetail( mapData.PERNR  ) ;

                        for( int j = 0 ; j < careerData_vt.size() ; j++ ) {
                            data = (A09CareerDetailData)careerData_vt.get(j);
                            a09CareerDetailData_vt.addElement(data);
                        }
                    }
                } else {
                    func1                  = new A09CareerDetailRFC();
                    a09CareerDetailData_vt = func1.getCareerDetail(a19CareerData.PERNR );
                }

                Logger.debug.println(this, "a09CareerDetailData_vt : "+ a09CareerDetailData_vt.toString());
                req.setAttribute("a09CareerDetailData_vt", a09CareerDetailData_vt);              
                //              �̵��߷� ��û�� ���� ��»��� 

                req.setAttribute("a19CareerData", a19CareerData);
                req.setAttribute("PersInfoData" ,phonenumdata );
                req.setAttribute("T_RESULT",    T_RESULT);
                req.setAttribute("E_JUSO_TEXT", E_JUSO_TEXT);
                req.setAttribute("E_KR_REPRES", E_KR_REPRES);


                if (PRINT_GUBUN.equals("2")) {
                    dest = WebUtil.JspURL+"A/A19Career/A19CareerPrintCareer02.jsp";
                } else {
                	dest = WebUtil.JspURL+"A/A19Career/A19CareerPrintCareer01.jsp";
                }
                
            } */
            else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if
            
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
            
        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {
            
        }
    }
}