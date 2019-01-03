package servlet.hris.D;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.D.*;
import hris.D.rfc.*;
import hris.common.WebUserData;

/**
 * D08RetroDetailSV.java
 * 개인소급내역에 대한 상세내용을 조회하여 D08RetroDetail.jsp 값을 넘겨주는 class
 *
 * @author 최영호   
 * @version 1.0, 2002/01/23
 **/
public class D08RetroDetailSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
                        
            Box box = WebUtil.getBox(req);
           //  월급여조회에서 넘겨받음        
            String year1  = box.get("year1");
            String month1 = box.get("month1");
//---4월 12일 수정----
            String ocrsn1 = box.get("ocrsn1");     
//--------------------
            String year = year1 + month1;
            
            D08RetroDetailRFC  rfc                   = null;
            D08RetroDetailData data                  = new D08RetroDetailData();//처음 가져온 데이타
            D08RetroDetailData data1                 = new D08RetroDetailData();//공제소급금액의 합을 담은 데이터
            D08RetroDetailData data2                 = new D08RetroDetailData();//지급소급금액의 합을 담은 데이터
            D08RetroDetailData data3                 = new D08RetroDetailData();//전체해당월중에서 하니씩만 골라내기위한 데이터
            D08RetroDetailData data4                 = new D08RetroDetailData();//전체해당월중에서 하니씩만 골라내기위한 데이터
            D08RetroDetailData data5                 = new D08RetroDetailData();//
            
            Vector            D08RetroDetailData_vt  = null;
            Vector            D08RetroDetailData1_vt = new Vector();//공제내역을 담은 백터
            Vector            D08RetroDetailData2_vt = new Vector();//지급내역을 담은 백터
            Vector            D08RetroDetailData3_vt = new Vector();//전체해당월을 1개씬만 담은 백터
                         
// D08RetroDetailRFC 개인소급내역 조회
            rfc = new D08RetroDetailRFC();
// 4월 12일 수정사항. 급여형태를 추가로 넘겨줌.
            D08RetroDetailData_vt = rfc.getRetroDetail(user.empNo, year, ocrsn1, user.area);
            int               sum1 = 0;
            int               sum2 = 0;
//전체해당월을 1개씬만 담은 백터           
            
            if ( D08RetroDetailData_vt.size() == 0 ) {
                Logger.debug.println(this, "Data Not Found");
                String msg = "msg004";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            } 

            data5 = (D08RetroDetailData)D08RetroDetailData_vt.get(0);
            D08RetroDetailData3_vt.addElement(data5);
            
            for( int i = 1 ; i < D08RetroDetailData_vt.size() ; i++ ) {
            	data3 = (D08RetroDetailData)D08RetroDetailData_vt.get(i-1);
            	data4 = (D08RetroDetailData)D08RetroDetailData_vt.get(i);
            	
            	if( ! data3.FPPER.equals(data4.FPPER) || ! data3.OCRSN.equals(data4.OCRSN) || ! data3.PAYDT.equals(data4.PAYDT)) {
            		D08RetroDetailData3_vt.addElement(data4);
            	}
            }
           Logger.debug.println(this, "data3 : "+ data3.toString());
           Logger.debug.println(this, "data4 : "+ data4.toString());
           Logger.debug.println(this, "D08RetroDetailData3_vt : "+ D08RetroDetailData3_vt.toString());
 
//공제내역과 지급내역을 구분해서 백터에 담음 
           for( int i = 0 ; i < D08RetroDetailData_vt.size() ; i++ ) 
                {
                    data = (D08RetroDetailData)D08RetroDetailData_vt.get(i);
// GUBUN CODE가 1이면 공제  2이면 지급                  
                    if( data.GUBUN.equals("1") ) {
                        D08RetroDetailData1_vt.addElement(data);
                    }else if( data.GUBUN.equals("2") ) {
                        D08RetroDetailData2_vt.addElement(data);
                    }
                }
//공제소급 금액의 합을 담는 로직
            for( int i = 0 ; i < D08RetroDetailData1_vt.size() ; i++ ){ 
           
                data1 = (D08RetroDetailData)D08RetroDetailData1_vt.get(i);
                
                sum1 += Double.parseDouble(data1.SOGUP_AMNT);
           
            }
            Logger.debug.println(this, "SUM1 : "+ sum1);
//지급소급 금액을 담는 로직
            for( int i = 0 ; i < D08RetroDetailData2_vt.size() ; i++ ) {
           
               data2 = (D08RetroDetailData)D08RetroDetailData2_vt.get(i);
                
               sum2 += Double.parseDouble(data2.SOGUP_AMNT);
           
            }
            
            Logger.debug.println(this, "SUM2 : "+ sum2);
            
            if ( D08RetroDetailData_vt.size() == 0 ) {
                Logger.debug.println(this, "Data Not Found");
                String msg = "msg004";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";

            } else {
                Logger.debug.println(this, "D08RetroDetailData_vt : "+ D08RetroDetailData_vt.toString());
                Logger.debug.println(this, "D08RetroDetailData_vt.size : "+ D08RetroDetailData_vt.size());
                Logger.debug.println(this, "D08RetroDetailData1_vt : "+ D08RetroDetailData1_vt.toString());
                Logger.debug.println(this, "D08RetroDetailData1_vt.size : "+ D08RetroDetailData1_vt.size());
                Logger.debug.println(this, "D08RetroDetailData2_vt : "+ D08RetroDetailData2_vt.toString());
                Logger.debug.println(this, "D08RetroDetailData2_vt.size : "+ D08RetroDetailData2_vt.size());
 
                req.setAttribute("D08RetroDetailData_vt", D08RetroDetailData_vt);
                req.setAttribute("D08RetroDetailData1_vt", D08RetroDetailData1_vt);
                req.setAttribute("D08RetroDetailData2_vt", D08RetroDetailData2_vt);
                req.setAttribute("total1", Integer.toString(sum1));
                req.setAttribute("total2", Integer.toString(sum2));
                req.setAttribute("D08RetroDetailData3_vt", D08RetroDetailData3_vt);
                
                dest = WebUtil.JspURL+"D/D08RetroDetail.jsp";
            }
         
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}