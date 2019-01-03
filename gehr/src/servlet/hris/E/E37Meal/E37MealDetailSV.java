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
 * 식대 신청 Class
 *
 * @author LSA   
 * @version 1.0, 2009/11/25
 * 2018/07/25 rdcamel 사용안함
 */

public class E37MealDetailSV extends EHRBaseServlet {
    private String UPMU_TYPE ="23";   // 결재 업무타입(식대)
    private String UPMU_NAME = "식대";
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
        //기준일자가 없을경우 현재일자를 default로한다.
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
       
        if( jobid.equals("first")  ) {                 //제일처음 저장 화면에 들어온경우. 
        	Logger.debug.println("----I_APLY_FLAG-"+I_APLY_FLAG);
        	ret = rfcMeal.detail( i_orgeh, i_yyyymm,I_APLY_FLAG  ); 
        	Logger.debug.println("-----222-");
            meal_vt = (Vector)ret.get(0);
            mealAppr_vt = (Vector)ret.get(1);
            String E_RETURN    = (String)ret.get(2);
            String E_MESSAGE = (String)ret.get(3);  
            //결재자리스트
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
            
        } else if( jobid.equals("delete") ) {       //삭제
        	 
        	E37MealApprData e37MealApprData_vt = new E37MealApprData();
        	E37MealData e37MealData_vt = new E37MealData(); 
        	String tmp_AINF_SEQN = "";
        	//결재라인(ZHRA003T) 벡터생성 AppLineData_vt - 공통
        	int row_count = box.getInt("RowCount"); 
            int RowCount_meal = box.getInt("RowCount_meal");
            for( int i = 0; i < RowCount_meal; i++) {
            	E37MealData e37MealData = new E37MealData();
                String          idx             = Integer.toString(i);

                if( box.get("use_flag"+idx).equals("N") ) continue;
              
                e37MealData.PERNR       = box.get("PERNR"+idx    );  // 사번(13자리 식대관리)         
                e37MealData.BEGDA       = box.get("BEGDA"+idx    );  // 신청일                        
                e37MealData.AINF_SEQN = box.get("AINF_SEQN"+idx);  // 결재정보 일련번호       
                e37MealData.APLY_FLAG = box.get("APLY_FLAG"+idx);  // 신청구분                      
                e37MealData.APLY_MNTH= i_yyyymm;  // 분석기간 - 월                 
                e37MealData.ORGEH       = i_orgeh;  // 조직 단위                     
                e37MealData.ENAME       = box.get("ENAME"+idx    );  // 사원 또는 지원자의 포맷된 이름
                e37MealData.TKCT_CONT= box.get("TKCT_CONT"+idx);  // 현물지급일수                  
                e37MealData.TKCT_WONX= box.get("TKCT_WONX"+idx);  // 현물지급액                    
                e37MealData.CASH_CONT= box.get("CASH_CONT"+idx);  // 현금보상일수                  
                e37MealData.CASH_WONX= box.get("CASH_WONX"+idx);  // 현금보상액                    
                e37MealData.BANKS        = box.get("BANKS"    +idx);  // 은행 국가 키                  
                e37MealData.BANKL        = box.get("BANKL"    +idx);  // 은행 키                       
                e37MealData.BANKN        = box.get("BANKN"    +idx);  // 은행 계정 번호                
                e37MealData.BKONT        = box.get("BKONT"    +idx);  // 은행 관리 키                  
                e37MealData.BVTYP        = box.get("BVTYP"    +idx);  // 파트너 은행 유형              
                e37MealData.POST_DATE = box.get("POST_DATE"+idx);  // POSTING일자                   
                e37MealData.BELNR         = box.get("BELNR"    +idx);  // 회계 전표 번호                
                e37MealData.ZPERNR       = user.empNo;                             
                e37MealData.ZUNAME      = box.get("ZUNAME"   +idx);  // 부서서무 이름                 
                e37MealData.BIGO_TXT    = box.get("BIGO_TXT" +idx);  // 구체적증상          
                e37MealData.THNG_MONY    = box.get("THNG_MONY" +idx);  //현물 (1끼당 금액)            
                e37MealData.CASH_MONY    = box.get("CASH_MONY" +idx);  //현물보상 기준금액           
                meal_vt.addElement(e37MealData);
                tmp_AINF_SEQN = e37MealData.AINF_SEQN;
                for( int j = 0; j < row_count; j++) {
                	E37MealApprData p_zhra003t = new E37MealApprData();

                	p_zhra003t.UPMU_FLAG = box.get("APPL_UPMU_FLAG"+j);
                	p_zhra003t.APPU_TYPE = box.get("APPL_APPU_TYPE"+j);
                	p_zhra003t.APPR_TYPE = box.get("APPL_APPR_TYPE"+j);
                	p_zhra003t.APPR_SEQN = box.get("APPL_APPR_SEQN"+j);
                	p_zhra003t.PERNR = box.get("PERNR"+idx    );  // 사번(13자리 식대관리)  
                	p_zhra003t.OTYPE = box.get("APPL_OTYPE"+i);
                	p_zhra003t.OBJID = box.get("APPL_OBJID"+i);
                	p_zhra003t.APPU_NUMB = box.get("APPL_APPU_NUMB"+j);
                	
                	p_zhra003t.AINF_SEQN = box.get("AINF_SEQN"+idx);  // 결재정보 일련번호       
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
        	//결재신청
        	Vector ret_vt = rfcMeal.delete(   i_orgeh,i_yyyymm, I_APLY_FLAG ,meal_vt ,mealAppr_vt);
        	
        	String msg = "msg003";;
            String msg2 = "";
        	
        	String E_RETURN    = (String)ret_vt.get(2);
            String E_MESSAGE = (String)ret_vt.get(3);

            Logger.debug.println("식대------E_RETURN : "+E_RETURN+"- E_MESSAGE : "+E_MESSAGE);

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

                
                //전자결재연동
                /*
                DraftDocForEloffice ddfe = new DraftDocForEloffice();
                Vector vcElofficInterfaceData = new Vector();	                
            	for( int i = 0; i < meal_vt.size(); i++) {
                    E37MealData e37MealData = (E37MealData)meal_vt.get(i);  
                    Logger.debug.println(this, "식대= vcElofficInterfaceData e37MealData= " + e37MealData.toString());	
                    Logger.debug.println(this, "식대= vcElofficInterfaceData appLine= " + appLine.toString());	            	
                    
                    ElofficInterfaceData eof = ddfe.makeDocForRemove(e37MealData.AINF_SEQN ,user.SServer ,UPMU_NAME, 
                    		e37MealData.PERNR ,appLine.APPL_PERNR);
                                            
                    vcElofficInterfaceData.add(eof);
                }	                

                Logger.debug.println(this, "식대========== vcElofficInterfaceData = " + vcElofficInterfaceData.toString());	            	
	            try {
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg2 = msg2 +  " Eloffic 연동 실패 " ;
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
