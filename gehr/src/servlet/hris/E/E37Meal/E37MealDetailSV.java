package  servlet.hris.E.E37Meal;
 
import hris.E.E37Meal.*;
import hris.E.E37Meal.rfc.*;
import hris.common.AppLineData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * E37MealBuildSV.java
 * �Ĵ� ��û Class
 *
 * @author LSA   
 * @version 1.0, 2009/11/25
 * 2018/07/25 rdcamel ������
 */

public class E37MealDetailSV extends EHRBaseServlet {
    private String UPMU_TYPE ="23";   // ���� ����Ÿ��(�Ĵ�)
    private String UPMU_NAME = "�Ĵ�";
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{            HttpSession session = req.getSession(false);

        WebUserData user = WebUtil.getSessionUser(req);
        
        String dest    = "";

        Box box = WebUtil.getBox(req);
        String jobid   = box.get("jobid");
        
        String t_year = box.get("t_year");
        String t_month = box.get("t_month");
                    
        String i_orgeh = box.get("hdn_deptId");
        String i_orgeh_nm = box.get("hdn_deptNm");
        
        String txt_searchNm = box.get("txt_searchNm");
        String I_APLY_FLAG = box.get("I_APLY_FLAG");
                    
        if(txt_searchNm == null){
        	txt_searchNm = "";
        }

        PersonInfoRFC numfunc = new PersonInfoRFC();
        PersonData phonenumdata;
        phonenumdata = (PersonData)numfunc.getPersonInfo( user.empNo);
        
        if( jobid.equals("") ){
            jobid = "first";
        }
        //�������ڰ� ������� �������ڸ� default���Ѵ�.
        if( t_year == null || t_year.equals("") ) {
        	t_year = DataUtil.getCurrentDate().substring(0, 4);
        }
        if( t_month == null || t_month.equals("") ) {
        	t_month = DataUtil.getCurrentDate().substring(4, 6);
        }
        String i_yyyymm = t_year+t_month;
                    
        if( i_orgeh == null || i_orgeh.equals("") ) {
        	i_orgeh = user.e_orgeh;
        }

        Logger.debug.println("------E37MealBuildSV i_orgeh: "+i_orgeh+"i_yyyymmL"+  i_yyyymm);
        E37MealRFC     rfcMeal    = new E37MealRFC();
        
        Vector meal_vt = new Vector();
        Vector mealAppr_vt = new Vector();
        Vector ret = new Vector();
        
        int rowcount = box.getInt("RowCount");
        Logger.debug.println("----");
       
        if( jobid.equals("first")  ) {                 //����ó�� ���� ȭ�鿡 ���°��. 
        	Logger.debug.println("----I_APLY_FLAG-"+I_APLY_FLAG);
        	ret = rfcMeal.detail( i_orgeh, i_yyyymm,I_APLY_FLAG  ); 
        	Logger.debug.println("-----222-");
            meal_vt = (Vector)ret.get(0);
            mealAppr_vt = (Vector)ret.get(1);
            String E_RETURN    = (String)ret.get(2);
            String E_MESSAGE = (String)ret.get(3);  
            //�����ڸ���Ʈ
            Vector AppLineData_vt     =  new Vector();
            if (meal_vt.size()>0){
                E37MealData meal_temp = (E37MealData)meal_vt.get(0);
                AppLineData_vt     = AppUtil.getAppChangeVt(meal_temp.AINF_SEQN);
            }else{
            	AppLineData_vt = AppUtil.getAppVector( user.empNo, UPMU_TYPE );
            }
            req.setAttribute("AppLineData_vt",       AppLineData_vt);

            Logger.debug.println("------E37MealDetailSV ret.TOSTRING: "+ret.toString());
            if (!E_RETURN.equals("E") ) {

                req.setAttribute("jobid",             jobid);
                req.setAttribute("hdn_deptId",    i_orgeh);
                req.setAttribute("hdn_deptNm",   i_orgeh_nm);
                req.setAttribute("txt_searchNm", txt_searchNm); 
                req.setAttribute("t_year",           t_year);
                req.setAttribute("t_month",        t_month);
                req.setAttribute("meal_vt",         meal_vt);
                req.setAttribute("mealAppr_vt",   mealAppr_vt); 
                req.setAttribute("I_APLY_FLAG",  I_APLY_FLAG); 
                req.setAttribute("E_RETURN", E_RETURN); 
                req.setAttribute("E_MESSAGE", E_MESSAGE); 
                 
            	dest = WebUtil.JspURL+"E/E37Meal/E37MealDetail.jsp";
            }   else { 
            	
                String msg = E_MESSAGE;
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E37Meal.E37MealDetailSV?hdn_deptId=&hdn_deptNm=&t_year="+t_year+"&t_month="+t_month+"&I_APLY_FLAG="+I_APLY_FLAG+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest = WebUtil.JspURL+"common/msg.jsp";              
             
             }
            
        } else if( jobid.equals("delete") ) {       //����
        	 
        	E37MealApprData e37MealApprData_vt = new E37MealApprData();
        	E37MealData e37MealData_vt = new E37MealData(); 
        	String tmp_AINF_SEQN = "";
        	//�������(ZHRA003T) ���ͻ��� AppLineData_vt - ����
        	int row_count = box.getInt("RowCount"); 
            int RowCount_meal = box.getInt("RowCount_meal");
            for( int i = 0; i < RowCount_meal; i++) {
            	E37MealData e37MealData = new E37MealData();
                String          idx             = Integer.toString(i);

                if( box.get("use_flag"+idx).equals("N") ) continue;
              
                e37MealData.PERNR       = box.get("PERNR"+idx    );  // ���(13�ڸ� �Ĵ����)         
                e37MealData.BEGDA       = box.get("BEGDA"+idx    );  // ��û��                        
                e37MealData.AINF_SEQN = box.get("AINF_SEQN"+idx);  // �������� �Ϸù�ȣ       
                e37MealData.APLY_FLAG = box.get("APLY_FLAG"+idx);  // ��û����                      
                e37MealData.APLY_MNTH= i_yyyymm;  // �м��Ⱓ - ��                 
                e37MealData.ORGEH       = i_orgeh;  // ���� ����                     
                e37MealData.ENAME       = box.get("ENAME"+idx    );  // ��� �Ǵ� �������� ���˵� �̸�
                e37MealData.TKCT_CONT= box.get("TKCT_CONT"+idx);  // ���������ϼ�                  
                e37MealData.TKCT_WONX= box.get("TKCT_WONX"+idx);  // �������޾�                    
                e37MealData.CASH_CONT= box.get("CASH_CONT"+idx);  // ���ݺ����ϼ�                  
                e37MealData.CASH_WONX= box.get("CASH_WONX"+idx);  // ���ݺ����                    
                e37MealData.BANKS        = box.get("BANKS"    +idx);  // ���� ���� Ű                  
                e37MealData.BANKL        = box.get("BANKL"    +idx);  // ���� Ű                       
                e37MealData.BANKN        = box.get("BANKN"    +idx);  // ���� ���� ��ȣ                
                e37MealData.BKONT        = box.get("BKONT"    +idx);  // ���� ���� Ű                  
                e37MealData.BVTYP        = box.get("BVTYP"    +idx);  // ��Ʈ�� ���� ����              
                e37MealData.POST_DATE = box.get("POST_DATE"+idx);  // POSTING����                   
                e37MealData.BELNR         = box.get("BELNR"    +idx);  // ȸ�� ��ǥ ��ȣ                
                e37MealData.ZPERNR       = user.empNo;                             
                e37MealData.ZUNAME      = box.get("ZUNAME"   +idx);  // �μ����� �̸�                 
                e37MealData.BIGO_TXT    = box.get("BIGO_TXT" +idx);  // ��ü������          
                e37MealData.THNG_MONY    = box.get("THNG_MONY" +idx);  //���� (1���� �ݾ�)            
                e37MealData.CASH_MONY    = box.get("CASH_MONY" +idx);  //�������� ���رݾ�           
                meal_vt.addElement(e37MealData);
                tmp_AINF_SEQN = e37MealData.AINF_SEQN;
                for( int j = 0; j < row_count; j++) {
                	E37MealApprData p_zhra003t = new E37MealApprData();

                	p_zhra003t.UPMU_FLAG = box.get("APPL_UPMU_FLAG"+j);
                	p_zhra003t.APPU_TYPE = box.get("APPL_APPU_TYPE"+j);
                	p_zhra003t.APPR_TYPE = box.get("APPL_APPR_TYPE"+j);
                	p_zhra003t.APPR_SEQN = box.get("APPL_APPR_SEQN"+j);
                	p_zhra003t.PERNR = box.get("PERNR"+idx    );  // ���(13�ڸ� �Ĵ����)  
                	p_zhra003t.OTYPE = box.get("APPL_OTYPE"+i);
                	p_zhra003t.OBJID = box.get("APPL_OBJID"+i);
                	p_zhra003t.APPU_NUMB = box.get("APPL_APPU_NUMB"+j);
                	
                	p_zhra003t.AINF_SEQN = box.get("AINF_SEQN"+idx);  // �������� �Ϸù�ȣ       
                	p_zhra003t.APPR_DATE = "";
                	p_zhra003t.APPR_STAT = "";
                	p_zhra003t.BEGDA = DataUtil.getCurrentDate();
                	p_zhra003t.BUKRS = user.companyCode; 
                	p_zhra003t.UPMU_TYPE = UPMU_TYPE;

                    mealAppr_vt.addElement(p_zhra003t);

                }                    
            }

            Vector AppLineData_vt     = AppUtil.getAppChangeVt(tmp_AINF_SEQN);
            req.setAttribute("AppLineData_vt",       AppLineData_vt);
 
            AppLineData appLine        = new AppLineData();

            box.copyToEntity(appLine);
            appLine = (AppLineData)AppLineData_vt.get(0);
        	//�����û
        	Vector ret_vt = rfcMeal.delete(   i_orgeh,i_yyyymm, I_APLY_FLAG ,meal_vt ,mealAppr_vt);
        	
        	String msg = "msg003";;
            String msg2 = "";
        	
        	String E_RETURN    = (String)ret_vt.get(2);
            String E_MESSAGE = (String)ret_vt.get(3);

            Logger.debug.println("�Ĵ�------E_RETURN : "+E_RETURN+"- E_MESSAGE : "+E_MESSAGE);

        	if(!E_RETURN.equals("E")){
        		   
            	req.setAttribute("jobid",           jobid);
                req.setAttribute("hdn_deptId",  i_orgeh);
                req.setAttribute("hdn_deptNm", i_orgeh_nm);
                req.setAttribute("t_year",        t_year);
                req.setAttribute("t_month",      t_month);
                req.setAttribute("meal_vt",       meal_vt);
                req.setAttribute("mealAppr_vt", mealAppr_vt); 
                req.setAttribute("RowCount_meal",  Integer.toString(RowCount_meal)); 
                req.setAttribute("I_APLY_FLAG",     I_APLY_FLAG); 

                
                //���ڰ��翬��
                /*
                DraftDocForEloffice ddfe = new DraftDocForEloffice();
                Vector vcElofficInterfaceData = new Vector();	                
            	for( int i = 0; i < meal_vt.size(); i++) {
                    E37MealData e37MealData = (E37MealData)meal_vt.get(i);  
                    Logger.debug.println(this, "�Ĵ�= vcElofficInterfaceData e37MealData= " + e37MealData.toString());	
                    Logger.debug.println(this, "�Ĵ�= vcElofficInterfaceData appLine= " + appLine.toString());	            	
                    
                    ElofficInterfaceData eof = ddfe.makeDocForRemove(e37MealData.AINF_SEQN ,user.SServer ,UPMU_NAME, 
                    		e37MealData.PERNR ,appLine.APPL_PERNR);
                                            
                    vcElofficInterfaceData.add(eof);
                }	                

                Logger.debug.println(this, "�Ĵ�========== vcElofficInterfaceData = " + vcElofficInterfaceData.toString());	            	
	            try {
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg2 = msg2 +  " Eloffic ���� ���� " ;
                } // end try
            	*/
                				
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E37Meal.E37MealDetailSV?hdn_deptId="+i_orgeh+"&hdn_deptNm="+i_orgeh_nm+"&t_year="+t_year+"&t_month="+t_month+"&I_APLY_FLAG="+I_APLY_FLAG+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
				dest = WebUtil.JspURL+"common/msg.jsp";	
        	}else{
        		msg = E_MESSAGE;
        		String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E37Meal.E37MealDetailSV?hdn_deptId="+i_orgeh+"&hdn_deptNm="+i_orgeh_nm+"&t_year="+t_year+"&t_month="+t_month+"&I_APLY_FLAG="+I_APLY_FLAG+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest = WebUtil.JspURL+"common/msg.jsp";
        	}
        	
            }else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
